Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC8E38C2C0
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298395; cv=none; b=Vq5sOMkUDvrZyaYb3xCngt0oyo6MYpFew/luOxD5jYv1jWSZYEAeVQq6dUTU7Wa2svQkicqM0/IdaN+tfEP5CKBZncS5qJEtJh2puz9w3km74T4+4T6p8lku0VcP8X2B2onZ9XUAisFKc5GBLwcIsqqKvZKFT+2WO9/Y5UZn7+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298395; c=relaxed/simple;
	bh=lakWGLMbD8Yvpo4OOw9ydIQuDDnXt8JvmE/VAp2jSqw=;
	h=Date:To:From:Subject:Message-Id; b=MDVx6E3VSF7SueO76BKyqOyeog8qLTfZOnlX/VFNPi99ssv4m/Y6BhIlAxrlcHNR8wiWbP/o5ud8+VR3IU/CEMGQ/QpoXqFAxhoPy4va8wNTMlUOUkmBr+ezCM3apyno+ofX608j68mOmFSNi4iQuhCXj1qgQZsR5UjH9R2uGO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xZmvclsx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xZmvclsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2D01F00A3A;
	Wed, 29 Jul 2026 04:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298393;
	bh=6KiseQ8nnj7YPebveAUyRYnITYjPuzfgzow+UZLJMKk=;
	h=Date:To:From:Subject;
	b=xZmvclsxDulwePVY0OuK4AjlXMFpRLnYDTyHgToL2UrQok9tgvtKmoANHpI3zp48+
	 M7URNwiWJ1Otp5JSORadyTa5pFL+0BHB3Fz+1QGTDLLfVXI3VsCujbLyP1ezjE94q/
	 EbiMmN0B6yhURzq6zFnJYsuwnaoubIMFtYBgi338=
Date: Tue, 28 Jul 2026 21:13:13 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,urezki@gmail.com,tj@kernel.org,shivamkalra98@zohomail.in,pfalcato@suse.de,mhocko@suse.com,dennis@kernel.org,cl@gentwo.org,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-percpu-make-cached-pages-lookup-explicit.patch removed from -mm tree
Message-Id: <20260729041313.8D2D01F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/percpu: make cached pages lookup explicit
has been removed from the -mm tree.  Its filename was
     mm-percpu-make-cached-pages-lookup-explicit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm/percpu: make cached pages lookup explicit
Date: Thu, 18 Jun 2026 21:04:13 +0800

pcpu_depopulate_chunk() only needs the temporary pages array that was
already allocated by an earlier successful population attempt.  Passing
GFP_KERNEL to pcpu_get_pages() in this path is misleading because the
depopulation path is not expected to allocate the array.

Teach pcpu_get_pages() to treat a zero gfp mask as a cached-only lookup
and add pcpu_get_pages_cached() for that use case.  This keeps allocation
on the populate path tied to the caller supplied GFP mask while making the
depopulate path's dependency on the cached array explicit.

Link: https://lore.kernel.org/20260618130414.96383-4-kaitao.cheng@linux.dev
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Suggested-by: Dennis Zhou <dennis@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Tejun Heo <tj@kernel.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu-vm.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/percpu-vm.c~mm-percpu-make-cached-pages-lookup-explicit
+++ a/mm/percpu-vm.c
@@ -21,7 +21,8 @@ static struct page *pcpu_chunk_page(stru
 
 /**
  * pcpu_get_pages - get temp pages array
- * @gfp: allocation flags passed to the underlying allocator
+ * @gfp: allocation flags passed to the underlying allocator, 0 to only
+ *	 return the cached array
  *
  * Returns pointer to array of pointers to struct page which can be indexed
  * with pcpu_page_idx().  Note that there is only one array and accesses
@@ -37,11 +38,16 @@ static struct page **pcpu_get_pages(gfp_
 
 	lockdep_assert_held(&pcpu_alloc_mutex);
 
-	if (!pages)
+	if (!pages && gfp)
 		pages = pcpu_mem_zalloc(pages_size, gfp);
 	return pages;
 }
 
+static struct page **pcpu_get_pages_cached(void)
+{
+	return pcpu_get_pages(0);
+}
+
 /**
  * pcpu_free_pages - free pages which were allocated for @chunk
  * @chunk: chunk pages were allocated for
@@ -333,7 +339,7 @@ static void pcpu_depopulate_chunk(struct
 	 * successful population attempt so the temp pages array must
 	 * be available now.
 	 */
-	pages = pcpu_get_pages(GFP_KERNEL);
+	pages = pcpu_get_pages_cached();
 	BUG_ON(!pages);
 
 	/* unmap and free */
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are

mm-kconfig-drop-redundant-memory-hotplug-dependencies.patch
mm-kconfig-drop-redundant-dependency-wrappers.patch

