From: akpm@linux-foundation.org
Subject: [merged] rtc-parisc-remove-redundant-locking.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:41:53 -0700
Message-ID: <200904011841.n31IfrfL009514@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934125AbZDATnx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:43:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dannf@hp.com, a.zummo@towertech.it, grundler@parisc-linux.org, kyle@mcmartin.ca, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     rtc-parisc: remove redundant locking
has been removed from the -mm tree.  Its filename was
     rtc-parisc-remove-redundant-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-parisc: remove redundant locking
From: dann frazier <dannf@hp.com>

The RTC subsystem proides ops locking, no need to implement our own

Signed-off-by: dann frazier <dannf@hp.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-parisc.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-parisc.c~rtc-parisc-remove-redundant-locking drivers/rtc/rtc-parisc.c
--- a/drivers/rtc/rtc-parisc.c~rtc-parisc-remove-redundant-locking
+++ a/drivers/rtc/rtc-parisc.c
@@ -14,17 +14,13 @@
 /* as simple as can be, and no simpler. */
 struct parisc_rtc {
 	struct rtc_device *rtc;
-	spinlock_t lock;
 };
 
 static int parisc_get_time(struct device *dev, struct rtc_time *tm)
 {
-	struct parisc_rtc *p = dev_get_drvdata(dev);
-	unsigned long flags, ret;
+	unsigned long ret;
 
-	spin_lock_irqsave(&p->lock, flags);
 	ret = get_rtc_time(tm);
-	spin_unlock_irqrestore(&p->lock, flags);
 
 	if (ret & RTC_BATT_BAD)
 		return -EOPNOTSUPP;
@@ -34,13 +30,9 @@ static int parisc_get_time(struct device
 
 static int parisc_set_time(struct device *dev, struct rtc_time *tm)
 {
-	struct parisc_rtc *p = dev_get_drvdata(dev);
-	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(&p->lock, flags);
 	ret = set_rtc_time(tm);
-	spin_unlock_irqrestore(&p->lock, flags);
 
 	if (ret < 0)
 		return -EOPNOTSUPP;
@@ -61,8 +53,6 @@ static int __devinit parisc_rtc_probe(st
 	if (!p)
 		return -ENOMEM;
 
-	spin_lock_init(&p->lock);
