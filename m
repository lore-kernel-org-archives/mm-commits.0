From: akpm@linux-foundation.org
Subject: [merged] coredump-kill-mmf_dumpable-and-mmf_dump_securely.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 11:03:26 -0800
Message-ID: <52e2b8fe.n6CfH64qFJ+y6cbH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbaAXTD1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:03:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, segoon@openwall.com, pmatouse@redhat.com, keescook@chromium.org, josh@joshtriplett.org, ebiederm@xmission.com, alex.page.kelly@gmail.com, oleg@redhat.com

Subject: [merged] coredump-kill-mmf_dumpable-and-mmf_dump_securely.patch removed from -mm tree
To: oleg@redhat.com,alex.page.kelly@gmail.com,ebiederm@xmission.com,josh@joshtriplett.org,keescook@chromium.org,pmatouse@redhat.com,segoon@openwall.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:03:26 -0800


The patch titled
     Subject: coredump: kill MMF_DUMPABLE and MMF_DUMP_SECURELY
has been removed from the -mm tree.  Its filename was
     coredump-kill-mmf_dumpable-and-mmf_dump_securely.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: coredump: kill MMF_DUMPABLE and MMF_DUMP_SECURELY

Nobody actually needs MMF_DUMPABLE/MMF_DUMP_SECURELY, they are only used
to enforce the encoding of SUID_DUMP_* enum in mm->flags &
MMF_DUMPABLE_MASK.

Now that set_dumpable() updates both bits atomically we can kill them and
simply store the value "as is" in 2 lower bits.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Alex Kelly <alex.page.kelly@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Petr Matousek <pmatouse@redhat.com>
Cc: Vasily Kulikov <segoon@openwall.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c             |   21 ++++++---------------
 include/linux/sched.h |    4 +---
 2 files changed, 7 insertions(+), 18 deletions(-)

diff -puN fs/exec.c~coredump-kill-mmf_dumpable-and-mmf_dump_securely fs/exec.c
--- a/fs/exec.c~coredump-kill-mmf_dumpable-and-mmf_dump_securely
+++ a/fs/exec.c
@@ -1613,33 +1613,24 @@ void set_binfmt(struct linux_binfmt *new
 EXPORT_SYMBOL(set_binfmt);
 
 /*
- * set_dumpable converts traditional three-value dumpable to two flags and
- * stores them into mm->flags.
+ * set_dumpable stores three-value SUID_DUMP_* into mm->flags.
  */
 void set_dumpable(struct mm_struct *mm, int value)
 {
 	unsigned long old, new;
 
+	if (WARN_ON((unsigned)value > SUID_DUMP_ROOT))
+		return;
+
 	do {
 		old = ACCESS_ONCE(mm->flags);
-		new = old & ~MMF_DUMPABLE_MASK;
-
-		switch (value) {
-		case SUID_DUMP_ROOT:
-			new |= (1 << MMF_DUMP_SECURELY);
-		case SUID_DUMP_USER:
-			new |= (1<< MMF_DUMPABLE);
-		}
-
+		new = (old & ~MMF_DUMPABLE_MASK) | value;
 	} while (cmpxchg(&mm->flags, old, new) != old);
 }
 
 int __get_dumpable(unsigned long mm_flags)
 {
-	int ret;
-
-	ret = mm_flags & MMF_DUMPABLE_MASK;
-	return (ret > SUID_DUMP_USER) ? SUID_DUMP_ROOT : ret;
+	return mm_flags & MMF_DUMPABLE_MASK;
 }
 
 /*
diff -puN include/linux/sched.h~coredump-kill-mmf_dumpable-and-mmf_dump_securely include/linux/sched.h
--- a/include/linux/sched.h~coredump-kill-mmf_dumpable-and-mmf_dump_securely
+++ a/include/linux/sched.h
@@ -400,10 +400,8 @@ extern int get_dumpable(struct mm_struct
 #define SUID_DUMP_ROOT		2	/* Dump as root */
 
 /* mm flags */
-/* dumpable bits */
-#define MMF_DUMPABLE      0  /* core dump is permitted */
-#define MMF_DUMP_SECURELY 1  /* core file is readable only by root */
 
+/* for SUID_DUMP_* above */
 #define MMF_DUMPABLE_BITS 2
 #define MMF_DUMPABLE_MASK ((1 << MMF_DUMPABLE_BITS) - 1)
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
mm-fix-the-theoretical-compound_lock-vs-prep_new_page-race.patch

