Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE39FC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 00:31:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbiKJAbj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 19:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbiKJAbY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 19:31:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17BE628E36
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 16:31:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 64FC7CE2108
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 00:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8545EC433C1;
        Thu, 10 Nov 2022 00:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668040268;
        bh=FTW5AacRMs5F9qZNWzCtXmT4dFtJIOSjU9ceGEIe3JY=;
        h=Date:To:From:Subject:From;
        b=Wi9QRigULAeVUZrlWcmyEKYeBy89fEU49MyNpd8r4RrzR54nU/gJE5yiUqaSLmNvv
         wSEor1OaftF/h/xoO93y9AlsVJCDDnkHhpt4JFqUz4dwjZziaQU4Rhaw2RZ+UHEEm7
         3Oinc5ZgmqiJAMEpkRpoCDupRCemxvhHMNmULx50=
Date:   Wed, 09 Nov 2022 16:31:07 -0800
To:     mm-commits@vger.kernel.org, suleiman@google.com, nphamcs@gmail.com,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-algo-parameter-support-to-zram_recompress.patch added to mm-unstable branch
Message-Id: <20221110003108.8545EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: add algo parameter support to zram_recompress()
has been added to the -mm mm-unstable branch.  Its filename is
     zram-add-algo-parameter-support-to-zram_recompress.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-algo-parameter-support-to-zram_recompress.patch

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
Subject: zram: add algo parameter support to zram_recompress()
Date: Wed, 9 Nov 2022 20:50:44 +0900

Recompression iterates through all the registered secondary compression
algorithms in order of their priorities so that we have higher chances of
finding the algorithm that compresses a particular page.  This, however,
may not always be best approach and sometimes we may want to limit
recompression to only one particular algorithm.  For instance, when a
higher priority algorithm uses too much power and device has a relatively
low battery level we may want to limit recompression to use only a lower
priority algorithm, which uses less power.

Introduce algo= parameter support to recompression sysfs knob so that
user-sapce can request recompression with particular algorithm only:

  echo "type=idle algo=zstd" > /sys/block/zramX/recompress

Link: https://lkml.kernel.org/r/20221109115047.2921851-11-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   54 ++++++++++++++++++++++++++------
 drivers/block/zram/zram_drv.h |    1 
 2 files changed, 46 insertions(+), 9 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-add-algo-parameter-support-to-zram_recompress
+++ a/drivers/block/zram/zram_drv.c
@@ -1674,6 +1674,7 @@ static int zram_recompress(struct zram *
 	unsigned int comp_len_new;
 	unsigned int class_index_old;
 	unsigned int class_index_new;
+	u32 num_recomps = 0;
 	void *src, *dst;
 	int ret;
 
@@ -1708,6 +1709,7 @@ static int zram_recompress(struct zram *
 		if (prio <= zram_get_priority(zram, index))
 			continue;
 
+		num_recomps++;
 		zstrm = zcomp_stream_get(zram->comps[prio]);
 		src = kmap_atomic(page);
 		ret = zcomp_compress(zstrm, src, &comp_len_new);
@@ -1740,13 +1742,19 @@ static int zram_recompress(struct zram *
 	if (!zstrm)
 		return 0;
 
-	/*
-	 * All secondary algorithms failed to re-compress the page in a way
-	 * that would save memory, mark the object as incompressible so that
-	 * we will not try to compress it again.
-	 */
 	if (class_index_new >= class_index_old) {
-		zram_set_flag(zram, index, ZRAM_INCOMPRESSIBLE);
+		/*
+		 * Secondary algorithms failed to re-compress the page
+		 * in a way that would save memory, mark the object as
+		 * incompressible so that we will not try to compress
+		 * it again.
+		 *
+		 * We need to make sure that all secondary algorithms have
+		 * failed, so we test if the number of recompressions matches
+		 * the number of active secondary algorithms.
+		 */
+		if (num_recomps == zram->num_active_comps - 1)
+			zram_set_flag(zram, index, ZRAM_INCOMPRESSIBLE);
 		return 0;
 	}
 
@@ -1795,10 +1803,11 @@ static ssize_t recompress_store(struct d
 				struct device_attribute *attr,
 				const char *buf, size_t len)
 {
+	u32 prio = ZRAM_SECONDARY_COMP, prio_max = ZRAM_MAX_COMPS;
 	struct zram *zram = dev_to_zram(dev);
-	u32 mode = 0, threshold = 0, prio = ZRAM_SECONDARY_COMP;
 	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
-	char *args, *param, *val;
+	char *args, *param, *val, *algo = NULL;
+	u32 mode = 0, threshold = 0;
 	unsigned long index;
 	struct page *page;
 	ssize_t ret;
@@ -1830,6 +1839,11 @@ static ssize_t recompress_store(struct d
 				return ret;
 			continue;
 		}
+
+		if (!strcmp(param, "algo")) {
+			algo = val;
+			continue;
+		}
 	}
 
 	if (threshold >= PAGE_SIZE)
@@ -1841,6 +1855,26 @@ static ssize_t recompress_store(struct d
 		goto release_init_lock;
 	}
 
+	if (algo) {
+		bool found = false;
+
+		for (; prio < ZRAM_MAX_COMPS; prio++) {
+			if (!zram->comp_algs[prio])
+				continue;
+
+			if (!strcmp(zram->comp_algs[prio], algo)) {
+				prio_max = min(prio + 1, ZRAM_MAX_COMPS);
+				found = true;
+				break;
+			}
+		}
+
+		if (!found) {
+			ret = -EINVAL;
+			goto release_init_lock;
+		}
+	}
+
 	page = alloc_page(GFP_KERNEL);
 	if (!page) {
 		ret = -ENOMEM;
@@ -1871,7 +1905,7 @@ static ssize_t recompress_store(struct d
 			goto next;
 
 		err = zram_recompress(zram, index, page, threshold,
-				      prio, ZRAM_MAX_COMPS);
+				      prio, prio_max);
 next:
 		zram_slot_unlock(zram, index);
 		if (err) {
@@ -2107,6 +2141,7 @@ static void zram_destroy_comps(struct zr
 		if (!comp)
 			continue;
 		zcomp_destroy(comp);
+		zram->num_active_comps--;
 	}
 }
 
@@ -2174,6 +2209,7 @@ static ssize_t disksize_store(struct dev
 		}
 
 		zram->comps[prio] = comp;
+		zram->num_active_comps++;
 	}
 	zram->disksize = disksize;
 	set_capacity_and_notify(zram->disk, zram->disksize >> SECTOR_SHIFT);
--- a/drivers/block/zram/zram_drv.h~zram-add-algo-parameter-support-to-zram_recompress
+++ a/drivers/block/zram/zram_drv.h
@@ -125,6 +125,7 @@ struct zram {
 	 */
 	u64 disksize;	/* bytes */
 	const char *comp_algs[ZRAM_MAX_COMPS];
+	s8 num_active_comps;
 	/*
 	 * zram is claimed so open request will be failed
 	 */
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-preparation-for-multi-zcomp-support.patch
zram-add-recompression-algorithm-sysfs-knob.patch
zram-factor-out-wb-and-non-wb-zram-read-functions.patch
zram-introduce-recompress-sysfs-knob.patch
zram-add-recompress-flag-to-read_block_state.patch
zram-clarify-writeback_store-comment.patch
zram-use-is_err_value-to-check-for-zs_malloc-errors.patch
zram-remove-redundant-checks-from-zram_recompress.patch
zram-add-algo-parameter-support-to-zram_recompress.patch
documentation-add-zram-recompression-documentation.patch
zram-add-incompressible-writeback.patch
zram-add-incompressible-flag-to-read_block_state.patch

