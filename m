From: akpm@linux-foundation.org
Subject: + pid-replace-pid-bitmap-implementation-with-idr-api-v6.patch
 added to -mm tree
Date: Wed, 11 Oct 2017 15:41:15 -0700
Message-ID: <59de9e0b.iAcmgaSpw3vH9F3G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39608 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750718AbdJKWlQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Oct 2017 18:41:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gs051095@gmail.com, ebiederm@xmission.com, hch@infradead.org, julia.lawall@lip6.fr, ktkhai@virtuozzo.com, mingo@kernel.org, oleg@redhat.com, pasha.tatashin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pid-replace-pid-bitmap-implementation-with-idr-api-v6
has been added to the -mm tree.  Its filename is
     pid-replace-pid-bitmap-implementation-with-idr-api-v6.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pid-replace-pid-bitmap-implementation-with-idr-api-v6.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pid-replace-pid-bitmap-implementation-with-idr-api-v6.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gargi Sharma <gs051095@gmail.com>
Subject: pid-replace-pid-bitmap-implementation-with-idr-api-v6

Link: http://lkml.kernel.org/r/1507760379-21662-2-git-send-email-gs051095@gmail.com
Signed-off-by: Gargi Sharma <gs051095@gmail.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Pavel Tatashin <pasha.tatashin@oracle.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c           |    6 ++++--
 kernel/pid_namespace.c |    2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN kernel/pid.c~pid-replace-pid-bitmap-implementation-with-idr-api-v6 kernel/pid.c
--- a/kernel/pid.c~pid-replace-pid-bitmap-implementation-with-idr-api-v6
+++ a/kernel/pid.c
@@ -124,7 +124,7 @@ void free_pid(struct pid *pid)
 		struct upid *upid = pid->numbers + i;
 		struct pid_namespace *ns = upid->ns;
 		hlist_del_rcu(&upid->pid_chain);
-		switch(--ns->nr_hashed) {
+		switch (--ns->nr_hashed) {
 		case 2:
 		case 1:
 			/* When all that is left in the pid namespace
@@ -168,6 +168,7 @@ struct pid *alloc_pid(struct pid_namespa
 
 	for (i = ns->level; i >= 0; i--) {
 		int pid_min = 1;
+
 		idr_preload(GFP_KERNEL);
 		spin_lock_irq(&pidmap_lock);
 
@@ -178,7 +179,8 @@ struct pid *alloc_pid(struct pid_namespa
 		if (idr_get_cursor(&tmp->idr) > RESERVED_PIDS)
 			pid_min = RESERVED_PIDS;
 
-		/* Store a null pointer so find_pid_ns does not find             *
+		/*
+		 * Store a null pointer so find_pid_ns does not find
 		 * a partially initialized PID (see below).
 		 */
 		nr = idr_alloc_cyclic(&tmp->idr, NULL, pid_min,
diff -puN kernel/pid_namespace.c~pid-replace-pid-bitmap-implementation-with-idr-api-v6 kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pid-replace-pid-bitmap-implementation-with-idr-api-v6
+++ a/kernel/pid_namespace.c
@@ -229,6 +229,7 @@ void zap_pid_ns_processes(struct pid_nam
 	 * 	  maintain a tasklist for each pid namespace.
 	 *
 	 */
+	rcu_read_lock();
 	read_lock(&tasklist_lock);
 	nr = 2;
 	idr_for_each_entry_continue(&pid_ns->idr, pid, nr) {
@@ -237,6 +238,7 @@ void zap_pid_ns_processes(struct pid_nam
 			send_sig_info(SIGKILL, SEND_SIG_FORCED, task);
 	}
 	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 
 	/*
 	 * Reap the EXIT_ZOMBIE children we had before we ignored SIGCHLD.
_

Patches currently in -mm which might be from gs051095@gmail.com are

pid-replace-pid-bitmap-implementation-with-idr-api.patch
pid-replace-pid-bitmap-implementation-with-idr-api-v6.patch
pid-remove-pidhash.patch
pid-remove-pidhash-v6.patch

