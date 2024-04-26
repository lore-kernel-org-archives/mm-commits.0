Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F2982491
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104492; cv=none; b=YmJBdGqymSDZZC3cT1s14Hu7j1tPPzj4BU17a6fUQpfe1hfFBPciqVcf84VRhQfuYN2Igggf9v06gTrA2hb5d9I43zwSEYhzhzyAaWBx2lgmZOMZmCQshKfWOZ4odXbX/8BJu8FGaUCxqiwy9udptKMI8s4Ents5iRqPI745rDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104492; c=relaxed/simple;
	bh=XuLIxj/LUSCiMse9RdTUZ5ar6PcCYzXL2WGgtgpSuik=;
	h=Date:To:From:Subject:Message-Id; b=L5x/XcF124n7gFRIYWkc8K22rErPD41bTAbHVyjgsJxirHxpPg2aXByCjJzS5ePRG1SjIcvZ+heBVjKDoBClRwDW0tlBQGtPtDiK4xKmIPjfY4FiG6f+cwOM5nj7ST3UHtyYfZ37YBlhm/4N4PYOjgRtpL+h6nbuJXLf15FBISs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aJbcaBWc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aJbcaBWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F2BC113CD;
	Fri, 26 Apr 2024 04:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104491;
	bh=XuLIxj/LUSCiMse9RdTUZ5ar6PcCYzXL2WGgtgpSuik=;
	h=Date:To:From:Subject:From;
	b=aJbcaBWcmSb/AJYSgiA0RpgkLnAWQJ7QRvTEYGxiXZ5lULqDAg/pT+yEnKFLGq7YE
	 f2cp+/QzxmKqXB1l8+y2WtHsRnLbTvgRp3xMo6dGdbZpc7qzbYI2VWaDK8Lqq+eNme
	 327jtgmDZs1ZSxfmc52Vv2SU5wlRqKW7AimrPiMM=
Date: Thu, 25 Apr 2024 21:08:11 -0700
To: mm-commits@vger.kernel.org,wintera@linux.ibm.com,twinkler@linux.ibm.com,svens@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,borntraeger@linux.ibm.com,arnd@arndb.de,agordeev@linux.ibm.com,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] s390-vmlogrdr-remove-function-pointer-cast.patch removed from -mm tree
Message-Id: <20240426040811.C7F2BC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/vmlogrdr: remove function pointer cast
has been removed from the -mm tree.  Its filename was
     s390-vmlogrdr-remove-function-pointer-cast.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: s390/vmlogrdr: remove function pointer cast
Date: Wed, 17 Apr 2024 11:24:35 -0700

Patch series "drivers/s390: Fix instances of -Wcast-function-type-strict".

This series resolves the instances of -Wcast-function-type-strict that
show up in my s390 builds on -next, which has this warning enabled by
default.


This patch (of 3):

Clang warns (or errors with CONFIG_WERROR) after enabling
-Wcast-function-type-strict by default:

  drivers/s390/char/vmlogrdr.c:746:18: error: cast from 'void (*)(const void *)' to 'void (*)(struct device *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
    746 |                 dev->release = (void (*)(struct device *))kfree;
        |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  1 error generated.

Add a standalone function to fix the warning properly, which addresses
the root of the warning that these casts are not safe for kCFI. The
comment is not really relevant after this change, so remove it.

Link: https://lkml.kernel.org/r/20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org
Link: https://lkml.kernel.org/r/20240417-s390-drivers-fix-cast-function-type-v1-1-fd048c9903b0@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandra Winter <wintera@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thorsten Winkler <twinkler@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/char/vmlogrdr.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/s390/char/vmlogrdr.c~s390-vmlogrdr-remove-function-pointer-cast
+++ a/drivers/s390/char/vmlogrdr.c
@@ -722,6 +722,10 @@ static void vmlogrdr_unregister_driver(v
 	iucv_unregister(&vmlogrdr_iucv_handler, 1);
 }
 
+static void vmlogrdr_free_dev(struct device *dev)
+{
+	kfree(dev);
+}
 
 static int vmlogrdr_register_device(struct vmlogrdr_priv_t *priv)
 {
@@ -736,14 +740,7 @@ static int vmlogrdr_register_device(stru
 		dev->driver = &vmlogrdr_driver;
 		dev->groups = vmlogrdr_attr_groups;
 		dev_set_drvdata(dev, priv);
-		/*
-		 * The release function could be called after the
-		 * module has been unloaded. It's _only_ task is to
-		 * free the struct. Therefore, we specify kfree()
-		 * directly here. (Probably a little bit obfuscating
-		 * but legitime ...).
-		 */
-		dev->release = (void (*)(struct device *))kfree;
+		dev->release = vmlogrdr_free_dev;
 	} else
 		return -ENOMEM;
 	ret = device_register(dev);
_

Patches currently in -mm which might be from nathan@kernel.org are


