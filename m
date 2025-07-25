Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D56F219312
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409705; cv=none; b=oZn1cQtVYvqPDSlrdI3RqdDki3QB3f03exI4uxQ234n5wXBd3NIs6v2snrShSGxH7paTGEAO/ZjC0T+5CUuGj1nXq1k5uYFN7OnVNFHF7JvUPnZX4hD7JDOdcfYVoXyNnVlVJ1QC/m7koAv3OTCbntJGMLYxuqg4nQlFpyBzuqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409705; c=relaxed/simple;
	bh=YWYJZ1I73mToNBfv4qL8wJFCTCvRr1mW/CBAK6G+vV4=;
	h=Date:To:From:Subject:Message-Id; b=OrFzIfzGP/+0Appbp3NkebpSyAh24zzl3h7LvB+TRcUCgJ/b3QPikoV2eox3EWKzPkCABxz8I6oTdA6fJQxD946/Y7IMYAZGpAF3WW26t5Lf48UUkMc7uVqCW3JZoILPABc/Nz57e652lzt8egdNux7qfhgjy/yhuCXq7LEr8Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mP2Z15Et; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mP2Z15Et"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044ADC4CEED;
	Fri, 25 Jul 2025 02:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409705;
	bh=YWYJZ1I73mToNBfv4qL8wJFCTCvRr1mW/CBAK6G+vV4=;
	h=Date:To:From:Subject:From;
	b=mP2Z15EtmArhDwl43n3Blw/226v4DxoH2FgaABrhlPH/48imGEBG5tX0NiC1W0l4H
	 DMs72UZBEVKw5kQzXEAzXUNKdf1keCuF144cIaU5zEb1jFBh/woyWyrb6sVRdrZGG+
	 AZzJtyshzyk6r5VeuJ3r3FBPWc0RYgcOBK1sKsR4=
Date: Thu, 24 Jul 2025 19:15:04 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-simplify-cma_debug_show_areas.patch removed from -mm tree
Message-Id: <20250725021505.044ADC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: cma: simplify cma_debug_show_areas()
has been removed from the -mm tree.  Its filename was
     mm-cma-simplify-cma_debug_show_areas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Subject: mm: cma: simplify cma_debug_show_areas()
Date: Sat, 19 Jul 2025 16:53:59 -0400

The function opencodes for_each_clear_bitrange().  Fix that and drop most
of housekeeping code.

Link: https://lkml.kernel.org/r/20250719205401.399475-2-yury.norov@gmail.com
Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

--- a/mm/cma.c~mm-cma-simplify-cma_debug_show_areas
+++ a/mm/cma.c
@@ -751,8 +751,7 @@ int __init cma_declare_contiguous_nid(ph
 
 static void cma_debug_show_areas(struct cma *cma)
 {
-	unsigned long next_zero_bit, next_set_bit, nr_zero;
-	unsigned long start;
+	unsigned long start, end;
 	unsigned long nr_part;
 	unsigned long nbits;
 	int r;
@@ -763,22 +762,12 @@ static void cma_debug_show_areas(struct
 	for (r = 0; r < cma->nranges; r++) {
 		cmr = &cma->ranges[r];
 
-		start = 0;
 		nbits = cma_bitmap_maxno(cma, cmr);
 
 		pr_info("range %d: ", r);
-		for (;;) {
-			next_zero_bit = find_next_zero_bit(cmr->bitmap,
-							   nbits, start);
-			if (next_zero_bit >= nbits)
-				break;
-			next_set_bit = find_next_bit(cmr->bitmap, nbits,
-						     next_zero_bit);
-			nr_zero = next_set_bit - next_zero_bit;
-			nr_part = nr_zero << cma->order_per_bit;
-			pr_cont("%s%lu@%lu", start ? "+" : "", nr_part,
-				next_zero_bit);
-			start = next_zero_bit + nr_zero;
+		for_each_clear_bitrange(start, end, cmr->bitmap, nbits) {
+			nr_part = (end - start) << cma->order_per_bit;
+			pr_cont("%s%lu@%lu", start ? "+" : "", nr_part, start);
 		}
 		pr_info("\n");
 	}
_

Patches currently in -mm which might be from yury.norov@gmail.com are


