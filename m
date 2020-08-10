Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A18BCC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7757820723
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026895;
	bh=95Jht/JzFxBzWuFVS13z5nRJLCHcLbA3gbBya7VabcQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Rr08wsyGThkMX6Dksa4BHzlMJ8YMt90lXCAgMWNPv0b8CfxjknBPT3x9mgVhRUli6
	 Z4nReq8e+7jAcHQ41gzWR3Se246e9RjGQA/mh8Pk3UovBdKNHEnEl9hGlNrra2frXj
	 zGlp+PksKF1g1JwOaZP8L5xRF9DgL6zMuPJIHOiA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgHJCez (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:34:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCez (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:34:55 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D69820773;
        Mon, 10 Aug 2020 02:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026894;
        bh=95Jht/JzFxBzWuFVS13z5nRJLCHcLbA3gbBya7VabcQ=;
        h=Date:From:To:Subject:From;
        b=ytLBr7MDp27Hx83kyCC5IpbILBmMJKTHUlV/3YE7MpU9YkWQmFfJiSPPt2NWVRe+2
         LIQ2t7uIH+U7GHYY+3lGHaA9s/IdvKJsNW5o8WzCG0tLEkjeOywwhqCT/2iczDgTqx
         HHnW6OF6idqZ/+brrFH4ln00huY6okn/KWCMrq5I=
Date:   Sun, 09 Aug 2020 19:34:53 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, iamjoonsoo.kim@lge.com,
        jannh@google.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz, vjitta@codeaurora.org
Subject:  [merged]
 mm-slub-make-some-slub_debug-related-attributes-read-only.patch removed
 from -mm tree
Message-ID: <20200810023453.4f-e0BS5u%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: make some slub_debug related attributes read-only
has been removed from the -mm tree.  Its filename was
     mm-slub-make-some-slub_debug-related-attributes-read-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: make some slub_debug related attributes read-only

SLUB_DEBUG creates several files under /sys/kernel/slab/<cache>/ that can
be read to check if the respective debugging options are enabled for given
cache.  The options can be also toggled at runtime by writing into the
files.  Some of those, namely red_zone, poison, and store_user can be
toggled only when no objects yet exist in the cache.

Vijayanand reports [1] that there is a problem with freelist randomization
if changing the debugging option's state results in different number of
objects per page, and the random sequence cache needs thus needs to be
recomputed.

However, another problem is that the check for "no objects yet exist in
the cache" is racy, as noted by Jann [2] and fixing that would add
overhead or otherwise complicate the allocation/freeing paths.  Thus it
would be much simpler just to remove the runtime toggling support.  The
documentation describes it's "In case you forgot to enable debugging on
the kernel command line", but the neccessity of having no objects limits
its usefulness anyway for many caches.

Vijayanand describes an use case [3] where debugging is enabled for all
but zram caches for memory overhead reasons, and using the runtime toggles
was the only way to achieve such configuration.  After the previous patch
it's now possible to do that directly from the kernel boot option, so we
can remove the dangerous runtime toggles by making the /sys attribute
files read-only.

While updating it, also improve the documentation of the debugging /sys files.

[1] https://lkml.kernel.org/r/1580379523-32272-1-git-send-email-vjitta@codeaurora.org
[2] https://lore.kernel.org/r/CAG48ez31PP--h6_FzVyfJ4H86QYczAFPdxtJHUEEan+7VJETAQ@mail.gmail.com
[3] https://lore.kernel.org/r/1383cd32-1ddc-4dac-b5f8-9c42282fa81c@codeaurora.org

Link: http://lkml.kernel.org/r/20200610163135.17364-3-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Vijayanand Jitta <vjitta@codeaurora.org>
Reported-by: Jann Horn <jannh@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/slub.rst |   26 ++++++++++++--------
 mm/slub.c                 |   46 ++----------------------------------
 2 files changed, 19 insertions(+), 53 deletions(-)

--- a/Documentation/vm/slub.rst~mm-slub-make-some-slub_debug-related-attributes-read-only
+++ a/Documentation/vm/slub.rst
@@ -101,20 +101,26 @@ with "-" as options::
 
 	slub_debug=FZ;-,zs_handle,zspage
 
-In case you forgot to enable debugging on the kernel command line: It is
-possible to enable debugging manually when the kernel is up. Look at the
-contents of::
+The state of each debug option for a slab can be found in the respective files
+under::
 
 	/sys/kernel/slab/<slab name>/
 
-Look at the writable files. Writing 1 to them will enable the
-corresponding debug option. All options can be set on a slab that does
-not contain objects. If the slab already contains objects then sanity checks
-and tracing may only be enabled. The other options may cause the realignment
-of objects.
+If the file contains 1, the option is enabled, 0 means disabled. The debug
+options from the ``slub_debug`` parameter translate to the following files::
 
-Careful with tracing: It may spew out lots of information and never stop if
-used on the wrong slab.
+	F	sanity_checks
+	Z	red_zone
+	P	poison
+	U	store_user
+	T	trace
+	A	failslab
+
+The sanity_checks, trace and failslab files are writable, so writing 1 or 0
+will enable or disable the option at runtime. The writes to trace and failslab
+may return -EINVAL if the cache is subject to slab merging. Careful with
+tracing: It may spew out lots of information and never stop if used on the
+wrong slab.
 
 Slab merging
 ============
--- a/mm/slub.c~mm-slub-make-some-slub_debug-related-attributes-read-only
+++ a/mm/slub.c
@@ -5335,61 +5335,21 @@ static ssize_t red_zone_show(struct kmem
 	return sprintf(buf, "%d\n", !!(s->flags & SLAB_RED_ZONE));
 }
 
-static ssize_t red_zone_store(struct kmem_cache *s,
-				const char *buf, size_t length)
-{
-	if (any_slab_objects(s))
-		return -EBUSY;
-
-	s->flags &= ~SLAB_RED_ZONE;
-	if (buf[0] == '1') {
-		s->flags |= SLAB_RED_ZONE;
-	}
-	calculate_sizes(s, -1);
-	return length;
-}
-SLAB_ATTR(red_zone);
+SLAB_ATTR_RO(red_zone);
 
 static ssize_t poison_show(struct kmem_cache *s, char *buf)
 {
 	return sprintf(buf, "%d\n", !!(s->flags & SLAB_POISON));
 }
 
-static ssize_t poison_store(struct kmem_cache *s,
-				const char *buf, size_t length)
-{
-	if (any_slab_objects(s))
-		return -EBUSY;
-
-	s->flags &= ~SLAB_POISON;
-	if (buf[0] == '1') {
-		s->flags |= SLAB_POISON;
-	}
-	calculate_sizes(s, -1);
-	return length;
-}
-SLAB_ATTR(poison);
+SLAB_ATTR_RO(poison);
 
 static ssize_t store_user_show(struct kmem_cache *s, char *buf)
 {
 	return sprintf(buf, "%d\n", !!(s->flags & SLAB_STORE_USER));
 }
 
-static ssize_t store_user_store(struct kmem_cache *s,
-				const char *buf, size_t length)
-{
-	if (any_slab_objects(s))
-		return -EBUSY;
-
-	s->flags &= ~SLAB_STORE_USER;
-	if (buf[0] == '1') {
-		s->flags &= ~__CMPXCHG_DOUBLE;
-		s->flags |= SLAB_STORE_USER;
-	}
-	calculate_sizes(s, -1);
-	return length;
-}
-SLAB_ATTR(store_user);
+SLAB_ATTR_RO(store_user);
 
 static ssize_t validate_show(struct kmem_cache *s, char *buf)
 {
_

Patches currently in -mm which might be from vbabka@suse.cz are


