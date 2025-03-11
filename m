Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE7926281D
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 18:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741717068; cv=none; b=D1R9bykd/8Znz9nAeO1fSlpikQooA3Ra+D7EMz07fXZaci18HtelvphsvNk7MRfv99f9C5zVL/BNcYAMJZ/f4Cfhr6ZHugVlNENVYklbqOJ+YVw9wqeHYvNDgLweg1ZzbBJ8uNcdwShGtdtpl1PN0wZrqFFWcxgucnr1x899R50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741717068; c=relaxed/simple;
	bh=pc1CRB2osvDyOLV4POGToT/xsLC+B+vmp4aRgK3w+ZM=;
	h=Date:To:From:Subject:Message-Id; b=RAesMWEgHSprHXjsU1juRMJ0mVTF3YX86ZHazTcmilRxSA4rTnc+7ag/aqkIGvPX6skj0H0wiZtgRNuzQ5zQnehEXeFrbd5M9B6Wejzpm+Xh7ayR3iEbtybV+Gwq3L6b0oXZt9tyNLUlTUmje+YOXjTScZb6I2b10kGVnQk9oXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=diGi3f5I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="diGi3f5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9846CC4CEEA;
	Tue, 11 Mar 2025 18:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741717067;
	bh=pc1CRB2osvDyOLV4POGToT/xsLC+B+vmp4aRgK3w+ZM=;
	h=Date:To:From:Subject:From;
	b=diGi3f5IQXsq83bXwHPR6Cu9p5PrbzoHFMib9fs5qKs98aceU8HppU4zXo2N/pADY
	 vOtk9es1PqpMLFIBj77SBLCVe7pGx5F8LqtN2/ZK2W8cKdSsWz/8F9AuWDNnYa5k05
	 H/neWK8AH1TITs8Bv630jC5V2fY8uIcYfqxzV6mM=
Date: Tue, 11 Mar 2025 11:17:46 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@infradead.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-move-free_vm_areaarea-from-the-__vmalloc_area_node-function-to-the-__vmalloc_node_range_noprof-function.patch removed from -mm tree
Message-Id: <20250311181747.9846CC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: move free_vm_area(area) from the __vmalloc_area_node function to the __vmalloc_node_range_noprof function
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-move-free_vm_areaarea-from-the-__vmalloc_area_node-function-to-the-__vmalloc_node_range_noprof-function.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Liu Ye <liuye@kylinos.cn>
Subject: mm/vmalloc: move free_vm_area(area) from the __vmalloc_area_node function to the __vmalloc_node_range_noprof function
Date: Mon, 3 Mar 2025 09:57:02 +0800

Moved free_vm_area from the __vmalloc_area_node function to the
__vmalloc_node_range_noprof function so that allocation and freeing of the
area can be paired in one function for better readability.

Link: https://lkml.kernel.org/r/20250303015702.319416-1-liuye@kylinos.cn
Signed-off-by: Liu Ye <liuye@kylinos.cn>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christop Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-move-free_vm_areaarea-from-the-__vmalloc_area_node-function-to-the-__vmalloc_node_range_noprof-function
+++ a/mm/vmalloc.c
@@ -3651,7 +3651,6 @@ static void *__vmalloc_area_node(struct
 		warn_alloc(gfp_mask, NULL,
 			"vmalloc error: size %lu, failed to allocated page array size %lu",
 			nr_small_pages * PAGE_SIZE, array_size);
-		free_vm_area(area);
 		return NULL;
 	}
 
@@ -3844,8 +3843,10 @@ again:
 
 	/* Allocate physical pages and map them into vmalloc space. */
 	ret = __vmalloc_area_node(area, gfp_mask, prot, shift, node);
-	if (!ret)
+	if (!ret) {
+		free_vm_area(area);
 		goto fail;
+	}
 
 	/*
 	 * Mark the pages as accessible, now that they are mapped.
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-memfd-fix-spelling-and-grammatical-issues.patch
mm-folio_queue-delete-__folio_order-and-use-folio_order-directly.patch
mm-shrinker-fix-name-consistency-issue-in-shrinker_debugfs_rename.patch
mm-vmalloc-refactoring-function-__vmalloc_node_range_noprof.patch

