Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B6E18D
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560117; cv=none; b=UxnmT5lohlQK+BmPaP6R+GDrwiI23dw+w45oVYa2i95otJFIx/4lhBRbbLEZCa2OXoyVYBUlaVqFXoiKIMQZkFJUU5DEgiZ9e7dwBjLwtET3H2AMsgRnaUowrSb7te/GJNq6Km7y703HsJVsvYqJ6tRhEJ9G1NPd51gjPwIhK/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560117; c=relaxed/simple;
	bh=2J65jI88K7wXe2edbCRlcmRYasUku9gjRKlItCQXIuE=;
	h=Date:To:From:Subject:Message-Id; b=BJjAI8DKfrEtqWbnaxj0cXint5mRekwPolphaFavnClKZn8aYBYfAazIU8muEqr2TwlhLkY+OM65cyJ41Pf0oSpEsKGDb+50BPsWbhXmHNATRnkwhqhJNPXQ1blQ/acdV7gZ6uoZxOUa0Swg7KLbwz1l1TG7OapqIXp1QE3Lj4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aDizWlK0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aDizWlK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493E5C43390;
	Thu, 22 Feb 2024 00:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560117;
	bh=2J65jI88K7wXe2edbCRlcmRYasUku9gjRKlItCQXIuE=;
	h=Date:To:From:Subject:From;
	b=aDizWlK0ds0NEdBcWWk344xgMkwMRrgokhlWgQkNSfIqi/ZnUokZ4DhKqMq6IVH4C
	 9KUHVTQcqNCLizIs/MoyonLyHzWGCM7BZd0GrPUhARGOi+E8W3qm8y0ePJZAmG0XxR
	 rXchCm7COYFEMV/KxtbnqaNepls6o8VFB03TQQIM=
Date: Wed, 21 Feb 2024 16:01:56 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-rename-__zswap_load-to-zswap_decompress.patch removed from -mm tree
Message-Id: <20240222000157.493E5C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: rename __zswap_load() to zswap_decompress()
has been removed from the -mm tree.  Its filename was
     mm-zswap-rename-__zswap_load-to-zswap_decompress.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: rename __zswap_load() to zswap_decompress()
Date: Mon, 29 Jan 2024 20:36:42 -0500

Link: https://lkml.kernel.org/r/20240130014208.565554-7-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/zswap.c~mm-zswap-rename-__zswap_load-to-zswap_decompress
+++ a/mm/zswap.c
@@ -1315,7 +1315,7 @@ static int zswap_enabled_param_set(const
 	return ret;
 }
 
-static void __zswap_load(struct zswap_entry *entry, struct page *page)
+static void zswap_decompress(struct zswap_entry *entry, struct page *page)
 {
 	struct zpool *zpool = zswap_find_zpool(entry);
 	struct scatterlist input, output;
@@ -1410,7 +1410,7 @@ static int zswap_writeback_entry(struct
 	zswap_entry_get(entry);
 	spin_unlock(&tree->lock);
 
-	__zswap_load(entry, &folio->page);
+	zswap_decompress(entry, &folio->page);
 
 	count_vm_event(ZSWPWB);
 	if (entry->objcg)
@@ -1702,7 +1702,7 @@ bool zswap_load(struct folio *folio)
 	spin_unlock(&tree->lock);
 
 	if (entry->length)
-		__zswap_load(entry, page);
+		zswap_decompress(entry, page);
 	else {
 		dst = kmap_local_page(page);
 		zswap_fill_page(dst, entry->value);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


