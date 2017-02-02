From: akpm@linux-foundation.org
Subject: + mmfsdax-change-pmd_fault-to-huge_fault-fix-fix.patch added to
 -mm tree
Date: Thu, 02 Feb 2017 14:40:17 -0800
Message-ID: <5893b551.yLLxPfwbj+QF/rL6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52136 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751496AbdBBWkS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2017 17:40:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, dave.jiang@intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: ext4: fix up huge_fault rename
has been added to the -mm tree.  Its filename is
     mmfsdax-change-pmd_fault-to-huge_fault-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmfsdax-change-pmd_fault-to-huge_fault-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmfsdax-change-pmd_fault-to-huge_fault-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mmfsdax-change-pmd_fault-to-huge_fault-fix-fix.patch
lib-add-config_test_sort-to-enable-self-test-of-sort-fix.patch

