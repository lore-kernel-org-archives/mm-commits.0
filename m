Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8895AC38142
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 01:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjARBK2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 Jan 2023 20:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjARBJl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2023 20:09:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201953D92A
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2023 17:04:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2EF7B81A5F
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 01:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44878C433EF;
        Wed, 18 Jan 2023 01:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674003857;
        bh=/jU2gfdfNfeEReZ7lhj87p6Vubtwm+kgdVv1Qu3Moxc=;
        h=Date:To:From:Subject:From;
        b=W+o/5VzChXd2UTm7ny4mw/6BCfqUhNfqESDUfLM3DCQbyHx17zZ3FGgfHfJxAhPd8
         OHiLBKxnxNv3Hk3wA4UGo5YfYZ5jnrnsx0+yrcYB38xUFUvzko9WKipNWKzOf7PxBy
         lVFZ+i3FLYycp3hUYAW1a8lWowG/ZeXkKehyux9o=
Date:   Tue, 17 Jan 2023 17:04:16 -0800
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        mike.kravetz@oracle.com, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-make-zspage-chain-size-configurable.patch added to mm-unstable branch
Message-Id: <20230118010417.44878C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: make zspage chain size configurable
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-make-zspage-chain-size-configurable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-make-zspage-chain-size-configurable.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: make zspage chain size configurable
Date: Wed, 18 Jan 2023 09:52:09 +0900

Remove hard coded limit on the maximum number of physical pages
per-zspage.

This will allow tuning of zsmalloc pool as zspage chain size changes
`pages per-zspage` and `objects per-zspage` characteristics of size
classes which also affects size classes clustering (the way size classes
are merged).

Link: https://lkml.kernel.org/r/20230118005210.2814763-4-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/mm/zsmalloc.rst~zsmalloc-make-zspage-chain-size-configurable
+++ a/Documentation/mm/zsmalloc.rst
@@ -80,3 +80,171 @@ Similarly, we assign zspage to:
 * ZS_ALMOST_FULL  when n > N / f
 * ZS_EMPTY        when n == 0
 * ZS_FULL         when n == N
+
+
+Internals
+=========
+
+zsmalloc has 255 size classes, each of which can hold a number of zspages.
+Each zspage can contain up to ZSMALLOC_CHAIN_SIZE physical (0-order) pages.
+The optimal zspage chain size for each size class is calculated during the
+creation of the zsmalloc pool (see calculate_zspage_chain_size()).
+
+As an optimization, zsmalloc merges size classes that have similar
+characteristics in terms of the number of pages per zspage and the number
+of objects that each zspage can store.
+
+For instance, consider the following size classes:::
+
+  class  size almost_full almost_empty obj_allocated   obj_used pages_used pages_per_zspage freeable
+  ...
+     94  1536           0            0             0          0          0                3        0
+    100  1632           0            0             0          0          0                2        0
+  ...
+
+
+Size classes #95-99 are merged with size class #100. This means that when we
+need to store an object of size, say, 1568 bytes, we end up using size class
+#100 instead of size class #96. Size class #100 is meant for objects of size
+1632 bytes, so each object of size 1568 bytes wastes 1632-1568=64 bytes.
+
+Size class #100 consists of zspages with 2 physical pages each, which can
+hold a total of 5 objects. If we need to store 13 objects of size 1568, we
+end up allocating three zspages, or 6 physical pages.
+
+However, if we take a closer look at size class #96 (which is meant for
+objects of size 1568 bytes) and trace `calculate_zspage_chain_size()`, we
+find that the most optimal zspage configuration for this class is a chain
+of 5 physical pages:::
+
+    pages per zspage      wasted bytes     used%
+           1                  960           76
+           2                  352           95
+           3                 1312           89
+           4                  704           95
+           5                   96           99
+
+This means that a class #96 configuration with 5 physical pages can store 13
+objects of size 1568 in a single zspage, using a total of 5 physical pages.
+This is more efficient than the class #100 configuration, which would use 6
+physical pages to store the same number of objects.
+
+As the zspage chain size for class #96 increases, its key characteristics
+such as pages per-zspage and objects per-zspage also change. This leads to
+dewer class mergers, resulting in a more compact grouping of classes, which
+reduces memory wastage.
+
+Let's take a closer look at the bottom of `/sys/kernel/debug/zsmalloc/zramX/classes`:::
+
+  class  size almost_full almost_empty obj_allocated   obj_used pages_used pages_per_zspage freeable
+  ...
+    202  3264           0            0             0          0          0                4        0
+    254  4096           0            0             0          0          0                1        0
+  ...
+
+Size class #202 stores objects of size 3264 bytes and has a maximum of 4 pages
+per zspage. Any object larger than 3264 bytes is considered huge and belongs
+to size class #254, which stores each object in its own physical page (objects
+in huge classes do not share pages).
+
+Increasing the size of the chain of zspages also results in a higher watermark
+for the huge size class and fewer huge classes overall. This allows for more
+efficient storage of large objects.
+
+For zspage chain size of 8, huge class watermark becomes 3632 bytes:::
+
+  class  size almost_full almost_empty obj_allocated   obj_used pages_used pages_per_zspage freeable
+  ...
+    202  3264           0            0             0          0          0                4        0
+    211  3408           0            0             0          0          0                5        0
+    217  3504           0            0             0          0          0                6        0
+    222  3584           0            0             0          0          0                7        0
+    225  3632           0            0             0          0          0                8        0
+    254  4096           0            0             0          0          0                1        0
+  ...
+
+For zspage chain size of 16, huge class watermark becomes 3840 bytes:::
+
+  class  size almost_full almost_empty obj_allocated   obj_used pages_used pages_per_zspage freeable
+  ...
+    202  3264           0            0             0          0          0                4        0
+    206  3328           0            0             0          0          0               13        0
+    207  3344           0            0             0          0          0                9        0
+    208  3360           0            0             0          0          0               14        0
+    211  3408           0            0             0          0          0                5        0
+    212  3424           0            0             0          0          0               16        0
+    214  3456           0            0             0          0          0               11        0
+    217  3504           0            0             0          0          0                6        0
+    219  3536           0            0             0          0          0               13        0
+    222  3584           0            0             0          0          0                7        0
+    223  3600           0            0             0          0          0               15        0
+    225  3632           0            0             0          0          0                8        0
+    228  3680           0            0             0          0          0                9        0
+    230  3712           0            0             0          0          0               10        0
+    232  3744           0            0             0          0          0               11        0
+    234  3776           0            0             0          0          0               12        0
+    235  3792           0            0             0          0          0               13        0
+    236  3808           0            0             0          0          0               14        0
+    238  3840           0            0             0          0          0               15        0
+    254  4096           0            0             0          0          0                1        0
+  ...
+
+Overall the combined zspage chain size effect on zsmalloc pool configuration:::
+
+  pages per zspage   number of size classes (clusters)   huge size class watermark
+         4                        69                               3264
+         5                        86                               3408
+         6                        93                               3504
+         7                       112                               3584
+         8                       123                               3632
+         9                       140                               3680
+        10                       143                               3712
+        11                       159                               3744
+        12                       164                               3776
+        13                       180                               3792
+        14                       183                               3808
+        15                       188                               3840
+        16                       191                               3840
+
+
+A synthetic test
+----------------
+
+zram as a build artifacts storage (Linux kernel compilation).
+
+* `CONFIG_ZSMALLOC_CHAIN_SIZE=4`
+
+  zsmalloc classes stats:::
+
+    class  size almost_full almost_empty obj_allocated   obj_used pages_used pages_per_zspage freeable
+    ...
+    Total                13           51        413836     412973     159955                         3
+
+  zram mm_stat:::
+
+   1691783168 628083717 655175680        0 655175680       60        0    34048    34049
+
+
+* `CONFIG_ZSMALLOC_CHAIN_SIZE=8`
+
+  zsmalloc classes stats:::
+
+    class  size almost_full almost_empty obj_allocated   obj_used pages_used pages_per_zspage freeable
+    ...
+    Total                18           87        414852     412978     156666                         0
+
+  zram mm_stat:::
+
+    1691803648 627793930 641703936        0 641703936       60        0    33591    33591
+
+Using larger zspage chains may result in using fewer physical pages, as seen
+in the example where the number of physical pages used decreased from 159955
+to 156666, at the same time maximum zsmalloc pool memory usage went down from
+655175680 to 641703936 bytes.
+
+However, this advantage may be offset by the potential for increased system
+memory pressure (as some zspages have larger chain sizes) in cases where there
+is heavy internal fragmentation and zspool compaction is unable to relocate
+objects and release zspages. In these cases, it is recommended to decrease
+the limit on the size of the zspage chains (as specified by the
+CONFIG_ZSMALLOC_CHAIN_SIZE option).
--- a/mm/Kconfig~zsmalloc-make-zspage-chain-size-configurable
+++ a/mm/Kconfig
@@ -191,6 +191,25 @@ config ZSMALLOC_STAT
 	  information to userspace via debugfs.
 	  If unsure, say N.
 
+config ZSMALLOC_CHAIN_SIZE
+	int "Maximum number of physical pages per-zspage"
+	default 4
+	range 4 16
+	depends on ZSMALLOC
+	help
+	  This option sets the upper limit on the number of physical pages
+	  that a zmalloc page (zspage) can consist of. The optimal zspage
+	  chain size is calculated for each size class during the
+	  initialization of the pool.
+
+	  Changing this option can alter the characteristics of size classes,
+	  such as the number of pages per zspage and the number of objects
+	  per zspage. This can also result in different configurations of
+	  the pool, as zsmalloc merges size classes with similar
+	  characteristics.
+
+	  For more information, see zsmalloc documentation.
+
 menu "SLAB allocator options"
 
 choice
--- a/mm/zsmalloc.c~zsmalloc-make-zspage-chain-size-configurable
+++ a/mm/zsmalloc.c
@@ -73,13 +73,6 @@
  */
 #define ZS_ALIGN		8
 
-/*
- * A single 'zspage' is composed of up to 2^N discontiguous 0-order (single)
- * pages. ZS_MAX_ZSPAGE_ORDER defines upper limit on N.
- */
-#define ZS_MAX_ZSPAGE_ORDER 2
-#define ZS_MAX_PAGES_PER_ZSPAGE (_AC(1, UL) << ZS_MAX_ZSPAGE_ORDER)
-
 #define ZS_HANDLE_SIZE (sizeof(unsigned long))
 
 /*
@@ -136,10 +129,13 @@
 #define HUGE_BITS	1
 #define FULLNESS_BITS	2
 #define CLASS_BITS	8
-#define ISOLATED_BITS	3
+#define ISOLATED_BITS	5
 #define MAGIC_VAL_BITS	8
 
 #define MAX(a, b) ((a) >= (b) ? (a) : (b))
+
+#define ZS_MAX_PAGES_PER_ZSPAGE	(_AC(CONFIG_ZSMALLOC_CHAIN_SIZE, UL))
+
 /* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
 #define ZS_MIN_ALLOC_SIZE \
 	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS))
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-correctly-handle-all-next_arg-cases.patch
zsmalloc-rework-zspage-chain-size-selection.patch
zsmalloc-skip-chain-size-calculation-for-pow_of_2-classes.patch
zsmalloc-make-zspage-chain-size-configurable.patch
zsmalloc-set-default-zspage-chain-size-to-8.patch

