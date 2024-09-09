Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B7F18E05D
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925251; cv=none; b=f3D24PLE9PzLUzbYHhxpoTW0ZGdk9lHxOOD5O+Audg5I1Ww9gM1Zh7OvRaX3RZvmHi8Srinb5tKsfDirx7SSAaSSbiiqzcqq8HZZDYQAIaktzewGtIGCpCfmxSfiXydIUqWs6D9yrXD7UGuZdDzZwpeMYRbvrNV1kBtp1JZ3AwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925251; c=relaxed/simple;
	bh=sd5ikRVv6zc52p34iWTI+a2/sez47HTJqKXklt1Xh7s=;
	h=Date:To:From:Subject:Message-Id; b=u8AVQs/tpCMrtpMQ5h/GzuZjj7239TfTE9Fh/skFDKx1e4zES9XNQfWXR6z8F+8XIQEK29lVIoj5LQKIeaLsdNBQeM4IN0BaKb2H4D/zxBhF4g6+XpNVJOx/G+nwV0XXxDv3uNECyUZz7RVhxUI4lQjPSrb+V2tV6vuyqkhG4fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KSqkf+sD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KSqkf+sD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87AC4C4CEC5;
	Mon,  9 Sep 2024 23:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925251;
	bh=sd5ikRVv6zc52p34iWTI+a2/sez47HTJqKXklt1Xh7s=;
	h=Date:To:From:Subject:From;
	b=KSqkf+sDckjFTKIbqSxcsnPSqZNLBU2VlfUoHoz5jxal4WleZitqiiigKj0C4XJSp
	 EgyGp6ZeGL6s7Btz7Arkzx5yhmhWwE5w8zaqlpEg490O/5FTjiHLKLR5tjoP+jRxMg
	 fkCTADpCJ5F6jy8fELiVqKp7F5fvAj9QfxuhXPQ4=
Date: Mon, 09 Sep 2024 16:40:51 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@infradead.org,lihongbo22@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-use-of-the-helper-macro-list_head.patch removed from -mm tree
Message-Id: <20240909234051.87AC4C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc.c: make use of the helper macro LIST_HEAD()
has been removed from the -mm tree.  Its filename was
     mm-make-use-of-the-helper-macro-list_head.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongbo Li <lihongbo22@huawei.com>
Subject: mm/vmalloc.c: make use of the helper macro LIST_HEAD()
Date: Wed, 28 Aug 2024 12:12:16 +0800

list_head can be initialized automatically with LIST_HEAD() instead of
calling INIT_LIST_HEAD().  Here we can simplify the code.

Link: https://lkml.kernel.org/r/20240828041216.1222582-1-lihongbo22@huawei.com
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/mm/vmalloc.c~mm-make-use-of-the-helper-macro-list_head
+++ a/mm/vmalloc.c
@@ -2131,23 +2131,18 @@ reclaim_list_global(struct list_head *he
 static void
 decay_va_pool_node(struct vmap_node *vn, bool full_decay)
 {
+	LIST_HEAD(decay_list);
+	struct rb_root decay_root = RB_ROOT;
 	struct vmap_area *va, *nva;
-	struct list_head decay_list;
-	struct rb_root decay_root;
 	unsigned long n_decay;
 	int i;
 
-	decay_root = RB_ROOT;
-	INIT_LIST_HEAD(&decay_list);
-
 	for (i = 0; i < MAX_VA_SIZE_PAGES; i++) {
-		struct list_head tmp_list;
+		LIST_HEAD(tmp_list);
 
 		if (list_empty(&vn->pool[i].head))
 			continue;
 
-		INIT_LIST_HEAD(&tmp_list);
-
 		/* Detach the pool, so no-one can access it. */
 		spin_lock(&vn->pool_lock);
 		list_replace_init(&vn->pool[i].head, &tmp_list);
_

Patches currently in -mm which might be from lihongbo22@huawei.com are


