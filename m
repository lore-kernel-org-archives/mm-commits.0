From: akpm@linux-foundation.org
Subject: [folded-merged]
 procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 15:08:01 -0700
Message-ID: <55f0adc1.o1JKUPSzAdrwZFDg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbbIIWIC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 18:08:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, calvinowens@fb.com, gorcunov@openvz.org, joe@perches.com, keescook@chromium.org, kirill@shutemov.name, luto@amacapital.net, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix
has been removed from the -mm tree.  Its filename was
     procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch

This patch was dropped because it was folded into procfs-always-expose-proc-pid-map_files-and-make-it-readable.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix

catch up with concurrent proc_pid_follow_link() changes

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Calvin Owens <calvinowens@fb.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/proc/base.c~procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix fs/proc/base.c
--- a/fs/proc/base.c~procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix
+++ a/fs/proc/base.c
@@ -1955,12 +1955,13 @@ struct map_files_info {
  * symlinks may be used to bypass permissions on ancestor directories in the
  * path to the file in question.
  */
-static void *proc_map_files_follow_link(struct dentry *dentry, struct nameidata *nd)
+static void *
+proc_map_files_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	if (!capable(CAP_SYS_ADMIN))
 		return ERR_PTR(-EPERM);
 
-	return proc_pid_follow_link(dentry, nd);
+	return proc_pid_follow_link(dentry, NULL);
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

procfs-always-expose-proc-pid-map_files-and-make-it-readable.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix-fix.patch
kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch

