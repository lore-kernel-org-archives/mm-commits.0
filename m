Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E448192D97
	for <mm-commits@vger.kernel.org>; Mon, 30 Sep 2024 18:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727719772; cv=none; b=uXTnDcmNwsXl1m7fqms0zyqT1ukQtj60+4XM48wWu+bjAIB+OwDl/NCK4Vb4yvg9peGFpL46GMlEFTx4TtKQD6ACujER2vfWZSJ4keB0Jq/Gi8vxz4iRRICXVwIhZprdhgh8jX6BBVr2ETO/EadRH16aHy9OUgA5DGURLmClCWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727719772; c=relaxed/simple;
	bh=eYRJqhD5px7GvfR+zTZdf34+On9/OgIs+A3VY8jrqA4=;
	h=Date:To:From:Subject:Message-Id; b=uf9OyqalchgQz1zhJClxeZDUNe6CYxeY6ZjiGwdChjZK+Adytt3HFZTdwi5gtdiSKwAeugzZZzsaOy2LygnmfFLAYbo0ns3XsB9JYy8nwmNpTuzUm2OEBCOpJTHcJOdyaAec/W+oAAcc6LoJ0DADdonvhW4zwssHkJNwaPDfWC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jyqYiyen; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jyqYiyen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86FCC4CEC7;
	Mon, 30 Sep 2024 18:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727719770;
	bh=eYRJqhD5px7GvfR+zTZdf34+On9/OgIs+A3VY8jrqA4=;
	h=Date:To:From:Subject:From;
	b=jyqYiyenXmlWXKU3NoN9YrRJA6McjAo63L55cRGmUH1d1vGlCHJgVAtBcP8XykUKf
	 4eSD4gTh+bie6eOSBkeBqzUGPJrsR6dtOJl6pCGbmJ333CXc6EgDpTYbMdqED9UjnF
	 sGiTEABZwXEp00HwpQDo6++jdOcfbqWKFvFF3Vgs=
Date: Mon, 30 Sep 2024 11:09:30 -0700
To: mm-commits@vger.kernel.org,gaoxiang17@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-cma-print-total-and-used-count-in-cma_alloc.patch removed from -mm tree
Message-Id: <20240930180930.B86FCC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma: print total and used count in cma_alloc()
has been removed from the -mm tree.  Its filename was
     mm-cma-print-total-and-used-count-in-cma_alloc.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: gaoxiang17 <gaoxiang17@xiaomi.com>
Subject: mm/cma: print total and used count in cma_alloc()
Date: Thu, 26 Sep 2024 20:00:49 +0800

To better understand cma area during debugging.

before:
[   24.407814] cma: cma_alloc(cma (____ptrval____), name: reserved, count 1, align 0)
[   24.413397] cma: cma_alloc(cma (____ptrval____), name: reserved, count 1, align 0)
[   24.415886] cma: cma_alloc(cma (____ptrval____), name: reserved, count 1, align 0)

after:
[   24.097989] cma: cma_alloc(cma (____ptrval____), name: reserved, total count 16384, used count: 64, request count 1, align 0)
[   24.104260] cma: cma_alloc(cma (____ptrval____), name: reserved, total count 16384, used count: 65, request count 1, align 0)
[   24.107504] cma: cma_alloc(cma (____ptrval____), name: reserved, total count 16384, used count: 66, request count 1, align 0)

Link: https://lkml.kernel.org/r/20240926120049.321514-1-gxxa03070307@gmail.com
Signed-off-by: gaoxiang17 <gaoxiang17@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/mm/cma.c~mm-cma-print-total-and-used-count-in-cma_alloc
+++ a/mm/cma.c
@@ -402,6 +402,17 @@ static void cma_debug_show_areas(struct
 	spin_unlock_irq(&cma->lock);
 }
 
+static unsigned long cma_get_used(struct cma *cma)
+{
+	unsigned long used;
+
+	spin_lock_irq(&cma->lock);
+	used = bitmap_weight(cma->bitmap, (int)cma_bitmap_maxno(cma));
+	spin_unlock_irq(&cma->lock);
+
+	return used << cma->order_per_bit;
+}
+
 static struct page *__cma_alloc(struct cma *cma, unsigned long count,
 				unsigned int align, gfp_t gfp)
 {
@@ -419,8 +430,8 @@ static struct page *__cma_alloc(struct c
 	if (!cma || !cma->count || !cma->bitmap)
 		return page;
 
-	pr_debug("%s(cma %p, name: %s, count %lu, align %d)\n", __func__,
-		(void *)cma, cma->name, count, align);
+	pr_debug("%s(cma %p, name: %s, total count %lu, used count: %lu, request count %lu, align %d)\n", __func__,
+		(void *)cma, cma->name, cma->count, cma_get_used(cma), count, align);
 
 	if (!count)
 		return page;
_

Patches currently in -mm which might be from gaoxiang17@xiaomi.com are


