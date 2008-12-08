From: akpm@linux-foundation.org
Subject: - drivers-isdn-misdn-use-array_size.patch removed from -mm tree
Date: Mon, 08 Dec 2008 15:24:07 -0800
Message-ID: <200812082324.mB8NO747006770@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753106AbYLHXYT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 18:24:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers/isdn/mISDN: use ARRAY_SIZE
has been removed from the -mm tree.  Its filename was
     drivers-isdn-misdn-use-array_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/isdn/mISDN: use ARRAY_SIZE
From: Julia Lawall <julia@diku.dk>

ARRAY_SIZE is more concise to use when the size of an array is divided by
the size of its type or the size of its first element.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@i@
@@

#include <linux/kernel.h>

@depends on i using "paren.iso"@
type T;
T[] E;
@@

- (sizeof(E)/sizeof(T))
+ ARRAY_SIZE(E)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/mISDN/dsp_hwec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/mISDN/dsp_hwec.c~drivers-isdn-misdn-use-array_size drivers/isdn/mISDN/dsp_hwec.c
--- a/drivers/isdn/mISDN/dsp_hwec.c~drivers-isdn-misdn-use-array_size
+++ a/drivers/isdn/mISDN/dsp_hwec.c
@@ -43,7 +43,7 @@ static struct mISDN_dsp_element dsp_hwec
 	.free = NULL,
 	.process_tx = NULL,
 	.process_rx = NULL,
-	.num_args = sizeof(args) / sizeof(struct mISDN_dsp_element_arg),
+	.num_args = ARRAY_SIZE(args),
 	.args = args,
 };
 struct mISDN_dsp_element *dsp_hwec = &dsp_hwec_p;
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
arch-arm-eliminate-null-test-and-memset-after-alloc_bootmem.patch
arch-avr32-eliminate-null-test-and-memset-after-alloc_bootmem.patch
powerpc-chrp-add-missing-of_node_put-in-pcic.patch
powerpc-powermac-add-missing-of_node_put.patch
drivers-media-video-cx88-cx88-alsac-adjust-error-handling-code.patch
arch-ia64-eliminate-null-test-and-memset-after-alloc_bootmem.patch
drivers-mtd-maps-nettelc-use-array_size.patch
net-tipc-bcasth-use-array_size.patch
fs-namespacec-drop-code-after-return.patch
mm-page_allocc-eliminate-null-test-and-memset-after-alloc_bootmem.patch
drivers-macintosh-add-missing-of_node_put-in-therm_adt746xc.patch

