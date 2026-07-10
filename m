Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F41757C9F
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 01:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783646096; cv=none; b=rFM+KCB6F2ivp5RYBfeDlcZP8UTP0i2CxlbpFynUJwtpWTMlinJCeLaOYD+lSOz5gGD2Lo3YXfelECUVKfSOs1oOnL7sWaG6ng7kDQ6UgA9a5Vr0B3y6zO/iiG0qk0xgImPrGPYN/fvV953OpF/urn0/DTzqhXIU6pVDeQdrheE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783646096; c=relaxed/simple;
	bh=Vvt4Kf4wTcos7zHLSquShv8CG4dKokoAHubAAkIfKsE=;
	h=Date:To:From:Subject:Message-Id; b=aaYgwT3KDOk0HPhHTGKQDKYjLvSPGQ/mKsnSAgVZ0gxt3ebZ5xSqiExEjGGgkPabXdqJ/KAEBKlVp90LaT+dzFrsUn54RIIjDXQELG99sCOKUwpU0MaZYpdPLqRS1Q9I0+bsH0MCKG+z3A87a0Dtc7F1yC3I2SQZ+Gp6Q+vz2NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yp4tVKw4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yp4tVKw4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC431F000E9;
	Fri, 10 Jul 2026 01:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783646095;
	bh=aLquXaBPl+I2hePSM+09iF2XadAKl8hz8ZeNC1AO5oY=;
	h=Date:To:From:Subject;
	b=Yp4tVKw4HPQ0O5FkJMakQRHcUdlbJ3NPgXzeWwbw1DOaj4ABscaJQIjNP191/gFMx
	 QU3jy2CrPvm1cceZvEeRJWl5gpknzngSRBjt+Cwd8BwgPpvgGDsYsM56BsqSuOyKOZ
	 19l7b3GbulJ1X+11af8knoyoTMzA2RN0B0ivhUZ0=
Date: Thu, 09 Jul 2026 18:14:54 -0700
To: mm-commits@vger.kernel.org,yangyingliang@huawei.com,mporter@kernel.crashing.org,alex.bou9@gmail.com,lgs201920130244@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rapidio-clear-mport-net-when-rio_add_net-fails.patch added to mm-nonmm-unstable branch
Message-Id: <20260710011455.2FC431F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rapidio: clear mport->net when rio_add_net() fails
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rapidio-clear-mport-net-when-rio_add_net-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rapidio-clear-mport-net-when-rio_add_net-fails.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Guangshuo Li <lgs201920130244@gmail.com>
Subject: rapidio: clear mport->net when rio_add_net() fails
Date: Wed, 8 Jul 2026 15:06:28 +0800

rio_alloc_net() stores the newly allocated rio_net in mport->net before
rio_scan_alloc_net() registers the device.

If rio_add_net() fails, rio_scan_alloc_net() drops the device reference
with put_device(), which releases the rio_net through the device release
callback.  However, mport->net is left pointing at the freed object.

A later mport unregister path can then dereference the dangling mport->net
pointer and may try to free the same rio_net again.

Clear mport->net in the rio_add_net() failure path, matching the cleanup
done for the destID table allocation failure path.

Link: https://lore.kernel.org/20260708070628.721010-1-lgs201920130244@gmail.com
Fixes: e842f9a1edf3 ("rapidio: add check for rio_add_net() in rio_scan_alloc_net()")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Yang yingliang <yangyingliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/rapidio/rio-scan.c~rapidio-clear-mport-net-when-rio_add_net-fails
+++ a/drivers/rapidio/rio-scan.c
@@ -874,6 +874,7 @@ static struct rio_net *rio_scan_alloc_ne
 		net->dev.release = rio_scan_release_dev;
 		if (rio_add_net(net)) {
 			put_device(&net->dev);
+			mport->net = NULL;
 			net = NULL;
 		}
 	}
_

Patches currently in -mm which might be from lgs201920130244@gmail.com are

rapidio-clear-mport-net-when-rio_add_net-fails.patch

