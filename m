Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27063B5F59
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068113; cv=none; b=Og4vYUdFMHg3ELscZzKVXk6jZyYy1NVwz6OvhNiK2IQCzTyHLYPDacf2ig5efVVpv3ocFpFYJjsgJBSWw+laPy1gRuVmp3BMH2TVQXxeRh5eKDWUKA3gdw6ORBkkT34OXK0OLjOip1ePOXBZM5aFYtWQYFeHejJYBT9mwXySpts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068113; c=relaxed/simple;
	bh=8rue7zAjpJrLYQog6OsrFxhZMDFH+DQYem5eHdxBXpQ=;
	h=Date:To:From:Subject:Message-Id; b=VzbftgoxTlIrfPHDFo79Mo42cL5aiALlw+4jOT9r1SPvWowZLOjfWAkKilo/lrbGA+QfaEGX+HdpKwGuScoYZTJyfa4empjJnJmxQRg+vTtkxiOKA0t3EOmM+PdXJW5W+uTy5dM15j2UzIhZ5ujeSFSBcTElr5XLt0U2a91mHvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p9IKz3gB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p9IKz3gB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715461F00A3A;
	Fri,  7 Aug 2026 02:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068112;
	bh=7AF7YhulFYXP8KKXihbDA+6/MzlXGxfkELYAbbpvvWM=;
	h=Date:To:From:Subject;
	b=p9IKz3gB9jWF5nFkw08jneIc6ftdskj9WZ8rpfhA5ErQNaRMY2D8GgpPpeUFbBqed
	 wUu2gWRF1Dd7LUjH2Fz+6qLRENvOZD8rJraoIyd3L5Gx4ANr5OzyIXj0B7nT1NLYdQ
	 cZuPeLXo2fQ/Z5yT85Adc56dsMjeZFgJVnOX4z7Y=
Date: Thu, 06 Aug 2026 19:01:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mincore-refactor-mincore_page.patch removed from -mm tree
Message-Id: <20260807020152.715461F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mincore: refactor mincore_page()
has been removed from the -mm tree.  Its filename was
     mm-mincore-refactor-mincore_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: mincore: refactor mincore_page()
Date: Fri, 17 Jul 2026 17:13:47 +0800

Use early returns to reduce indentation and improve readability.

Link: https://lore.kernel.org/20260717091347.1144789-7-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/mm/mincore.c~mm-mincore-refactor-mincore_page
+++ a/mm/mincore.c
@@ -93,7 +93,7 @@ static unsigned char mincore_swap(swp_en
  */
 static unsigned char mincore_page(struct address_space *mapping, pgoff_t index)
 {
-	unsigned char present = 0;
+	unsigned char present;
 	struct folio *folio;
 
 	/*
@@ -103,17 +103,16 @@ static unsigned char mincore_page(struct
 	 * tmpfs's .fault). So swapped out tmpfs mappings are tested here.
 	 */
 	folio = filemap_get_entry(mapping, index);
-	if (folio) {
-		if (xa_is_value(folio)) {
-			if (shmem_mapping(mapping))
-				return mincore_swap(radix_to_swp_entry(folio),
-						    true);
-			else
-				return 0;
-		}
-		present = folio_test_uptodate(folio);
-		folio_put(folio);
+	if (!folio)
+		return 0;
+
+	if (xa_is_value(folio)) {
+		if (!shmem_mapping(mapping))
+			return 0;
+		return mincore_swap(radix_to_swp_entry(folio), true);
 	}
+	present = folio_test_uptodate(folio);
+	folio_put(folio);
 
 	return present;
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


