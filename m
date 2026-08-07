Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57904B04B3;
	Fri,  7 Aug 2026 02:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068082; cv=none; b=ZP9Y/cUc4OfnqllZp1zAh8f726+LCiEoFFYIqtBrzoDAtjBHK97pKQOFq/Hd845j5tGSGH6cYCpQtDmWFMrlx2nYcm9IWGWP3XFiZO6ae16jP4RbGl+LYUM0DoK/TMrpzh5XnBm1YVSb0qY7Uo9n2+6gVyIZf7ddMiJJ5q8BTCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068082; c=relaxed/simple;
	bh=wPPZxl+g81CWdF9n8fQuf2QuuI9tgU6j+TzEsmE79Lk=;
	h=Date:To:From:Subject:Message-Id; b=EVmq8lyIuEO7anJUURueQRiOWVrG17w8/w6Aw4oOQEp6qu39HMdNwUg09HczgncjoWhEviYTU3t6qluayA1mq5nMrCQvVZFRl3k7Q19G+PqoIM5lKPyoBSBdx85U8BZo8DKKsIgIrK/ZLRmBXlNNWXeEpeqEsO6NU85Zggca9Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ht95Vp9Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ht95Vp9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1B81F00A3A;
	Fri,  7 Aug 2026 02:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068078;
	bh=1mhP+qIoGlP05/1/tq9UB7EPmsLXbw2bkn6Lj6itIng=;
	h=Date:To:From:Subject;
	b=Ht95Vp9Zkgw1sQmvZ3f7iw3OiSV117O0A+FFSLJUQflhU8neRO9hVN5GSMCIXke7g
	 paoza73oe/+kQ3+bUWdWX9otu+4uU4OYB8ASLEeRfXir1/vDCdQcT6yBT3u2+b2R41
	 bnzoA44SpeJOiSr74qhAFpwSgfduEUmymJUlu8rc=
Date: Thu, 06 Aug 2026 19:01:17 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-drop-last-same-folio-access-check-reuse-optimization.patch removed from -mm tree
Message-Id: <20260807020117.DD1B81F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: drop last same folio access check reuse optimization
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-drop-last-same-folio-access-check-reuse-optimization.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/paddr: drop last same folio access check reuse optimization
Date: Tue, 14 Jul 2026 20:09:59 -0700

It can race when multiple kdamonds are being used.  The problem from the
race is doubtful, but the gain from the optimization is also doubtful. 
Simply drop the optimization in favor of code simplicity.

The user impact is doubtfully trivial.  After all, this kind of
interference can happen only by intentional user setup.  Even if it
happens, it will be rare, and the consequence is degradation of the
best-effort monitoring results.  No critical consequences like kernel
panic or memory corruption happen.

The race was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260715031002.108504-5-sj@kernel.org
Link: https://lore.kernel.org/20260621204050.10993-1-sj@kernel.org [1]
Fixes: a28397beb55b ("mm/damon: implement primitives for physical address space monitoring")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-drop-last-same-folio-access-check-reuse-optimization
+++ a/mm/damon/paddr.c
@@ -65,7 +65,7 @@ static void damon_pa_prepare_access_chec
 	}
 }
 
-static bool damon_pa_young(phys_addr_t paddr, unsigned long *folio_sz)
+static bool damon_pa_young(phys_addr_t paddr)
 {
 	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
 	bool accessed;
@@ -74,7 +74,6 @@ static bool damon_pa_young(phys_addr_t p
 		return false;
 
 	accessed = damon_folio_young(folio);
-	*folio_sz = folio_size(folio);
 	folio_put(folio);
 	return accessed;
 }
@@ -82,23 +81,12 @@ static bool damon_pa_young(phys_addr_t p
 static void __damon_pa_check_access(struct damon_region *r,
 		unsigned long addr_unit)
 {
-	static phys_addr_t last_addr;
-	static unsigned long last_folio_sz = PAGE_SIZE;
-	static bool last_accessed;
+	bool accessed;
 	phys_addr_t sampling_addr = damon_pa_phys_addr(
 			r->sampling_addr, addr_unit);
 
-	/* If the region is in the last checked page, reuse the result */
-	if (ALIGN_DOWN(last_addr, last_folio_sz) ==
-				ALIGN_DOWN(sampling_addr, last_folio_sz)) {
-		damon_update_region_access_rate(r, last_accessed);
-		return;
-	}
-
-	last_accessed = damon_pa_young(sampling_addr, &last_folio_sz);
-	damon_update_region_access_rate(r, last_accessed);
-
-	last_addr = sampling_addr;
+	accessed = damon_pa_young(sampling_addr);
+	damon_update_region_access_rate(r, accessed);
 }
 
 static unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
_

Patches currently in -mm which might be from sj@kernel.org are


