From: akpm@linux-foundation.org
Subject: [merged] drivers-char-msm_smd_pktc-dont-use-is_err.patch removed from -mm tree
Date: Fri, 26 Aug 2011 12:06:30 -0700
Message-ID: <201108261903.p7QJ3ElC005666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753084Ab1HZTED (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 15:04:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thomas@m3y3r.de, nvishwan@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     drivers/char/msm_smd_pkt.c: don't use IS_ERR()
has been removed from the -mm tree.  Its filename was
     drivers-char-msm_smd_pktc-dont-use-is_err.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/msm_smd_pkt.c: don't use IS_ERR()
From: Thomas Meyer <thomas@m3y3r.de>

The various basic memory allocation function return NULL, not an ERR_PTR.

The semantic patch that makes this change is available in
scripts/coccinelle/null/eno.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Cc: Niranjana Vishwanathapura <nvishwan@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/msm_smd_pkt.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/char/msm_smd_pkt.c~drivers-char-msm_smd_pktc-dont-use-is_err drivers/char/msm_smd_pkt.c
--- a/drivers/char/msm_smd_pkt.c~drivers-char-msm_smd_pktc-dont-use-is_err
+++ a/drivers/char/msm_smd_pkt.c
@@ -379,9 +379,8 @@ static int __init smd_pkt_init(void)
 	for (i = 0; i < NUM_SMD_PKT_PORTS; ++i) {
 		smd_pkt_devp[i] = kzalloc(sizeof(struct smd_pkt_dev),
 					  GFP_KERNEL);
-		if (IS_ERR(smd_pkt_devp[i])) {
-			r = PTR_ERR(smd_pkt_devp[i]);
-			pr_err("kmalloc() failed %d\n", r);
+		if (!smd_pkt_devp[i]) {
+			pr_err("kmalloc() failed\n");
 			goto clean_cdevs;
 		}
 
_

Patches currently in -mm which might be from thomas@m3y3r.de are

origin.patch
linux-next.patch

