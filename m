Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E6BE7734B
	for <mm-commits@archiver.kernel.org>; Fri, 29 Sep 2023 22:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbjI2W5r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 18:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjI2W5r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 18:57:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D671BAC
        for <mm-commits@vger.kernel.org>; Fri, 29 Sep 2023 15:57:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F746C433C8;
        Fri, 29 Sep 2023 22:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696028265;
        bh=4eUlDIkQUP6kCcRzYgnxup+z/ht9+BvMsoWKcIKsnyc=;
        h=Date:To:From:Subject:From;
        b=DXqOcEkZYyu32WI+7LZHEVnKxz4B+w9LHvMeztxBS5lVViM3NQ2RRfSeKnZAluLTF
         VHoOeEBzu5pweW9bl8sSUJc+xnoB9rcbiFvtL6rj4cAqxbTgZW67M4v6uaYWLMXoTj
         7W9fhU+VxcYLJYiSOHHvFfoFkS0a7Apg3GQTqXj0=
Date:   Fri, 29 Sep 2023 15:57:44 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        Liam.Howlett@oracle.com, akpm@linux-foudation.org,
        christophe.jaillet@wanadoo.fr, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] radix-tree-test-suite-fix-a-memory-initialization-issue.patch removed from -mm tree
Message-Id: <20230929225745.6F746C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: radix tree test suite: Fix a memory initialization issue
has been removed from the -mm tree.  Its filename was
     radix-tree-test-suite-fix-a-memory-initialization-issue.patch

This patch was dropped because it was nacked

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

kstrtox-remove-strtobool.patch

