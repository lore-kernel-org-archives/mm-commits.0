Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778503F44E7
	for <mm-commits@vger.kernel.org>; Wed,  8 Jul 2026 21:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783545257; cv=none; b=m3EgiqUFe91eOQu0lr3mi8kdGg+OK/ar5etEICJx/6/RzKpf+vonB4s5lkatY+aB/VJ8AAMrAABsvqxKEMfbbOznrtS9tQXEm9moYsNRaxbKB+4gfvC6EGx3eMihskvuqAja7g2uIZPdQbnipSMZheKZrkc/dlkAHGGMpmYfZVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783545257; c=relaxed/simple;
	bh=IYnsjIKj9DRZVYGi42bl8nUFaX3So1RdfGtQ6gWeFhY=;
	h=Date:To:From:Subject:Message-Id; b=IWfyblPdXOMtVqbPq2N6TQwF3vKzU/Q0Wn+IZ+YU9Y9ZXrsCUJlaApv/QKz0fVgoWm4riAW2aTe9DNfX0TcvxKBbhuXP4ZPY7cvtjXm88ylqGJe/qiaHMpfR6dzGjj7K1SqwzsAift4QRBmokSG+hwbk3AIiY15AuwMLmLzb1vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2qltRxTR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2qltRxTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75FFC1F000E9;
	Wed,  8 Jul 2026 21:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783545253;
	bh=qUFnftqnslwq5aeibY45pZSFbOESxNQvq7D2I6UiGJI=;
	h=Date:To:From:Subject;
	b=2qltRxTRl46f+1jFDppE3wfSP1iD+tX3SsBsOUMDGQkqjxXRVg9qyB0/HVdsrhQvf
	 ISFKdH2FvQO+8F728fONWtd8bMwlDZkLUAANUI1q4xraoM7uSe7rYBwbLh/D/5NqQT
	 cTSEU/+3hgZuX+q8oecpQ9kP9yUSMTu9h6aXWJlQ=
Date: Wed, 08 Jul 2026 14:14:13 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,souravpanda@google.com,kent.overstreet@linux.dev,hao.ge@linux.dev,corbet@lwn.net,abhishekbapat@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-add-accuracy-based-filtering-to-ioctl.patch added to mm-new branch
Message-Id: <20260708211413.75FFC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: add accuracy based filtering to ioctl
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-add-accuracy-based-filtering-to-ioctl.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-add-accuracy-based-filtering-to-ioctl.patch

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
Subject: alloc_tag: add accuracy based filtering to ioctl
Date: Wed, 8 Jul 2026 18:01:26 +0000

Extend the allocinfo filtering mechanism to allow users to filter tags
based on their accuracy.

Link: https://lore.kernel.org/396a5e4bc3b2990223ab355f2cd3ceb6aa15499e.1783532853.git.abhishekbapat@google.com
Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
Acked-by: Hao Ge <hao.ge@linux.dev>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/alloc_tag.h |    4 ++++
 mm/alloc_tag.c                 |    8 ++++++++
 2 files changed, 12 insertions(+)

--- a/include/uapi/linux/alloc_tag.h~alloc_tag-add-accuracy-based-filtering-to-ioctl
+++ a/include/uapi/linux/alloc_tag.h
@@ -31,6 +31,8 @@ struct allocinfo_tag {
 	char function[ALLOCINFO_STR_SIZE];
 	char filename[ALLOCINFO_STR_SIZE];
 	__u64 lineno;
+	/* filter criteria only; see allocinfo_counter.accurate for actual accuracy */
+	__u64 inaccurate;
 };
 
 /* The alignment ensures 32-bit compatible interfaces are not broken */
@@ -50,6 +52,7 @@ enum {
 	ALLOCINFO_FILTER_FUNCTION,
 	ALLOCINFO_FILTER_FILENAME,
 	ALLOCINFO_FILTER_LINENO,
+	ALLOCINFO_FILTER_INACCURATE,
 	ALLOCINFO_FILTER_MIN_SIZE,
 	ALLOCINFO_FILTER_MAX_SIZE,
 	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_MAX_SIZE
@@ -59,6 +62,7 @@ enum {
 #define ALLOCINFO_FILTER_MASK_FUNCTION		(1 << ALLOCINFO_FILTER_FUNCTION)
 #define ALLOCINFO_FILTER_MASK_FILENAME		(1 << ALLOCINFO_FILTER_FILENAME)
 #define ALLOCINFO_FILTER_MASK_LINENO		(1 << ALLOCINFO_FILTER_LINENO)
+#define ALLOCINFO_FILTER_MASK_INACCURATE	(1 << ALLOCINFO_FILTER_INACCURATE)
 #define ALLOCINFO_FILTER_MASK_MIN_SIZE		(1 << ALLOCINFO_FILTER_MIN_SIZE)
 #define ALLOCINFO_FILTER_MASK_MAX_SIZE		(1 << ALLOCINFO_FILTER_MAX_SIZE)
 
--- a/mm/alloc_tag.c~alloc_tag-add-accuracy-based-filtering-to-ioctl
+++ a/mm/alloc_tag.c
@@ -252,6 +252,8 @@ static bool matches_filter(struct codeta
 			   struct alloc_tag_counters *counters,
 			   bool *fetched_counters)
 {
+	bool inaccurate;
+
 	if (!filter || !filter->mask)
 		return true;
 
@@ -277,6 +279,12 @@ static bool matches_filter(struct codeta
 	    ct->lineno != filter->fields.lineno)
 		return false;
 
+	if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
+		inaccurate = !!(ct->flags & CODETAG_FLAG_INACCURATE);
+		if (inaccurate != !!(filter->fields.inaccurate))
+			return false;
+	}
+
 	if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
 		if (!*fetched_counters) {
 			*counters = allocinfo_prefetch_counters(ct);
_

Patches currently in -mm which might be from abhishekbapat@google.com are

alloc_tag-add-ioctl-filters-to-proc-allocinfo.patch
alloc_tag-add-size-based-filtering-to-ioctl.patch
alloc_tag-add-accuracy-based-filtering-to-ioctl.patch
kselftest-alloc_tag-add-kselftest-for-ioctl-interface.patch
kselftest-alloc_tag-extend-the-allocinfo-ioctl-kselftest.patch

