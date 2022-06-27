Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFED8C43334
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jun 2022 19:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240126AbiF0THC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jun 2022 15:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237798AbiF0THB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jun 2022 15:07:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F378C2712
        for <mm-commits@vger.kernel.org>; Mon, 27 Jun 2022 12:07:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9257B615E1
        for <mm-commits@vger.kernel.org>; Mon, 27 Jun 2022 19:07:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F7AC341CB;
        Mon, 27 Jun 2022 19:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656356820;
        bh=gCmxJ3eQPgdHPqtjYT9zSzGQUeMQ9mhai6ZjwhWiRSQ=;
        h=Date:To:From:Subject:From;
        b=kG3Wu1DjrXSaLpFObRvtzecuC9L43xpcdCVYNMaI9e4WD4hpEcl2ni38tBeYovGkD
         9lxASzfly48OMpqHe9QTpZI7mxnxp/3L3qBWHT7Ko0ATiYGa/Au0oc9ysct95p8b4X
         WnJLvWDpI8agvtNjhtrvzFGiJAByg6Ky0Chg7mvQ=
Date:   Mon, 27 Jun 2022 12:06:59 -0700
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        skhan@linuxfoundation.org, ryabinin.a.a@gmail.com,
        glider@google.com, dvyukov@google.com, andreyknvl@gmail.com,
        gautammenghani201@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-kasan-fix-null-pointer-dereference-warning-in-qlink_to_cache.patch removed from -mm tree
Message-Id: <20220627190659.E7F7AC341CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/kasan: fix null pointer dereference warning in qlink_to_cache()
has been removed from the -mm tree.  Its filename was
     mm-kasan-fix-null-pointer-dereference-warning-in-qlink_to_cache.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Gautam Menghani <gautammenghani201@gmail.com>
Subject: mm/kasan: fix null pointer dereference warning in qlink_to_cache()
Date: Sun, 26 Jun 2022 22:33:55 +0530

virt_to_slab() declared in slab.h can return NULL if the address does not
belong to a slab.  This case is not handled in qlink_to_cache() in
quarantine.c, which can cause a NULL pointer dereference in
"virt_to_slab(qlink)->slab_cache".  This issue was discovered by fanalyzer
(my gcc version: 12.1.1 20220507)

Link: https://lkml.kernel.org/r/20220626170355.198913-1-gautammenghani201@gmail.com
Signed-off-by: Gautam Menghani <gautammenghani201@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/kasan/quarantine.c~mm-kasan-fix-null-pointer-dereference-warning-in-qlink_to_cache
+++ a/mm/kasan/quarantine.c
@@ -128,7 +128,13 @@ static unsigned long quarantine_batch_si
 
 static struct kmem_cache *qlink_to_cache(struct qlist_node *qlink)
 {
-	return virt_to_slab(qlink)->slab_cache;
+	struct slab *folio_slab = virt_to_slab(qlink);
+
+	if (!folio_slab) {
+		pr_warn("The address %p does not belong to a slab", qlink);
+		return NULL;
+	}
+	return folio_slab->slab_cache;
 }
 
 static void *qlink_to_object(struct qlist_node *qlink, struct kmem_cache *cache)
_

Patches currently in -mm which might be from gautammenghani201@gmail.com are


