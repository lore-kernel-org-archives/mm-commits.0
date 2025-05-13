Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A87D1EB1A1
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119216; cv=none; b=KNq3HOrxjfKMJgICOMZMYABb+iKoz85VxElU8gFlVohxyOALUdyVg2vHoQ/6OLQY36z0vnzfeYSv4IPDC6dc1vJ6PQuzr54rmmhl5q7hMpucT73qR0t2MeEN6WghOSkIw6/oAVqwbVdS1107ciOuwgqe6mzHd8eDRvWYUErut4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119216; c=relaxed/simple;
	bh=Gf+21rSODGzHhpe4LMsBWpiIFj3SXkBC3DXgzp4tRtM=;
	h=Date:To:From:Subject:Message-Id; b=j7k3G14lGIA/UvVcCjvRfNpqMHH7fSwi6nv2L79U2owIqL5XbfE5Ie7fNXMK3IQXvo6489c2j8enoNdQ3952aOx7cKFpK6MmHkevhWSqj2ib7WQDzxHFd89ijG5dKiTOL3PWRX2fbxmyzVBARs6mUw2zCt1F/vwgRfuOHcQQ6nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GEE0hM+y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GEE0hM+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B29C4CEE4;
	Tue, 13 May 2025 06:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119215;
	bh=Gf+21rSODGzHhpe4LMsBWpiIFj3SXkBC3DXgzp4tRtM=;
	h=Date:To:From:Subject:From;
	b=GEE0hM+yFEIo2tZklpyU64b3Z4jtaDxNHga4j4/gLo4V3XCXxUU9XGLKov+uDdq87
	 Cvh3wp3qi1TSH7JBmKc47J8af62VFeEmbpWburV1fgzQxHMZ4Y0ZwFRsr9AL1H1BO+
	 9JEv0hFanBww6WExBKNK33INXEh5Ro1rbEHCEnjQ=
Date: Mon, 12 May 2025 23:53:34 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,urezki@gmail.com,shivankg@amd.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmallocc-optimize-code-in-decay_va_pool_node-a-little-bit.patch removed from -mm tree
Message-Id: <20250513065335.70B29C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc.c: optimize code in decay_va_pool_node() a little bit
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-optimize-code-in-decay_va_pool_node-a-little-bit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmalloc.c: optimize code in decay_va_pool_node() a little bit
Date: Sat, 19 Apr 2025 06:36:51 +0800

When purge lazily freed vmap areas, VA stored in vn->pool[] will also be
taken away into free vmap tree partially or completely accordingly, that
is done in decay_va_pool_node().  When doing that, for each pool of node,
the whole list is detached from the pool for handling.  At this time, that
pool is empty.  It's not necessary to update the pool size each time when
one VA is removed and addded into free vmap tree.

Here change code to update the pool size when attaching the pool back.

Link: https://lkml.kernel.org/r/20250418223653.243436-4-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/mm/vmalloc.c~mm-vmallocc-optimize-code-in-decay_va_pool_node-a-little-bit
+++ a/mm/vmalloc.c
@@ -2149,7 +2149,7 @@ decay_va_pool_node(struct vmap_node *vn,
 	LIST_HEAD(decay_list);
 	struct rb_root decay_root = RB_ROOT;
 	struct vmap_area *va, *nva;
-	unsigned long n_decay;
+	unsigned long n_decay, pool_len;
 	int i;
 
 	for (i = 0; i < MAX_VA_SIZE_PAGES; i++) {
@@ -2163,22 +2163,20 @@ decay_va_pool_node(struct vmap_node *vn,
 		list_replace_init(&vn->pool[i].head, &tmp_list);
 		spin_unlock(&vn->pool_lock);
 
-		if (full_decay)
-			WRITE_ONCE(vn->pool[i].len, 0);
+		pool_len = n_decay = vn->pool[i].len;
+		WRITE_ONCE(vn->pool[i].len, 0);
 
 		/* Decay a pool by ~25% out of left objects. */
-		n_decay = vn->pool[i].len >> 2;
+		if (!full_decay)
+			n_decay >>= 2;
+		pool_len -= n_decay;
 
 		list_for_each_entry_safe(va, nva, &tmp_list, list) {
+			if (!n_decay--)
+				break;
+
 			list_del_init(&va->list);
 			merge_or_add_vmap_area(va, &decay_root, &decay_list);
-
-			if (!full_decay) {
-				WRITE_ONCE(vn->pool[i].len, vn->pool[i].len - 1);
-
-				if (!--n_decay)
-					break;
-			}
 		}
 
 		/*
@@ -2187,9 +2185,10 @@ decay_va_pool_node(struct vmap_node *vn,
 		 * can populate the pool therefore a simple list replace
 		 * operation takes place here.
 		 */
-		if (!full_decay && !list_empty(&tmp_list)) {
+		if (!list_empty(&tmp_list)) {
 			spin_lock(&vn->pool_lock);
 			list_replace_init(&tmp_list, &vn->pool[i].head);
+			WRITE_ONCE(vn->pool[i].len, pool_len);
 			spin_unlock(&vn->pool_lock);
 		}
 	}
_

Patches currently in -mm which might be from bhe@redhat.com are


