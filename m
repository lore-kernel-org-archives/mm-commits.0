Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B20C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 20:19:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41310207FF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 20:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597868389;
	bh=sQ23Fy+mqLefR3lp8mzW2yqK1s/XFLpwagyztvcidTc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=dcIBvdOA1lhJADoANwxgu/2O2RrPl4uvAoLstrPZTPrBpU6Emfhxb9vKOVk3W9BN0
	 oQsvH/Vb2+egpBorxshd7oAPFUksEuFrLcDhbm+yc0gTeuMOYiT6jGNDV3yCAeDgSe
	 eCJ1mXOvLTripoI4+APAL/jkhnlnM2c/LcLeWS6Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgHSUTs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 16:19:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725275AbgHSUTm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 16:19:42 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C70AC207DE;
        Wed, 19 Aug 2020 20:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597868380;
        bh=sQ23Fy+mqLefR3lp8mzW2yqK1s/XFLpwagyztvcidTc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gkDYdaDLqcXtC8UEN3uu2X+bJZmAA+3YKM00CVTz+Z/QDAB/ANdPVSk7vOvcg9YIn
         fJoDroinLRlcihcggvjClLeKia/LA+btuRZTjtseHQCIjKR1zAbiJQfQ8eJ0nwpogv
         osj9jqTkBvUy35WeZ8O64seYYu3DAm7Yp7Wn9AIU=
Date:   Wed, 19 Aug 2020 13:19:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     ari-pekka.verta@digital14.com, cl@linux.com,
        iamjoonsoo.kim@lge.com, keun-o.park@digital14.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, thgarnie@google.com, timo.simola@digital14.com
Subject:  +
 mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes.patch
 added to -mm tree
Message-ID: <20200819201939.rByM6iuXa%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slub: re-initialize randomized freelist sequence in calculate_sizes
has been added to the -mm tree.  Its filename is
     mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sahara <keun-o.park@digital14.com>
Subject: mm: slub: re-initialize randomized freelist sequence in calculate_sizes

Slab cache flags are exported to sysfs and are allowed to get modified
from userspace.  Some of those may call calculate_sizes function because
the changed flag can take an effect on slab object size and layout, which
means kmem_cache may have different order and objects.  The freelist
pointer corruption occurs if some slab flags are modified while
CONFIG_SLAB_FREELIST_RANDOM is turned on.

 $ echo 0 > /sys/kernel/slab/zs_handle/store_user
 $ echo 0 > /sys/kernel/slab/zspage/store_user
 $ mkswap /dev/block/zram0
 $ swapon /dev/block/zram0 -p 32758

 =============================================================================
 BUG zs_handle (Not tainted): Freepointer corrupt
 -----------------------------------------------------------------------------

 Disabling lock debugging due to kernel taint
 INFO: Slab 0xffffffbf29603600 objects=102 used=102 fp=0x0000000000000000 flags=0x0200
 INFO: Object 0xffffffca580d8d78 @offset=3448 fp=0xffffffca580d8ed0

 Redzone 00000000f3cddd6c: bb bb bb bb bb bb bb bb                          ........
 Object 0000000082d5d74e: 6b 6b 6b 6b 6b 6b 6b a5                          kkkkkkk.
 Redzone 000000008fd80359: bb bb bb bb bb bb bb bb                          ........
 Padding 00000000c7f56047: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ

In this example, an Android device tries to use zram as a swap and to turn
off store_user in order to reduce the slub object size.  When
calculate_sizes is called in kmem_cache_open, size, order and objects for
zs_handle is:

 size:360, order:0, objects:22
However, if the SLAB_STORE_USER bit is cleared in store_user_store:
 size: 56, order:1, objects:73

All the size, order, and objects is changed by calculate_sizes(), but the
size of the random_seq array is still old value(22).  As a result,
out-of-bound array access can occur at shuffle_freelist() when slab
allocation is requested.

This patch fixes the problem by re-allocating the random_seq array with
re-calculated correct objects value.

Link: https://lkml.kernel.org/r/20200808095030.13368-1-kpark3469@gmail.com
Fixes: 210e7a43fa905 ("mm: SLUB freelist randomization")
Reported-by: Ari-Pekka Verta <ari-pekka.verta@digital14.com>
Reported-by: Timo Simola <timo.simola@digital14.com>
Signed-off-by: Sahara <keun-o.park@digital14.com>
Cc: Thomas Garnier <thgarnie@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/mm/slub.c~mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes
+++ a/mm/slub.c
@@ -3781,7 +3781,22 @@ static int calculate_sizes(struct kmem_c
 	if (oo_objects(s->oo) > oo_objects(s->max))
 		s->max = s->oo;
 
-	return !!oo_objects(s->oo);
+	if (!oo_objects(s->oo))
+		return 0;
+
+	/*
+	 * Initialize the pre-computed randomized freelist if slab is up.
+	 * If the randomized freelist random_seq is already initialized,
+	 * free and re-initialize it with re-calculated value.
+	 */
+	if (slab_state >= UP) {
+		if (s->random_seq)
+			cache_random_seq_destroy(s);
+		if (init_cache_random_seq(s))
+			return 0;
+	}
+
+	return 1;
 }
 
 static int kmem_cache_open(struct kmem_cache *s, slab_flags_t flags)
@@ -3825,12 +3840,6 @@ static int kmem_cache_open(struct kmem_c
 	s->remote_node_defrag_ratio = 1000;
 #endif
 
-	/* Initialize the pre-computed randomized freelist if slab is up */
-	if (slab_state >= UP) {
-		if (init_cache_random_seq(s))
-			goto error;
-	}
-
 	if (!init_kmem_cache_nodes(s))
 		goto error;
 
_

Patches currently in -mm which might be from keun-o.park@digital14.com are

mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes.patch

