Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D887C3526B
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10B1623B98
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgLRWEm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 17:04:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:36270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726334AbgLRWEm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 17:04:42 -0500
Date:   Fri, 18 Dec 2020 14:04:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608329066;
        bh=Qa/lJeHYl8b4KzgVDEcPnrNSL3TndyoXcPsKu0X9a9U=;
        h=From:To:Subject:In-Reply-To:From;
        b=VWayIH3VsNQ0otj7vzyi/dXtsGirtaw0Q03B2Za+R+3emElE9YVg2YmlZjS38lBEw
         9iDf0muVGmAEpuLrvweu55/1Zy5QDtOA3+e9qCuhW9eNk0kjt4EJwkN4XMpEsmgd/4
         eq7zLQo4EvsNkEpPFZ3IHDLGM3WKxAHFzCuktaIA=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, gor@linux.ibm.com,
        kevin.brodsky@arm.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [patch 55/78] kasan: simplify quarantine_put call site
Message-ID: <20201218220426.ZSJB8Aga-%akpm@linux-foundation.org>
In-Reply-To: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: simplify quarantine_put call site

Patch series "kasan: boot parameters for hardware tag-based mode", v4.

=== Overview

Hardware tag-based KASAN mode [1] is intended to eventually be used in
production as a security mitigation. Therefore there's a need for finer
control over KASAN features and for an existence of a kill switch.

This patchset adds a few boot parameters for hardware tag-based KASAN that
allow to disable or otherwise control particular KASAN features, as well
as provides some initial optimizations for running KASAN in production.

There's another planned patchset what will further optimize hardware
tag-based KASAN, provide proper benchmarking and tests, and will fully
enable tag-based KASAN for production use.

Hardware tag-based KASAN relies on arm64 Memory Tagging Extension (MTE)
[2] to perform memory and pointer tagging. Please see [3] and [4] for
detailed analysis of how MTE helps to fight memory safety problems.

The features that can be controlled are:

1. Whether KASAN is enabled at all.
2. Whether KASAN collects and saves alloc/free stacks.
3. Whether KASAN panics on a detected bug or not.

The patch titled "kasan: add and integrate kasan boot parameters" of this
series adds a few new boot parameters.

kasan.mode allows to choose one of three main modes:

- kasan.mode=off - KASAN is disabled, no tag checks are performed
- kasan.mode=prod - only essential production features are enabled
- kasan.mode=full - all KASAN features are enabled

The chosen mode provides default control values for the features mentioned
above. However it's also possible to override the default values by
providing:

- kasan.stacktrace=off/on - enable stacks collection
                            (default: on for mode=full, otherwise off)
- kasan.fault=report/panic - only report tag fault or also panic
                             (default: report)

If kasan.mode parameter is not provided, it defaults to full when
CONFIG_DEBUG_KERNEL is enabled, and to prod otherwise.

It is essential that switching between these modes doesn't require
rebuilding the kernel with different configs, as this is required by
the Android GKI (Generic Kernel Image) initiative.

=== Benchmarks

For now I've only performed a few simple benchmarks such as measuring
kernel boot time and slab memory usage after boot. There's an upcoming
patchset which will optimize KASAN further and include more detailed
benchmarking results.

The benchmarks were performed in QEMU and the results below exclude the
slowdown caused by QEMU memory tagging emulation (as it's different from
the slowdown that will be introduced by hardware and is therefore
irrelevant).

KASAN_HW_TAGS=y + kasan.mode=off introduces no performance or memory
impact compared to KASAN_HW_TAGS=n.

kasan.mode=prod (manually excluding tagging) introduces 3% of performance
and no memory impact (except memory used by hardware to store tags)
compared to kasan.mode=off.

kasan.mode=full has about 40% performance and 30% memory impact over
kasan.mode=prod. Both come from alloc/free stack collection.

=== Notes

This patchset is available here:

https://github.com/xairy/linux/tree/up-boot-mte-v4

This patchset is based on v11 of "kasan: add hardware tag-based mode for
arm64" patchset [1].

For testing in QEMU hardware tag-based KASAN requires:

1. QEMU built from master [6] (use "-machine virt,mte=on -cpu max" arguments
   to run).
2. GCC version 10.

[1] https://lore.kernel.org/linux-arm-kernel/cover.1606161801.git.andreyknvl@google.com/T/#t
[2] https://community.arm.com/developer/ip-products/processors/b/processors-ip-blog/posts/enhancing-memory-safety
[3] https://arxiv.org/pdf/1802.09517.pdf
[4] https://github.com/microsoft/MSRC-Security-Research/blob/master/papers/2020/Security%20analysis%20of%20memory%20tagging.pdf
[5] https://source.android.com/devices/architecture/kernel/generic-kernel-image
[6] https://github.com/qemu/qemu

=== Tags

Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>


This patch (of 19):

Move get_free_info() call into quarantine_put() to simplify the call site.

No functional changes.

Link: https://lkml.kernel.org/r/cover.1606162397.git.andreyknvl@google.com
Link: https://lkml.kernel.org/r/312d0a3ef92cc6dc4fa5452cbc1714f9393ca239.1606162397.git.andreyknvl@google.com
Link: https://linux-review.googlesource.com/id/Iab0f04e7ebf8d83247024b7190c67c3c34c7940f
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c     |    2 +-
 mm/kasan/kasan.h      |    5 ++---
 mm/kasan/quarantine.c |    3 ++-
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/mm/kasan/common.c~kasan-simplify-quarantine_put-call-site
+++ a/mm/kasan/common.c
@@ -313,7 +313,7 @@ static bool __kasan_slab_free(struct kme
 
 	kasan_set_free_info(cache, object, tag);
 
-	quarantine_put(get_free_info(cache, object), cache);
+	quarantine_put(cache, object);
 
 	return IS_ENABLED(CONFIG_KASAN_GENERIC);
 }
--- a/mm/kasan/kasan.h~kasan-simplify-quarantine_put-call-site
+++ a/mm/kasan/kasan.h
@@ -216,12 +216,11 @@ struct kasan_track *kasan_get_free_track
 
 #if defined(CONFIG_KASAN_GENERIC) && \
 	(defined(CONFIG_SLAB) || defined(CONFIG_SLUB))
-void quarantine_put(struct kasan_free_meta *info, struct kmem_cache *cache);
+void quarantine_put(struct kmem_cache *cache, void *object);
 void quarantine_reduce(void);
 void quarantine_remove_cache(struct kmem_cache *cache);
 #else
-static inline void quarantine_put(struct kasan_free_meta *info,
-				struct kmem_cache *cache) { }
+static inline void quarantine_put(struct kmem_cache *cache, void *object) { }
 static inline void quarantine_reduce(void) { }
 static inline void quarantine_remove_cache(struct kmem_cache *cache) { }
 #endif
--- a/mm/kasan/quarantine.c~kasan-simplify-quarantine_put-call-site
+++ a/mm/kasan/quarantine.c
@@ -163,11 +163,12 @@ static void qlist_free_all(struct qlist_
 	qlist_init(q);
 }
 
-void quarantine_put(struct kasan_free_meta *info, struct kmem_cache *cache)
+void quarantine_put(struct kmem_cache *cache, void *object)
 {
 	unsigned long flags;
 	struct qlist_head *q;
 	struct qlist_head temp = QLIST_INIT;
+	struct kasan_free_meta *info = get_free_info(cache, object);
 
 	/*
 	 * Note: irq must be disabled until after we move the batch to the
_
