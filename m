Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792620097;
	b=vN7S3+h72PY8kDq8I27Vc+ULYteaMnLAoHINS+7TK/FbDoTXPexqHsk3h4JHnQqdLa36
	 kt2Xx4GYakLNsF4zwKTOE9tujaw8zZn++cFlEPNXVwR9fxfPZDOMUQHyt3ZJ/4NWhdY9L
	 gnmFBxV8me9Xs4AtFMFxHN41jGDObRvxwJOF5aupN4JtsBRzZ2bJchkINt2CoEZJfKsxp
	 tCHRMYdyG+rJDop2O7SdoV/fo3hsfvcMAL3JzMVXcBcZ32WtlMVMdX9QHmbsKoDsZ1LCQ
	 Y6EqTnmgg8TvIi2uGxgUh8+yQcgikpi7DscUV2f1Oc+2kDHnKRpqKe3Towp1WJO/Bwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792620097;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=XG4FKOAiiJxa5Wcqv+KgE34SYtrHx/TMDjTuMQvFXlE=;
	b=cteBPd5oiVZZZRMomZ7pkBbpXEpI8ekcBGyOSELsrWaVzgDkhs7/XciOBWKdhtbd7BYq
	 ohBSy6sDE5jUQ1gCj91W6m0B0cNkYOn6KeCT3tKLLcMoJS7/QX46BH15Q51yZcXKmsyzH
	 8Em1NB2dgvxpcGgoGVz1eYQHlslug3gRrHmizA4Fp5Yv5QJwqqZAJTcMtU61PJ3z/elrh
	 3Ha+4Gmw3ivXp7c5YHQXx0qr+gei3wzHmVlywG7xmpaodooWHZyxqvlvvwNPyMiNhBLK7
	 eVELxpihaMQ4CLs7oMFKOzMdcQDEPGh9bKklNjQkKn//J06CTq2hadA2VxA+X2EwOqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2p6eRC8R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A88606A323
	for <mm-commits@vger.kernel.org>; Wed, 21 Oct 2026 22:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2p6eRC8R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41F11F000C1;
	Wed, 21 Oct 2026 22:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792620096;
	bh=XG4FKOAiiJxa5Wcqv+KgE34SYtrHx/TMDjTuMQvFXlE=;
	h=Date:To:From:Subject;
	b=2p6eRC8RAiHlNlOXBEeINgy9t8f/o8kzeVsWY1HqmDH5oJHOoaLs5P5hTHnwYF4YH
	 Y+4U/zO1A/2X/FbVN8ROu5/Kt7N4Puxpqit32xTIrr8KcJ27mWSNxfACLIVJUYe0wU
	 JdvvAIrtz9P/uWFPZfiXHGtf0nAsgmB4grIWK+Us=
Date: Wed, 21 Oct 2026 15:01:36 -0700
To: mm-commits@vger.kernel.org,sashiko-bot@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,gourry@gourry.net,chris@chrisdown.name,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_counter-use-write_once-for-emin-elow-when-parent-is-the-root.patch added to mm-unstable branch
Message-Id: <20261021220136.A41F11F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/page_counter: use WRITE_ONCE() for emin/elow when parent is the root
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_counter-use-write_once-for-emin-elow-when-parent-is-the-root.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_counter-use-write_once-for-emin-elow-when-parent-is-the-root.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: mm/page_counter: use WRITE_ONCE() for emin/elow when parent is the root
Date: Wed, 21 Oct 2026 13:48:18 -0700

page_counter_calculate_protection() runs without locks.  Several
reclaimers can update the same counter's emin and elow at the same time,
and readers such as mem_cgroup_below_min(), mem_cgroup_protection() and
the dmem eviction code load them with READ_ONCE().

Commit b3a7822e5e75 ("mm, memcg: prevent mem_cgroup_protected store
tearing") made the main path store emin and elow with WRITE_ONCE(), but it
missed the early return for a counter whose parent is the reclaim root. 
Those two stores are the only plain accesses to emin and elow left.

With CONFIG_KCSAN_STRICT=y, a few tasks writing to the same cgroup's
memory.reclaim trigger reports like this within seconds:

  BUG: KCSAN: data-race in page_counter_calculate_protection / shrink_node

  read (marked) to 0xff1f91b146d40e40 of 8 bytes by task 163 on cpu 4:
   shrink_node+0x57a/0x1210
   do_try_to_free_pages+0x194/0x930
   try_to_free_mem_cgroup_pages+0x204/0x3f0
   user_proactive_reclaim+0x28a/0x4d0
   memory_reclaim+0x35/0x50
   ...

  write to 0xff1f91b146d40e40 of 8 bytes by task 167 on cpu 6:
   page_counter_calculate_protection+0x1fa/0x360
   mem_cgroup_calculate_protection+0x4e/0x70
   shrink_node+0x53e/0x1210
   ...

The default KCSAN config does not report it, because it treats aligned
word-sized plain writes as atomic.

Use WRITE_ONCE() for these two stores as well.

There is no functional change.  Readers already accept stale values, and
compilers emit a single word-sized store either way: with GCC 14 the
x86-64 object code is the same before and after this change.

Link: https://lore.kernel.org/20261021204818.3431099-1-shakeel.butt@linux.dev
Fixes: b3a7822e5e75 ("mm, memcg: prevent mem_cgroup_protected store tearing")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Chris Down <chris@chrisdown.name>
---

 mm/page_counter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_counter.c~mm-page_counter-use-write_once-for-emin-elow-when-parent-is-the-root
+++ a/mm/page_counter.c
@@ -472,8 +472,8 @@ void page_counter_calculate_protection(s
 		return;
 
 	if (parent == root) {
-		counter->emin = READ_ONCE(counter->min);
-		counter->elow = READ_ONCE(counter->low);
+		WRITE_ONCE(counter->emin, READ_ONCE(counter->min));
+		WRITE_ONCE(counter->elow, READ_ONCE(counter->low));
 		return;
 	}
 
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-page_counter-use-write_once-for-emin-elow-when-parent-is-the-root.patch

