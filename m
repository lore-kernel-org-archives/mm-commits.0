Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795479086;
	b=ZARkbitK3Y+gXtHJgKu0jeaFbHzRKugfI3tr8hRsDDGUqhBsJOcM9YLdwnpV+EX93+DH
	 BJi/2LMX/e2zsme+DcxyfUE2w9cU+iDmWWIzWWTlCgiP/VIkL4Lk3iddB2gyQb3zD6+Ve
	 LRYQxflJVj/uPGUw87wpglhcfdngLeWFwpLsiZsp2u1TfTCzho35JtnQYMiYcmomUPuU9
	 W7BVi3hUHbyw33hg9e45syCoeSftEuAWRWLmg2uGT3ERmfe6U/cfQMvfdvY+poTGYusTH
	 nfanP/BkooynShQXScK/vFqI4T5ohH4e+tT3hglZ2/MksTB1CmoHqyFtQjaC1i3CF6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795479086;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=hq9MHNmf5z+jIkrzLF2XaknjsP17OD5HJekgqR1pJOw=;
	b=qjGB+xYMnWIIOY0UaxZu0nTNgOibgRPZcauwYuDC6GQS+iKi1V/kHMbDThHOE/14a5L5
	 C4HJ6FPb+ToQgeBNi31KDFgqMQloR+n6EAS/KYVHA/Yu7QXcUGY07z/W8xnk0/Cx6yHQe
	 D3Cb0P5XDkBOV6CB63p7CzmiAQzAn/wN7kh/6au3/3cnDQzNoo2Jo7kPJmnGLBCHHO0TB
	 4y137OkBw7wa3n2Rcy8NAXmUWPiq6xKPS9PSuS+LxYbalr40sxlfXVAhtVZK4gp09Rdsv
	 6vC/dMEBEvyFAok/vjh3XIeDJtarY3cadIhSv2pH2WVSiBGu/ETCHwqxNtp1r/FOEcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sB79IUuv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C77606A321
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 00:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sB79IUuv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C671F000CA;
	Tue, 24 Nov 2026 00:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795479086;
	bh=hq9MHNmf5z+jIkrzLF2XaknjsP17OD5HJekgqR1pJOw=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=sB79IUuvgH5MQahuvH2cDeSgER238H9lZ2OudQKMrTetVx3nfkpq+PQtGDRQhm22l
	 +IgeBFjJ8dx4jhuFEicyVv6N6iyhkVhgyfvIqq30ubB5KFvEOVoetynxLURED8ylbJ
	 mYx6OEvFdBBRLDSsOxeuJ2FMICjrHdaois/pThZI=
Date: Mon, 23 Nov 2026 16:11:25 -0800
To: mm-commits@vger.kernel.org,yosry@kernel.org,nphamcs@gmail.com,
	minchan@kernel.org,hongfengchen@xiaomi.com,chenhongfeng0212@gmail.com,
	bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123054746.2579253-2-senozhatsky@chromium.org>
References: <20261123054746.2579253-2-senozhatsky@chromium.org>
Subject: + zsmalloc-free-a-zspages-pages-in-one-batch.patch added to mm-new branch
Message-Id: <20261124001126.08C671F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: zsmalloc: free a zspage's pages in one batch
has been added to the -mm mm-new branch.  Its filename is
     zsmalloc-free-a-zspages-pages-in-one-batch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-free-a-zspages-pages-in-one-batch.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: free a zspage's pages in one batch
Date: Mon, 23 Nov 2026 14:47:36 +0900

Patch series "zram: zsmalloc: speed up zspage free path", v3.

This is a followup on deferred zs_free() discussion [1].  We cannot do
deferred zs_free(), at least not on the zsmalloc side, due to the fact
that object handle is now stored in-place on the client side (zswap/zram
entry).  There is still a possibility for a speed up tho.  One is batching
of zspage's pages free.  The other one is moving zram stats into per-CPU
area (as was suggested by Hongfeng Chen), which reduces cache lines
bouncing in zram slot-free notification path.


This patch (of 2):

__free_frozen_pages() and dec_zone_page_state() take about 22% of the
profile [2].

Collect the pages of a multi-page zspage in a folio_batch and free
them with folios_put(), which takes the pcp lock once per run of
same-zone pages, and update NR_ZSPAGES once per such run as well
A zspage never has more pages than a folio_batch holds.

Single-page zspages, incompressible or power of 2 size classes, use
the current inline path.  There is nothing to batch there, and
folio_batch is not free, hence the batch path lives in its own
noinline function.

munmap() test:
                    next-20261119      v7.4-rc3
  256 MiB           -2.0% .. -4.1%     -4.4%
  1 GiB             -2.8% .. -4.4%     -3.8%

Link: https://lore.kernel.org/20261123054746.2579253-1-senozhatsky@chromium.org
Link: https://patch.msgid.link/20261123054746.2579253-2-senozhatsky@chromium.org
Link: https://lore.kernel.org/all/20261016120927.3191690-1-hongfengchen@xiaomi.com/ [1]
Link: https://lore.kernel.org/20261109105957.2577351-1-chenhongfeng0212@gmail.com [2]
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Hongfeng Chen <hongfengchen@xiaomi.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hongfeng Chen <chenhongfeng0212@gmail.com>

 mm/zsmalloc.c |   52 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 6 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-free-a-zspages-pages-in-one-batch
+++ a/mm/zsmalloc.c
@@ -43,6 +43,7 @@
 #include <linux/debugfs.h>
 #include <linux/zsmalloc.h>
 #include <linux/fs.h>
+#include <linux/folio_batch.h>
 #include <linux/workqueue.h>
 #include "zpdesc.h"
 
@@ -844,6 +845,44 @@ unlock:
 }
 
 /*
+ * Free the pages of a multi-page zspage in one go, see folios_put().
+ * Not inlined, so that the folio_batch is only set up (and, with
+ * CONFIG_INIT_STACK_ALL_ZERO, zero-filled) when there is something
+ * to batch.
+ */
+static noinline void free_page_chain(struct zpdesc *zpdesc)
+{
+	struct zone *zone = zpdesc_zone(zpdesc);
+	struct folio_batch fbatch;
+	int nr = 0;
+
+	static_assert(ZS_MAX_PAGES_PER_ZSPAGE <= FOLIO_BATCH_SIZE);
+
+	folio_batch_init(&fbatch);
+	do {
+		struct zpdesc *next = get_next_zpdesc(zpdesc);
+
+		VM_BUG_ON_PAGE(!zpdesc_is_locked(zpdesc), zpdesc_page(zpdesc));
+		reset_zpdesc(zpdesc);
+		zpdesc_unlock(zpdesc);
+
+		/* NR_ZSPAGES is per zone: one update per same-zone run */
+		if (unlikely(zpdesc_zone(zpdesc) != zone)) {
+			mod_zone_page_state(zone, NR_ZSPAGES, -nr);
+			zone = zpdesc_zone(zpdesc);
+			nr = 0;
+		}
+		nr++;
+
+		folio_batch_add(&fbatch, zpdesc_folio(zpdesc));
+		zpdesc = next;
+	} while (zpdesc);
+
+	mod_zone_page_state(zone, NR_ZSPAGES, -nr);
+	folios_put(&fbatch);
+}
+
+/*
  * Three free helpers, kept apart here:
  *
  * __free_zspage_lockless(): bare core; walks zpdescs and returns pages
@@ -861,21 +900,22 @@ unlock:
  */
 static inline void __free_zspage_lockless(struct zspage *zspage)
 {
-	struct zpdesc *zpdesc, *next;
+	struct zpdesc *zpdesc;
 
 	VM_BUG_ON(get_zspage_inuse(zspage));
 	VM_BUG_ON(zspage->fullness != ZS_INUSE_RATIO_0);
 
-	next = zpdesc = get_first_zpdesc(zspage);
-	do {
+	zpdesc = get_first_zpdesc(zspage);
+	if (get_next_zpdesc(zpdesc)) {
+		free_page_chain(zpdesc);
+	} else {
+		/* Single-page zspage, e.g. a huge object: nothing to batch */
 		VM_BUG_ON_PAGE(!zpdesc_is_locked(zpdesc), zpdesc_page(zpdesc));
-		next = get_next_zpdesc(zpdesc);
 		reset_zpdesc(zpdesc);
 		zpdesc_unlock(zpdesc);
 		zpdesc_dec_zone_page_state(zpdesc);
 		zpdesc_put(zpdesc);
-		zpdesc = next;
-	} while (zpdesc != NULL);
+	}
 
 	cache_free_zspage(zspage);
 }
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-prefix-backends-printk-s.patch
zram-remove-debugfs-entry-on-init-failure.patch
zram-reset-writeback-state-in-zram_reset_device.patch
zram-move-mark_slot_accessed-under-existing-slot-lock-sections.patch
zram-remove-stale-warn_on-from-zram_read_page.patch
zram-zstd-do-not-allocate-empty-c-d-dictionaries.patch
zram-lz4hc-pre-initialize-dictionary-stream-in-setup_params.patch
zram-lz4-use-lz4_decompress_safe_usingdict.patch
zram-lz4hc-use-lz4_decompress_safe_usingdict.patch
zram-zstd-do-not-use-kvzalloc-for-zstd-allocations.patch
zram-split-zcomp-into-separate-r-w-streams.patch
zram-introduce-shared-decompression-streams.patch
zram-allocate-bounce-buffer-for-spanning-objects.patch
zram-borrow-idle-decompression-streams-in-exclusive-mode.patch
zram-use-a-singleton-compression-context-for-recompression.patch
zram-drop-stale-comment-in-write_incompressible_page.patch
zram-drop-get_slot_handle-and-set_slot_handle.patch
zsmalloc-return-handle-from-obj_allocated.patch
zsmalloc-switch-handle-type-to-struct-zs_handle.patch
zram-check-mem_limit-before-allocating-zsmalloc-object.patch
zram-allocate-zsmalloc-object-under-slot-lock.patch
zswap-do-not-free-the-entry-if-its-pool-is-null.patch
zsmalloc-encode-1-based-obj_idx-so-valid-obj-is-never-0.patch
zsmalloc-embed-struct-zs_handle-into-zram-and-zswap-entries.patch
zsmalloc-fold-zs_obj_write-into-zs_store.patch
zsmalloc-populate-new-zspage-outside-class-lock-in-zs_store.patch
zram-fix-quadratic-writeback-bitmap-search.patch
zsmalloc-free-a-zspages-pages-in-one-batch.patch
zram-keep-the-hot-statistics-per-cpu.patch
zsmalloc-fix-spdx-license-identifier.patch
zram-use-spdx-license-identifier.patch

