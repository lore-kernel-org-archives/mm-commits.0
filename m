Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA928C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  7 Jun 2022 22:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383236AbiFGWeC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Jun 2022 18:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383079AbiFGWdV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2022 18:33:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AA71A35AC
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 12:29:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D80660BD6
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 19:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D32BC385A5;
        Tue,  7 Jun 2022 19:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654630185;
        bh=XrwEeC0lAdL0QgRKKwvwYteXOGkr4gqdIKANwV2SUQA=;
        h=Date:To:From:Subject:From;
        b=EAbTze7rv+/ofypvfTMNoHDTKWiK9JG6FBC+o6NhLJAdE9Vl9RGXXmVca0Kk0tiIi
         DW67xkt2YaYfBI/d+sMv793VC5QcXrG4JgBYnyD2CEe7egY1bsjSMoDj1vH9ai/B2j
         nCE4spdbTxVTEJRy8EcQb7JYjWpXEnyUTHYHkjc0=
Date:   Tue, 07 Jun 2022 12:29:44 -0700
To:     mm-commits@vger.kernel.org, peterz@infradead.org, jolsa@redhat.com,
        acme@redhat.com, wuchi.zero@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-btree-simplify-btree_lookupupdate.patch added to mm-nonmm-unstable branch
Message-Id: <20220607192945.8D32BC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/btree: simplify btree_{lookup|update}
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-btree-simplify-btree_lookupupdate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-btree-simplify-btree_lookupupdate.patch

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

lib-flex_proportionsc-remove-local_irq_ops-in-fprop_new_period.patch
lib-btree-simplify-btree_lookupupdate.patch

