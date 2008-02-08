From: akpm@linux-foundation.org
Subject: - libfs-allow-error-return-from-simple-attributes-fix.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:47:07 -0800
Message-ID: <200802080846.m188kmpp016246@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55373 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933157AbYBHIr4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:47:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, greg@kroah.com, hch@lst.de, stefano.brivio@polimi.it, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     libfs-allow-error-return-from-simple-attributes fix
has been removed from the -mm tree.  Its filename was
     libfs-allow-error-return-from-simple-attributes-fix.patch

This patch was dropped because it was folded into libfs-allow-error-return-from-simple-attributes.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libfs-allow-error-return-from-simple-attributes fix
From: Andrew Morton <akpm@linux-foundation.org>

lib/fault-inject.c: In function 'fops_ul_MAX_STACK_TRACE_DEPTH_open':
lib/fault-inject.c:167: warning: passing argument 4 of 'simple_attr_open' from i

Cc: Christoph Hellwig <hch@lst.de>
Cc: <stefano.brivio@polimi.it>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/fault-inject.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/fault-inject.c~libfs-allow-error-return-from-simple-attributes-fix lib/fault-inject.c
--- a/lib/fault-inject.c~libfs-allow-error-return-from-simple-attributes-fix
+++ a/lib/fault-inject.c
@@ -141,11 +141,12 @@ static int debugfs_ul_set(void *data, u6
 }
 
 #ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
-static void debugfs_ul_set_MAX_STACK_TRACE_DEPTH(void *data, u64 val)
+static int debugfs_ul_set_MAX_STACK_TRACE_DEPTH(void *data, u64 val)
 {
 	*(unsigned long *)data =
 		val < MAX_STACK_TRACE_DEPTH ?
 		val : MAX_STACK_TRACE_DEPTH;
+	return 0;
 }
 #endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
proc-detect-duplicate-names-on-registration.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-fix-openless-usage-due-to-proc_fops-flip.patch
intel-iommu-fault_reason_index_cleanuppatch.patch
modules-make-module_address_lookup-safe-fix.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace.patch
pid-sys_wait-fixes-v2.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
rewrite-rd.patch
fs-remove-fastcall-it-is-always-empty.patch
kernel-remove-fastcall-in-kernel.patch
lib-remove-fastcall-from-lib.patch
remove-fastcall-from-linux-include.patch
constify-tables-in-kernel-sysctl_checkc.patch
aoe-statically-initialise-devlist_lock.patch
ufs-fix-symlink-creation-on-ufs2.patch
libfs-allow-error-return-from-simple-attributes.patch
libfs-allow-error-return-from-simple-attributes-fix.patch
fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
mount-options-fix-tmpfs-fix.patch
char-applicom-use-pci_match_id-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
