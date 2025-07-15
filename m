Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B785367
	for <mm-commits@vger.kernel.org>; Tue, 15 Jul 2025 00:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752540141; cv=none; b=Ua2IleI/Z5sKvBRrF7NKkkTVRENrUzSlCj2c+t4PPPKZecZXEf83zdWuLN3bUbV2Sp5iBWP8crsLYfiLxZFC/u/vsrR8lczgYYT6av9EzhyB7AmFaGdtr6engO+qe082RDZTWiYwgliKHRjjZdsJ5QAfqeBGuwnh7J67y9vkmmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752540141; c=relaxed/simple;
	bh=RSnqKTS2ONf6K5qIY8wdRhcLqrSfaT2Znf1fbDw6Y9Y=;
	h=Date:To:From:Subject:Message-Id; b=vEMj8y0F7+1imILTWO9/bmCPKjzCWNSQ/ipVYGSEr1HCZOr/oFZ989tMu1mI2i/M0Nhqs/pIF8O05Ej91qX7hrYLli1b3we0/UcD1/sZD87OVU7mcTxBo5X79W+k9vySWvybUis4aMZzuogn4OoJSBh/130QcnM3IzqjK1V6K/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xKblz5YZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xKblz5YZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27C9C4CEED;
	Tue, 15 Jul 2025 00:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752540141;
	bh=RSnqKTS2ONf6K5qIY8wdRhcLqrSfaT2Znf1fbDw6Y9Y=;
	h=Date:To:From:Subject:From;
	b=xKblz5YZyBFMVvLgCj7ljncaK+aRIHsKyAePT6XdBEznaWKc505Q9gYklFgF1czcO
	 h4biBlxPr0mcV7nd9hRgTgMzGhn0QevwWGByO6u0BBfkHJzzo9/q7ZrgDDP7As0qb2
	 weMgO/oWXxZJDA3QexOuXW7en7hWfJLqy8MOf2mg=
Date: Mon, 14 Jul 2025 17:42:20 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,linux@treblig.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-xxhash-comment-out-unused-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20250715004220.F27C9C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/xxhash: comment out unused functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-xxhash-comment-out-unused-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-xxhash-comment-out-unused-functions.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Dr. David Alan Gilbert" <linux@treblig.org>
Subject: lib/xxhash: comment out unused functions
Date: Mon, 14 Jul 2025 01:09:27 +0100

xxh32_digest() and xxh32_update() were added in 2017 in the original
xxhash commit, but have remained unused.

While I've mostly been deleting unused functions, this is a general
library and I see erofs is using other bits of xxh32, so it didn't seem
right just to delete them.

Comment them out with #if 0.
(Which checkpatch rightly warns about)

Link: https://lkml.kernel.org/r/20250714000927.294767-1-linux@treblig.org
Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/xxhash.h |    4 ++++
 lib/xxhash.c           |    2 ++
 2 files changed, 6 insertions(+)

--- a/include/linux/xxhash.h~lib-xxhash-comment-out-unused-functions
+++ a/include/linux/xxhash.h
@@ -177,6 +177,9 @@ struct xxh64_state {
  */
 void xxh32_reset(struct xxh32_state *state, uint32_t seed);
 
+#if 0
+/* Currently unused, feel free to uncomment them if you use them. */
+
 /**
  * xxh32_update() - hash the data given and update the xxh32 state
  *
@@ -202,6 +205,7 @@ int xxh32_update(struct xxh32_state *sta
  * Return: The xxh32 hash stored in the state.
  */
 uint32_t xxh32_digest(const struct xxh32_state *state);
+#endif
 
 /**
  * xxh64_reset() - reset the xxh64 state to start a new hashing operation
--- a/lib/xxhash.c~lib-xxhash-comment-out-unused-functions
+++ a/lib/xxhash.c
@@ -267,6 +267,7 @@ void xxh64_reset(struct xxh64_state *sta
 }
 EXPORT_SYMBOL(xxh64_reset);
 
+#if 0
 int xxh32_update(struct xxh32_state *state, const void *input, const size_t len)
 {
 	const uint8_t *p = (const uint8_t *)input;
@@ -373,6 +374,7 @@ uint32_t xxh32_digest(const struct xxh32
 	return h32;
 }
 EXPORT_SYMBOL(xxh32_digest);
+#endif
 
 int xxh64_update(struct xxh64_state *state, const void *input, const size_t len)
 {
_

Patches currently in -mm which might be from linux@treblig.org are

lib-xxhash-comment-out-unused-functions.patch

