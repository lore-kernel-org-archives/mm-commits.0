Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0993B95FD
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439051; cv=none; b=VfkIa64t0PEkbc5TTxoYhUoMjloBqEVqHoDxt7HbLE13CHCuynhjE/XNgks2hZ8Z8YvxLcahr+FHBpB7IuxBzrapn8YoHDSkdQl44vP/3u54Mg2d9tbdpSIvUkj4vSKjZkl8p46Vz27qNaihXjbnXUZNGe8vSuAsoyFY9+Yz9fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439051; c=relaxed/simple;
	bh=nIuK9RS+ciHSuBRPoAdFSvVDoP64fVmsfQCScxCm0Z8=;
	h=Date:To:From:Subject:Message-Id; b=iceWPpovb7TL+hYSVgqHwvSKDG4o+3Z5znN+wufzkt27yuafEo8WxA+TGTIuEprBFzzIAIXjToBlo/ITwaWfe94ytntIsdoHfiz8jLMJZigic6c4cLkHvpJgPeAIspmDvc9zKBC8PzXbFW4i4nMbaSTlaZiWEh+wqKHd3F/6F7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FWfZgPlS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FWfZgPlS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0C61F00898;
	Tue,  2 Jun 2026 22:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439050;
	bh=KnMSvP22esKJqHwI+BuDDB8isCr+LfxYMY3szycUOwE=;
	h=Date:To:From:Subject;
	b=FWfZgPlSpK57T2ev4MvTFzMeGuJ2bx2Y2LeDBDYYJvitl3jV3w6CdKafzzdgLAhX+
	 lfjUg4i5cUTK1rV84OkbsTQUTHQjmcSZ78lXV5T2+0MJtEr2QKXIwbMP22i5dMCzdn
	 ip4y3uDXVHJDg+EEcsfGEWF0smjDKEngzMBw9mgY=
Date: Tue, 02 Jun 2026 15:24:09 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,david@kernel.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-mm-page-types-fix-typo-in-madvise-error-message.patch removed from -mm tree
Message-Id: <20260602222409.EF0C61F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm/page-types: fix typo in madvise() error message
has been removed from the -mm tree.  Its filename was
     tools-mm-page-types-fix-typo-in-madvise-error-message.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: tools/mm/page-types: fix typo in madvise() error message
Date: Wed, 13 May 2026 10:21:16 +0800

Patch series "tools/mm/page-types: Fix misc bugs".

This series fixes three issues in tools/mm/page-types.c:

1. Fix two typos in madvise() error messages ("madvice" -> "madvise")
2. Fix operator precedence bug in the sigbus handler where the ternary
   operator binds looser than addition, producing incorrect offset
   calculation when sigbus_addr is non-NULL
3. Fix --kpageflags option declaration in getopt_long: has_arg should
   be 1 (required_argument) since the option requires a file path


This patch (of 3):

Two error messages incorrectly spelled the madvise() function name as
"madvice".  Fix the typo in both occurrences.

Link: https://lore.kernel.org/20260513022120.58033-1-ye.liu@linux.dev
Link: https://lore.kernel.org/20260513022120.58033-2-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page-types.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/mm/page-types.c~tools-mm-page-types-fix-typo-in-madvise-error-message
+++ a/tools/mm/page-types.c
@@ -997,7 +997,7 @@ static void walk_file_range(const char *
 
 		/* turn off readahead */
 		if (madvise(ptr, len, MADV_RANDOM))
-			fatal("madvice failed: %s", name);
+			fatal("madvise failed: %s", name);
 
 		if (sigsetjmp(sigbus_jmp, 1)) {
 			end = off + sigbus_addr ? sigbus_addr - ptr : 0;
@@ -1015,7 +1015,7 @@ got_sigbus:
 
 		/* turn off harvesting reference bits */
 		if (madvise(ptr, len, MADV_SEQUENTIAL))
-			fatal("madvice failed: %s", name);
+			fatal("madvise failed: %s", name);
 
 		if (pagemap_read(buf, (unsigned long)ptr / page_size,
 					nr_pages) != nr_pages)
_

Patches currently in -mm which might be from liuye@kylinos.cn are


