From: akpm@linux-foundation.org
Subject: + ipc-msg-fix-message-length-check-for-negative-values.patch
 added to -mm tree
Date: Mon, 04 Nov 2013 12:44:16 -0800
Message-ID: <52780720.Wmhm/UErAqGgQHQO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab3KDUoR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Nov 2013 15:44:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, torvalds@linux-foundation.org, stable@vger.kernel.org, spender@grsecurity.net, pageexec@freemail.hu, manfred@colorfullife.com, davidlohr@hp.com, minipli@googlemail.com

Subject: + ipc-msg-fix-message-length-check-for-negative-values.patch added to -mm tree
To: minipli@googlemail.com,davidlohr@hp.com,manfred@colorfullife.com,pageexec@freemail.hu,spender@grsecurity.net,stable@vger.kernel.org,torvalds@linux-foundation.org
From: akpm@linux-foundation.org
Date: Mon, 04 Nov 2013 12:44:16 -0800


The patch titled
     Subject: ipc, msg: fix message length check for negative values
has been added to the -mm tree.  Its filename is
     ipc-msg-fix-message-length-check-for-negative-values.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-msg-fix-message-length-check-for-negative-values.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-msg-fix-message-length-check-for-negative-values.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mathias Krause <minipli@googlemail.com>
Subject: ipc, msg: fix message length check for negative values

On 64 bit systems the test for negative message sizes is bogus as the
size, which may be positive when evaluated as a long, will get truncated
to an int when passed to load_msg().  So a long might very well contain a
positive value but when truncated to an int it would become negative.

That in combination with a small negative value of msg_ctlmax (which will
be promoted to an unsigned type for the comparison against msgsz, making
it a big positive value and therefore make it pass the check) will lead to
two problems: 1/ The kmalloc() call in alloc_msg() will allocate a too
small buffer as the addition of alen is effectively a subtraction.  2/ The
copy_from_user() call in load_msg() will first overflow the buffer with
userland data and then, when the userland access generates an access
violation, the fixup handler copy_user_handle_tail() will try to fill the
remainder with zeros -- roughly 4GB.  That almost instantly results in a
system crash or reset.

,-[ Reproducer (needs to be run as root) ]--
| #include <sys/stat.h>
| #include <sys/msg.h>
| #include <unistd.h>
| #include <fcntl.h>
|
| int main(void) {
|     long msg = 1;
|     int fd;
|
|     fd = open("/proc/sys/kernel/msgmax", O_WRONLY);
|     write(fd, "-1", 2);
|     close(fd);
|
|     msgsnd(0, &msg, 0xfffffff0, IPC_NOWAIT);
|
|     return 0;
| }
'---

Fix the issue by preventing msgsz from getting truncated by consistently
using size_t for the message length.  This way the size checks in
do_msgsnd() could still be passed with a negative value for msg_ctlmax but
we would fail on the buffer allocation in that case and error out.

Also change the type of m_ts from int to size_t to avoid similar nastiness
in other code paths -- it is used in similar constructs, i.e.  signed vs. 
unsigned checks.  It should never become negative under normal
circumstances, though.

Setting msg_ctlmax to a negative value is an odd configuration and should
be prevented.  As that might break existing userland, it will be handled
in a separate commit so it could easily be reverted and reworked without
reintroducing the above described bug.

Hardening mechanisms for user copy operations would have catched that bug
early -- e.g.  checking slab object sizes on user copy operations as the
usercopy feature of the PaX patch does.  Or, for that matter, detect the
long vs.  int sign change due to truncation, as the size overflow plugin
of the very same patch does.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Pax Team <pageexec@freemail.hu>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Brad Spengler <spender@grsecurity.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@vger.kernel.org>	[ v2.3.27+ -- yes, that old ;) ]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/msg.h |    6 +++---
 ipc/msgutil.c       |   20 ++++++++++----------
 ipc/util.h          |    4 ++--
 3 files changed, 15 insertions(+), 15 deletions(-)

diff -puN include/linux/msg.h~ipc-msg-fix-message-length-check-for-negative-values include/linux/msg.h
--- a/include/linux/msg.h~ipc-msg-fix-message-length-check-for-negative-values
+++ a/include/linux/msg.h
@@ -6,9 +6,9 @@
 
 /* one msg_msg structure for each message */
 struct msg_msg {
-	struct list_head m_list; 
-	long  m_type;          
-	int m_ts;           /* message text size */
+	struct list_head m_list;
+	long m_type;
+	size_t m_ts;		/* message text size */
 	struct msg_msgseg* next;
 	void *security;
 	/* the actual message follows immediately */
diff -puN ipc/msgutil.c~ipc-msg-fix-message-length-check-for-negative-values ipc/msgutil.c
--- a/ipc/msgutil.c~ipc-msg-fix-message-length-check-for-negative-values
+++ a/ipc/msgutil.c
@@ -41,15 +41,15 @@ struct msg_msgseg {
 	/* the next part of the message follows immediately */
 };
 
-#define DATALEN_MSG	(int)(PAGE_SIZE-sizeof(struct msg_msg))
-#define DATALEN_SEG	(int)(PAGE_SIZE-sizeof(struct msg_msgseg))
+#define DATALEN_MSG	(PAGE_SIZE-sizeof(struct msg_msg))
+#define DATALEN_SEG	(PAGE_SIZE-sizeof(struct msg_msgseg))
 
 
-static struct msg_msg *alloc_msg(int len)
+static struct msg_msg *alloc_msg(size_t len)
 {
 	struct msg_msg *msg;
 	struct msg_msgseg **pseg;
-	int alen;
+	size_t alen;
 
 	alen = min(len, DATALEN_MSG);
 	msg = kmalloc(sizeof(*msg) + alen, GFP_KERNEL);
@@ -80,12 +80,12 @@ out_err:
 	return NULL;
 }
 
-struct msg_msg *load_msg(const void __user *src, int len)
+struct msg_msg *load_msg(const void __user *src, size_t len)
 {
 	struct msg_msg *msg;
 	struct msg_msgseg *seg;
 	int err = -EFAULT;
-	int alen;
+	size_t alen;
 
 	msg = alloc_msg(len);
 	if (msg == NULL)
@@ -117,8 +117,8 @@ out_err:
 struct msg_msg *copy_msg(struct msg_msg *src, struct msg_msg *dst)
 {
 	struct msg_msgseg *dst_pseg, *src_pseg;
-	int len = src->m_ts;
-	int alen;
+	size_t len = src->m_ts;
+	size_t alen;
 
 	BUG_ON(dst == NULL);
 	if (src->m_ts > dst->m_ts)
@@ -147,9 +147,9 @@ struct msg_msg *copy_msg(struct msg_msg
 	return ERR_PTR(-ENOSYS);
 }
 #endif
-int store_msg(void __user *dest, struct msg_msg *msg, int len)
+int store_msg(void __user *dest, struct msg_msg *msg, size_t len)
 {
-	int alen;
+	size_t alen;
 	struct msg_msgseg *seg;
 
 	alen = min(len, DATALEN_MSG);
diff -puN ipc/util.h~ipc-msg-fix-message-length-check-for-negative-values ipc/util.h
--- a/ipc/util.h~ipc-msg-fix-message-length-check-for-negative-values
+++ a/ipc/util.h
@@ -148,9 +148,9 @@ int ipc_parse_version (int *cmd);
 #endif
 
 extern void free_msg(struct msg_msg *msg);
-extern struct msg_msg *load_msg(const void __user *src, int len);
+extern struct msg_msg *load_msg(const void __user *src, size_t len);
 extern struct msg_msg *copy_msg(struct msg_msg *src, struct msg_msg *dst);
-extern int store_msg(void __user *dest, struct msg_msg *msg, int len);
+extern int store_msg(void __user *dest, struct msg_msg *msg, size_t len);
 
 extern void recompute_msgmni(struct ipc_namespace *);
 
_

Patches currently in -mm which might be from minipli@googlemail.com are

origin.patch
ipc-msg-fix-message-length-check-for-negative-values.patch
ipc-msg-forbid-negative-values-for-msgmaxmnbmni.patch
linux-next.patch

