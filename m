Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8004DC43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379896AbiFQC7M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379885AbiFQC7F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:59:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F5A65D09
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:59:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79CA7B826F3
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39184C3411A;
        Fri, 17 Jun 2022 02:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434741;
        bh=hu5bBTmquW2feY2E923j9GYYxQH6mNsDWqN0wtNej7E=;
        h=Date:To:From:Subject:From;
        b=Q5trszsk6/XPti8Q6zmYTooD63KiXSqPVmT3JM1uUVLYEKLl1bclf3PgdZEbGIqYj
         I9HeV6F0LFOlZdzEUgwHHJTT8lxpvJlRRF+MR3CZrQs+hipNCHvNxU1hK707FGJXp5
         92Sfh4uE3JNJIiUfjbvZuNYWsE8q+vGnU6503iP4=
Date:   Thu, 16 Jun 2022 19:59:00 -0700
To:     mm-commits@vger.kernel.org, peterz@infradead.org, jolsa@redhat.com,
        acme@redhat.com, wuchi.zero@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-btree-simplify-btree_lookupupdate.patch removed from -mm tree
Message-Id: <20220617025901.39184C3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/btree: simplify btree_{lookup|update}
has been removed from the -mm tree.  Its filename was
     lib-btree-simplify-btree_lookupupdate.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: wuchi <wuchi.zero@gmail.com>
Subject: lib/btree: simplify btree_{lookup|update}
Date: Tue, 7 Jun 2022 21:35:56 +0800

btree_{lookup|update} both need to look up node by key, using the common
parts(add function btree_lookup_node) to simplify code.

Link: https://lkml.kernel.org/r/20220607133556.34732-1-wuchi.zero@gmail.com
Signed-off-by: wuchi <wuchi.zero@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/btree.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

--- a/lib/btree.c~lib-btree-simplify-btree_lookupupdate
+++ a/lib/btree.c
@@ -238,7 +238,7 @@ static int keyzero(struct btree_geo *geo
 	return 1;
 }
 
-void *btree_lookup(struct btree_head *head, struct btree_geo *geo,
+static void *btree_lookup_node(struct btree_head *head, struct btree_geo *geo,
 		unsigned long *key)
 {
 	int i, height = head->height;
@@ -257,7 +257,16 @@ void *btree_lookup(struct btree_head *he
 		if (!node)
 			return NULL;
 	}
+	return node;
+}
+
+void *btree_lookup(struct btree_head *head, struct btree_geo *geo,
+		unsigned long *key)
+{
+	int i;
+	unsigned long *node;
 
+	node = btree_lookup_node(head, geo, key);
 	if (!node)
 		return NULL;
 
@@ -271,23 +280,10 @@ EXPORT_SYMBOL_GPL(btree_lookup);
 int btree_update(struct btree_head *head, struct btree_geo *geo,
 		 unsigned long *key, void *val)
 {
-	int i, height = head->height;
-	unsigned long *node = head->node;
-
-	if (height == 0)
-		return -ENOENT;
-
-	for ( ; height > 1; height--) {
-		for (i = 0; i < geo->no_pairs; i++)
-			if (keycmp(geo, node, i, key) <= 0)
-				break;
-		if (i == geo->no_pairs)
-			return -ENOENT;
-		node = bval(geo, node, i);
-		if (!node)
-			return -ENOENT;
-	}
+	int i;
+	unsigned long *node;
 
+	node = btree_lookup_node(head, geo, key);
 	if (!node)
 		return -ENOENT;
 
_

Patches currently in -mm which might be from wuchi.zero@gmail.com are

lib-debugobjects-fix-stat-count-and-optimize-debug_objects_mem_init.patch

