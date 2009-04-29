From: akpm@linux-foundation.org
Subject: + poll-avoid-extra-wakeups-in-select-poll.patch added to -mm tree
Date: Wed, 29 Apr 2009 14:01:02 -0700
Message-ID: <200904292101.n3TL12CI020461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754026AbZD2VEO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 17:04:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com, ak@linux.intel.com, davem@davemloft.net, davidel@xmailserver.org, mingo@elte.hu


The patch titled
     poll: avoid extra wakeups in select/poll
has been added to the -mm tree.  Its filename is
     poll-avoid-extra-wakeups-in-select-poll.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: poll: avoid extra wakeups in select/poll
From: Eric Dumazet <dada1@cosmosbay.com>

After introduction of keyed wakeups Davide Libenzi did on epoll, we are
able to avoid spurious wakeups in poll()/select() code too.

For example, typical use of poll()/select() is to wait for incoming
network frames on many sockets.  But TX completion for UDP/TCP frames call
sock_wfree() which in turn schedules thread.

When scheduled, thread does a full scan of all polled fds and can sleep
again, because nothing is really available.  If number of fds is large,
this cause significant load.

This patch makes select()/poll() aware of keyed wakeups and useless
wakeups are avoided.  This reduces number of context switches by about 50%
on some setups, and work performed by sofirq handlers.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/select.c          |   40 ++++++++++++++++++++++++++++++++++++----
 include/linux/poll.h |    3 +++
 2 files changed, 39 insertions(+), 4 deletions(-)

diff -puN fs/select.c~poll-avoid-extra-wakeups-in-select-poll fs/select.c
--- a/fs/select.c~poll-avoid-extra-wakeups-in-select-poll
+++ a/fs/select.c
@@ -168,7 +168,7 @@ static struct poll_table_entry *poll_get
 	return table->entry++;
 }
 
-static int pollwake(wait_queue_t *wait, unsigned mode, int sync, void *key)
+static int __pollwake(wait_queue_t *wait, unsigned mode, int sync, void *key)
 {
 	struct poll_wqueues *pwq = wait->private;
 	DECLARE_WAITQUEUE(dummy_wait, pwq->polling_task);
@@ -194,6 +194,16 @@ static int pollwake(wait_queue_t *wait, 
 	return default_wake_function(&dummy_wait, mode, sync, key);
 }
 
+static int pollwake(wait_queue_t *wait, unsigned mode, int sync, void *key)
+{
+	struct poll_table_entry *entry;
+
+	entry = container_of(wait, struct poll_table_entry, wait);
+	if (key && !((unsigned long)key & entry->key))
+		return 0;
+	return __pollwake(wait, mode, sync, key);
+}
+
 /* Add a new entry */
 static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
 				poll_table *p)
@@ -205,6 +215,7 @@ static void __pollwait(struct file *filp
 	get_file(filp);
 	entry->filp = filp;
 	entry->wait_address = wait_address;
+	entry->key = p->key;
 	init_waitqueue_func_entry(&entry->wait, pollwake);
 	entry->wait.private = pwq;
 	add_wait_queue(wait_address, &entry->wait);
@@ -362,6 +373,18 @@ get_max:
 #define POLLOUT_SET (POLLWRBAND | POLLWRNORM | POLLOUT | POLLERR)
 #define POLLEX_SET (POLLPRI)
 
+static inline void wait_key_set(poll_table *wait, unsigned long in,
+				unsigned long out, unsigned long bit)
+{
+	if (wait) {
+		wait->key = POLLEX_SET;
+		if (in & bit)
+			wait->key |= POLLIN_SET;
+		if (out & bit)
+			wait->key |= POLLOUT_SET;
+	}
+}
+
 int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
 {
 	ktime_t expire, *to = NULL;
@@ -418,20 +441,25 @@ int do_select(int n, fd_set_bits *fds, s
 				if (file) {
 					f_op = file->f_op;
 					mask = DEFAULT_POLLMASK;
-					if (f_op && f_op->poll)
-						mask = (*f_op->poll)(file, retval ? NULL : wait);
+					if (f_op && f_op->poll) {
+						wait_key_set(wait, in, out, bit);
+						mask = (*f_op->poll)(file, wait);
+					}
 					fput_light(file, fput_needed);
 					if ((mask & POLLIN_SET) && (in & bit)) {
 						res_in |= bit;
 						retval++;
+						wait = NULL;
 					}
 					if ((mask & POLLOUT_SET) && (out & bit)) {
 						res_out |= bit;
 						retval++;
+						wait = NULL;
 					}
 					if ((mask & POLLEX_SET) && (ex & bit)) {
 						res_ex |= bit;
 						retval++;
+						wait = NULL;
 					}
 				}
 			}
@@ -685,8 +713,12 @@ static inline unsigned int do_pollfd(str
 		mask = POLLNVAL;
 		if (file != NULL) {
 			mask = DEFAULT_POLLMASK;
-			if (file->f_op && file->f_op->poll)
+			if (file->f_op && file->f_op->poll) {
+				if (pwait)
+					pwait->key = pollfd->events |
+							POLLERR | POLLHUP;
 				mask = file->f_op->poll(file, pwait);
+			}
 			/* Mask out unneeded events. */
 			mask &= pollfd->events | POLLERR | POLLHUP;
 			fput_light(file, fput_needed);
diff -puN include/linux/poll.h~poll-avoid-extra-wakeups-in-select-poll include/linux/poll.h
--- a/include/linux/poll.h~poll-avoid-extra-wakeups-in-select-poll
+++ a/include/linux/poll.h
@@ -32,6 +32,7 @@ typedef void (*poll_queue_proc)(struct f
 
 typedef struct poll_table_struct {
 	poll_queue_proc qproc;
+	unsigned long key;
 } poll_table;
 
 static inline void poll_wait(struct file * filp, wait_queue_head_t * wait_address, poll_table *p)
@@ -43,10 +44,12 @@ static inline void poll_wait(struct file
 static inline void init_poll_funcptr(poll_table *pt, poll_queue_proc qproc)
 {
 	pt->qproc = qproc;
+	pt->key   = ~0UL; /* all events enabled */
 }
 
 struct poll_table_entry {
 	struct file *filp;
+	unsigned long key;
 	wait_queue_t wait;
 	wait_queue_head_t *wait_address;
 };
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
linux-next.patch
poll-avoid-extra-wakeups-in-select-poll.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch

