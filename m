Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BCB63AC
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739376; cv=none; b=UC1r51EkPD/2kK4R916E07BlIYb/7KIXQyPdS2FOmZHYKnvPXRpewS8CXukMYpiCe6NP1J0UhfgvqkfpCT5u8Pys+2uxvnnzLz1OIezfJjPevB8ZTV4RyoqzL1IVEW95Yiqdq4VMaDHsuqvaT2bQRFT4FiHOUlZNrWokhUJQcPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739376; c=relaxed/simple;
	bh=R/PxesR04S+MqnxEcPaU1YSEcW0bZNT8Rf47oRni2PE=;
	h=Date:To:From:Subject:Message-Id; b=sYDenLM3W89c/VUwdqwAw7hSKPeUx1JS8KE3n9TvpNRyZpfti/ICM2jluQp/IpU3wR3HQRbWCrmZxWP7MFrcLmPJycPz5oxDw3p1ohFr1pSHZZAB6Qo9lFq9UtBpIGAFw34GIcX1SYlPq2lO+S07UDk76RYzIBUdrf1JdmKgspI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PSeNubfY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PSeNubfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B2BC43390;
	Sat, 24 Feb 2024 01:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739376;
	bh=R/PxesR04S+MqnxEcPaU1YSEcW0bZNT8Rf47oRni2PE=;
	h=Date:To:From:Subject:From;
	b=PSeNubfY/vqyLz13rnrAAI4AxdnhtwXeFGZCN9SeyYVkSA4w9OqzNiU2Tt4ZYh5xx
	 RjBYn80T9YqrdZxPNAhJSOlsmpfr+B06HzOP9g9Dfk5lLXLDhdlD9DNxRyeAzxfJPR
	 3xxx4G6v4hkcYhKb6nEXBtUXMO4kW/XDeps2bIs0=
Date: Fri, 23 Feb 2024 17:49:36 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,paulmck@kernel.org,oleksiy.avramchenko@sony.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,k-hagio-ab@nec.com,joel@joelfernandes.org,hch@lst.de,david@fromorbit.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-offload-free_vmap_area_lock-lock-fix.patch removed from -mm tree
Message-Id: <20240224014936.97B2BC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: add a scan area of VA only once
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-offload-free_vmap_area_lock-lock-fix.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: add a scan area of VA only once
Date: Fri, 2 Feb 2024 20:06:28 +0100

Invoke a kmemleak_scan_area() function only for newly allocated objects to
add a scan area within that object.  There is no reason to add a same scan
area(pointer to beginning or inside the object) several times.  If a VA is
obtained from the cache its scan area has already been associated.

Link: https://lkml.kernel.org/r/20240202190628.47806-1-urezki@gmail.com
Fixes: 7db166b4aa0d ("mm: vmalloc: offload free_vmap_area_lock lock")
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Kazuhito Hagio <k-hagio-ab@nec.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-offload-free_vmap_area_lock-lock-fix
+++ a/mm/vmalloc.c
@@ -1834,13 +1834,13 @@ static struct vmap_area *alloc_vmap_area
 		va = kmem_cache_alloc_node(vmap_area_cachep, gfp_mask, node);
 		if (unlikely(!va))
 			return ERR_PTR(-ENOMEM);
-	}
 
-	/*
-	 * Only scan the relevant parts containing pointers to other objects
-	 * to avoid false negatives.
-	 */
-	kmemleak_scan_area(&va->rb_node, SIZE_MAX, gfp_mask);
+		/*
+		 * Only scan the relevant parts containing pointers to other objects
+		 * to avoid false negatives.
+		 */
+		kmemleak_scan_area(&va->rb_node, SIZE_MAX, gfp_mask);
+	}
 
 retry:
 	if (addr == vend) {
_

Patches currently in -mm which might be from urezki@gmail.com are


