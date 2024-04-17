Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC34D3B1AC
	for <mm-commits@vger.kernel.org>; Wed, 17 Apr 2024 20:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713385693; cv=none; b=bxYFLxKGAqkIMTBgHTus+SyMmPKUfTtPv4jWS1VqwdGSC2nBbOS7utpPGH5SaCzxSIbednKCYIeiSVdgboUkTfdt6qFHA6WIksMRgRnZyKZvT8+zxR5Zfp3GwkZioeaqp9BkHufZf+yO9JwAYUIAPYelIAac4tJVB7cRGaTQSnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713385693; c=relaxed/simple;
	bh=APX/daaXp8mU3bBTd8bwjWU7aCWZEonc9R8Fi8Cc7r8=;
	h=Date:To:From:Subject:Message-Id; b=YtikMw54ESuj8+mxIKyIFeh1EddN8yLezeIaT/EBpsFjrXcalWLY8ObN+iKpLVtT1cxKjJdob3V0l1r/nPOoVQgE1TNNconMpp19YzJQc1hxNibC8z713IOuXT3j3jpDB4MriF2D4Tp20NvnyinMP56KcUsG8568FeDNCZYy3TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AXtZJfG4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AXtZJfG4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A4CC072AA;
	Wed, 17 Apr 2024 20:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713385692;
	bh=APX/daaXp8mU3bBTd8bwjWU7aCWZEonc9R8Fi8Cc7r8=;
	h=Date:To:From:Subject:From;
	b=AXtZJfG4A+5Ns/YBBEPymZYPUk1SCrIY0cp4U3MKa4AqLv84HaAl/K5HlwCQpfZI8
	 MlAS5dSU5WLZwLjR4hu6ZauS98cTAGWgPHN5EodL+lboJAukprUgdiVrLm+tDtSzHS
	 ehBOtIDcfC9dY1LYxn1lFTMTT8kNGRaEmrKinPcU=
Date: Wed, 17 Apr 2024 13:28:11 -0700
To: mm-commits@vger.kernel.org,wintera@linux.ibm.com,twinkler@linux.ibm.com,svens@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,borntraeger@linux.ibm.com,arnd@arndb.de,agordeev@linux.ibm.com,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-vmlogrdr-remove-function-pointer-cast.patch added to mm-nonmm-unstable branch
Message-Id: <20240417202812.58A4CC072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390/vmlogrdr: remove function pointer cast
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     s390-vmlogrdr-remove-function-pointer-cast.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-vmlogrdr-remove-function-pointer-cast.patch

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

s390-vmlogrdr-remove-function-pointer-cast.patch
s390-smsgiucv_app-remove-function-pointer-cast.patch
s390-netiucv-remove-function-pointer-cast.patch

