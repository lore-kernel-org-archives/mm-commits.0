Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2434248A1
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816323; cv=none; b=L2hN21kLrMG/vB0DHpQQgDmlPW54JMecyqOUc7Uv3NifhvMC4BfKHGmBdQnYu2B91db9cF34/mdqmuW0t8m1tr8TNC65CCSSo3uAtGbhdc9czwhdbVR/x4isJVzL9YoTZdu0PYBN8uZthaVC0MxmJcs8Ua0sJVS7X4qRQwNY/L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816323; c=relaxed/simple;
	bh=O2XL3AOS4XEfWwHcwsFNv6CjKdT2bjsIbEnvOzoxlTg=;
	h=Date:To:From:Subject:Message-Id; b=g3MYKFrE0gehkMHKj4uC0UqRoW/aRLKWm7u8/Ck9FNF1UpOMTHKbI5YoVWisTgSmO8d81bxEGzKtD/rjyNzDrEH5Ge2z0rb731XtuR6f4ycnu7pBy4fTpLRH3V3oCwyple6zMTWlQB9f4xQTa+hXEwkzAARpYn0zjwgWV667lGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nBZGXNCQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nBZGXNCQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C1C1F00A3A;
	Tue,  4 Aug 2026 04:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816322;
	bh=IpXAAaiMiOskPVol75J7wrsgnGwtyPVX4d9ElfCIC4c=;
	h=Date:To:From:Subject;
	b=nBZGXNCQQXuAA4dxcX8Yfe+ao0h80YkKsNoZhgEyPPEv5NjF1bJ/RHRO5O/5esvDG
	 eORHdViJR9B/P26cj1ZTXRX8GfnTxKNyqu15kzevfVt0jcuzVvL4tkyTio4r3OEVtB
	 32Egnu/KzD14PjKEONhzC3HOVuHnQ1KpG3PxWf0E=
Date: Mon, 03 Aug 2026 21:05:21 -0700
To: mm-commits@vger.kernel.org,yangyingliang@huawei.com,mporter@kernel.crashing.org,alex.bou9@gmail.com,lgs201920130244@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rapidio-clear-mport-net-when-rio_add_net-fails.patch removed from -mm tree
Message-Id: <20260804040522.16C1C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rapidio: clear mport->net when rio_add_net() fails
has been removed from the -mm tree.  Its filename was
     rapidio-clear-mport-net-when-rio_add_net-fails.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


