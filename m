From: akpm@linux-foundation.org
Subject: - change-comment-in-include-linux-clkh.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:12:34 -0700
Message-ID: <200810182312.m9INCYRc028021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750773AbYJRXM6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:12:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raimondi@miromico.ch, haavard.skinnemoen@atmel.com, johnstul@us.ibm.com, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     include/linux/clk.h: fix comment
has been removed from the -mm tree.  Its filename was
     change-comment-in-include-linux-clkh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/clk.h: fix comment
From: Alex Raimondi <raimondi@miromico.ch>

clk_get and clk_put may not be used from within interrupt context.  Change
comment to this function.

Signed-off-by: Alex Raimondi <raimondi@miromico.ch>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/clk.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/linux/clk.h~change-comment-in-include-linux-clkh include/linux/clk.h
--- a/include/linux/clk.h~change-comment-in-include-linux-clkh
+++ a/include/linux/clk.h
@@ -35,6 +35,8 @@ struct clk;
  * clk_get may return different clock producers depending on @dev.)
  *
  * Drivers must assume that the clock source is not enabled.
+ *
+ * clk_get should not be called from within interrupt context.
  */
 struct clk *clk_get(struct device *dev, const char *id);
 
@@ -76,6 +78,8 @@ unsigned long clk_get_rate(struct clk *c
  * Note: drivers must ensure that all clk_enable calls made on this
  * clock source are balanced by clk_disable calls prior to calling
  * this function.
+ *
+ * clk_put should not be called from within interrupt context.
  */
 void clk_put(struct clk *clk);
 
_

Patches currently in -mm which might be from raimondi@miromico.ch are

origin.patch

