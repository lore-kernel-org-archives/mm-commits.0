Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65F3748F
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291748; cv=none; b=UeSGqdz4cAe8u2wHaItUBAlEmVa+hbF8UtDsDcZNYf0Dx3MQr91L6pS2p+TDN5jddw7yn7U6asDpoS7n3rwbn/wCXkS2ITg4zJ71i12ZVIYrep7fHlCxW/WjVJmNCLZe6T5QBjKVFC7q1DqLD7T6v3R4fEskm+fo9ay/gMp2vvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291748; c=relaxed/simple;
	bh=HIoWbv+55AZBhqDrbTwkgslvfcOqLPyI320VslTjJlE=;
	h=Date:To:From:Subject:Message-Id; b=nz73obSG434TAb4dmV63T+3VgGTDAQnTnyN+LgVh/qo2TgPM67H16jooOhBL4RW2dLwJLBPfOetmrvHIHt5AW64oAQsYNXFq92+JaXBJJUdikdk+pvXxw92bntV51rrBc1D149d/ZBrc5qJLVbqrgr5PqCIxKzmmpcHHXNrCYZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C5/l96qZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C5/l96qZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617EBC32782;
	Tue, 25 Jun 2024 05:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291747;
	bh=HIoWbv+55AZBhqDrbTwkgslvfcOqLPyI320VslTjJlE=;
	h=Date:To:From:Subject:From;
	b=C5/l96qZtSJroz9CJ7mstNyKDpm/VdZMpxz4qf4ODMTn1EeT8Sqy+XZjYg8mcmHT0
	 k2bBNhToKgHV2nJWrSNPqR7e3ajoluC7+2JlRS1nrjhIPnnAp0fIMC8Y6VlLdw7CrD
	 /GLR6/fGXtRats5M2coWczHroKvYO1SYMZmYMJoU=
Date: Mon, 24 Jun 2024 22:02:26 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] khugepaged-simplify-the-allocation-of-slab-caches.patch removed from -mm tree
Message-Id: <20240625050227.617EBC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: khugepaged: simplify the allocation of slab caches
has been removed from the -mm tree.  Its filename was
     khugepaged-simplify-the-allocation-of-slab-caches.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: khugepaged: simplify the allocation of slab caches
Date: Tue, 18 Jun 2024 09:45:17 +0800

Use the new KMEM_CACHE() macro instead of direct kmem_cache_create
to simplify the creation of SLAB caches.

Link: https://lkml.kernel.org/r/20240618014517.25954-1-lihongfu@kylinos.cn
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/khugepaged.c~khugepaged-simplify-the-allocation-of-slab-caches
+++ a/mm/khugepaged.c
@@ -385,10 +385,7 @@ int hugepage_madvise(struct vm_area_stru
 
 int __init khugepaged_init(void)
 {
-	mm_slot_cache = kmem_cache_create("khugepaged_mm_slot",
-					  sizeof(struct khugepaged_mm_slot),
-					  __alignof__(struct khugepaged_mm_slot),
-					  0, NULL);
+	mm_slot_cache = KMEM_CACHE(khugepaged_mm_slot, 0);
 	if (!mm_slot_cache)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are


