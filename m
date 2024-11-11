Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7641662E9
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313722; cv=none; b=LnVgGpFRqhTfHmSJB40f2Gyf4nQ6rKX97px4ksZlgHmxmx/VKIOJya5gDVKmNKdSoU34JQlCvCPJsrP+L39cyMEIeu/KvDxHoRsu9t3x2gcQbJKXCXMhf5zTVHcx63uZer0wUkd47EXw/tGnLEEZqich5UHVPwI+FuGDUhfj8Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313722; c=relaxed/simple;
	bh=cQ6F2qw3F7QXhtX6AY+yJpUKbhCme4Y2Re5RqQoPlSY=;
	h=Date:To:From:Subject:Message-Id; b=HQuDMAS7bmGq4qBaoThiQ81CLLq57gEf8H97GVjhYp+SVMICbG0RHx/uOsUjANzFAnUv32Iu4/iaKIEdfcyfkK9PXgjhlFHlTjTIEON3cV0jOn4NslbMNtR52VK5qDPGnHmKfHOCkKPtuChJk2k8OJpg3NDkVBVwphDjqqgnxoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RbOZLerG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RbOZLerG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8245C4CED0;
	Mon, 11 Nov 2024 08:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313720;
	bh=cQ6F2qw3F7QXhtX6AY+yJpUKbhCme4Y2Re5RqQoPlSY=;
	h=Date:To:From:Subject:From;
	b=RbOZLerGD3QmTJqT2w2skKY9xZ9Bq2LRyWee2FcgBIkwQZiiXG2heCEAun3DNQZYu
	 SxiO9ZH4vC1GLVqMBj72m4l4d5VAxoabRuLAt6k+cYZteeOIvkYDJ6yIy0VSUzCugt
	 0FL6jf9oSBet/TjOfdIqd0tKoKhtDwuEkLxssccc=
Date: Mon, 11 Nov 2024 00:28:40 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-the-return-value-of-mas_root_expand-is-not-used.patch removed from -mm tree
Message-Id: <20241111082840.C8245C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: the return value of mas_root_expand() is not used
has been removed from the -mm tree.  Its filename was
     maple_tree-the-return-value-of-mas_root_expand-is-not-used.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: the return value of mas_root_expand() is not used
Date: Thu, 31 Oct 2024 23:16:24 +0000

No user of the return value now, just remove it.

Link: https://lkml.kernel.org/r/20241031231627.14316-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-the-return-value-of-mas_root_expand-is-not-used
+++ a/lib/maple_tree.c
@@ -3408,7 +3408,7 @@ static noinline_for_kasan void mas_commi
  * @mas: The maple state
  * @entry: The entry to store into the tree
  */
-static inline int mas_root_expand(struct ma_state *mas, void *entry)
+static inline void mas_root_expand(struct ma_state *mas, void *entry)
 {
 	void *contents = mas_root_locked(mas);
 	enum maple_type type = maple_leaf_64;
@@ -3444,7 +3444,7 @@ static inline int mas_root_expand(struct
 	ma_set_meta(node, maple_leaf_64, 0, slot);
 	/* swap the new root into the tree */
 	rcu_assign_pointer(mas->tree->ma_root, mte_mk_root(mas->node));
-	return slot;
+	return;
 }
 
 static inline void mas_store_root(struct ma_state *mas, void *entry)
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


