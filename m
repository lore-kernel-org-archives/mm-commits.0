Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37151EB5FE
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119211; cv=none; b=rtqthKpffBVKdKBSXQlinW6LkIjuot6qjH/ejrlcsDbmhESoCP5X0t/dteVza5w7U58qV0g+BCrE17Vy0LR2yDAtBF8m3AAc6ixCgykN4yOMN9k0cLTVxaxFd/1trlGnsRYkYzLgUfZECHgus/cu300u8quItfSWIxKf9yXfck8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119211; c=relaxed/simple;
	bh=dAVk96fqNm7GO89sPvaIpZ+dbLgmB+2XgLrEKSI9/lg=;
	h=Date:To:From:Subject:Message-Id; b=LdTimB9I+b355OfO/NyosZ6HBrpvJHbOl8grXDobIG9vBmvTTYCCLT4MIRnC4+8VVQMIDx6w4qJ28L+KhO43JWJUSRFk5sJlRw48fCn9tbU+WfBuhAo8Oo4xAacpG1hv0cw+ItLZEII+jxPxHS/NdJfuBEOpYB4+BfCx64Nzi/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UxENn5z4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UxENn5z4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E18CC4CEE4;
	Tue, 13 May 2025 06:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119210;
	bh=dAVk96fqNm7GO89sPvaIpZ+dbLgmB+2XgLrEKSI9/lg=;
	h=Date:To:From:Subject:From;
	b=UxENn5z4M/qYINfkI90o4I5WMu/H/yhw47dO1rS0GkykQnWYjCZBqyCzd6ls0I4WA
	 5KlBcJur9Yu9pw6xAlFat9w+z4zGxn1Ayr/zLKPRdX/UAG2UHbDwNquJt2TmCajOnz
	 78KjsGWwVsQBW374OXHdTeiMQNFgN4bWUVkTws6c=
Date: Mon, 12 May 2025 23:53:29 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pvkumar5749404@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-typos-in-comments-in-mm_initc.patch removed from -mm tree
Message-Id: <20250513065330.4E18CC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix typos in comments in mm_init.c
has been removed from the -mm tree.  Its filename was
     mm-fix-typos-in-comments-in-mm_initc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Prabhav Kumar Vaish <pvkumar5749404@gmail.com>
Subject: mm: fix typos in comments in mm_init.c
Date: Sun, 20 Apr 2025 19:34:40 +0530

Corrected minor typos in comments:
	- 'contigious' -> 'contiguous'
	- 'hierarcy' -> 'hierarchy'

This is a non-functional change in comment text only.

Link: https://lkml.kernel.org/r/20250420140440.18817-1-pvkumar5749404@gmail.com
Signed-off-by: Prabhav Kumar Vaish <pvkumar5749404@gmail.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mm_init.c~mm-fix-typos-in-comments-in-mm_initc
+++ a/mm/mm_init.c
@@ -828,7 +828,7 @@ overlap_memmap_init(unsigned long zone,
  * - physical memory bank size is not necessarily the exact multiple of the
  *   arbitrary section size
  * - early reserved memory may not be listed in memblock.memory
- * - non-memory regions covered by the contigious flatmem mapping
+ * - non-memory regions covered by the contiguous flatmem mapping
  * - memory layouts defined with memmap= kernel parameter may not align
  *   nicely with memmap sections
  *
@@ -1907,7 +1907,7 @@ void __init free_area_init(unsigned long
 		free_area_init_node(nid);
 
 		/*
-		 * No sysfs hierarcy will be created via register_one_node()
+		 * No sysfs hierarchy will be created via register_one_node()
 		 *for memory-less node because here it's not marked as N_MEMORY
 		 *and won't be set online later. The benefit is userspace
 		 *program won't be confused by sysfs files/directories of
_

Patches currently in -mm which might be from pvkumar5749404@gmail.com are


