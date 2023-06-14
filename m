Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03E00EB64D9
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jun 2023 19:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236967AbjFNToQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Jun 2023 15:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238602AbjFNToN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Jun 2023 15:44:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E794C1FCA
        for <mm-commits@vger.kernel.org>; Wed, 14 Jun 2023 12:43:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65F4F62C2E
        for <mm-commits@vger.kernel.org>; Wed, 14 Jun 2023 19:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E35C433C0;
        Wed, 14 Jun 2023 19:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686771823;
        bh=8E2zkqDaDOEIQwyXhk1/r6xfYqRbqu/Jc8QajjpPnFQ=;
        h=Date:To:From:Subject:From;
        b=by1LgYrIOoqG9nhASo1PsldMVsTvJlLCblUQasHIZLGNM47Aw73aWayoqcS4kN3gf
         A/UH451myVOLSdghXfswYGU7fmcqmo52q2tU8JHf4mfjN51i1neJe79p3Jdz1ng8Rw
         zqlDi12nx1CAV10K/nLtV/JT0eFWBgubxUAtta2Q=
Date:   Wed, 14 Jun 2023 12:43:43 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, nphamcs@gmail.com,
        hannes@cmpxchg.org, ddstreet@ieee.org, cerasuolodomenico@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-invaldiate-entry-after-writeback.patch added to mm-unstable branch
Message-Id: <20230614194343.B6E35C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: zswap: invaldiate entry after writeback
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-invaldiate-entry-after-writeback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-invaldiate-entry-after-writeback.patch

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
From: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Subject: mm: zswap: invaldiate entry after writeback
Date: Wed, 14 Jun 2023 16:31:22 +0200

When an entry started writeback, it used to be invalidated with ref count
logic alone, meaning that it would stay on the tree until all references
were put.  The problem with this behavior is that as soon as the writeback
started, the ownership of the data held by the entry is passed to the
swapcache and should not be left in zswap too.  Currently there are no
known issues because of this, but this change explicitly invalidates an
entry that started writeback to reduce opportunities for future bugs.

This patch is a follow up on the series titled "mm: zswap: move writeback
LRU from zpool to zswap" + commit f090b7949768("mm: zswap: support
exclusive loads").

Link: https://lkml.kernel.org/r/20230614143122.74471-1-cerasuolodomenico@gmail.com
Signed-off-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/mm/zswap.c~mm-zswap-invaldiate-entry-after-writeback
+++ a/mm/zswap.c
@@ -599,6 +599,16 @@ static struct zswap_pool *zswap_pool_fin
 	return NULL;
 }
 
+static void zswap_invalidate_entry(struct zswap_tree *tree,
+				   struct zswap_entry *entry)
+{
+	/* remove from rbtree */
+	zswap_rb_erase(&tree->rbroot, entry);
+
+	/* drop the initial reference from entry creation */
+	zswap_entry_put(tree, entry);
+}
+
 static int zswap_reclaim_entry(struct zswap_pool *pool)
 {
 	struct zswap_entry *entry;
@@ -644,12 +654,13 @@ static int zswap_reclaim_entry(struct zs
 		goto put_unlock;
 	}
 
-	/* Check for invalidate() race */
-	if (entry != zswap_rb_search(&tree->rbroot, swpoffset))
-		goto put_unlock;
-
-	/* Drop base reference */
-	zswap_entry_put(tree, entry);
+	/*
+	 * Writeback started successfully, the page now belongs to the
+	 * swapcache. Drop the entry from zswap - unless invalidate already
+	 * took it out while we had the tree->lock released for IO.
+	 */
+	if (entry == zswap_rb_search(&tree->rbroot, swpoffset))
+		zswap_invalidate_entry(tree, entry);
 
 put_unlock:
 	/* Drop local reference */
@@ -1383,16 +1394,6 @@ shrink:
 	goto reject;
 }
 
-static void zswap_invalidate_entry(struct zswap_tree *tree,
-				   struct zswap_entry *entry)
-{
-	/* remove from rbtree */
-	zswap_rb_erase(&tree->rbroot, entry);
-
-	/* drop the initial reference from entry creation */
-	zswap_entry_put(tree, entry);
-}
-
 /*
  * returns 0 if the page was successfully decompressed
  * return -1 on entry not found or error
_

Patches currently in -mm which might be from cerasuolodomenico@gmail.com are

mm-zswap-add-pool-shrinking-mechanism.patch
mm-zswap-remove-page-reclaim-logic-from-zbud.patch
mm-zswap-remove-page-reclaim-logic-from-z3fold.patch
mm-zswap-remove-page-reclaim-logic-from-zsmalloc.patch
mm-zswap-remove-shrink-from-zpool-interface.patch
mm-zswap-simplify-writeback-function.patch
mm-zswap-remove-zswap_header.patch
mm-zswap-invaldiate-entry-after-writeback.patch

