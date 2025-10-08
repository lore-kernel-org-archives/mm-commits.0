Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C6221C19E
	for <mm-commits@vger.kernel.org>; Wed,  8 Oct 2025 00:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759882934; cv=none; b=MQZsljCJbGg+fhA6rcOHXbzBOSrObVqqP5SUZQWgTHx7Aq44ks0yLlGLw/poo8NZPh44BYjKMh8U5gXXmh3BN824pDFwd0YlpyLthXOaFOeLiFgMGB3INTm1WltitmtA2e616pOJjEivGSpzqDpui5TBNhVRgt8zbplfgZeuZ68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759882934; c=relaxed/simple;
	bh=IyZNcwN8x5CuZRodEw0KV1cX6PFRroHiSP4Sz0l9eJk=;
	h=Date:To:From:Subject:Message-Id; b=bWdaoN+4pcAYP5jIFWHY2LfiKIvk1Mo/UUr31+5mNjuo8A3b44CNEZo7yjscH1QVcPHP7ZiNHi2I0eiFJMx96H7rrQ/ZLDA4IoaeaGzrayjrC5XUgPiYLFUOco/reLghTGAzUcR/zRCvC9902OetmxPRqdro9y7UpLde8xeGGog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V2rTjqG9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V2rTjqG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA5AC4CEF7;
	Wed,  8 Oct 2025 00:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759882933;
	bh=IyZNcwN8x5CuZRodEw0KV1cX6PFRroHiSP4Sz0l9eJk=;
	h=Date:To:From:Subject:From;
	b=V2rTjqG9MH9J1vZzhE2roxruRyiOKsggGPUrBLytGeDNw250w6yfuObFIk2Rrvg69
	 Ey+YSdKGuUYTRlkyPOSXT1n1/0suiBx9XLb2YMPkiODz+CiZs74PeySZlgMVdzyzwV
	 ZToEd9iAsW3qXi5ZgCsiqIbG4LTxz5cxMc1LVDbM=
Date: Tue, 07 Oct 2025 17:22:12 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,david@redhat.com,corbet@lwn.net,chrisl@kernel.org,chengming.zhou@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-fix-typos-s-zwap-zswap.patch added to mm-new branch
Message-Id: <20251008002213.5DA5AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: fix typos: s/zwap/zswap/
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-fix-typos-s-zwap-zswap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-fix-typos-s-zwap-zswap.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/zswap: fix typos: s/zwap/zswap/
Date: Fri, 3 Oct 2025 13:38:49 -0700

As the subject says.

Link: https://lkml.kernel.org/r/20251003203851.43128-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 mm/zswap.c      |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-zswap-fix-typos-s-zwap-zswap
+++ a/mm/memcontrol.c
@@ -5443,7 +5443,7 @@ bool obj_cgroup_may_zswap(struct obj_cgr
  * @size: size of compressed object
  *
  * This forces the charge after obj_cgroup_may_zswap() allowed
- * compression and storage in zwap for this cgroup to go ahead.
+ * compression and storage in zswap for this cgroup to go ahead.
  */
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
 {
--- a/mm/zswap.c~mm-zswap-fix-typos-s-zwap-zswap
+++ a/mm/zswap.c
@@ -879,7 +879,7 @@ static bool zswap_compress(struct page *
 	 * acomp instance, then get those requests done simultaneously. but in this
 	 * case, zswap actually does store and load page by page, there is no
 	 * existing method to send the second page before the first page is done
-	 * in one thread doing zwap.
+	 * in one thread doing zswap.
 	 * but in different threads running on different cpu, we have different
 	 * acomp instance, so multiple threads can do (de)compression in parallel.
 	 */
@@ -1128,7 +1128,7 @@ static enum lru_status shrink_memcg_cb(s
 	 *
 	 * 1. We extract the swp_entry_t to the stack, allowing
 	 *    zswap_writeback_entry() to pin the swap entry and
-	 *    then validate the zwap entry against that swap entry's
+	 *    then validate the zswap entry against that swap entry's
 	 *    tree using pointer value comparison. Only when that
 	 *    is successful can the entry be dereferenced.
 	 *
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch
mm-zswap-fix-typos-s-zwap-zswap.patch
mm-zswap-s-red-black-tree-xarray.patch
docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch

