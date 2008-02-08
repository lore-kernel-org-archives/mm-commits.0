From: akpm@linux-foundation.org
Subject: - add-an-err_cast-function-to-complement-err_ptr-and-co.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:07:06 -0800
Message-ID: <200802080806.m1886lCn014481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51823 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932268AbYBHIT6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Add an ERR_CAST() function to complement ERR_PTR and co.
has been removed from the -mm tree.  Its filename was
     add-an-err_cast-function-to-complement-err_ptr-and-co.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add an ERR_CAST() function to complement ERR_PTR and co.
From: David Howells <dhowells@redhat.com>

Add an ERR_CAST() function to complement ERR_PTR and co.  for the purposes
of casting an error entyped as one pointer type to an error of another
pointer type whilst making it explicit as to what is going on.

This provides a replacement for the ERR_PTR(PTR_ERR(p)) construct.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/err.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN include/linux/err.h~add-an-err_cast-function-to-complement-err_ptr-and-co include/linux/err.h
--- a/include/linux/err.h~add-an-err_cast-function-to-complement-err_ptr-and-co
+++ a/include/linux/err.h
@@ -34,6 +34,19 @@ static inline long IS_ERR(const void *pt
 	return IS_ERR_VALUE((unsigned long)ptr);
 }
 
+/**
+ * ERR_CAST - Explicitly cast an error-valued pointer to another pointer type
+ * @ptr: The pointer to cast.
+ *
+ * Explicitly cast an error-valued pointer to another pointer type in such a
+ * way as to make it clear that's what's going on.
+ */
+static inline void *ERR_CAST(const void *ptr)
+{
+	/* cast away the const */
+	return (void *) ptr;
+}
+
 #endif
 
 #endif /* _LINUX_ERR_H */
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
tty-let-architectures-override-the-user-kernel-macros.patch
aout-move-stack_top-to-asm-processorh.patch
aout-mark-arches-that-support-aout-format.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
usb-net2280-cant-have-a-function-called-show_registers.patch
mn10300-allocate-serial-port-uart-ids-for-on-chip-serial-ports.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
mn10300-add-platform-mtd-support-for-the-asb2303-board.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
procfs-constify-function-pointer-tables.patch
avoid-overflows-in-kernel-timec.patch
mount-options-fix-afs.patch
remove-aout-interpreter-support-in-elf-loader.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
mutex-subsystem-synchro-test-module.patch
