Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793596654;
	b=nRK6e3x3ydu5uAOf/mYqhWvrYe6Dz/CMfIC2yn8C9x65/uYkfGBnSQuh8PZG9Rn/giaf
	 RyoZSqjMn51pKV1dlwOjF+O18tKis5aO7McOdqwI+tnK6s1DQiz5qMikViv3lfcIHZTVA
	 iQSa/udeGIcxmZzEz5YtmX2btSlXqHYbyU6xar6xQwSF0dTTepzVO0XtjY2h6J9RuwJks
	 yrKXOgE+D1M74Zf0avNwmG9DLKQedC0yWkY2dh9Zl0qnfek8liRfJ8nwnvmJAkX6FeJ1L
	 PopuM1dVvpxw8U1c4P9SsucFSmcKSme4Zeg1dmuF1jigBa+Obpw5H65Y4lsynetXB1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793596654;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=mM/fA7p5mq2aPk9ubyA2U1uaRFEHARxjnfZTzgcb0WQ=;
	b=pp7OqEYlzzqGJXVbGl3kMflMd9uLau5Ir9qPlp62gOhZNPHubONjBh7c4peGgiYjrQKg
	 20lh6gXZgmxdh1eox1WmqzF1kxgXuC84JRL551eHhpeUos45v51OoEqL8/3399fNoQIoV
	 Xu6owWaz/hBowtQnp5NkctZQqEv66ZpSrbNXz0l7CR25XIwnVWfzhL9Hc+sXYq0BRTXMP
	 3ohulGw0y0/0kwPsiBdba7/nNiw2w/czla0iTdCAbgMMRqZx2/FkwzPuY6S8PFsDnmrQv
	 brq4444j3T768fPYV5s8n/748toJRAILs+w1+Doll1XZVbxNOaCCmW5qt3wvn9isIYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZeNVx4d8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EAE606A324
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 05:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZeNVx4d8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A601F000C1;
	Mon,  2 Nov 2026 05:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793596653;
	bh=mM/fA7p5mq2aPk9ubyA2U1uaRFEHARxjnfZTzgcb0WQ=;
	h=Date:To:From:Subject;
	b=ZeNVx4d8JqxoOsQu2S0GQwgEatfNZ0QjQVzqPKR4zTUHSQgnU4f5tES3cQh7bFh7W
	 kqoaMk0JEm+PxktvKFRpmM+JCORi35WlQ6UfsTkJkkZf50mS8cCW8FljWv6NVy5wHt
	 1IztuEiVMdTGxed22JlCUXcgBDSzuK2lfDb/Xx2Q=
Date: Sun, 01 Nov 2026 21:17:33 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,david@kernel.org,
	baolin.wang@linux.alibaba.com,tongweilin@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-thpmaps-fix-missing-order-1-file-thp-statistics.patch added to mm-new branch
Message-Id: <20261102051733.C3A601F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: tools/mm/thpmaps: fix missing order-1 file THP statistics
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-thpmaps-fix-missing-order-1-file-thp-statistics.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-thpmaps-fix-missing-order-1-file-thp-statistics.patch

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
From: Weilin Tong <tongweilin@linux.alibaba.com>
Subject: tools/mm/thpmaps: fix missing order-1 file THP statistics
Date: Tue, 27 Oct 2026 15:49:03 +0800

File-backed THPs can have order 1, but the per-size counters are only
emitted for order 2 and above. Fully and contiguously mapped order-1
file THPs are therefore missing from the output.

Start emitting the per-size counters at order 1.

Link: https://lore.kernel.org/20261027074904.3328878-3-tongweilin@linux.alibaba.com
Fixes: 2444172cfde4 ("tools/mm: add thpmaps script to dump THP usage info")
Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
---

 tools/mm/thpmaps |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/mm/thpmaps~tools-mm-thpmaps-fix-missing-order-1-file-thp-statistics
+++ a/tools/mm/thpmaps
@@ -295,7 +295,7 @@ def thp_parse(vma, kpageflags, ranges, i
 
     def flatten_sub(type, subtype, stats):
         param = f"{type}-thp-pte-{subtype}-{{}}kB"
-        for od, nr in enumerate(stats[2:], 2):
+        for od, nr in enumerate(stats[1:], 1):
             rstats[param.format(odkb(od))] = {'type': type, 'value': nrkb(nr)}
 
     def flatten_type(type, stats):
_

Patches currently in -mm which might be from tongweilin@linux.alibaba.com are

tools-mm-thpmaps-fix-partial-thp-anon-file-accounting.patch
tools-mm-thpmaps-fix-missing-order-1-file-thp-statistics.patch
tools-mm-thpmaps-fix-missing-mapping-names.patch

