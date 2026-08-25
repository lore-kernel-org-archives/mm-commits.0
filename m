Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B07136167E
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622885; cv=none; b=g+bwyS1i9H0QT41v4i5cOz8Uk/R+hjr/5jYUv0FVxMh3xz/PASxt53PfmPEZqSNQspxohz3JHERRfK5T6eI6mo0cOPb5ybE4Hq/qsHSE2TWTPDLkt4N9MIPtbbcSnxuqJNNkDavXExvLGVnXwl1tVIw9VvgTT4D+O2AoiLVzl0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622885; c=relaxed/simple;
	bh=4j3/C4VIBS2CzdHnTAORsQU6VZ2QGM8IWaz/wyYXKqY=;
	h=Date:To:From:Subject:Message-Id; b=p7yCko1/sf1rydU11/GH6qWxadBKpOuFqfWqhZkFb/Xkb30arV3KCgAkL6DA9OrNFRV5+Y6tWFjgx5nn6a0VFaDgOTPv8BDBiQ5hjQC1Vd0I1y9+hmyZQ1/65xk4aTQy25lH0gNCm8g0xPedI/U2xFYFoXdPMauvStHlV2O3wiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gSvDzUH/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gSvDzUH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FDB1F00A3A;
	Tue, 25 Aug 2026 01:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622882;
	bh=STDCJkYV0rzri5E+bbxRmbW0G8ZOsDyKL0NJ1uhjkAI=;
	h=Date:To:From:Subject;
	b=gSvDzUH/lLUXmlrSi6w+9SbN2u9D+PHtJzDhHE1YTP89Udw+TaPEd+Z9OGZWMkNes
	 LkRxUAxRNRJNUGwVimMf0xlfWXuD+4Ec8UezFzsNwrLxIzWlpbI8GhdojepHJp5PM5
	 Bl5CNzl1wK7eTzp6u69wqxp0MUiVSE5gje9Udlq0=
Date: Mon, 24 Aug 2026 18:54:41 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,souravpanda@google.com,kent.overstreet@linux.dev,hao.ge@linux.dev,corbet@lwn.net,abhishekbapat@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alloc_tag-add-accuracy-based-filtering-to-ioctl.patch removed from -mm tree
Message-Id: <20260825015442.33FDB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: add accuracy based filtering to ioctl
has been removed from the -mm tree.  Its filename was
     alloc_tag-add-accuracy-based-filtering-to-ioctl.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Abhishek Bapat <abhishekbapat@google.com>
Subject: alloc_tag: add accuracy based filtering to ioctl
Date: Wed, 8 Jul 2026 18:01:26 +0000

Extend the allocinfo filtering mechanism to allow users to filter tags
based on their accuracy.

[abhishekbapat@google.com: move `inaccurate` filtering criteria from `struct allocinfo_tag` to `struct allocinfo_filter`]
  Link: https://lore.kernel.org/e4e49ec4a5960292aeeb9e196526c18dc95228a2.1785867739.git.abhishekbapat@google.com
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
@@ -50,6 +50,7 @@ enum {
 	ALLOCINFO_FILTER_FUNCTION,
 	ALLOCINFO_FILTER_FILENAME,
 	ALLOCINFO_FILTER_LINENO,
+	ALLOCINFO_FILTER_INACCURATE,
 	ALLOCINFO_FILTER_MIN_SIZE,
 	ALLOCINFO_FILTER_MAX_SIZE,
 	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_MAX_SIZE
@@ -59,6 +60,7 @@ enum {
 #define ALLOCINFO_FILTER_MASK_FUNCTION		(1 << ALLOCINFO_FILTER_FUNCTION)
 #define ALLOCINFO_FILTER_MASK_FILENAME		(1 << ALLOCINFO_FILTER_FILENAME)
 #define ALLOCINFO_FILTER_MASK_LINENO		(1 << ALLOCINFO_FILTER_LINENO)
+#define ALLOCINFO_FILTER_MASK_INACCURATE	(1 << ALLOCINFO_FILTER_INACCURATE)
 #define ALLOCINFO_FILTER_MASK_MIN_SIZE		(1 << ALLOCINFO_FILTER_MIN_SIZE)
 #define ALLOCINFO_FILTER_MASK_MAX_SIZE		(1 << ALLOCINFO_FILTER_MAX_SIZE)
 
@@ -70,6 +72,8 @@ struct allocinfo_filter {
 	struct allocinfo_tag fields;
 	__u64 min_size;
 	__u64 max_size;
+	/* filter criteria only; see allocinfo_counter.accurate for actual accuracy */
+	__u64 inaccurate;
 };
 
 struct allocinfo_get_at {
--- a/mm/alloc_tag.c~alloc_tag-add-accuracy-based-filtering-to-ioctl
+++ a/mm/alloc_tag.c
@@ -262,6 +262,8 @@ static bool matches_filter(struct codeta
 			   struct alloc_tag_counters *counters,
 			   bool *fetched_counters)
 {
+	bool inaccurate;
+
 	if (!filter || !filter->mask)
 		return true;
 
@@ -287,6 +289,12 @@ static bool matches_filter(struct codeta
 	    ct->lineno != filter->fields.lineno)
 		return false;
 
+	if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
+		inaccurate = !!(ct->flags & CODETAG_FLAG_INACCURATE);
+		if (inaccurate != !!(filter->inaccurate))
+			return false;
+	}
+
 	if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
 		if (!*fetched_counters) {
 			*counters = allocinfo_prefetch_counters(ct);
_

Patches currently in -mm which might be from abhishekbapat@google.com are


