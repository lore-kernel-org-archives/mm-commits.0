From: akpm@linux-foundation.org
Subject: + nfs-invariant-fix.patch added to -mm tree
Date: Wed, 16 May 2007 08:40:34 -0700
Message-ID: <200705161540.l4GFeX51003925@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35183 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756492AbXEPPmE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 May 2007 11:42:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nickpiggin@yahoo.com.au


The patch titled
     nfs-invariant-fix
has been added to the -mm tree.  Its filename is
     nfs-invariant-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -826,7 +826,7 @@ int __set_page_dirty_nobuffers(struct pa
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

slob-implement-rcu-freeing.patch
convert-hugetlbfs-to-use-vm_ops-fault.patch
lazy-freeing-of-memory-through-madv_free.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
nfs-invariant-fix.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
sched2-sched-domain-sysctl.patch
