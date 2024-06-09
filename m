Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C645514265
	for <mm-commits@vger.kernel.org>; Sun,  9 Jun 2024 21:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717967197; cv=none; b=RaOZIiFG6XxD68uTgdvbpYaJWKJ5CZ7PlbYDveT0Mi4IaYtizDsa6bATDByp6yvY2STMU5O53cx9l/3SxAQbXMDFuGWbQ2C+kDjuWXuyPyxhAiLfUitJn9hF2DOfcWuB/fiMk32AIv1ZBACVvziuLG/XiH2L/7f8K9FTSYBW9Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717967197; c=relaxed/simple;
	bh=ptlaFAxlr03xMyfyU+6oNahBuhXaAhuSOYVia3Ais8I=;
	h=Date:To:From:Subject:Message-Id; b=l96KFie++NM/p7NVrQB9yi479kcDj1DH6S6pM6W9cMC48zq8caE8TqyvVlj0t14mEeFGqZY4A4mSjVkqZBTQgILkEpkL4qivLZYJSlYdowDgOr7DgSuLHONzeNzJhctoPhMdsT3OHSe7gEByqwG0VOzoov6/xK/qwR+WpWfH270=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dtouzU6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dtouzU6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20740C2BD10;
	Sun,  9 Jun 2024 21:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717967197;
	bh=ptlaFAxlr03xMyfyU+6oNahBuhXaAhuSOYVia3Ais8I=;
	h=Date:To:From:Subject:From;
	b=dtouzU6uOUR9YYdxuoGSveSfusKVoyHuiw6PZnlO9tRAmcnu/u2vI4t2YLZu6zSXE
	 ba41M3N1Xy5lkn/9T4x8KzcfC5GJGphW6gPvzgASESMO5GAd+3QH5qr13q0TBbHRLe
	 VLtQXck9vEyg+Ag4vjJo5FVZDjgsC8etVfQBpz0M=
Date: Sun, 09 Jun 2024 14:06:36 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,Parthiban.Veerasooran@microchip.com,joel@jms.id.au,jk@ozlabs.org,eajames@linux.ibm.com,christian.gromm@microchip.com,alistair@popple.id.au,adobriyan@gmail.com,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fsi-occ-remove-usage-of-the-deprecated-ida_simple_xx-api.patch added to mm-nonmm-unstable branch
Message-Id: <20240609210637.20740C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fsi: occ: remove usage of the deprecated ida_simple_xx() API
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fsi-occ-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fsi-occ-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

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
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: fsi: occ: remove usage of the deprecated ida_simple_xx() API
Date: Sat, 8 Jun 2024 16:34:18 +0200

Patch series "Remove usage of the deprecated ida_simple_xx() API".

The serie removes the *last* usages of the deprecated ida_simple_xx() API.


This patch (of 3):

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

Note that the upper limit of ida_simple_get() is exclusive, but the one of
ida_alloc_range() is inclusive.  So, this upper limit, INT_MAX, should
have been changed to INT_MAX-1.

But, it is likely that the INT_MAX 'idx' is valid that the max value passed
to ida_simple_get() should have been 0.

So, allow this INT_MAX 'idx' value now.

Link: https://lkml.kernel.org/r/cover.1717855701.git.christophe.jaillet@wanadoo.fr
Link: https://lkml.kernel.org/r/8e28b0c45fe8f28ca4475fe0027f8099c41259f0.1717855701.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Eddie James <eajames@linux.ibm.com>
Cc: Alistar Popple <alistair@popple.id.au>
Cc: Christian Gromm <christian.gromm@microchip.com>
Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/fsi/fsi-occ.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/drivers/fsi/fsi-occ.c~fsi-occ-remove-usage-of-the-deprecated-ida_simple_xx-api
+++ a/drivers/fsi/fsi-occ.c
@@ -656,17 +656,16 @@ static int occ_probe(struct platform_dev
 		rc = of_property_read_u32(dev->of_node, "reg", &reg);
 		if (!rc) {
 			/* make sure we don't have a duplicate from dts */
-			occ->idx = ida_simple_get(&occ_ida, reg, reg + 1,
-						  GFP_KERNEL);
+			occ->idx = ida_alloc_range(&occ_ida, reg, reg,
+						   GFP_KERNEL);
 			if (occ->idx < 0)
-				occ->idx = ida_simple_get(&occ_ida, 1, INT_MAX,
-							  GFP_KERNEL);
+				occ->idx = ida_alloc_min(&occ_ida, 1,
+							 GFP_KERNEL);
 		} else {
-			occ->idx = ida_simple_get(&occ_ida, 1, INT_MAX,
-						  GFP_KERNEL);
+			occ->idx = ida_alloc_min(&occ_ida, 1, GFP_KERNEL);
 		}
 	} else {
-		occ->idx = ida_simple_get(&occ_ida, 1, INT_MAX, GFP_KERNEL);
+		occ->idx = ida_alloc_min(&occ_ida, 1, GFP_KERNEL);
 	}
 
 	platform_set_drvdata(pdev, occ);
@@ -680,7 +679,7 @@ static int occ_probe(struct platform_dev
 	rc = misc_register(&occ->mdev);
 	if (rc) {
 		dev_err(dev, "failed to register miscdevice: %d\n", rc);
-		ida_simple_remove(&occ_ida, occ->idx);
+		ida_free(&occ_ida, occ->idx);
 		kvfree(occ->buffer);
 		return rc;
 	}
@@ -719,7 +718,7 @@ static int occ_remove(struct platform_de
 	else
 		device_for_each_child(&pdev->dev, NULL, occ_unregister_of_child);
 
-	ida_simple_remove(&occ_ida, occ->idx);
+	ida_free(&occ_ida, occ->idx);
 
 	return 0;
 }
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

fsi-occ-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
most-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
proc-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

