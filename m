From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-iwmc3200top-mainc-eliminate-useless-code.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:06:04 -0800
Message-ID: <201003091906.o29J64Fu031155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755336Ab0CITG5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:06:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, tomas.winkler@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/iwmc3200top/main.c: eliminate useless code
has been removed from the -mm tree.  Its filename was
     drivers-misc-iwmc3200top-mainc-eliminate-useless-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/iwmc3200top/main.c: eliminate useless code
From: Julia Lawall <julia@diku.dk>

The variable priv is initialized twice to the same (side effect-free)
expression.  Drop one initialization.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@forall@
idexpression *x;
identifier f!=ERR_PTR;
@@

x = f(...)
... when != x
(
x = f(...,<+...x...+>,...)
|
* x = f(...)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/iwmc3200top/main.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/misc/iwmc3200top/main.c~drivers-misc-iwmc3200top-mainc-eliminate-useless-code drivers/misc/iwmc3200top/main.c
--- a/drivers/misc/iwmc3200top/main.c~drivers-misc-iwmc3200top-mainc-eliminate-useless-code
+++ a/drivers/misc/iwmc3200top/main.c
@@ -597,8 +597,6 @@ static void iwmct_remove(struct sdio_fun
 	struct iwmct_work_struct *read_req;
 	struct iwmct_priv *priv = sdio_get_drvdata(func);
 
-	priv = sdio_get_drvdata(func);
