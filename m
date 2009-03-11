From: akpm@linux-foundation.org
Subject: [merged] mm-get_nid_for_pfn-returns-int.patch removed from -mm tree
Date: Wed, 11 Mar 2009 11:09:18 -0700
Message-ID: <200903111809.n2BI9IFe019919@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751956AbZCKSKw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 14:10:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, garyhade@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     mm: get_nid_for_pfn() returns int
has been removed from the -mm tree.  Its filename was
     mm-get_nid_for_pfn-returns-int.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: get_nid_for_pfn() returns int
From: Roel Kluin <roel.kluin@gmail.com>

get_nid_for_pfn() returns int

Presumably the (nid < 0) case has never happened.

We do know that it is happening on one system while creating a symlink for
a memory section so it should also happen on the same system if
unregister_mem_sect_under_nodes() were called to remove the same symlink.

The test was actually added in response to a problem with an earlier
version reported by Yasunori Goto where one or more of the leading pages
of a memory section on the 2nd node of one of his systems was
uninitialized because I believe they coincided with a memory hole.  The
earlier version did not ignore uninitialized pages and determined the nid
by considering only the 1st page of each memory section.  This caused the
symlink to the 1st memory section on the 2nd node to be incorrectly
created in /sys/devices/system/node/node0 instead of
/sys/devices/system/node/node1.  The problem was fixed by adding the test
to skip over uninitialized pages.

I suspect we have not seen any reports of the non-removal
of a symlink due to the incorrect declaration of the nid
variable in unregister_mem_sect_under_nodes() because
  - systems where a memory section could have an uninitialized
    range of leading pages are probably rare.
  - memory remove is probably not done very frequently on the
    systems that are capable of demonstrating the problem.
  - lingering symlink(s) that should have been removed may
    have simply gone unnoticed.

[garyhade@us.ibm.com: wrote changelog]
Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Gary Hade <garyhade@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/node.c~mm-get_nid_for_pfn-returns-int drivers/base/node.c
--- a/drivers/base/node.c~mm-get_nid_for_pfn-returns-int
+++ a/drivers/base/node.c
@@ -303,7 +303,7 @@ int unregister_mem_sect_under_nodes(stru
 	sect_start_pfn = section_nr_to_pfn(mem_blk->phys_index);
 	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
 	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
-		unsigned int nid;
+		int nid;
 
 		nid = get_nid_for_pfn(pfn);
 		if (nid < 0)
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
acpi-get_throttling_state-cannot-be-larger-state_count.patch
acpi-wmic-unsigned-cannot-be-less-than-0.patch
powerpc-spufs-check-file-offset-before-calculating-write-size-in-fixed-sized-files.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
jffs2_acl_count-tests-0-on-unsigned.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
hugetlb-chg-cannot-become-less-than-0.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-fix-macros.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
rtc-test-before-subtraction-on-unsigned.patch
rtc-test-before-subtraction-on-unsigned-fix.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch
arkfb-fix-misplaced-parentheses.patch
uvesafb-bitwise-or-has-higher-precedence-than.patch
vesafb-bitwise-or-has-higher-precedence-than.patch
viafb-returns-0-two-too-early.patch
ufs-sector_t-cannot-be-negative.patch
hppfs-hppfs_read_file-may-return-error.patch
rio-addition-has-higher-precedence-than.patch

