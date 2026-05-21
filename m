Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5563603D8
	for <mm-commits@vger.kernel.org>; Thu, 21 May 2026 16:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779382198; cv=none; b=nB2m8aoCgCWfquZ+kqWgbt6/sOOTthoBVcd5w7cJzHsUGbj1M/wimMKTpjy7RJQiIgerr4KCXUWttG9bSRjub/KeH3Mx5FOAtnqvAnZkNaqjJ5tqnLNkihR32lgrACPC0j6tWxlm5q8zy7dAKRg4gTs8kNU0cUuGE2vlMccMgZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779382198; c=relaxed/simple;
	bh=QDqcLArmw+DZ7Ny6MAnDh8lE4cvItP5/8vS+HL97Eyw=;
	h=Date:To:From:Subject:Message-Id; b=pI34xlSqWhJ4qbVcioAQ78PEMfgKvnwiHt+5N4ClEdBZtvtCWVRmBjo5uvsH+KbZm0rhoraJtCbEYpIm6FJD1PbhVPOVBotWM6RjenU3bpC23JzW5TcXRYFWZa/HjacJKEbjJ3M2N7JtESecDwba0+J1qJyFH8oXb55JFb3lXCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aQxpiWKG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aQxpiWKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFB71F000E9;
	Thu, 21 May 2026 16:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779382196;
	bh=hLHU72sNWcwiOAbySPZeqfg/V7aGQfjP6Rj/W7S8g8M=;
	h=Date:To:From:Subject;
	b=aQxpiWKGsjhcfPexCY+w7M2xgpfBwv9RV5jV2LS7j/7v0i0Io8e/5Af7LqrPnKI0o
	 1uLOtf3mVTlqFrnyWThfiVy7T7RYm9RSHSK53iIFiNjAD1A866Ym53KryxzlJRp15c
	 gdEiihXMYvtYwKVLp6rRbb4vw6fCqQxbr1wa93a4=
Date: Thu, 21 May 2026 09:49:56 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,harry@kernel.org,elver@google.com,david@kernel.org,kees@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-util-use-kmalloc-buckets-for-kmemdup_nul.patch added to mm-new branch
Message-Id: <20260521164956.9BFB71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/util: use kmalloc buckets for kmemdup_nul()
has been added to the -mm mm-new branch.  Its filename is
     mm-util-use-kmalloc-buckets-for-kmemdup_nul.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-util-use-kmalloc-buckets-for-kmemdup_nul.patch

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
From: Kees Cook <kees@kernel.org>
Subject: mm/util: use kmalloc buckets for kmemdup_nul()
Date: Thu, 21 May 2026 05:40:31 -0700

The use of the kmemdup_nul()-family of allocations are explicitly for
allocating NUL terminated strings, so these would be best separated from
typed allocations, as they are their own set of arbitrarily sized
allocations.  They are not as risky as userspace controlled allocations,
but these would be good to separate as well.

  # grep memdup_nul /proc/slabinfo | cut -c-25
  memdup_nul-8k          0
  memdup_nul-4k          0
  memdup_nul-2k          0
  memdup_nul-1k          0
  memdup_nul-512        28
  memdup_nul-256         0
  memdup_nul-192        60
  memdup_nul-128        60
  memdup_nul-96         60
  memdup_nul-64        180
  memdup_nul-32        960
  memdup_nul-16       1860
  memdup_nul-8        1980

Link: https://lore.kernel.org/20260521124026.work.036-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Suggested-by: Harry Yoo <harry@kernel.org>
Acked-by: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/util.c~mm-util-use-kmalloc-buckets-for-kmemdup_nul
+++ a/mm/util.c
@@ -34,6 +34,9 @@
 #include "internal.h"
 #include "swap.h"
 
+static kmem_buckets *user_buckets __ro_after_init;
+static kmem_buckets *nul_buckets __ro_after_init;
+
 /**
  * kfree_const - conditionally free memory
  * @x: pointer to the memory
@@ -61,7 +64,7 @@ static __always_inline char *__kmemdup_n
 	char *buf;
 
 	/* '+1' for the NUL terminator */
-	buf = kmalloc_track_caller(len + 1, gfp);
+	buf = kmem_buckets_alloc_track_caller(nul_buckets, len + 1, gfp);
 	if (!buf)
 		return NULL;
 
@@ -195,15 +198,14 @@ char *kmemdup_nul(const char *s, size_t
 }
 EXPORT_SYMBOL(kmemdup_nul);
 
-static kmem_buckets *user_buckets __ro_after_init;
-
-static int __init init_user_buckets(void)
+static int __init init_buckets(void)
 {
 	user_buckets = kmem_buckets_create("memdup_user", 0, 0, INT_MAX, NULL);
+	nul_buckets = kmem_buckets_create("memdup_nul", 0, 0, INT_MAX, NULL);
 
 	return 0;
 }
-subsys_initcall(init_user_buckets);
+subsys_initcall(init_buckets);
 
 /**
  * memdup_user - duplicate memory region from user space
_

Patches currently in -mm which might be from kees@kernel.org are

mm-util-use-kmalloc-buckets-for-kmemdup_nul.patch

