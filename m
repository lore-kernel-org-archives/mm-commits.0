From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-vt8500-use-devm_ioremap_resource.patch removed
 from -mm tree
Date: Fri, 04 Apr 2014 12:35:08 -0700
Message-ID: <533f096c.X45dBtmAByTCza3h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbaDDTfI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:35:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, linux@prisktech.co.nz, jg1.han@samsung.com

Subject: [merged] rtc-rtc-vt8500-use-devm_ioremap_resource.patch removed from -mm tree
To: jg1.han@samsung.com,linux@prisktech.co.nz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:35:08 -0700


The patch titled
     Subject: rtc: rtc-vt8500: use devm_ioremap_resource()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-vt8500-use-devm_ioremap_resource.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-vt8500: use devm_ioremap_resource()

Use devm_ioremap_resource() in order to make the code simpler, and move
'struct resource *res' from 'struct vt8500_rtc' to vt8500_rtc_probe()
because the 'res' variable is used only in vt8500_rtc_probe().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Tony Prisk <linux@prisktech.co.nz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-vt8500.c |   28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff -puN drivers/rtc/rtc-vt8500.c~rtc-rtc-vt8500-use-devm_ioremap_resource drivers/rtc/rtc-vt8500.c
--- a/drivers/rtc/rtc-vt8500.c~rtc-rtc-vt8500-use-devm_ioremap_resource
+++ a/drivers/rtc/rtc-vt8500.c
@@ -79,7 +79,6 @@
 
 struct vt8500_rtc {
 	void __iomem		*regbase;
-	struct resource		*res;
 	int			irq_alarm;
 	struct rtc_device	*rtc;
 	spinlock_t		lock;		/* Protects this structure */
@@ -209,6 +208,7 @@ static const struct rtc_class_ops vt8500
 static int vt8500_rtc_probe(struct platform_device *pdev)
 {
 	struct vt8500_rtc *vt8500_rtc;
+	struct resource	*res;
 	int ret;
 
 	vt8500_rtc = devm_kzalloc(&pdev->dev,
@@ -219,34 +219,16 @@ static int vt8500_rtc_probe(struct platf
 	spin_lock_init(&vt8500_rtc->lock);
 	platform_set_drvdata(pdev, vt8500_rtc);
 
-	vt8500_rtc->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!vt8500_rtc->res) {
-		dev_err(&pdev->dev, "No I/O memory resource defined\n");
-		return -ENXIO;
-	}
-
 	vt8500_rtc->irq_alarm = platform_get_irq(pdev, 0);
 	if (vt8500_rtc->irq_alarm < 0) {
 		dev_err(&pdev->dev, "No alarm IRQ resource defined\n");
 		return vt8500_rtc->irq_alarm;
 	}
 
-	vt8500_rtc->res = devm_request_mem_region(&pdev->dev,
-					vt8500_rtc->res->start,
-					resource_size(vt8500_rtc->res),
-					"vt8500-rtc");
-	if (vt8500_rtc->res == NULL) {
-		dev_err(&pdev->dev, "failed to request I/O memory\n");
-		return -EBUSY;
-	}
