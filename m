From: akpm@linux-foundation.org
Subject: [merged] bnx2x-use-prandom_bytes.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:11:50 -0800
Message-ID: <20121218201150.AE1EF100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:51951 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab2LRULx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:11:53 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so126231vcd.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:11:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, adrian.hunter@intel.com, david.laight@aculab.com, dedekind1@gmail.com, dwmw2@infradead.org, eilong@broadcom.com, robert.w.love@intel.com, tytso@mit.edu, valdis.kletnieks@vt.edu, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bnx2x: use prandom_bytes()
has been removed from the -mm tree.  Its filename was
     bnx2x-use-prandom_bytes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: bnx2x: use prandom_bytes()

Use prandom_bytes() to fill rss key with pseudo-random bytes.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Eilon Greenstein <eilong@broadcom.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Laight <david.laight@aculab.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Robert Love <robert.w.love@intel.com>
Cc: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c~bnx2x-use-prandom_bytes drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c~bnx2x-use-prandom_bytes
+++ a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -1832,7 +1832,6 @@ int bnx2x_config_rss_pf(struct bnx2x *bp
 			bool config_hash)
 {
 	struct bnx2x_config_rss_params params = {NULL};
-	int i;
 
 	/* Although RSS is meaningless when there is a single HW queue we
 	 * still need it enabled in order to have HW Rx hash generated.
@@ -1864,9 +1863,7 @@ int bnx2x_config_rss_pf(struct bnx2x *bp
 
 	if (config_hash) {
 		/* RSS keys */
-		for (i = 0; i < sizeof(params.rss_key) / 4; i++)
-			params.rss_key[i] = random32();
