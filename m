Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2002459DD
	for <mm-commits@vger.kernel.org>; Sat,  6 Jun 2026 01:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780710733; cv=none; b=lSgXfRY7iHkzCpGxUQ/AHd9PQBWL681ehymFRd66/mQ0bYsgK7h1htmZLOl4N5J8Tud/EFYQKpAXd2ojlhN1Wh2ycKZ6CEpxZeLX+k+di3CE+vfUiIGmZhbRr+FQ0mUNDg0PDB2OJk0O6eigezrUqRad1tJFsQN9xKr6c8Yqz6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780710733; c=relaxed/simple;
	bh=TFbFswQNK/2SeH67Q8GKJJHKKLt65kERw/yKQ9S4AJI=;
	h=Date:To:From:Subject:Message-Id; b=HCe2V4R8W2L5FBrZID1iujK7UyN5rAzfzOTP+V0uPQX1EyuFa/vOhR3EqFigheRpNEq8/BjTMJnC7vG3e0B2X+DE8IkSQHvtHud1bVtBtWIsNrTjmkdwSg+c0TP4oL+XpTsLNUszfs4M29tsu7Ek1fUIKxpB6yWlL8PktFV3aJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kijsAfkO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kijsAfkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5A81F00893;
	Sat,  6 Jun 2026 01:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780710732;
	bh=jX5dRdR3zlJete0TjrVN5q4+aI1Zk57TDz8GFvjyc1g=;
	h=Date:To:From:Subject;
	b=kijsAfkOCpqwuvUXCPq9JELXCBz1bfyFLjxJkN0WE2DZWDK4z22CYKn+1CM420G2t
	 hWuFebOdOotXkTzqeXas2rMlVEruGxCTPy2OPvZoLoaWesoDDJev2Gf9A8mG1bn89R
	 5nKeTVqxw+Z4WJZIbDKK4cP0AfMCJvme0t4XvwNY=
Date: Fri, 05 Jun 2026 18:52:12 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,ljs@kernel.org,kent.overstreet@linux.dev,david@kernel.org,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-hao-ge-as-reviewer-for-codetag-and-alloc_tag.patch added to mm-unstable branch
Message-Id: <20260606015212.8D5A81F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add Hao Ge as reviewer for codetag and alloc_tag
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-add-hao-ge-as-reviewer-for-codetag-and-alloc_tag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-hao-ge-as-reviewer-for-codetag-and-alloc_tag.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Hao Ge <hao.ge@linux.dev>
Subject: MAINTAINERS: add Hao Ge as reviewer for codetag and alloc_tag
Date: Tue, 26 May 2026 17:26:41 +0800

I've been contributing to the codetag and alloc_tag subsystems since 2024,
Memory allocation profiling is indeed a great tool and I'd like to stay
involved as a reviewer to keep up with ongoing development and not miss
any of the details.  I'm happy to help review patches and contribute to
the ongoing development of this subsystem.

Link: https://lore.kernel.org/20260526092641.299399-1-hao.ge@linux.dev
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-hao-ge-as-reviewer-for-codetag-and-alloc_tag
+++ a/MAINTAINERS
@@ -6349,6 +6349,7 @@ F:	Documentation/process/code-of-conduct
 CODE TAGGING
 M:	Suren Baghdasaryan <surenb@google.com>
 M:	Kent Overstreet <kent.overstreet@linux.dev>
+R:	Hao Ge <hao.ge@linux.dev>
 S:	Maintained
 F:	include/asm-generic/codetag.lds.h
 F:	include/linux/codetag.h
@@ -16706,6 +16707,7 @@ F:	tools/testing/memblock/
 MEMORY ALLOCATION PROFILING
 M:	Suren Baghdasaryan <surenb@google.com>
 M:	Kent Overstreet <kent.overstreet@linux.dev>
+R:	Hao Ge <hao.ge@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/mm/allocation-profiling.rst
_

Patches currently in -mm which might be from hao.ge@linux.dev are

lib-test_hmm-fix-memory-leak-in-dmirror_migrate_to_system.patch
mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list.patch
alloc_tag-fix-use-after-free-in-proc-allocinfo-after-module-unload.patch
maintainers-add-hao-ge-as-reviewer-for-codetag-and-alloc_tag.patch

