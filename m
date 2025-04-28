Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1663526158A
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 09:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745832490; cv=none; b=TtpmsBmQfgcQsyPmQNEGufMjIxSX20/DAkiau+CCQKMi56rRc7NcIvbOqSAJLSTwS8yxiWRbYecvZpKk7JGJWRJE7Vs5CYV5yD+0sKcXz3T0gbSB1+t0rJPAZgn+vQGCarlBTu6lYIpn2a/eZcA3QvQE8ovvbZU18jyEGdv/hrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745832490; c=relaxed/simple;
	bh=9yiwFVUdG5MzNLvuJytwDjnuzxr8YMAT9K0tSVYJal8=;
	h=Date:To:From:Subject:Message-Id; b=tBdR6OZoPH+BogI8Pv0GR0WdnXfCxmIvKTQ+OcDR+UQVLN3y166b34Zb/0yHHL+0553kqnFXs/QhC/U+3hP5+FEoKayx8tvWn+r+R4Ssh1YP62SuYmuIAlXQ/OUPtASdi/bxosZvCvsk3HXNInq1YVCoDBIYN2VUgt2xNNtxh34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wpaK1ihK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wpaK1ihK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFB7C4CEE4;
	Mon, 28 Apr 2025 09:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745832489;
	bh=9yiwFVUdG5MzNLvuJytwDjnuzxr8YMAT9K0tSVYJal8=;
	h=Date:To:From:Subject:From;
	b=wpaK1ihKfedyaiPXysKvDSp6t5IzR+OYmvvz/6B2Iy3IqAD4AVG1AMM6QA9nrpyym
	 4CAi/DpN2Zm1iOkefDag4CXrOsPpynJuJeOY/OYtWZDnCFesAas8AH2M7JtKfGzY/n
	 9Lj3NC4azvxyG1yRQBODu4uoByKdzumZscGUiD/c=
Date: Mon, 28 Apr 2025 02:28:08 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,vitaly.wool@konsulko.se,shakeel.butt@linux.dev,nphamcs@gmail.com,igor.b@beldev.am,hannes@cmpxchg.org,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zblock-avoid-failing-the-build-fix.patch added to mm-new branch
Message-Id: <20250428092809.6AFB7C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-zblock-avoid-failing-the-build-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-zblock-avoid-failing-the-build-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zblock-avoid-failing-the-build-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-zblock-avoid-failing-the-build-fix
Date: Mon Apr 28 02:19:47 AM PDT 2025

s/#warn/#warning/

Cc: Igor Belousov <igor.b@beldev.am>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zblock.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zblock.h~mm-zblock-avoid-failing-the-build-fix
+++ a/mm/zblock.h
@@ -21,7 +21,7 @@
 /* max 256 slots per block, max table size 64 */
 #define SLOT_BITS 8
 #else
-#warn This PAGE_SIZE is not quite supported yet
+#warning This PAGE_SIZE is not quite supported yet
 #define SLOT_BITS 8
 #endif
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

x86-disable-image-size-check-for-test-builds-fix.patch
x86-disable-image-size-check-for-test-builds-fix-fix.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
mm-add-zblock-allocator-fix.patch
mm-zblock-avoid-failing-the-build-fix.patch
mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes.patch
compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix.patch

