Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0398F47
	for <mm-commits@vger.kernel.org>; Fri,  2 Aug 2024 00:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722556988; cv=none; b=oELdt41pPxQp/viFPyvu9349JqcZgXOnRK3kG07nYnjyrNeGdMMKlS1VwvUwskDK+BDqUNllIpZW0Qd49gUtdcjy2nbDikpM07iKYdGTg8R6tdl6wATWLnIPIA+9JlZjY7Jj4ZP3eDGsr+LuUVLBe/z2EaRpF9mJ4lzx+/PVbXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722556988; c=relaxed/simple;
	bh=F9oEXkiNwh3lqz3Icn4qeRSKte9/UkpXuGkH4RHTnxM=;
	h=Date:To:From:Subject:Message-Id; b=X0RNzB/LqMNmsBZl9pnQdVDXgjDwEPn6jB0yAKPRAroApvbkJ3Gnt2yzl4jEY9lVTuTrfBZAlx5/uCQYUqUgODji4iqKPjusFvMz5boLBr/rhvtNbka54n5uqy+9UjY7Nw3LY9gYYE7P53GZvSH1Q9i8Aun6xm91S/AHKnA86OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qwtfnG5a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qwtfnG5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494FCC32786;
	Fri,  2 Aug 2024 00:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722556988;
	bh=F9oEXkiNwh3lqz3Icn4qeRSKte9/UkpXuGkH4RHTnxM=;
	h=Date:To:From:Subject:From;
	b=qwtfnG5aT/tCpcW24Y6IbQHqS5K5or303KWE6XEvvxfmB2ME+hLvHZGWavJ/2hJTp
	 GjZnohmk8gOe5lmoFCHZ599cm5c6xyhX80B0E9NLrhWuxbundyzN3B7QvRGU4Kk24I
	 8yuK9zVa12g9o/vvk1ylat75is08eTagSM+tUqJk=
Date: Thu, 01 Aug 2024 17:03:07 -0700
To: mm-commits@vger.kernel.org,kaiyang2@cs.cmu.edu,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + include-linux-mmzoneh-clean-up-watermark-accessors.patch added to mm-unstable branch
Message-Id: <20240802000308.494FCC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: include/linux/mmzone.h: clean up watermark accessors
has been added to the -mm mm-unstable branch.  Its filename is
     include-linux-mmzoneh-clean-up-watermark-accessors.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/include-linux-mmzoneh-clean-up-watermark-accessors.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/mmzone.h: clean up watermark accessors
Date: Thu Aug  1 04:50:05 PM PDT 2024

- we have a helper wmark_pages().  Teach min_wmark_pages(),
  low_wmark_pages(), high_wmark_pages() and promo_wmark_pages() to use
  it instead of open-coding its implementation.

- there's no reason to implement all these things as macros.  Redo them
  in C.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

--- a/include/linux/mmzone.h~include-linux-mmzoneh-clean-up-watermark-accessors
+++ a/include/linux/mmzone.h
@@ -668,12 +668,6 @@ enum zone_watermarks {
 #define NR_LOWORDER_PCP_LISTS (MIGRATE_PCPTYPES * (PAGE_ALLOC_COSTLY_ORDER + 1))
 #define NR_PCP_LISTS (NR_LOWORDER_PCP_LISTS + NR_PCP_THP)
 
-#define min_wmark_pages(z) (z->_watermark[WMARK_MIN] + z->watermark_boost)
-#define low_wmark_pages(z) (z->_watermark[WMARK_LOW] + z->watermark_boost)
-#define high_wmark_pages(z) (z->_watermark[WMARK_HIGH] + z->watermark_boost)
-#define promo_wmark_pages(z) (z->_watermark[WMARK_PROMO] + z->watermark_boost)
-#define wmark_pages(z, i) (z->_watermark[i] + z->watermark_boost)
-
 /*
  * Flags used in pcp->flags field.
  *
@@ -1019,6 +1013,32 @@ enum zone_flags {
 	ZONE_BELOW_HIGH,		/* zone is below high watermark. */
 };
 
+static inline unsigned long wmark_pages(const struct zone *z,
+					enum zone_watermarks w)
+{
+	return z->_watermark[w] + z->watermark_boost;
+}
+
+static inline unsigned long min_wmark_pages(const struct zone *z)
+{
+	return wmark_pages(z, WMARK_MIN);
+}
+
+static inline unsigned long low_wmark_pages(const struct zone *z)
+{
+	return wmark_pages(z, WMARK_LOW);
+}
+
+static inline unsigned long high_wmark_pages(const struct zone *z)
+{
+	return wmark_pages(z, WMARK_HIGH);
+}
+
+static inline unsigned long promo_wmark_pages(const struct zone *z)
+{
+	return wmark_pages(z, WMARK_PROMO);
+}
+
 static inline unsigned long zone_managed_pages(struct zone *zone)
 {
 	return (unsigned long)atomic_long_read(&zone->managed_pages);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-clean-up-watermark-accessors.patch

