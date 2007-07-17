From: akpm@linux-foundation.org
Subject: - nfs-invariant-fix.patch removed from -mm tree
Date: Tue, 17 Jul 2007 01:13:16 -0700
Message-ID: <200707170813.l6H8DHsc006996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53691 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933248AbXGQIN0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 04:13:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     nfs-invariant-fix
has been removed from the -mm tree.  Its filename was
     nfs-invariant-fix.patch

This patch was dropped because it was folded into fs-introduce-some-page-buffer-invariants.patch

------------------------------------------------------
Subject: nfs-invariant-fix
From: Nick Piggin <nickpiggin@yahoo.com.au>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page-writeback.c~nfs-invariant-fix mm/page-writeback.c
--- a/mm/page-writeback.c~nfs-invariant-fix
+++ a/mm/page-writeback.c
@@ -824,7 +824,7 @@ int __set_page_dirty_nobuffers(struct pa
 		mapping2 = page_mapping(page);
 		if (mapping2) { /* Race with truncate? */
 			BUG_ON(mapping2 != mapping);
-			WARN_ON(!PageUptodate(page));
+			WARN_ON(!PagePrivate(page) && !PageUptodate(page));
 			if (mapping_cap_account_dirty(mapping)) {
 				__inc_zone_page_state(page, NR_FILE_DIRTY);
 				task_io_account_write(PAGE_CACHE_SIZE);
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

origin.patch
ocfs2-release-page-lock-before-calling-page_mkwrite.patch
document-page_mkwrite-locking.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
fs-introduce-some-page-buffer-invariants.patch
nfs-invariant-fix.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
sched2-sched-domain-sysctl.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
