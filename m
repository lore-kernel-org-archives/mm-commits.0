Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31762385D81
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 03:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778641400; cv=none; b=QMsFdMEkhvEJPs1Kgq3jye3vFxbWEQJ1eyXLExZGOCnnk6QTA1DLV7a0LEivtMWTm/RIHlUe4pStaj8tKqFreGHWSenOyPfugTlHg6kPzEEe1RmGCYKI8JWBcBgwFoHDQ0dtUhqlCAKtVU0hfGAL62wZEgJUKMsdCoVJoF6Dsx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778641400; c=relaxed/simple;
	bh=lLDBq2nD0VhrkfwZK2wc2cwyAqODYAVJMktH6zJWaD8=;
	h=Date:To:From:Subject:Message-Id; b=KJGtLwrKI3kUo7xqNVwJHXApYBKBEH4QuC5VjkgKcidjZgMwt9o/WZ5Hg53cB4zDX1eY2NenzzVW65HzoYyyT3y2LgEaYvOT5BG8e4ty2EJuSnN7NXDpuX/pl15JLSscftyZQA4pHDGHRwlZEspNSGpEMf2OeIdHZ3tBHcGC8xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=10b1zv2v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="10b1zv2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39E5C2BCFC;
	Wed, 13 May 2026 03:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778641399;
	bh=lLDBq2nD0VhrkfwZK2wc2cwyAqODYAVJMktH6zJWaD8=;
	h=Date:To:From:Subject:From;
	b=10b1zv2v0c61bjwBsPH+WwEJUcoij++kErIgXyqWBcKWbnzjaccjAEs1z9nlefo/R
	 8qfqTN1c7LdMzZdpgSZdRE/bw401+ymtwcx3r3dti7IW08rCmZY4/ROeYF1BWl6Uwt
	 EX9nRkovuyyTNh4YtFn28SVTAzFEHwlyJqwb3qSo=
Date: Tue, 12 May 2026 20:03:19 -0700
To: mm-commits@vger.kernel.org,error27@gmail.com,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_meminit-use-for-bools.patch added to mm-new branch
Message-Id: <20260513030319.B39E5C2BCFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_meminit: use && for bools
has been added to the -mm mm-new branch.  Its filename is
     lib-test_meminit-use-for-bools.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_meminit-use-for-bools.patch

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
From: Alexander Potapenko <glider@google.com>
Subject: lib/test_meminit: use && for bools
Date: Mon, 4 May 2026 12:06:37 +0200

As pointed out by Dan Carpenter, test_kmemcache() was using a bitwise AND
on two bools instead of a boolean AND.  Fix this for the sake of code
cleanliness.

Link: https://lore.kernel.org/20260504100637.1535762-1-glider@google.com
Fixes: 5015a300a522 ("lib: introduce test_meminit module")
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/kernel-janitors/afOcIan1ap9kD26M@stanley.mountain/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_meminit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_meminit.c~lib-test_meminit-use-for-bools
+++ a/lib/test_meminit.c
@@ -387,7 +387,7 @@ static int __init test_kmemcache(int *to
 			ctor = flags & 1;
 			rcu = flags & 2;
 			zero = flags & 4;
-			if (ctor & zero)
+			if (ctor && zero)
 				continue;
 			num_tests += do_kmem_cache_size(size, ctor, rcu, zero,
 							&failures);
_

Patches currently in -mm which might be from glider@google.com are

lib-test_meminit-use-for-bools.patch
kfence-fix-kasan-hw-tags-bypass-via-runtime-sample_interval-change.patch

