Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 091F6C433E1
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 20:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE04420738
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 20:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598300310;
	bh=mvhz0t84COuEYgyG21zhCtwub9t1cKymguZBYNvccwY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=0uXHqpBz9hGIY1CyZGKIQj5JGSkGnwv20ix5MRt/kt5p2MSSSlF9LrUrSW2sMwKWd
	 0I60V3Q93PD0eGIVAlox4e5Mq+i4LtLjLofa/aty00I3wV/Ygsn2T1e2LE9pt97IhR
	 j3V4F9mZImw9Dq6upHakSSf/R2u9trGwz/GpBK7E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgHXUSa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 16:18:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbgHXUS3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 16:18:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D68D8206BE;
        Mon, 24 Aug 2020 20:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598300307;
        bh=mvhz0t84COuEYgyG21zhCtwub9t1cKymguZBYNvccwY=;
        h=Date:From:To:Subject:From;
        b=p8uEtSFnL5Xq7JgwpLxMp0CCVFiT9XhEkBYrfm9d8zBFW2ADu/eqjPc0EHyvFHXca
         u8ELQvp44iMkbSG5NDzREy6qf8W0z/TiRoQOLKTsnzHJl7OAxPLetEI2SGxfc3LTIE
         9A6tXZehBCaG556c1n/CY6l59lV5StDlicGRhIHI=
Date:   Mon, 24 Aug 2020 13:18:26 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  + lib-radix-tree-delete-duplicated-words.patch added to
 -mm tree
Message-ID: <20200824201826.TDqf-g1t3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: radix-tree: delete duplicated words
has been added to the -mm tree.  Its filename is
     lib-radix-tree-delete-duplicated-words.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-radix-tree-delete-duplicated-words.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-radix-tree-delete-duplicated-words.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib: radix-tree: delete duplicated words

Drop the repeated word "be".

Link: https://lkml.kernel.org/r/20200823040508.26086-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/radix-tree.c~lib-radix-tree-delete-duplicated-words
+++ a/lib/radix-tree.c
@@ -325,7 +325,7 @@ static __must_check int __radix_tree_pre
 	int ret = -ENOMEM;
 
 	/*
-	 * Nodes preloaded by one cgroup can be be used by another cgroup, so
+	 * Nodes preloaded by one cgroup can be used by another cgroup, so
 	 * they should never be accounted to any particular memory cgroup.
 	 */
 	gfp_mask &= ~__GFP_ACCOUNT;
_

Patches currently in -mm which might be from rdunlap@infradead.org are

fs-ocfs2-delete-repeated-words-in-comments.patch
fs-configfs-delete-repeated-words-in-comments.patch
lib-bitmap-delete-duplicated-words.patch
lib-libcrc32c-delete-duplicated-words.patch
lib-decompress_bunzip2-delete-duplicated-words.patch
lib-devres-delete-duplicated-words.patch
lib-dynamic_queue_limits-delete-duplicated-words-fix-typo.patch
lib-earlycpio-delete-duplicated-words.patch
lib-radix-tree-delete-duplicated-words.patch
lib-syscall-delete-duplicated-words.patch
lib-test_sysctl-delete-duplicated-words.patch

