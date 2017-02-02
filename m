From: akpm@linux-foundation.org
Subject: [alternative-merged]
 mmfsdax-change-pmd_fault-to-huge_fault-fix-fix.patch removed from -mm tree
Date: Thu, 02 Feb 2017 14:42:11 -0800
Message-ID: <5893b5c3.CS3BDLCzZpO/7T1e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52222 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751520AbdBBWmM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2017 17:42:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, dave.jiang@intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: ext4: fix up huge_fault rename
has been removed from the -mm tree.  Its filename was
     mmfsdax-change-pmd_fault-to-huge_fault-fix-fix.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: ext4: fix up huge_fault rename

It looks like a search+replace accidentally change one function pointer
that should have remained as before, as shown by this new warning:

fs/ext4/file.c:279:1: error: 'ext4_dax_huge_fault' defined but not used [-Werror=unused-function]

This reverts the one line of the changeset.

Fixes: 80a841811260 ("mm,fs,dax: change ->pmd_fault to ->huge_fault")
Link: http://lkml.kernel.org/r/20170202113625.702169-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext4/file.c~mmfsdax-change-pmd_fault-to-huge_fault-fix-fix fs/ext4/file.c
--- a/fs/ext4/file.c~mmfsdax-change-pmd_fault-to-huge_fault-fix-fix
+++ a/fs/ext4/file.c
@@ -329,7 +329,7 @@ static int ext4_dax_pfn_mkwrite(struct v
 static const struct vm_operations_struct ext4_dax_vm_ops = {
 	.fault		= ext4_dax_fault,
 	.huge_fault	= ext4_dax_fault,
-	.page_mkwrite	= ext4_dax_fault,
+	.page_mkwrite	= ext4_dax_huge_fault,
 	.pfn_mkwrite	= ext4_dax_pfn_mkwrite,
 };
 #else
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-track-active-portions-of-a-section-at-boot-fix-fix.patch
mm-support-section-unaligned-zone_device-memory-ranges-fix.patch
mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf-fix.patch
lib-add-config_test_sort-to-enable-self-test-of-sort-fix.patch

