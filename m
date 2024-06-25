Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96066145347
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293213; cv=none; b=qkNxM3/OufMCe7Gp7mKRsVjhh5tOMwvbhQUlcEZgy06isjzkSZxIMMsMgyVESLH9J6MCcEpi6u40n6eVKsmk/bpapw6JNnOfoHb7bux9lO5Kj/zuCD794Ns3JkA2Dy0s3Ii06AkM6yVE04L/38lw7IAhnmiW6zrCVwVzseg97Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293213; c=relaxed/simple;
	bh=c6WJSoWaMkJv+9s147wc0dtqXLNg5d8t8f9hdW5UznE=;
	h=Date:To:From:Subject:Message-Id; b=IbG4b8aR0W+cqYronyDm47aJ+UUyxSyY2liF2I8zfm1v4CeQq6BD8naq4QbLsT+4IpCf95aQnuRWm0EyClT5R+yLqIXD9y33yMmxISs2Z979pMRctgOHYf0V/H/L0pq+g8ldO0fDW5g78HX1f7UQARmm1+/L+UlcOaDIfgac/nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0pjC54so; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0pjC54so"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADD0C32782;
	Tue, 25 Jun 2024 05:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293213;
	bh=c6WJSoWaMkJv+9s147wc0dtqXLNg5d8t8f9hdW5UznE=;
	h=Date:To:From:Subject:From;
	b=0pjC54solCXZsb0a6xs0CvrjY1sNIMGFvHC5NwGA8VtU7wNx8eSoXDK7yxjSK/2Pf
	 Lcap8Jf3vNv1sX8ctrvn0BBZ1U9gQnKAVlJC8P8Zo9AffTH6AGXjTZyzZ6kSN/Va14
	 grJA0NCUIA7P5Vb6ZuWOB0ksS+hT0Dbag+GvIero=
Date: Mon, 24 Jun 2024 22:26:52 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,Parthiban.Veerasooran@microchip.com,joel@jms.id.au,jk@ozlabs.org,eajames@linux.ibm.com,christian.gromm@microchip.com,alistair@popple.id.au,adobriyan@gmail.com,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fsi-occ-remove-usage-of-the-deprecated-ida_simple_xx-api.patch removed from -mm tree
Message-Id: <20240625052653.6ADD0C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fsi: occ: remove usage of the deprecated ida_simple_xx() API
has been removed from the -mm tree.  Its filename was
     fsi-occ-remove-usage-of-the-deprecated-ida_simple_xx-api.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: fsi: occ: remove usage of the deprecated ida_simple_xx() API
Date: Sat, 8 Jun 2024 16:34:18 +0200

Patch series "Remove usage of the deprecated ida_simple_xx() API".

The series removes the *last* usages of the deprecated ida_simple_xx() API.


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


