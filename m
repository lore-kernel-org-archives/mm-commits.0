Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE5F1C5519F
	for <mm-commits@archiver.kernel.org>; Wed, 18 Nov 2020 22:52:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E342246E4
	for <mm-commits@archiver.kernel.org>; Wed, 18 Nov 2020 22:52:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wn8df3rP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgKRWwg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Nov 2020 17:52:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:56226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726502AbgKRWwf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Nov 2020 17:52:35 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76E0B246DC;
        Wed, 18 Nov 2020 22:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605739963;
        bh=vBUc24L5nCNBgM39E0vhYOCRkZoQfnlYqlckdMHLWv0=;
        h=Date:From:To:Subject:From;
        b=wn8df3rPxkgqc/yP1Vkbp2dGQriyPGS8NlQ3yALEhKHb0cfxBVPbw1rgzUesXjJ8t
         /gozbpkh1J+56GfOWiGPDOjB+I8CLC+PqOhpOc/m3BLtWHKj6TQ4w53lgBzGyYMyEc
         6vsCLo9uG+cVsLJfiKJ4kpyoelmdFZ7781d7jU60=
Date:   Wed, 18 Nov 2020 14:52:41 -0800
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, bharata@linux.ibm.com, cl@linux.com,
        guro@fb.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, vbabka@suse.cz
Subject:  +
 mm-slub-let-number-of-online-cpus-determine-the-slub-page-order.patch added
 to -mm tree
Message-ID: <20201118225241.du8BN_c5p%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: let number of online CPUs determine the slub page order
has been added to the -mm tree.  Its filename is
     mm-slub-let-number-of-online-cpus-determine-the-slub-page-order.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-let-number-of-online-cpus-determine-the-slub-page-order.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-let-number-of-online-cpus-determine-the-slub-page-order.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bharata B Rao <bharata@linux.ibm.com>
Subject: mm/slub: let number of online CPUs determine the slub page order

The page order of the slab that gets chosen for a given slab cache depends
on the number of objects that can be fit in the slab while meeting other
requirements.  We start with a value of minimum objects based on
nr_cpu_ids that is driven by possible number of CPUs and hence could be
higher than the actual number of CPUs present in the system.  This leads
to calculate_order() chosing a page order that is on the higher side
leading to increased slab memory consumption on systems that have bigger
page sizes.

Hence rely on the number of online CPUs when determining the mininum
objects, thereby increasing the chances of chosing a lower conservative
page order for the slab.

Vlastimil:

: Ideally, we would react to hotplug events and update existing caches 
: accordingly. But for that, recalculation of order for existing caches 
: would have to be made safe, while not affecting hot paths. We have 
: removed the sysfs interface with 32a6f409b693 ("mm, slub: remove runtime 
: allocation order changes") as it didn't seem easy and worth the trouble.
: 
: In case somebody wants to start with a large order right from the boot 
: because they know they will hotplug lots of cpus later, they can use 
: slub_min_objects= boot param to override this heuristic. So in case this 
: change regresses somebody's performance, there's a way around it and 
: thus the risk is low IMHO.

Link: https://lkml.kernel.org/r/20201118082759.1413056-1-bharata@linux.ibm.com
Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-let-number-of-online-cpus-determine-the-slub-page-order
+++ a/mm/slub.c
@@ -3431,7 +3431,7 @@ static inline int calculate_order(unsign
 	 */
 	min_objects = slub_min_objects;
 	if (!min_objects)
-		min_objects = 4 * (fls(nr_cpu_ids) + 1);
+		min_objects = 4 * (fls(num_online_cpus()) + 1);
 	max_objects = order_objects(slub_max_order, size);
 	min_objects = min(min_objects, max_objects);
 
_

Patches currently in -mm which might be from bharata@linux.ibm.com are

mm-slub-let-number-of-online-cpus-determine-the-slub-page-order.patch

