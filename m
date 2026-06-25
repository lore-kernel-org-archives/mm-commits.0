Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879EF3A9DA3
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 02:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782353451; cv=none; b=ZJcVoV0XSLNpDz6C+T6Zcc9jooF0N8MmpAmssWkb5DM1xYNEgqLon2N3qqPGEO3mSQ5z+5DZjby0anmRDuHVXCC6BSzSbEgfSiuAbpKvJNamVvpxIuWmQqNgYDmPgHfXgUztPtI9vckLrWJRmE56/X05oaK60/Jfoqq72ErVZMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782353451; c=relaxed/simple;
	bh=5j3nJqNLd+ujzhqt7yIeFO5VJ51Rvmu79C+AYeufJco=;
	h=Date:To:From:Subject:Message-Id; b=WG1zT5t2jXsDOhbAShUhdwMW6ew92cZ39iKXuTRqTioRTLUHs8B9Xqn3lvr3kn6IhbcdB9g2WtVSXlsOwyxXvg549ow3/py7CoLk7AhCPCzxENCQhXt8vK3EJ7SDwMaqOiK7TXi4Em3LhRoc2rcepNybwHMui8NGPpS4lj2Dnzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YK8b1rTp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YK8b1rTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5951F000E9;
	Thu, 25 Jun 2026 02:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782353450;
	bh=mC7g3pAt2DID6ccEi1HROmsOPEJnHajS4xy2W+5lXTw=;
	h=Date:To:From:Subject;
	b=YK8b1rTpX3XCPTRNrLYx4knjrz15VU+RtmbME73cC6F0+ZLimdQ+vs3V4Xf81bxAj
	 xHrSF+7HB72BWAu8iWcxI3KvraCz61nrBfV3G13/wP600ygzOI9XhpjcCy/X5RCsNJ
	 L5jyObZ+cNW4H8YL6Gz/iiVFXqszfxYnHBnj8ftE=
Date: Wed, 24 Jun 2026 19:10:49 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,urezki@gmail.com,tj@kernel.org,shivamkalra98@zohomail.in,pfalcato@suse.de,mhocko@suse.com,dennis@kernel.org,cl@gentwo.org,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-percpu-make-cached-pages-lookup-explicit.patch added to mm-new branch
Message-Id: <20260625021050.5C5951F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/percpu: make cached pages lookup explicit
has been added to the -mm mm-new branch.  Its filename is
     mm-percpu-make-cached-pages-lookup-explicit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-percpu-make-cached-pages-lookup-explicit.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-vmalloc-honor-gfp-constraints-in-pcpu_get_vm_areas.patch
mm-percpu-honor-gfp-constraints-when-populating-chunks.patch
mm-percpu-make-cached-pages-lookup-explicit.patch
mm-percpu-avoid-io-fs-reclaim-in-backing-allocations.patch

