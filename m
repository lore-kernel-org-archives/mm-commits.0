From: akpm@linux-foundation.org
Subject: + kernel-audit-reduce-mmap_sem-hold-for-mm-exe_file.patch added
 to -mm tree
Date: Mon, 23 Feb 2015 14:20:53 -0800
Message-ID: <54eba7c5.CI76xdhwnNFtThIC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46467 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbbBWWUy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 17:20:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, eparis@redhat.com, paul@paul-moore.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/audit: reduce mmap_sem hold for mm->exe_file
has been added to the -mm tree.  Its filename is
     kernel-audit-reduce-mmap_sem-hold-for-mm-exe_file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-audit-reduce-mmap_sem-hold-for-mm-exe_file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-audit-reduce-mmap_sem-hold-for-mm-exe_file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: kernel/audit: reduce mmap_sem hold for mm->exe_file

The mm->exe_file is currently serialized with mmap_sem (shared) in order
to both safely (1) read the file and (2) audit it via audit_log_d_path(). 
Good users will, on the other hand, make use of the more standard
get_mm_exe_file(), requiring only holding the mmap_sem to read the value,
and relying on reference counting to make sure that the exe file won't
dissapear underneath us.

Additionally, upon NULL return of get_mm_exe_file, we also call
audit_log_format(ab, " exe=(null)").

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff -puN kernel/audit.c~kernel-audit-reduce-mmap_sem-hold-for-mm-exe_file kernel/audit.c
--- a/kernel/audit.c~kernel-audit-reduce-mmap_sem-hold-for-mm-exe_file
+++ a/kernel/audit.c
@@ -43,6 +43,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/file.h>
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/atomic.h>
@@ -1841,15 +1842,20 @@ EXPORT_SYMBOL(audit_log_task_context);
 void audit_log_d_path_exe(struct audit_buffer *ab,
 			  struct mm_struct *mm)
 {
-	if (!mm) {
-		audit_log_format(ab, " exe=(null)");
-		return;
-	}
+	struct file *exe_file;
+
+	if (!mm)
+		goto out_null;
 
-	down_read(&mm->mmap_sem);
-	if (mm->exe_file)
-		audit_log_d_path(ab, " exe=", &mm->exe_file->f_path);
-	up_read(&mm->mmap_sem);
+	exe_file = get_mm_exe_file(mm);
+	if (!exe_file)
+		goto out_null;
+
+	audit_log_d_path(ab, " exe=", &exe_file->f_path);
+	fput(exe_file);
+	return;
+out_null:
+	audit_log_format(ab, " exe=(null)");
 }
 
 void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
_

Patches currently in -mm which might be from dave@stgolabs.net are

kernel-audit-consolidate-handling-of-mm-exe_file.patch
kernel-audit-reduce-mmap_sem-hold-for-mm-exe_file.patch
arc-do-not-export-symbols-in-troubleshootc.patch

