From: akpm@linux-foundation.org
Subject: + drivers-misc-iwmc3200top-mainc-eliminate-useless-code.patch added to -mm tree
Date: Fri, 22 Jan 2010 17:03:04 -0800
Message-ID: <201001230103.o0N134J8007578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752696Ab0AWBDN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jan 2010 20:03:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, tomas.winkler@intel.com


The patch titled
     drivers/misc/iwmc3200top/main.c: eliminate useless code
has been added to the -mm tree.  Its filename is
     drivers-misc-iwmc3200top-mainc-eliminate-useless-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
