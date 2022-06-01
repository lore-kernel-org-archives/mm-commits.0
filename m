Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D8D7C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  1 Jun 2022 21:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiFAVMI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Jun 2022 17:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbiFAVMH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2022 17:12:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FAB5A094
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 14:12:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD963B81CE8
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 21:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76079C385A5;
        Wed,  1 Jun 2022 21:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654117923;
        bh=zt6GPqm3OBsAY0KcowIBDMF9WoMYaqT0wk7BhknR/hc=;
        h=Date:To:From:Subject:From;
        b=wFvWdhyD7/PE2+xyN1GGGez6JNEmcQUee6BBZLEw8wRxxGi2AEfcNsH2Spkp8XRaV
         KXzcE8ff1Ylni7M2wA92qLYW3BiN8j0/IFVDogwSJ/gh+QwlH8zbvRP6bvzeRuelbB
         NFkAslEE2l9NWOoqh+6SuISriNwNHrg9NV5+QY08=
Date:   Wed, 01 Jun 2022 14:12:02 -0700
To:     mm-commits@vger.kernel.org, mark.rutland@arm.com, arnd@arndb.de,
        tianyu.li@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-fix-get_nodes-out-of-bound-access.patch added to mm-unstable branch
Message-Id: <20220601211203.76079C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: fix get_nodes out of bound access
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-fix-get_nodes-out-of-bound-access.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-fix-get_nodes-out-of-bound-access.patch

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
From: Tianyu Li <tianyu.li@arm.com>
Subject: mm/mempolicy: fix get_nodes out of bound access
Date: Wed, 1 Jun 2022 17:32:11 +0800

When user specified more nodes than supported, get_nodes will access nmask
array out of bounds.

Link: https://lkml.kernel.org/r/20220601093211.2970565-1-tianyu.li@arm.com
Fixes: e130242dc351 ("mm: simplify compat numa syscalls")
Signed-off-by: Tianyu Li <tianyu.li@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-get_nodes-out-of-bound-access
+++ a/mm/mempolicy.c
@@ -1397,7 +1397,7 @@ static int get_nodes(nodemask_t *nodes,
 		unsigned long bits = min_t(unsigned long, maxnode, BITS_PER_LONG);
 		unsigned long t;
 
-		if (get_bitmap(&t, &nmask[maxnode / BITS_PER_LONG], bits))
+		if (get_bitmap(&t, &nmask[(maxnode - 1) / BITS_PER_LONG], bits))
 			return -EFAULT;
 
 		if (maxnode - bits >= MAX_NUMNODES) {
_

Patches currently in -mm which might be from tianyu.li@arm.com are

mm-mempolicy-fix-get_nodes-out-of-bound-access.patch

