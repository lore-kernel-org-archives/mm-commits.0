Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85413BED7A;
	Sun, 27 Sep 2026 20:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790540874; cv=none; b=Njx+VCE1TLp7eoimuZpkkvdu/aowik30RxNlfUY4W4QxUxleom4Mlx9Evpn/3jaaiRVvM0aVAG2yVpZA7QMyn8pWTQsgGVJLsxUMsdW0luInvglG+Fdbjb19srIPP5oDwNuPeIe5/KjsJ+NAW/1XNI21+hwb0qnje98NmSiw4BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790540874; c=relaxed/simple;
	bh=572VQmqb2dfr1RNCIBhU4ug/vBbdVLwltPNy6Oz231I=;
	h=Date:To:From:Subject:Message-Id; b=NRYwzbTG4dv3kMBaTT6GfTsp4Jv4wPR7JvYME9cLaexulsXKMAdq8AQI6tIJVyZh2YRfhhXdAKqFG7I+xm83kuR46qdbazU2c/T9klyG9qGp95OCoIIQerYp65f3Y7fDCeDEcqqeNEtbyIFvv+x2+Ayf+SXJkbZbMOYt7JFMxIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lh0WnP6W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lh0WnP6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A34B1F000FF;
	Sun, 27 Sep 2026 20:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790540873;
	bh=fi8EgsrgABmEiHSBJmJmlyhtzsI0fsLLXGIf4h1us88=;
	h=Date:To:From:Subject;
	b=Lh0WnP6WwtQyoMhrNQrDtqPEdp3L2VAav3QxXuMKGtmqdMOeKoVTUmzx1qBF1E8Hn
	 tphq5tweO9MYG5gvPkqrB54t9R9AuqmS9EkjYsScMn8+gxrgxUK2+MW8KhSV1/vJFH
	 j9jHBL9Hagt0Qs7YiTOagLA6X9l3gpSbEDZZ/rUc=
Date: Sun, 27 Sep 2026 13:27:52 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,stable@vger.kernel.org,joao.m.martins@oracle.com,dave.jiang@intel.com,alison.schofield@intel.com,yaojiale02@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dax-device-defer-publishing-the-dynamic-pgmap.patch added to mm-new branch
Message-Id: <20260927202753.4A34B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dax/device: defer publishing the dynamic pgmap
has been added to the -mm mm-new branch.  Its filename is
     dax-device-defer-publishing-the-dynamic-pgmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dax-device-defer-publishing-the-dynamic-pgmap.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

dax-device-defer-publishing-the-dynamic-pgmap.patch

