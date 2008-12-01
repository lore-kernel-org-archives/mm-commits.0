From: akpm@linux-foundation.org
Subject: - m25p80-fix-detection-of-m25p16-flashes.patch removed from -mm tree
Date: Mon, 01 Dec 2008 11:49:19 -0800
Message-ID: <200812011949.mB1JnJY5025191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752553AbYLATt1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 14:49:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, Michael.Hennerich@analog.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     m25p80: fix detection of m25p16 flashes
has been removed from the -mm tree.  Its filename was
     m25p80-fix-detection-of-m25p16-flashes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m25p80: fix detection of m25p16 flashes
From: Mike Frysinger <vapier@gentoo.org>

Commit d0e8c47c58575b9131e786edb488fd029eba443e ("m25p80.c extended jedec
support") added support for extended ids but seems to break on flashes
which don't have an extended id defined.  If the table does not have an
extid defined, then we should ignore it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Michael Hennerich <Michael.Hennerich@analog.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/m25p80.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/devices/m25p80.c~m25p80-fix-detection-of-m25p16-flashes drivers/mtd/devices/m25p80.c
--- a/drivers/mtd/devices/m25p80.c~m25p80-fix-detection-of-m25p16-flashes
+++ a/drivers/mtd/devices/m25p80.c
@@ -575,7 +575,7 @@ static struct flash_info *__devinit jede
 			tmp < ARRAY_SIZE(m25p_data);
 			tmp++, info++) {
 		if (info->jedec_id == jedec) {
-			if (ext_jedec != 0 && info->ext_id != ext_jedec)
+			if (info->ext_id != 0 && info->ext_id != ext_jedec)
 				continue;
 			return info;
 		}
_

Patches currently in -mm which might be from vapier@gentoo.org are

linux-next.patch
linux-timexh-cleanup-for-userspace.patch
mtd-physmap-make-physmap-compat-explicit.patch
linux-serialh-touchup-for-userspace.patch
autodetect_raid-add-missing-__init-marking.patch

