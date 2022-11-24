Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E28C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 24 Nov 2022 03:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiKXDq5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Nov 2022 22:46:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiKXDqx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Nov 2022 22:46:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA778D1
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 19:46:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 684A8B826A1
        for <mm-commits@vger.kernel.org>; Thu, 24 Nov 2022 03:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF97C433C1;
        Thu, 24 Nov 2022 03:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669261610;
        bh=M5KknmXf2aqqIDSl7sDa0nf8fO+pfU0KRE+Ovh7uJmI=;
        h=Date:To:From:Subject:From;
        b=te+cm9HK8t6jOfJrUWlH1bZiTAmf8/DlBOoesrKqkC7Jj4vsHReE9CpSKOCPZcg0N
         EQlMxLKqxomgHq4q+aGWEK8Cl+n35EhG95m24yOE2+1TEvQkDdMHxoL6SFR6DzF/jK
         Dm/AKimrCpXfOmLzj4cKmjXAVZMzFMzSOscb20z0=
Date:   Wed, 23 Nov 2022 19:46:49 -0800
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        nphamcs@gmail.com, minchan@kernel.org, hannes@cmpxchg.org,
        ddstreet@ieee.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-do-not-allocate-from-atomic-pool.patch added to mm-unstable branch
Message-Id: <20221124034650.0DF97C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: do not allocate from atomic pool
has been added to the -mm mm-unstable branch.  Its filename is
     zswap-do-not-allocate-from-atomic-pool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zswap-do-not-allocate-from-atomic-pool.patch

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
Subject: zswap: do not allocate from atomic pool
Date: Tue, 22 Nov 2022 12:30:22 +0900

zswap_frontswap_load() should be called from preemptible context (we even
call mutex_lock() there) and it does not look like we need to do
GFP_ATOMIC allocaion for temp buffer.  The same applies to
zswap_writeback_entry().

Use GFP_KERNEL for temporary buffer allocation in both cases.

Link: https://lkml.kernel.org/r/Y3xCTr6ikbtcUr/y@google.com
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpool.c |    7 +++++++
 mm/zswap.c |    4 ++--
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/mm/zpool.c~zswap-do-not-allocate-from-atomic-pool
+++ a/mm/zpool.c
@@ -387,6 +387,13 @@ bool zpool_evictable(struct zpool *zpool
  * zpool_can_sleep_mapped - Test if zpool can sleep when do mapped.
  * @zpool:	The zpool to test
  *
+ * Some allocators enter non-preemptible context in ->map() callback (e.g.
+ * disable pagefaults) and exit that context in ->unmap(), which limits what
+ * we can do with the mapped object. For instance, we cannot wait for
+ * asynchronous crypto API to decompress such an object or take mutexes
+ * since those will call into the scheduler. This function tells us whether
+ * we use such an allocator.
+ *
  * Returns: true if zpool can sleep; false otherwise.
  */
 bool zpool_can_sleep_mapped(struct zpool *zpool)
--- a/mm/zswap.c~zswap-do-not-allocate-from-atomic-pool
+++ a/mm/zswap.c
@@ -958,7 +958,7 @@ static int zswap_writeback_entry(struct
 	};
 
 	if (!zpool_can_sleep_mapped(pool)) {
-		tmp = kmalloc(PAGE_SIZE, GFP_ATOMIC);
+		tmp = kmalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!tmp)
 			return -ENOMEM;
 	}
@@ -1311,7 +1311,7 @@ static int zswap_frontswap_load(unsigned
 	}
 
 	if (!zpool_can_sleep_mapped(entry->pool->zpool)) {
-		tmp = kmalloc(entry->length, GFP_ATOMIC);
+		tmp = kmalloc(entry->length, GFP_KERNEL);
 		if (!tmp) {
 			ret = -ENOMEM;
 			goto freeentry;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-preparation-for-multi-zcomp-support.patch
zram-add-recompression-algorithm-sysfs-knob.patch
zram-factor-out-wb-and-non-wb-zram-read-functions.patch
zram-introduce-recompress-sysfs-knob.patch
zram-introduce-recompress-sysfs-knob-fix.patch
zram-add-recompress-flag-to-read_block_state.patch
zram-clarify-writeback_store-comment.patch
zram-use-is_err_value-to-check-for-zs_malloc-errors.patch
zram-remove-redundant-checks-from-zram_recompress.patch
zram-add-algo-parameter-support-to-zram_recompress.patch
documentation-add-zram-recompression-documentation.patch
zram-add-incompressible-writeback.patch
zram-add-incompressible-flag-to-read_block_state.patch
docs-abi-zram-document-zram-recompress-sysfs-knobs.patch
zram-remove-unused-stats-fields.patch
zswap-do-not-allocate-from-atomic-pool.patch

