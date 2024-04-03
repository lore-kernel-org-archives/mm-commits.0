Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9205DF0E
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 20:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712176529; cv=none; b=rAB6zhciBq+eluZ82IqB9kk6zeI9ymghpK2K9QZC0J4ImcmzDJy/NQgtzmOL+Hj5gHYQ1865/9ugUijQsiVo81844YoYFLThSnXN+3oyZVU7VYopyH87w0WhpaaW7nXJXIF3PQcZm4+XTwT+qh9+kOwTl7n0D3zyyKbvD2ANOb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712176529; c=relaxed/simple;
	bh=p5teQA63lhmM+Z+avSzLmXWyZJ3vZQyTxFoMBh0GRIA=;
	h=Date:To:From:Subject:Message-Id; b=lTNGhOl3VeyICb244UcxdAUiC3ZQLGc5LA6h+9JBmliZrr4Qp/lRK4p85nfdGVjDF9a0j48lwxb2ENxdMlcoWT538u/69o2ZfeMxcYFX4l9pkMbtZIPK42N4DayIMLk9WDwz9vR3vtp8ycTH86cje0corH71o1jv5LuRLQigcNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=agNkwL4n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="agNkwL4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2084C433C7;
	Wed,  3 Apr 2024 20:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712176528;
	bh=p5teQA63lhmM+Z+avSzLmXWyZJ3vZQyTxFoMBh0GRIA=;
	h=Date:To:From:Subject:From;
	b=agNkwL4n8vExIs+M1fOP+bR3VshIXzUEtji/N60poK5AYkR/zGj4NKTKswCE1rzKR
	 b8qua5Rv8JMScwgt43HBtu4A2297gZ0CRqlqLC7HPyZN5/TPzv2N+4KDDtFcX1+YK2
	 Nj3fmImwQOvPdtjQvGYp817o3yAFJWAIp/4/La80=
Date: Wed, 03 Apr 2024 13:35:28 -0700
To: mm-commits@vger.kernel.org,pstanner@redhat.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + devres-switch-to-use-dev_err_probe-for-unification.patch added to mm-nonmm-unstable branch
Message-Id: <20240403203528.C2084C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: devres: switch to use dev_err_probe() for unification
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     devres-switch-to-use-dev_err_probe-for-unification.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/devres-switch-to-use-dev_err_probe-for-unification.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: devres: switch to use dev_err_probe() for unification
Date: Wed, 3 Apr 2024 13:46:56 +0300

Patch series "devres: A couple of cleanups".

A couple of ad-hoc cleanups. No functional changes intended. 


This patch (of 2):

The devm_*() APIs are supposed to be called during the ->probe() stage. 
Many drivers (especially new ones) have switched to use dev_err_probe()
for error messaging for the sake of unification.  Let's do the same in the
devres APIs.

Link: https://lkml.kernel.org/r/20240403104820.557487-1-andriy.shevchenko@linux.intel.com
Link: https://lkml.kernel.org/r/20240403104820.557487-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Philipp Stanner <pstanner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/devres.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/lib/devres.c~devres-switch-to-use-dev_err_probe-for-unification
+++ a/lib/devres.c
@@ -125,12 +125,13 @@ __devm_ioremap_resource(struct device *d
 	resource_size_t size;
 	void __iomem *dest_ptr;
 	char *pretty_name;
+	int ret;
 
 	BUG_ON(!dev);
 
 	if (!res || resource_type(res) != IORESOURCE_MEM) {
-		dev_err(dev, "invalid resource %pR\n", res);
-		return IOMEM_ERR_PTR(-EINVAL);
+		ret = dev_err_probe(dev, -EINVAL, "invalid resource %pR\n", res);
+		return IOMEM_ERR_PTR(ret);
 	}
 
 	if (type == DEVM_IOREMAP && res->flags & IORESOURCE_MEM_NONPOSTED)
@@ -144,20 +145,20 @@ __devm_ioremap_resource(struct device *d
 	else
 		pretty_name = devm_kstrdup(dev, dev_name(dev), GFP_KERNEL);
 	if (!pretty_name) {
-		dev_err(dev, "can't generate pretty name for resource %pR\n", res);
-		return IOMEM_ERR_PTR(-ENOMEM);
+		ret = dev_err_probe(dev, -ENOMEM, "can't generate pretty name for resource %pR\n", res);
+		return IOMEM_ERR_PTR(ret);
 	}
 
 	if (!devm_request_mem_region(dev, res->start, size, pretty_name)) {
-		dev_err(dev, "can't request region for resource %pR\n", res);
-		return IOMEM_ERR_PTR(-EBUSY);
+		ret = dev_err_probe(dev, -EBUSY, "can't request region for resource %pR\n", res);
+		return IOMEM_ERR_PTR(ret);
 	}
 
 	dest_ptr = __devm_ioremap(dev, res->start, size, type);
 	if (!dest_ptr) {
-		dev_err(dev, "ioremap failed for resource %pR\n", res);
 		devm_release_mem_region(dev, res->start, size);
-		dest_ptr = IOMEM_ERR_PTR(-ENOMEM);
+		ret = dev_err_probe(dev, -ENOMEM, "ioremap failed for resource %pR\n", res);
+		return IOMEM_ERR_PTR(ret);
 	}
 
 	return dest_ptr;
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

devres-switch-to-use-dev_err_probe-for-unification.patch
devres-dont-use-proxy-headers.patch

