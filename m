Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7A1372B50;
	Tue, 25 Aug 2026 01:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622916; cv=none; b=uIPtkxtUFdNt8SPi/H/aGxop3TuBMRRuarCx5jdDCURJj8lT6Q2ZaQ8e/IxfRYSgFuFQOv6kiToHvk6aVOo1BfKqEfnPwDZm6I7n2OEAZ5dL0pTmbVL+SYqIYh6szQ4YW27J5Cqv3r2gISt/NW0NfxhmXqJyQ9XoRBmcO4vr4VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622916; c=relaxed/simple;
	bh=2yTY3wHz1D0UUUyGwRo8d77Q9U4v+you+3nRRboVl1U=;
	h=Date:To:From:Subject:Message-Id; b=HLds7uJHzZ2/cTfe13czOjSy+1rXIQqVY+ZpCQDPcJFvMuHnwb/GvnzxQ1W/VJyoin2jk+eOehHc3DRKLr9ra2RVJRi7YH5xA4dLT5DrvxH9CRiORfq3a6Ijtcc2xvxoNNv7sEx2A7Q3ysy3KlerQBi3jtnd7wIuWOSm7fJIkRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w2KXvBix; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w2KXvBix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331E21F00A3D;
	Tue, 25 Aug 2026 01:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622915;
	bh=BBIXlOC7C65mfIsPWeXTGiqT2NaLhxc5zFQexLthNC4=;
	h=Date:To:From:Subject;
	b=w2KXvBixsar0CCVJo4ve6Kn2tvo+PJ91LAGhQ6oPk7zwNKIe1OncAFEJ8Bd+VNCn9
	 mWraMVQ5f6QKCWMoGDWM7y5qAu5QpX/dTR/jjCesPvGTcWBzL312NtgoUSMmn9ls9j
	 SEYAligBmjGcR8zC/z+zphql6VLWsYiC8J8Fqb/4=
Date: Mon, 24 Aug 2026 18:55:14 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-account-for-handle-size-in-class-lookup.patch removed from -mm tree
Message-Id: <20260825015515.331E21F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zsmalloc: account for handle size in class lookup
has been removed from the -mm tree.  Its filename was
     zsmalloc-account-for-handle-size-in-class-lookup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Longlong Xia <xialonglong@kylinos.cn>
Subject: zsmalloc: account for handle size in class lookup
Date: Sun, 9 Aug 2026 19:55:18 +0800

zs_lookup_class_index() lets zram recompression decide whether a newly
compressed object would use a smaller size class.  It currently classifies
the payload size directly, while zs_malloc() adds ZS_HANDLE_SIZE before
selecting the class.

This makes lookup disagree with allocation near size-class boundaries. 
With 4 KiB pages, CONFIG_ZSMALLOC_CHAIN_SIZE=8, and 64-bit handles, a
1025-to-1024-byte recompression appears to move from class 64 to class 62
although both allocations use class 64.  Conversely, a 1049-to-1025-byte
recompression appears to stay in class 64 although the allocations move
from class 65 to class 64.

As a result, zram can accept replacements with no allocation benefit or
reject ones that would save memory, potentially marking the object
incompressible.

Factor size-class selection into lookup_size_class(), account for the
handle there, and use the helper for both lookup and allocation.

Link: https://lore.kernel.org/20260809115518.3791787-1-xialonglong2025@163.com
Fixes: 7c2af309abd2 ("zram: add size class equals check into recompression")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-account-for-handle-size-in-class-lookup
+++ a/mm/zsmalloc.c
@@ -552,6 +552,11 @@ static int get_size_class_index(int size
 	return min_t(int, ZS_SIZE_CLASSES - 1, idx);
 }
 
+static struct size_class *lookup_size_class(struct zs_pool *pool, size_t size)
+{
+	return pool->size_class[get_size_class_index(size + ZS_HANDLE_SIZE)];
+}
+
 static inline void class_stat_add(struct size_class *class, int type,
 				  unsigned long cnt)
 {
@@ -1117,7 +1122,7 @@ unsigned int zs_lookup_class_index(struc
 {
 	struct size_class *class;
 
-	class = pool->size_class[get_size_class_index(size)];
+	class = lookup_size_class(pool, size);
 
 	return class->index;
 }
@@ -1407,9 +1412,7 @@ unsigned long zs_malloc(struct zs_pool *
 	if (!handle)
 		return (unsigned long)ERR_PTR(-ENOMEM);
 
-	/* extra space in chunk to keep the handle */
-	size += ZS_HANDLE_SIZE;
-	class = pool->size_class[get_size_class_index(size)];
+	class = lookup_size_class(pool, size);
 
 	/* class->lock effectively protects the zpage migration */
 	spin_lock(&class->lock);
_

Patches currently in -mm which might be from xialonglong@kylinos.cn are

mm-hugetlb-keep-max_huge_pages-when-dissolving-surplus-folios.patch

