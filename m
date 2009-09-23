From: akpm@linux-foundation.org
Subject: [merged] mtd-jedec_probe-fix-nec-upd29f064115-detection.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:05:23 -0700
Message-ID: <200909232005.n8NK5NfX023258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753956AbZIWUGD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:06:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ito@mlb.co.jp, David.Woodhouse@intel.com, anemo@mba.ocn.ne.jp, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd: jedec_probe: fix NEC uPD29F064115 detection
has been removed from the -mm tree.  Its filename was
     mtd-jedec_probe-fix-nec-upd29f064115-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: jedec_probe: fix NEC uPD29F064115 detection
From: Hiroshi Ito <ito@mlb.co.jp>

linux v2.6.31-rc6 can not detect NEC uPD29F064115.

uPD29F064115 is a 16 bit device.
datasheet:
  http://www.cn.necel.com/memory/cn/download/M16062EJ2V0DS00.pdf

A problem and fix is described in the following commit, which in the main
kernel tree, uPD29F064115 needs same fix.

commit ca6f12c67ed19718cf37d0f531af9438de85b70c
Author: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Date:   Wed Jul 16 00:09:15 2008 +0900

    [MTD] jedec_probe: Fix SST 16-bit chip detection

    The unlock_addr rework in kernel 2.6.25 breaks 16-bit SST chips.  SST
    39LF160 and SST 39VF1601 are both 16-bit only chip (do not have BYTE#
    pin) and new uaddr value is not correct for them.  Add
    MTD_UADDR_0xAAAA_0x5555 for those chips.  Tested with SST 39VF1601
    chip.

    Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

Signed-off-by: Hiroshi Ito <ito@mlb.co.jp>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/chips/jedec_probe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mtd/chips/jedec_probe.c~mtd-jedec_probe-fix-nec-upd29f064115-detection drivers/mtd/chips/jedec_probe.c
--- a/drivers/mtd/chips/jedec_probe.c~mtd-jedec_probe-fix-nec-upd29f064115-detection
+++ a/drivers/mtd/chips/jedec_probe.c
@@ -1156,8 +1156,8 @@ static const struct amd_flash_info jedec
 		.mfr_id		= MANUFACTURER_NEC,
 		.dev_id		= UPD29F064115,
 		.name		= "NEC uPD29F064115",
-		.devtypes	= CFI_DEVICETYPE_X16|CFI_DEVICETYPE_X8,
-		.uaddr		= MTD_UADDR_0x0555_0x02AA,	/* ???? */
+		.devtypes	= CFI_DEVICETYPE_X16,
+		.uaddr		= MTD_UADDR_0xAAAA_0x5555,
 		.dev_size	= SIZE_8MiB,
 		.cmd_set	= P_ID_AMD_STD,
 		.nr_regions	= 3,
_

Patches currently in -mm which might be from ito@mlb.co.jp are

origin.patch

