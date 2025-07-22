Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5CA286426
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 21:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753220452; cv=none; b=mJWzbdYZOjOAErsLeOvG4H5/ZtQ3Uim2FJfC5Sy1ZQ+2H6oWsQhUdIU8wgZGLiNFxLDEV3btyaw3w/baVeubQpijQtBs2s9KbiO3bhPLITYIOXdHaVSmEisaOcD/tLYswtOs35GcZyf5jPNNPhLVXh7U3p85m9K2cstYvrsD9g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753220452; c=relaxed/simple;
	bh=pvlIB3C0DZ6cBNk2oQOfhyC2PdHEenlKhf9Ru4lDRJw=;
	h=Date:To:From:Subject:Message-Id; b=j5tnte94UUfboIUM8RC+pQLamuDF/KVRJAw9rKaYUWdAjGaU5ew4oUEQmy9awqCNPWz1Y66G4VmnviK4zyVoNOJOS/B0J00++QY46qv8V8I4ZN0J1Ts0LaPJj/mkov3epHLsGpYzgB4f6fkxDkamcv8PWd3eJ96mVMaAvDUhQCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cR3zss9/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cR3zss9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21403C4CEF6;
	Tue, 22 Jul 2025 21:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753220452;
	bh=pvlIB3C0DZ6cBNk2oQOfhyC2PdHEenlKhf9Ru4lDRJw=;
	h=Date:To:From:Subject:From;
	b=cR3zss9/3jjXK9mr2wuyZ98Dpi9/rfAkszLXfiyWA5u8R2VDKIqcEKGUNEZMirxjf
	 ab/OioCpO8OK0bGPLQm9HFNNMUFjeuQWI1j97w23oKUDbtKwJs3RWPUslva7EDPaut
	 BshAp73YXi78cKkkbny8Js5FNOxFuwhGhyhY8xPI=
Date: Tue, 22 Jul 2025 14:40:51 -0700
To: mm-commits@vger.kernel.org,jonathan.cameron@huawei.com,dave.jiang@intel.com,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + cxl-mce-fix-typo-notifer.patch added to mm-nonmm-unstable branch
Message-Id: <20250722214052.21403C4CEF6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: cxl: mce: fix typo "notifer"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     cxl-mce-fix-typo-notifer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cxl-mce-fix-typo-notifer.patch

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
From: WangYuli <wangyuli@uniontech.com>
Subject: cxl: mce: fix typo "notifer"
Date: Tue, 22 Jul 2025 15:34:25 +0800

According to the context, "mce_notifer" should be "mce_notifier".

Link: https://lkml.kernel.org/r/E1EB1BA9FDF07D53+20250722073431.21983-2-wangyuli@uniontech.com
Fixes: 516e5bd0b6bf ("cxl: Add mce notifier to emit aliased address for extended linear cache")
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cxl/core/mce.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cxl/core/mce.h~cxl-mce-fix-typo-notifer
+++ a/drivers/cxl/core/mce.h
@@ -7,7 +7,7 @@
 
 #ifdef CONFIG_CXL_MCE
 int devm_cxl_register_mce_notifier(struct device *dev,
-				   struct notifier_block *mce_notifer);
+				   struct notifier_block *mce_notifier);
 #else
 static inline int
 devm_cxl_register_mce_notifier(struct device *dev,
_

Patches currently in -mm which might be from wangyuli@uniontech.com are

kvm-x86-fix-typo-notifer.patch
cxl-mce-fix-typo-notifer.patch
drm-xe-fix-typo-notifer.patch
net-mvneta-fix-typo-notifer.patch
wifi-brcmfmac-fix-typo-notifer.patch
serial-8250_dw-fix-typo-notifer.patch
xen-xenbus-fix-typo-notifer.patch
scripts-spellingtxt-add-notifernotifier-to-spellingtxt.patch

