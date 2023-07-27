Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45B77C001DC
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 16:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjG0Qc1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 12:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjG0Qc0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 12:32:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD3635BF
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 09:31:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC5AF61EC3
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 16:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51076C433C7;
        Thu, 27 Jul 2023 16:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690475490;
        bh=GY0mV04fmjqS0SmBYODinlDzEfpl0iCVSuzcTvIQyK4=;
        h=Date:To:From:Subject:From;
        b=qMsrK15zXGzzKWRAMO+RQGPkPtkkz7UPNIUj0LzgqpQEvK4KxNv1dUh/4rDH7Pa7y
         JHZj0fSk8xLOSv8Sr49deVnC874lPNMVOcExgBfyCbM4MDgeXyClMdo2vyGBnB77eA
         pW67d7hZanN4RHeQW3IMU/1wJgth2AZXEk9No8Is=
Date:   Thu, 27 Jul 2023 09:31:29 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, song.bao.hua@hisilicon.com,
        sjenning@redhat.com, nphamcs@gmail.com,
        cerasuolodomenico@gmail.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-tighten-up-entry-invalidation.patch added to mm-unstable branch
Message-Id: <20230727163130.51076C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: zswap: tighten up entry invalidation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-tighten-up-entry-invalidation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-tighten-up-entry-invalidation.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: tighten up entry invalidation
Date: Thu, 27 Jul 2023 12:22:24 -0400

Removing a zswap entry from the tree is tied to an explicit operation
that's supposed to drop the base reference: swap invalidation, exclusive
load, duplicate store.  Don't silently remove the entry on final put, but
instead warn if an entry is in tree without reference.

While in that diff context, convert a BUG_ON to a WARN_ON_ONCE.  No need
to crash on a refcount underflow.

Link: https://lkml.kernel.org/r/20230727162343.1415598-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-tighten-up-entry-invalidation
+++ a/mm/zswap.c
@@ -417,9 +417,9 @@ static void zswap_entry_put(struct zswap
 {
 	int refcount = --entry->refcount;
 
-	BUG_ON(refcount < 0);
+	WARN_ON_ONCE(refcount < 0);
 	if (refcount == 0) {
-		zswap_rb_erase(&tree->rbroot, entry);
+		WARN_ON_ONCE(!RB_EMPTY_NODE(&entry->rbnode));
 		zswap_free_entry(entry);
 	}
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-kill-frontswap.patch
mm-kill-frontswap-fix.patch
mm-zswap-use-zswap_invalidate_entry-for-duplicates.patch
mm-zswap-tighten-up-entry-invalidation.patch
mm-zswap-kill-zswap_get_swap_cache_page.patch

