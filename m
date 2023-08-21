Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B927EE49B1
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbjHUUj2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbjHUUjL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38A01B1
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50E6064A31
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A608EC433C8;
        Mon, 21 Aug 2023 20:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650345;
        bh=TlDJKBNFypyy1bXMBOMzq3FB0zLGgtmmLMQ1ufpFqjA=;
        h=Date:To:From:Subject:From;
        b=D8iV+y1oXAsBHlCAJiHFRmxU8U1YEDFRhlX/+37zUvhIBRPZkk/OJN4bKRFtfusxa
         1ouo9mBqkI9BLlnhhyg9OTBHNgp0l+Qb8DtMgxYztJ7khFRUggLfj+3R0WcMQtpxAR
         YjgM79PBv33qwx4KSxCzsYGX4eoBBZ/oawiOUlZY=
Date:   Mon, 21 Aug 2023 13:39:05 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, song.bao.hua@hisilicon.com,
        sjenning@redhat.com, nphamcs@gmail.com,
        cerasuolodomenico@gmail.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-tighten-up-entry-invalidation.patch removed from -mm tree
Message-Id: <20230821203905.A608EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: zswap: tighten up entry invalidation
has been removed from the -mm tree.  Its filename was
     mm-zswap-tighten-up-entry-invalidation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
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


