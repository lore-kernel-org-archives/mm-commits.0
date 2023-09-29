Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 477F9E728D7
	for <mm-commits@archiver.kernel.org>; Fri, 29 Sep 2023 19:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbjI2TPe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 15:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233878AbjI2TPd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 15:15:33 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722201B3
        for <mm-commits@vger.kernel.org>; Fri, 29 Sep 2023 12:15:30 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8683C433C8;
        Fri, 29 Sep 2023 19:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696014930;
        bh=b7UgY54H63wknMnDYK8dy4HZqAT97LW14k2I717bKRk=;
        h=Date:To:From:Subject:From;
        b=dNGdSBeam5sNETTaddBQfi7NsfhGzLym30IwVAPWzBiMqBZJqhmAu6BUQcwt0tfIP
         uQnzrCo4Ux0hzVpoVWDGmUZc5AfVzt6uziW33oOEl7UQYO5EUMKKg0GLOd/YGmdJ/r
         MHE6hfq2z42xciGlShO7oZWPnZ2d9mUj3mWHo3NU=
Date:   Fri, 29 Sep 2023 12:15:29 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        Liam.Howlett@oracle.com, akpm@linux-foudation.org,
        christophe.jaillet@wanadoo.fr, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + radix-tree-test-suite-fix-a-memory-initialization-issue.patch added to mm-unstable branch
Message-Id: <20230929191529.E8683C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: radix tree test suite: Fix a memory initialization issue
has been added to the -mm mm-unstable branch.  Its filename is
     radix-tree-test-suite-fix-a-memory-initialization-issue.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/radix-tree-test-suite-fix-a-memory-initialization-issue.patch

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
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: radix tree test suite: Fix a memory initialization issue
Date: Thu, 28 Sep 2023 23:11:45 +0200

If __GFP_ZERO is used, the whole allocated memory should be cleared, not
the first part of it only.

Link: https://lkml.kernel.org/r/b1f490b450b14dd754a45f91bb1abd622ce8d4f7.1695935486.git.christophe.jaillet@wanadoo.fr
Fixes: cc86e0c2f306 ("radix tree test suite: add support for slab bulk APIs")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Andrew Morton <akpm@linux-foudation.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/linux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/radix-tree/linux.c~radix-tree-test-suite-fix-a-memory-initialization-issue
+++ a/tools/testing/radix-tree/linux.c
@@ -172,7 +172,7 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 			if (cachep->ctor)
 				cachep->ctor(p[i]);
 			else if (gfp & __GFP_ZERO)
-				memset(p[i], 0, cachep->size);
+				memset(p[i], 0, cachep->size * size);
 		}
 	}
 
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

radix-tree-test-suite-fix-a-memory-initialization-issue.patch
kstrtox-remove-strtobool.patch

