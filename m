Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42975261B71;
	Tue, 28 Jul 2026 01:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785200412; cv=none; b=ECbCqRmSwhG4ZE09FHUSykibMXnlaffR0NYwFfEDDjeSRrsExVxdWANe2/Vqq6Ahrbfc6nUcsy9Vd+W04zfSD7zv3NXVXkOD2TZxevHs4HTV2MhsikQy1JIC/+qEHtCGEFT5h/FBgy0ho+wNyETb4WlUp7uVjeF3foycisRv+gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785200412; c=relaxed/simple;
	bh=GUtkgyKZMUl6G82wFhtKPCd2IRFRABAkNgX+wlmUKOU=;
	h=Date:To:From:Subject:Message-Id; b=P85Q6Q06IRJn23AdpZ52BFih+puTQS/mV4H7e1PXpKbPFYbG/uOweLS5wY1aameCIZg6awp/pbJ4LOL63QLo8AYx1VVwhphgurx5hp/SoPrGmqmuoEcMxvUOhcE7xA03+p5IJR6j110Dy2Hm8C1pSDVaOE9xsPQM3ERGSAJAZ78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1LCNS/4m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1LCNS/4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5411F000E9;
	Tue, 28 Jul 2026 01:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785200409;
	bh=+ekvYRaDcrAeZfAF0V4F4da5Dnh+gWmswDQ7EKDu5TA=;
	h=Date:To:From:Subject;
	b=1LCNS/4m1edEh4NeChLcbxLUx0qUtqqPml2KX4ku15YDj6yDsNCKAh5NAga/A5aTn
	 1PRTWUhaeZrV2VaaQDNdmNvHrWA6Xh6iB+8fyRaGTiueCaroMnHCADcDmkZrZpb/Wt
	 Zl4yJXJV5AteoSNTKFvrJJcbDaT07AzOn6GDBVH8=
Date: Mon, 27 Jul 2026 18:00:08 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mporter@kernel.crashing.org,gregkh@linuxfoundation.org,error27@gmail.com,alex.bou9@gmail.com,james010kim@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rapidio-mport_cdev-fix-use-after-free-in-dma_req_free.patch added to mm-nonmm-unstable branch
Message-Id: <20260728010009.0F5411F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rapidio: mport_cdev: fix use-after-free in dma_req_free()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rapidio-mport_cdev-fix-use-after-free-in-dma_req_free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rapidio-mport_cdev-fix-use-after-free-in-dma_req_free.patch

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
From: James Kim <james010kim@gmail.com>
Subject: rapidio: mport_cdev: fix use-after-free in dma_req_free()
Date: Fri, 24 Jul 2026 08:52:20 +0900

dma_req_free() acquires buf_mutex through req->map, drops the mapping
reference with kref_put(), and then dereferences req->map again to unlock
the mutex.

If kref_put() drops the last reference, mport_release_mapping() frees the
mapping, and the subsequent mutex_unlock() dereferences a freed object. 
This is a use-after-free.

Fix this by caching map and md before kref_put(), clearing req->map while
holding buf_mutex, and using the cached md for mutex unlocking.

The bug is reachable from userspace via the RapidIO mport character device
interface.

Link: https://lore.kernel.org/20260723235220.588424-1-james010kim@gmail.com
Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Signed-off-by: James Kim <james010kim@gmail.com>
Reviewed-by: Dan Carpenter <error27@gmail.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-mport_cdev-fix-use-after-free-in-dma_req_free
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -564,9 +564,13 @@ static void dma_req_free(struct kref *re
 	}
 
 	if (req->map) {
-		mutex_lock(&req->map->md->buf_mutex);
-		kref_put(&req->map->ref, mport_release_mapping);
-		mutex_unlock(&req->map->md->buf_mutex);
+		struct rio_mport_mapping *map = req->map;
+		struct mport_dev *md = map->md;
+
+		mutex_lock(&md->buf_mutex);
+		req->map = NULL;
+		kref_put(&map->ref, mport_release_mapping);
+		mutex_unlock(&md->buf_mutex);
 	}
 
 	kref_put(&priv->dma_ref, mport_release_dma);
_

Patches currently in -mm which might be from james010kim@gmail.com are

rapidio-mport_cdev-fix-use-after-free-in-dma_req_free.patch

