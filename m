From: akpm@linux-foundation.org
Subject: [folded-merged]
 maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch removed
 from -mm tree
Date: Mon, 08 Jun 2020 20:24:23 -0700
Message-ID: <20200609032423.gh4G7qPn1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbgFIDY0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 23:24:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net, hch@lst.de, hpa@zytor.com, mhiramat@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, tglx@linutronix.de, vbabka@suse.cz


The patch titled
     Subject: maccess-always-use-strict-semantics-for-probe_kernel_read-fix
has been removed from the -mm tree.  Its filename was
     maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch

This patch was dropped because it was folded into maccess-always-use-strict-semantics-for-probe_kernel_read.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maccess-always-use-strict-semantics-for-probe_kernel_read-fix

update "maccess: always use strict semantics for probe_kernel_read"
(http://lkml.kernel.org/r/20200331165454.12263-1-vbabka@suse.cz) for
"mm, dump_page(): do not crash with invalid mapping pointer"
(http://lkml.kernel.org/r/20200331165454.12263-1-vbabka@suse.cz).

Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/debug.c~maccess-always-use-strict-semantics-for-probe_kernel_read-fix
+++ a/mm/debug.c
@@ -120,9 +120,9 @@ void __dump_page(struct page *page, cons
 		 * mapping can be invalid pointer and we don't want to crash
 		 * accessing it, so probe everything depending on it carefully
 		 */
-		if (probe_kernel_read_strict(&host, &mapping->host,
-						sizeof(struct inode *)) ||
-		    probe_kernel_read_strict(&a_ops, &mapping->a_ops,
+		if (probe_kernel_read(&host, &mapping->host,
+					sizeof(struct inode *)) ||
+		    probe_kernel_read(&a_ops, &mapping->a_ops,
 				sizeof(struct address_space_operations *))) {
 			pr_warn("failed to read mapping->host or a_ops, mapping not a valid kernel address?\n");
 			goto out_mapping;
@@ -133,7 +133,7 @@ void __dump_page(struct page *page, cons
 			goto out_mapping;
 		}
 
-		if (probe_kernel_read_strict(&dentry_first,
+		if (probe_kernel_read(&dentry_first,
 			&host->i_dentry.first, sizeof(struct hlist_node *))) {
 			pr_warn("mapping->a_ops:%ps with invalid mapping->host inode address %px\n",
 				a_ops, host);
@@ -146,7 +146,7 @@ void __dump_page(struct page *page, cons
 		}
 
 		dentry_ptr = container_of(dentry_first, struct dentry, d_u.d_alias);
-		if (probe_kernel_read_strict(&dentry, dentry_ptr,
+		if (probe_kernel_read(&dentry, dentry_ptr,
 							sizeof(struct dentry))) {
 			pr_warn("mapping->aops:%ps with invalid mapping->host->i_dentry.first %px\n",
 				a_ops, dentry_ptr);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
maccess-always-use-strict-semantics-for-probe_kernel_read.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
lib-test-get_count_order-long-in-test_bitopsc-fix.patch
lib-test-get_count_order-long-in-test_bitopsc-fix-fix.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-git-rejects.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
