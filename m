From: akpm@linux-foundation.org
Subject: - mm-hugetlb-dont-crash-when-hpage_shift-is-0.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:05:58 -0700
Message-ID: <200808042005.m74K5wHR027633@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753271AbYHDUGB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:06:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     mm/hugetlb: don't crash when HPAGE_SHIFT is 0
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-dont-crash-when-hpage_shift-is-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/hugetlb: don't crash when HPAGE_SHIFT is 0
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Some platform decide whether they support huge pages at boot time.  On
these, such as powerpc, HPAGE_SHIFT is a variable, not a constant, and is
set to 0 when there is no such support.

The patches to introduce multiple huge pages support broke that causing
the kernel to crash at boot time on machines such as POWER3 which lack
support for multiple page sizes.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-dont-crash-when-hpage_shift-is-0 mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-dont-crash-when-hpage_shift-is-0
+++ a/mm/hugetlb.c
@@ -1283,7 +1283,12 @@ module_exit(hugetlb_exit);
 
 static int __init hugetlb_init(void)
 {
-	BUILD_BUG_ON(HPAGE_SHIFT == 0);
+	/* Some platform decide whether they support huge pages at boot
+	 * time. On these, such as powerpc, HPAGE_SHIFT is set to 0 when
+	 * there is no such support
+	 */
+	if (HPAGE_SHIFT == 0)
+		return 0;
 
 	if (!size_to_hstate(default_hstate_size)) {
 		default_hstate_size = HPAGE_SIZE;
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
linux-next.patch
powerpc-replace-__function__-with-__func__.patch
powerpc-86xx-mpc8610_hpcd-add-watchdog-node.patch
radeon-misc-corrections.patch
radeonfb-give-i2c-buses-nicer-names.patch
radeonfb-revert-fix-radeon-ddc-regression.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
powerpc-hugetlb-pgtable-cache-access-cleanup.patch

