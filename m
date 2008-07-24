From: akpm@linux-foundation.org
Subject: - aty128fb-test-below-0-on-unsigned-pll-post_divider.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:31:52 -0700
Message-ID: <200807242331.m6ONVqjq011681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756735AbYGXXcD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:32:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, adaplas@pol.net, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     aty128fb: test below 0 on unsigned pll->post_divider
has been removed from the -mm tree.  Its filename was
     aty128fb-test-below-0-on-unsigned-pll-post_divider.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aty128fb: test below 0 on unsigned pll->post_divider
From: Roel Kluin <12o3l@tiscali.nl>

pll->post_divider is unsigned, so the test fails

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Antonino Daplas <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/aty128fb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/video/aty/aty128fb.c~aty128fb-test-below-0-on-unsigned-pll-post_divider drivers/video/aty/aty128fb.c
--- a/drivers/video/aty/aty128fb.c~aty128fb-test-below-0-on-unsigned-pll-post_divider
+++ a/drivers/video/aty/aty128fb.c
@@ -1339,10 +1339,8 @@ static int aty128_var_to_pll(u32 period_
 	if (vclk * 12 < c.ppll_min)
 		vclk = c.ppll_min/12;
 
-	pll->post_divider = -1;
