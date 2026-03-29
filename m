Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8025821B905
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744824; cv=none; b=jmQW7BVHG+O8rfmW06XkGM/Q+Hg90+Ugq3gG6K7XnpWpredFvAHBaHfj00Y8zJXF8PhvFGlo7Sp+2vtFfm+UIjSMLGq3kQvK8/q8gk1mqpdY60RdhRSuedYAfJfeQCXsKprXDw4WLq06Qf7F1ZeiOkk6o3iEuyIQC473SvLALGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744824; c=relaxed/simple;
	bh=28kDLs1KMdQztdbub5v5M1LqAjo7EE33aRKHJk6z2Fk=;
	h=Date:To:From:Subject:Message-Id; b=nYp6nlmLGuidriO9Cb+XFoFJ6zPC6x3tsKIEDavFDejAFwu8rK76v8cpvgn5+pdp8SLlRYCT+TgNeErcTDUO/eksn9p/VlmQ4NFEw7zSBDohd76eedNgRF8IAQd/nw1S+mL/1SjnSzPAP87fQaUmI5OL8zqhhjs+WCr8MjxwMh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AZqmOZzi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AZqmOZzi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59064C4CEF7;
	Sun, 29 Mar 2026 00:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744824;
	bh=28kDLs1KMdQztdbub5v5M1LqAjo7EE33aRKHJk6z2Fk=;
	h=Date:To:From:Subject:From;
	b=AZqmOZziXholvdtuP1VDr58vNDds1f5tuYsFLOI5G31+ezvhB+CqpylCFK7SHalnO
	 8hTtjo6tFjWlONbj3Wu40H03m9hgDicd8duTNnRhtQp6LiPU1jlZ+ExPPYns722wYL
	 lpWKaBs0/WuA5zF2Rk4rUoBBYIJSRfVGlDJ6yeDU=
Date: Sat, 28 Mar 2026 17:40:23 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-add-damon_split_region_at-debug_sanity-check.patch removed from -mm tree
Message-Id: <20260329004024.59064C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: add damon_split_region_at() debug_sanity check
has been removed from the -mm tree.  Its filename was
     mm-damon-core-add-damon_split_region_at-debug_sanity-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: add damon_split_region_at() debug_sanity check
Date: Fri, 6 Mar 2026 07:29:10 -0800

damon_split_region_at() should be called with the correct address to split
on.  Add a sanity check for that under CONFIG_DAMON_DEBUG_SANITY.

Link: https://lkml.kernel.org/r/20260306152914.86303-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-add-damon_split_region_at-debug_sanity-check
+++ a/mm/damon/core.c
@@ -2588,6 +2588,21 @@ static void kdamond_merge_regions(struct
 			threshold / 2 < max_thres);
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_split_region_at(struct damon_region *r,
+		unsigned long sz_r)
+{
+	WARN_ONCE(sz_r == 0 || sz_r >= damon_sz_region(r),
+			"sz_r: %lu r: %lu-%lu (%lu)\n",
+			sz_r, r->ar.start, r->ar.end, damon_sz_region(r));
+}
+#else
+static void damon_verify_split_region_at(struct damon_region *r,
+		unsigned long sz_r)
+{
+}
+#endif
+
 /*
  * Split a region in two
  *
@@ -2599,6 +2614,7 @@ static void damon_split_region_at(struct
 {
 	struct damon_region *new;
 
+	damon_verify_split_region_at(r, sz_r);
 	new = damon_new_region(r->ar.start + sz_r, r->ar.end);
 	if (!new)
 		return;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

