Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABD21C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 18 Jun 2022 22:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiFRW0i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 18 Jun 2022 18:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbiFRW0e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 18 Jun 2022 18:26:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907341208B
        for <mm-commits@vger.kernel.org>; Sat, 18 Jun 2022 15:26:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24E6760B01
        for <mm-commits@vger.kernel.org>; Sat, 18 Jun 2022 22:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D2AC3411A;
        Sat, 18 Jun 2022 22:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655591192;
        bh=J8ZqZAy+1MP7eeAD2tKjBoBQNnB2Rvz+XnzQO6yHa0Y=;
        h=Date:To:From:Subject:From;
        b=cUIO7fQsISKngWE4vkX/WpJyyps8osLJBz+ooU9l7Bw7UIzXwx0aQvKmJH8Th0yMK
         xC8d4dtdkI2PUp3YLlZqu0JBx90f5YThPCPBuPitxLzkHOwI1PT/PWXurLzMtMhRvj
         7c4nNOIcvk7kiJB3QCK5kHrDq3/WHn6LQ0sBbMU4=
Date:   Sat, 18 Jun 2022 15:26:31 -0700
To:     mm-commits@vger.kernel.org, philipp.reisner@linbit.com,
        lars.ellenberg@linbit.com, christoph.boehmwalder@linbit.com,
        wuchi.zero@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-lru_cache-fix-error-free-handing-in-lc_create.patch added to mm-nonmm-unstable branch
Message-Id: <20220618222632.74D2AC3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/lru_cache: fix error free handing in lc_create
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-lru_cache-fix-error-free-handing-in-lc_create.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-lru_cache-fix-error-free-handing-in-lc_create.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: wuchi <wuchi.zero@gmail.com>
Subject: lib/lru_cache: fix error free handing in lc_create
Date: Sat, 18 Jun 2022 16:25:21 +0800

When kmem_cache_alloc in function lc_create returns null, we will
free the memory already allocated. The loop of kmem_cache_free
is wrong, especially:
  i = 0  ==> do wrong loop
  i > 0  ==> do not free element[0]

Link: https://lkml.kernel.org/r/20220618082521.7082-1-wuchi.zero@gmail.com
Signed-off-by: wuchi <wuchi.zero@gmail.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Christoph Bhmwalder <christoph.boehmwalder@linbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lru_cache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/lru_cache.c~lib-lru_cache-fix-error-free-handing-in-lc_create
+++ a/lib/lru_cache.c
@@ -147,8 +147,8 @@ struct lru_cache *lc_create(const char *
 		return lc;
 
 	/* else: could not allocate all elements, give up */
-	for (i--; i; i--) {
-		void *p = element[i];
+	while (i) {
+		void *p = element[--i];
 		kmem_cache_free(cache, p - e_off);
 	}
 	kfree(lc);
_

Patches currently in -mm which might be from wuchi.zero@gmail.com are

lib-debugobjects-fix-stat-count-and-optimize-debug_objects_mem_init.patch
lib-lru_cache-fix-error-free-handing-in-lc_create.patch

