From: akpm@linux-foundation.org
Subject: + change-comment-in-include-linux-clkh.patch added to -mm tree
Date: Fri, 10 Oct 2008 19:48:45 -0700
Message-ID: <200810110248.m9B2mjne002563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751570AbYJKCuD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 22:50:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raimondi@miromico.ch, haavard.skinnemoen@atmel.com, johnstul@us.ibm.com, rmk+kernel@arm.linux.org.uk


The patch titled
     include/linux/clk.h: fix comment
has been added to the -mm tree.  Its filename is
     change-comment-in-include-linux-clkh.patch

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

git-avr32.patch
change-comment-in-include-linux-clkh.patch

