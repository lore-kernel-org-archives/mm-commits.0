Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62FFEC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiJCVIa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiJCVG2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:06:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8D911815
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 031226118C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599CDC433B5;
        Mon,  3 Oct 2022 21:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831147;
        bh=0T1FhUFoOkgWUtasI3otyaWlLyqs8+mhZT9aJ/Jkcsw=;
        h=Date:To:From:Subject:From;
        b=OCfDA1RHgtBOKP8yQM7suiiJJkiy+OopjU4M+HQ233c11trd+KJJyugYHFZJDhn6W
         ZoWJSaPR360aqF8R2jZQNAZg5yimm3LmInZq+RTvFEEVcwZ6ddGi9xbJbiZRWF+huP
         9tdKQjW2Rww67RTUPkTptocO2cMQ/dMWT8qYCpDE=
Date:   Mon, 03 Oct 2022 14:05:46 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-check-kasan_no_free_meta-in-__kasan_metadata_size.patch removed from -mm tree
Message-Id: <20221003210547.599CDC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: check KASAN_NO_FREE_META in __kasan_metadata_size
has been removed from the -mm tree.  Its filename was
     kasan-check-kasan_no_free_meta-in-__kasan_metadata_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: check KASAN_NO_FREE_META in __kasan_metadata_size
Date: Mon, 5 Sep 2022 23:05:16 +0200

Patch series "kasan: switch tag-based modes to stack ring from per-object
metadata", v3.

This series makes the tag-based KASAN modes use a ring buffer for storing
stack depot handles for alloc/free stack traces for slab objects instead
of per-object metadata.  This ring buffer is referred to as the stack
ring.

On each alloc/free of a slab object, the tagged address of the object and
the current stack trace are recorded in the stack ring.

On each bug report, if the accessed address belongs to a slab object, the
stack ring is scanned for matching entries.  The newest entries are used
to print the alloc/free stack traces in the report: one entry for alloc
and one for free.

The advantages of this approach over storing stack trace handles in
per-object metadata with the tag-based KASAN modes:

- Allows to find relevant stack traces for use-after-free bugs without
  using quarantine for freed memory. (Currently, if the object was
  reallocated multiple times, the report contains the latest alloc/free
  stack traces, not necessarily the ones relevant to the buggy allocation.)
- Allows to better identify and mark use-after-free bugs, effectively
  making the CONFIG_KASAN_TAGS_IDENTIFY functionality always-on.
- Has fixed memory overhead.

The disadvantage:

- If the affected object was allocated/freed long before the bug happened
  and the stack trace events were purged from the stack ring, the report
  will have no stack traces.

Discussion
==========

The proposed implementation of the stack ring uses a single ring buffer
for the whole kernel.  This might lead to contention due to atomic
accesses to the ring buffer index on multicore systems.

At this point, it is unknown whether the performance impact from this
contention would be significant compared to the slowdown introduced by
collecting stack traces due to the planned changes to the latter part, see
the section below.

For now, the proposed implementation is deemed to be good enough, but this
might need to be revisited once the stack collection becomes faster.

A considered alternative is to keep a separate ring buffer for each CPU
and then iterate over all of them when printing a bug report.  This
approach requires somehow figuring out which of the stack rings has the
freshest stack traces for an object if multiple stack rings have them.

Further plans
=============

This series is a part of an effort to make KASAN stack trace collection
suitable for production.  This requires stack trace collection to be fast
and memory-bounded.

The planned steps are:

1. Speed up stack trace collection (potentially, by using SCS;
   patches on-hold until steps #2 and #3 are completed).
2. Keep stack trace handles in the stack ring (this series).
3. Add a memory-bounded mode to stack depot or provide an alternative
   memory-bounded stack storage.
4. Potentially, implement stack trace collection sampling to minimize
   the performance impact.


This patch (of 34):

__kasan_metadata_size() calculates the size of the redzone for objects in
a slab cache.

When accounting for presence of kasan_free_meta in the redzone, this
function only compares free_meta_offset with 0.  But free_meta_offset
could also be equal to KASAN_NO_FREE_META, which indicates that
kasan_free_meta is not present at all.

Add a comparison with KASAN_NO_FREE_META into __kasan_metadata_size().

Link: https://lkml.kernel.org/r/cover.1662411799.git.andreyknvl@google.com
Link: https://lkml.kernel.org/r/c7b316d30d90e5947eb8280f4dc78856a49298cf.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/kasan/common.c~kasan-check-kasan_no_free_meta-in-__kasan_metadata_size
+++ a/mm/kasan/common.c
@@ -224,8 +224,9 @@ size_t __kasan_metadata_size(struct kmem
 		return 0;
 	return (cache->kasan_info.alloc_meta_offset ?
 		sizeof(struct kasan_alloc_meta) : 0) +
-		(cache->kasan_info.free_meta_offset ?
-		sizeof(struct kasan_free_meta) : 0);
+		((cache->kasan_info.free_meta_offset &&
+		  cache->kasan_info.free_meta_offset != KASAN_NO_FREE_META) ?
+		 sizeof(struct kasan_free_meta) : 0);
 }
 
 struct kasan_alloc_meta *kasan_get_alloc_meta(struct kmem_cache *cache,
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-array-bounds-warnings-in-tests.patch

