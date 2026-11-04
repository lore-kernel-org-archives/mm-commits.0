Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793833813;
	b=HcOrNl3TXV0oMbPEZN9zNAhvDSW8ftB2oTJ5J0ku77TA02bypqnZTkeJ9byiz8fDtKiA
	 PeHOOvgz+5twaKMTw/NM6MRqXHg5ieRbkUi2LtrojBiRdq8XKZVUEU8K4a4x/BYB+8/f7
	 Uu6w4ETDtYwcsoAqYYtWdjEo1wmXo6EyuTJktJmevFY/81NIxfK2cH7eM8AYA6Vwk5mIT
	 2mPyumM6BqjlGokMsfE53G8+K7x/Gx8M7H8Hy4WzV8PTOoNyX6MF501oixJ6UEi/rdKk8
	 QryZO4CdFIi3C48clKegjJC+oSnO6RJSw1/XgnP62tZ1R4gGbeeM48XsAgTDsLiu/TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793833813;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=2uGCNdPT9dEJ62eROeO4s4jQqgZyi/3svCZ3YKRDc4c=;
	b=1Zwh50a+xZ7QLOKj650VvAu556uj/tv1q1lm0uaEC5otwAV95WmByDTYGi5/wpwaLFY8
	 NZ3Bq35/2dqbYBU7k7Df8uFwjF4OXsbkGaEuTUBIVsCd74ezHpnasny4/W1VBaupfjUhe
	 TaznT88F5rsT1E0bclVv0ymM6pL5pDpvnN6NwoDbiJ8KvSuZuy3F5r3hJsYUeu/q96GQJ
	 RSy2MtXoUl/jG8ld5IVuhah3WDs7y1Dzaidt0IaJ7I7/07zb3tKpzI/OG01q6LZkpe5vb
	 vOmp5nw7GwSpMxJUH0BF6Ea3WPi2QNF+vhqOG73PvApcW5w7+DSPmMmhv1mdT1RqmqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="qjfaWi/8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E308606A31B
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 23:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qjfaWi/8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B5A1F000C1;
	Wed,  4 Nov 2026 23:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793833812;
	bh=2uGCNdPT9dEJ62eROeO4s4jQqgZyi/3svCZ3YKRDc4c=;
	h=Date:To:From:Subject;
	b=qjfaWi/86MM58oS1bJQ68Ou1VCezdMkmY8T8+XUputmftvIr2wd2vMDvgF05A3BLj
	 vVg50kTI5UsQUPNEx3AJ2HGgEb8TPuUiayqGLeqbPEx5a3di6F3Ncas3uKIZ6Sz4i1
	 Tikjdhlg3SnrT3qUSlrZ9fs5tL9whOIknqgglnF8=
Date: Wed, 04 Nov 2026 15:10:11 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,hao.ge@linux.dev,
	akpm@linux-foundation.org,abhishekbapat@google.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-add-a-flags-field-to-allocinfo_filter.patch added to mm-new branch
Message-Id: <20261104231012.38B5A1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: alloc_tag: add a flags field to allocinfo_filter
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-add-a-flags-field-to-allocinfo_filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-add-a-flags-field-to-allocinfo_filter.patch

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
From: Abhishek Bapat <abhishekbapat@google.com>
Subject: alloc_tag: add a flags field to allocinfo_filter
Date: Wed, 04 Nov 2026 19:03:38 +0000

struct allocinfo_filter uses a whole __u64 to hold the single boolean
used by the accuracy filter. Adding another boolean criterion the same
way would grow struct allocinfo_get_at, which changes the
ALLOCINFO_IOC_GET_AT ioctl number and breaks the UAPI.

Add a `flags` field that shares storage with `inaccurate` through an
anonymous union, and use bit 0, ALLOCINFO_FILTER_FLAG_INACCURATE, for
the accuracy criterion. New boolean criteria can take the remaining
bits without changing the struct layout.

Keeping `inaccurate` in the union means userspace built against the
older API still compiles, and the values 0 and 1 keep their meaning.
Previously any non-zero value selected inaccurate tags; now only bit 0
is checked, so a value such as 2 selects accurate tags instead.

Link: https://lore.kernel.org/64ce5ba6eedf0950c22d1416b794e83afbab8ea8.1793818636.git.abhishekbapat@google.com
Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Hao Ge <hao.ge@linux.dev>
---

 include/uapi/linux/alloc_tag.h |   16 ++++++++++++++--
 mm/alloc_tag.c                 |    2 +-
 2 files changed, 15 insertions(+), 3 deletions(-)

--- a/include/uapi/linux/alloc_tag.h~alloc_tag-add-a-flags-field-to-allocinfo_filter
+++ a/include/uapi/linux/alloc_tag.h
@@ -68,13 +68,25 @@ enum {
 #define ALLOCINFO_FILTER_MASKS \
 	((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
 
+#define ALLOCINFO_FILTER_FLAG_INACCURATE	(1ULL << 0)
+
 struct allocinfo_filter {
 	__u64 mask; /* bitmask of the filter fields used */
 	struct allocinfo_tag fields;
 	__u64 min_size;
 	__u64 max_size;
-	/* filter criteria only; see allocinfo_counter.accurate for actual accuracy */
-	__u64 inaccurate;
+	/*
+	 * Filter criteria only; see allocinfo_counter for the actual state.
+	 * Set ALLOCINFO_FILTER_FLAG_* bits in flags for the criteria selected
+	 * in mask. inaccurate is kept as an alias of flags so that userspace
+	 * built against the older API still compiles. Note that only
+	 * ALLOCINFO_FILTER_FLAG_INACCURATE is checked, so a non-zero value
+	 * with bit 0 clear no longer selects inaccurate tags.
+	 */
+	union {
+		__u64 inaccurate;
+		__u64 flags;
+	};
 };
 
 struct allocinfo_get_at {
--- a/mm/alloc_tag.c~alloc_tag-add-a-flags-field-to-allocinfo_filter
+++ a/mm/alloc_tag.c
@@ -306,7 +306,7 @@ static bool matches_filter(struct codeta
 
 	if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
 		inaccurate = alloc_tag_is_inaccurate(ct_to_alloc_tag(ct));
-		if (inaccurate != !!(filter->inaccurate))
+		if (inaccurate != !!(filter->flags & ALLOCINFO_FILTER_FLAG_INACCURATE))
 			return false;
 	}
 
_

Patches currently in -mm which might be from abhishekbapat@google.com are

alloc_tag-add-trace-events-for-tracing-allocations.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints.patch
alloc_tag-add-a-flags-field-to-allocinfo_filter.patch
alloc_tag-extend-allocinfo_filter-to-support-tracing-queries.patch
alloc_tag-add-a-test-for-trace-state-toggle-and-filtering.patch

