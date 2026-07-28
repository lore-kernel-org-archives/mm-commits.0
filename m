Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D521E17C211;
	Tue, 28 Jul 2026 00:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785200336; cv=none; b=WcRSHjengPVwPj79Ddfbn2lvPSacvRIHbWSSXJ6NXyaskios/F2lQy40sG2meTUI81DARrtlh5O4FRpfqgsCzObfHFuEq7JmLGad1+G74cLMy+5AahpZzNNspFqLA7Y0OjTniOB3uA/Gb4z0tp0m2lpGdM4aASrvqmLkyXriN+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785200336; c=relaxed/simple;
	bh=bOepoL0IvnfGrKO76D0Ujh8P7H6S/ZWFYiSL6T9Dxog=;
	h=Date:To:From:Subject:Message-Id; b=RJsvEaq5aTy06r2+5DFw50Euqp/4GNNOrikqDAlgSwgLgficPEad28BUVG+mTa6nQdBCWRAe3l3dF7YNoJpIs1inVsBOR5wLzj4svkD3MeRYElgYVAxpylzHds49BEgifhPrDZ/wAMTA1f/yhB3cpjBNQKWrGxY61Q8cwkDpv6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yhCWx7N9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yhCWx7N9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E1C1F000E9;
	Tue, 28 Jul 2026 00:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785200334;
	bh=4B4bjR37Eh7Rn5EPN3/WtW37PgvpD3qHrWgpV2Fmz/c=;
	h=Date:To:From:Subject;
	b=yhCWx7N9UE9ZSCLzDPQjFAv93VpZAI0Gtb5J2nykk666M+lEggIem7hX4wP/GXOhw
	 gnm39DHGQjBmOPL8s+i2ADP+ZCRZJfNBcHZzoatEC+r2lTGHYo6x26IUyNvxBdC6a8
	 72UYdsPDjaT5y4riLMqLPHaJ6hm+CR3LOrYVUdWk=
Date: Mon, 27 Jul 2026 17:58:54 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mporter@kernel.crashing.org,gregkh@linuxfoundation.org,error27@gmail.com,alex.bou9@gmail.com,james010kim@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] rapidio-mport_cdev-fix-use-after-free-in-dma_req_free.patch removed from -mm tree
Message-Id: <20260728005854.87E1C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rapidio: mport_cdev: fix use-after-free in dma_req_free()
has been removed from the -mm tree.  Its filename was
     rapidio-mport_cdev-fix-use-after-free-in-dma_req_free.patch

This patch was dropped because an updated version will be issued

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
Reviewed-by: Dan Carpenter <error27@gmail.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
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


