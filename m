From: akpm@linux-foundation.org
Subject: + rtc-parisc-remove-redundant-locking.patch added to -mm tree
Date: Mon, 26 Jan 2009 13:49:55 -0800
Message-ID: <200901262149.n0QLntIp003855@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753742AbZAZVu6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 16:50:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dannf@hp.com, a.zummo@towertech.it, grundler@parisc-linux.org, kyle@mcmartin.ca, matthew@wil.cx


The patch titled
     rtc-parisc: remove redundant locking
has been added to the -mm tree.  Its filename is
     rtc-parisc-remove-redundant-locking.patch

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
