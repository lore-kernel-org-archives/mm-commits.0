Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFB24734FA;
	Tue, 29 Sep 2026 21:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790718970; cv=none; b=hn40BflwcVVMHhj7JZOxnoUwhG2Bk0csFGEVw46wad1yqv6vv7LEtPM5Uewhq1V6Y/07NIdb7bGS1jLcwA6sbeUb/7QQzV9WUUmtdvKixsgODYVgDyIhCQouXdYVX/OKIhnCCb6fHIa7A0WeO9QAsRbPoJqN2u6HAE94is9QATI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790718970; c=relaxed/simple;
	bh=GTYa4sjo8bWJP0K/hWSxAeBxrVlKN7Tq8X8LyyHf/18=;
	h=Date:To:From:Subject:Message-Id; b=RKVcSYNMfG43iVXvjRaCNVoExRmxwtnE4EzsReHiMMKIJGO1hZPdfpjkLKIbp7MsGFtLEXr9Yzv473lNuQw2BfYOPa/64wi41LLu1pxwKT/yp1xaaG5JYzx/1MVN/z2AW/A3jMKIqgfWYy2DKJGOQlYe2vCYHsK/hij5qmByezY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F0ZrTPnB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F0ZrTPnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BEE1F000FF;
	Tue, 29 Sep 2026 21:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790718968;
	bh=JpPEopjtDdRriWdDiSbalTqab0kId/zhJ4B4k/frWHw=;
	h=Date:To:From:Subject;
	b=F0ZrTPnBISi1gk2fuHyhw7kewLDbgdrisk73BJGumUKoiJ9pknRxr2ffKgx7u2pgC
	 CWANY7ufYwdfNunDMWSWQRrT7uur0ATDlVolJOQN7oC7g9j1r4tTXHXsOCxUxX+buo
	 ROE5qRpLMR1FfhbnCVG8ocrF670FoECTxrqYMrkk=
Date: Tue, 29 Sep 2026 14:56:07 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,stable@vger.kernel.org,joao.m.martins@oracle.com,dave.jiang@intel.com,alison.schofield@intel.com,yaojiale02@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] dax-device-defer-publishing-the-dynamic-pgmap.patch removed from -mm tree
Message-Id: <20260929215608.60BEE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dax/device: defer publishing the dynamic pgmap
has been removed from the -mm tree.  Its filename was
     dax-device-defer-publishing-the-dynamic-pgmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiale Yao <yaojiale02@163.com>
Subject: dax/device: defer publishing the dynamic pgmap
Date: Sun, 27 Sep 2026 19:47:36 +0800

The dynamic device-dax probe path publishes its devm-allocated pgmap
before several operations that can still fail.  If one of them fails,
devres frees the pgmap while dev_dax->pgmap remains non-NULL.  A later
bind then fails the dynamic-dax invariant check and leaves the device
unusable until its region is recreated.

Defer assigning dev_dax->pgmap until the final devm action has been
installed and probe can no longer fail.  A failed probe then never
publishes the temporary pgmap.

Link: https://lore.kernel.org/20260927114736.1113965-1-yaojiale02@163.com
Fixes: fc65c4eb0b2a ("device-dax: ensure dev_dax->pgmap is valid for dynamic devices")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: <stable@vger.kernel.org>
---

 drivers/dax/device.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/dax/device.c~dax-device-defer-publishing-the-dynamic-pgmap
+++ a/drivers/dax/device.c
@@ -409,7 +409,6 @@ static int dev_dax_probe(struct dev_dax
 			return -ENOMEM;
 
 		pgmap->nr_range = dev_dax->nr_range;
-		dev_dax->pgmap = pgmap;
 
 		for (i = 0; i < dev_dax->nr_range; i++) {
 			struct range *range = &dev_dax->ranges[i].range;
@@ -450,7 +449,13 @@ static int dev_dax_probe(struct dev_dax
 		return rc;
 
 	run_dax(dax_dev);
-	return devm_add_action_or_reset(dev, dev_dax_kill, dev_dax);
+	rc = devm_add_action_or_reset(dev, dev_dax_kill, dev_dax);
+	if (rc)
+		return rc;
+
+	/* Probe can no longer fail; expose the pgmap via dev_dax. */
+	dev_dax->pgmap = pgmap;
+	return 0;
 }
 
 static struct dax_device_driver device_dax_driver = {
_

Patches currently in -mm which might be from yaojiale02@163.com are


