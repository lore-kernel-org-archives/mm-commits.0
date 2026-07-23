Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3DA212550;
	Thu, 23 Jul 2026 00:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784766100; cv=none; b=RLvw9QVW/y6EU4qLP0ZU9PMeeIKq/d0XLiZKKDSnfmClJ7bWBPLVIZW0dhfOLxDScUzWYJmC1L6Rc+ES3HPsDVHmpjS6jTpu+CKfsVZBIPanhin82JT+sg//1VpUTpBc8sZM7sZkJN7HxABNFSBviH8d6DVapRLevvfxYVZWH6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784766100; c=relaxed/simple;
	bh=GJcgIRGP4yxGcDXlHfGwlIYlseX94HASdKFKfb70qaU=;
	h=Date:To:From:Subject:Message-Id; b=vD3KCc0/ZetdRJpzHDW4+012XWHr8fB3HqSIBRPCj4hBoay9oOB9zZfHELSo7/Nm2iU4yZt3OOw84sRLKv0QGey6tATO+iXJlPpDjYaUD0MrpjGSyPTaEXCKeL0E2CN61hreo0GBjkilpxVRyrHrUlVnEM1sWPFZjqAzcsIEnQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HrlSUhI5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HrlSUhI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE6E1F000E9;
	Thu, 23 Jul 2026 00:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784766098;
	bh=YgKMx1CPQIR3ipgUjtLb6j62NqA9HPw9zDd0K+Cpsio=;
	h=Date:To:From:Subject;
	b=HrlSUhI5HVmEY/1oZzIXEjW33NNMsNRqjpAawm5LRUxZViB0X8tcNxvh3iVE4CADo
	 mcwGnNadU0QLUDhCyGigrwCEFO2qyjJ2EqciENTjz9azSqvKmV4R4RrisA6LXYmzEW
	 cqezy0XoYY8n1so6S8H5wJNmEt8SedvcGxN0vc1I=
Date: Wed, 22 Jul 2026 17:21:38 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mporter@kernel.crashing.org,gregkh@linuxfoundation.org,dan.carpenter@linaro.org,alex.bou9@gmail.com,james010kim@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rapidio-mport_cdev-fix-use-after-free-in-dma_req_free.patch added to mm-nonmm-unstable branch
Message-Id: <20260723002138.6CE6E1F000E9@smtp.kernel.org>
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
Date: Mon, 15 Jun 2026 16:05:30 +0900

dma_req_free() drops the mapping reference under buf_mutex and then
dereferences req->map again to unlock the mutex.

If kref_put() drops the last reference, mport_release_mapping() frees the
mapping, and the subsequent mutex_unlock() dereferences a freed object. 
This is a use-after-free.

Fix this by caching map and md before kref_put() and using the cached md
for mutex unlocking.

Link: https://lore.kernel.org/20260615070530.371640-1-james010kim@gmail.com
Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Signed-off-by: James Kim <james010kim@gmail.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-mport_cdev-fix-use-after-free-in-dma_req_free
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -564,9 +564,14 @@ static void dma_req_free(struct kref *re
 	}
 
 	if (req->map) {
-		mutex_lock(&req->map->md->buf_mutex);
-		kref_put(&req->map->ref, mport_release_mapping);
-		mutex_unlock(&req->map->md->buf_mutex);
+		struct rio_mport_mapping *map = req->map;
+		struct mport_dev *md = map->md;
+
+		mutex_lock(&md->buf_mutex);
+		kref_put(&map->ref, mport_release_mapping);
+		mutex_unlock(&md->buf_mutex);
+
+		req->map = NULL;
 	}
 
 	kref_put(&priv->dma_ref, mport_release_dma);
_

Patches currently in -mm which might be from james010kim@gmail.com are

rapidio-mport_cdev-fix-use-after-free-in-dma_req_free.patch

