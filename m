Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793833815;
	b=u2LSp5z/5LZSrMG2R30FtrvlSJ1V8hKvm82SmJMhmxmdaL2KPjtoIrmnlNohl+/wW9XA
	 0CR3qhpVF3MQvnYR4lqBFpUs062otfqOwe8LYj52DXHxbFnLluliQDIcmNBINjjOTV65I
	 KWJApMoVUZkAROOSXYi4kH7c2F0T1yzOY3zR8UDlp/Uj2ZqRKKE8trONSpxI1qP27JqeQ
	 yqQ65+Y2uLykTxW2tWZNtxjyBmXD8+N3ElXFSYid+t9/xAxldvW5CKaoeJn8aMxK3AfPI
	 5zOb7LSij2rHans4Q+DymGJ52ivh4oeUIZItUsyyNYtKRmZW8Ml8mV2DgpVPijMlCrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793833815;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=7q3WB05zn8X+IG2o8XapS8+YWEEKKa9sTaWxYpR02iA=;
	b=D1dierOvtLbxP0UkFJqCFoWqLEQiSGHRc3nLv8sxSXNQq9+t3BxVPOWhBGDhsZoIHCef
	 EhIqs2qTJ/oOffCANCAiCO73IGKo0JZU+KBINthMeGK05IIURS6XnX3fmZaeRLdCiHZJz
	 Aj5KG/LNQndKyLxiUQQWjfK4Ok6HWSWyIDgoxhaFAObP45kiiIsZmR07qB5hfeIbrdLyj
	 TtNvTn8K2VMXLvv4NKlckjInXZuhmsN35u4KRl5Q5JyGZ1Pgskr3uhQKHV6owTQxg4JHy
	 PyzOPmsNtOTMj1teLJO1ngxylrqI+4MWPEA6458K1oalLXHH2pMBuZxRZEdt/AljxBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tkUxu6k3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B853606A31B
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 23:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tkUxu6k3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A741F000C1;
	Wed,  4 Nov 2026 23:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793833814;
	bh=7q3WB05zn8X+IG2o8XapS8+YWEEKKa9sTaWxYpR02iA=;
	h=Date:To:From:Subject;
	b=tkUxu6k36Czk9gbG3aZr/cIIWX+Oywaw8h59YRvM3klIqC4WsdsTgQ5cvHWFhtw8o
	 cEB3Hcjy6g5A4iJ4QGIkXRYb5+nrtx5khSqq5z40kZHBU4KBXtWzPYlFr8VIYRdUGz
	 f+nuU1Yf2OD8UufJWYBky4AFYIZ4hF81M7x6K3B4=
Date: Wed, 04 Nov 2026 15:10:14 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,hao.ge@linux.dev,
	akpm@linux-foundation.org,abhishekbapat@google.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-extend-allocinfo_filter-to-support-tracing-queries.patch added to mm-new branch
Message-Id: <20261104231014.96A741F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: alloc_tag: extend allocinfo_filter to support tracing queries
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-extend-allocinfo_filter-to-support-tracing-queries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-extend-allocinfo_filter-to-support-tracing-queries.patch

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
Subject: alloc_tag: extend allocinfo_filter to support tracing queries
Date: Wed, 04 Nov 2026 19:03:39 +0000

Extend the allocinfo filtering mechanism to allow users to filter tags
based on their trace state.

Link: https://lore.kernel.org/1cb54b7e6ffe2e7a0890815c3072d8a3819b48d9.1793818636.git.abhishekbapat@google.com
Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Hao Ge <hao.ge@linux.dev>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/alloc_tag.h |    8 ++++++--
 mm/alloc_tag.c                 |    8 ++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/include/uapi/linux/alloc_tag.h~alloc_tag-extend-allocinfo_filter-to-support-tracing-queries
+++ a/include/uapi/linux/alloc_tag.h
@@ -38,7 +38,8 @@ struct allocinfo_counter {
 	__u64 bytes;
 	__u64 calls;
 	__u8 accurate;
-	__u8 pad[7];
+	__u8 trace_on;
+	__u8 pad[6];
 } __attribute__((aligned(8)));
 
 struct allocinfo_tag_data {
@@ -54,7 +55,8 @@ enum {
 	ALLOCINFO_FILTER_INACCURATE,
 	ALLOCINFO_FILTER_MIN_SIZE,
 	ALLOCINFO_FILTER_MAX_SIZE,
-	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_MAX_SIZE
+	ALLOCINFO_FILTER_TRACE_ON,
+	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_TRACE_ON
 };
 
 #define ALLOCINFO_FILTER_MASK_MODNAME		(1 << ALLOCINFO_FILTER_MODNAME)
@@ -64,11 +66,13 @@ enum {
 #define ALLOCINFO_FILTER_MASK_INACCURATE	(1 << ALLOCINFO_FILTER_INACCURATE)
 #define ALLOCINFO_FILTER_MASK_MIN_SIZE		(1 << ALLOCINFO_FILTER_MIN_SIZE)
 #define ALLOCINFO_FILTER_MASK_MAX_SIZE		(1 << ALLOCINFO_FILTER_MAX_SIZE)
+#define ALLOCINFO_FILTER_MASK_TRACE_ON		(1 << ALLOCINFO_FILTER_TRACE_ON)
 
 #define ALLOCINFO_FILTER_MASKS \
 	((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
 
 #define ALLOCINFO_FILTER_FLAG_INACCURATE	(1ULL << 0)
+#define ALLOCINFO_FILTER_FLAG_TRACE_ON		(1ULL << 1)
 
 struct allocinfo_filter {
 	__u64 mask; /* bitmask of the filter fields used */
--- a/mm/alloc_tag.c~alloc_tag-extend-allocinfo_filter-to-support-tracing-queries
+++ a/mm/alloc_tag.c
@@ -250,6 +250,7 @@ static void allocinfo_to_params(struct c
 	data->counter.bytes = counters->bytes;
 	data->counter.calls = counters->calls;
 	data->counter.accurate = !alloc_tag_is_inaccurate(ct_to_alloc_tag(ct));
+	data->counter.trace_on = alloc_tag_is_traced(ct_to_alloc_tag(ct));
 }
 
 /*
@@ -323,6 +324,13 @@ static bool matches_filter(struct codeta
 			return false;
 	}
 
+	if (filter->mask & ALLOCINFO_FILTER_MASK_TRACE_ON) {
+		bool tracing = alloc_tag_is_traced(ct_to_alloc_tag(ct));
+
+		if (tracing != !!(filter->flags & ALLOCINFO_FILTER_FLAG_TRACE_ON))
+			return false;
+	}
+
 	return true;
 }
 
_

Patches currently in -mm which might be from abhishekbapat@google.com are

alloc_tag-add-trace-events-for-tracing-allocations.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints.patch
alloc_tag-add-a-flags-field-to-allocinfo_filter.patch
alloc_tag-extend-allocinfo_filter-to-support-tracing-queries.patch
alloc_tag-add-a-test-for-trace-state-toggle-and-filtering.patch

