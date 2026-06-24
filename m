Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B906E3CAE8F
	for <mm-commits@vger.kernel.org>; Wed, 24 Jun 2026 19:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782331104; cv=none; b=iKVI8gjqNpefDxiKX4iQeLLKcOUmsvlif/nIaVLhCNiDOIUy3k60FA2t1qE1yuedmzCgcNZSWxIQLtSypyVbPHS1tylgwNaHsbW4AefJUsnvlWlIQSYNeKNd90/KnFEWjB/Eb8yuG9hgKfEy8a86z6EkB8Q3Pniw/hjsypYLj/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782331104; c=relaxed/simple;
	bh=d2Nj+i14jifD5RShoVMKCn4FJRnoGxlM4mfMrWOAuDk=;
	h=Date:To:From:Subject:Message-Id; b=OTkdw2Yg1/RkHfK1IGF/wd0jjcmjhD4v4O7FEo5UCGv1vjMG8hQpXRR+gwwAUsAobRwl5HWnWIFWWZP29hrqf8hCA8A6olIIBxBWL0n8jevJpn6evSKNxOme+6a09D6evDIOFOUnPJSzdqksICi8x5zt2h4BL9azuJzFJe4u4EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mMIhSB+Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mMIhSB+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438C21F000E9;
	Wed, 24 Jun 2026 19:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782331103;
	bh=1GTChDZ08fdZQdy+mRNbhVVwBmWxgy6ggXMyy/UdmQM=;
	h=Date:To:From:Subject;
	b=mMIhSB+ZTxoJU/ji64Ie712R92ri3b4lHipaOy2xHvVboXb6u+C6hdIeiI3RDHaMQ
	 9TWnU4gWz4OINlfX/A3oiFHEF9Im1G13JdtAxkuseaVFt2UQGQqTuw2IyzGSRaWTgO
	 GpkPa3M6k42K+ZGcpN0QWMlbnGgm3BVhTFMve+DY=
Date: Wed, 24 Jun 2026 12:58:22 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-add-thp_swap_allocator_test-binary-to-gitignore.patch added to mm-new branch
Message-Id: <20260624195823.438C21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm: add thp_swap_allocator_test binary to .gitignore
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-add-thp_swap_allocator_test-binary-to-gitignore.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-add-thp_swap_allocator_test-binary-to-gitignore.patch

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
From: Zenghui Yu <zenghui.yu@linux.dev>
Subject: tools/mm: add thp_swap_allocator_test binary to .gitignore
Date: Wed, 24 Jun 2026 23:06:42 +0800

Tell git to ignore the generated binary for thp_swap_allocator_test.c.

Link: https://lore.kernel.org/20260624150642.19749-1-zenghui.yu@linux.dev
Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/mm/.gitignore~tools-mm-add-thp_swap_allocator_test-binary-to-gitignore
+++ a/tools/mm/.gitignore
@@ -2,3 +2,4 @@
 slabinfo
 page-types
 page_owner_sort
+thp_swap_allocator_test
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

tools-mm-add-thp_swap_allocator_test-binary-to-gitignore.patch

