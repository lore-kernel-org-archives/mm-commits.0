Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12F95C61DA4
	for <mm-commits@archiver.kernel.org>; Tue, 14 Feb 2023 19:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbjBNTlk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Feb 2023 14:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBNTlj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2023 14:41:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 588B02BEF2
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2023 11:41:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C290DB81EBE
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2023 19:41:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67615C4339B;
        Tue, 14 Feb 2023 19:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676403695;
        bh=hpjB1DfN0z9MwO2rUFR4yJfGEYrCpu6VgD4/y8+7FSA=;
        h=Date:To:From:Subject:From;
        b=ojFZYEFg5i6g+oIImoaU6CyxEfRKVeZtB1TVVrBNWT05pFOw10J8RfNQE2Q8lh3TG
         aa/DxB0xsHjatNpvVrdzXAuxyHz+WntU6Ly/Xj55p5QyxnMWSJaeKZJ+aRX7Vdhus9
         VXWmfsHv19oubI/DLHN8AmM5LCsp0gDSTa8CZ900=
Date:   Tue, 14 Feb 2023 11:41:34 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        vernon2gm@gmail.com, ryabinin.a.a@gmail.com,
        Liam.Howlett@Oracle.com, glider@google.com, dvyukov@google.com,
        david@redhat.com, andreyknvl@gmail.com, arnd@arndb.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-reduce-stack-usage-with-gcc-9-and-earlier.patch added to mm-unstable branch
Message-Id: <20230214194135.67615C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: reduce stack usage with gcc-9 and earlier
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-reduce-stack-usage-with-gcc-9-and-earlier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-reduce-stack-usage-with-gcc-9-and-earlier.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: maple_tree: reduce stack usage with gcc-9 and earlier
Date: Tue, 14 Feb 2023 11:30:24 +0100

gcc-10 changed the way inlining works to be less aggressive, but older
versions run into an oversized stack frame warning whenever
CONFIG_KASAN_STACK is enabled, as that forces variables from inlined
callees to be non-overlapping:

lib/maple_tree.c: In function 'mas_wr_bnode':
lib/maple_tree.c:4320:1: error: the frame size of 1424 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

Change the annotations on mas_store_b_node() and mas_commit_b_node()
to explicitly forbid inlining in this configuration, which is
the same behavior that newer versions already have.

Link: https://lkml.kernel.org/r/20230214103030.1051950-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/maple_tree.c~maple_tree-reduce-stack-usage-with-gcc-9-and-earlier
+++ a/lib/maple_tree.c
@@ -146,6 +146,13 @@ struct maple_subtree_state {
 	struct maple_big_node *bn;
 };
 
+#ifdef CONFIG_KASAN_STACK
+/* Prevent mas_wr_bnode() from exceeding the stack frame limit */
+#define noinline_for_kasan noinline_for_stack
+#else
+#define noinline_for_kasan inline
+#endif
+
 /* Functions */
 static inline struct maple_node *mt_alloc_one(gfp_t gfp)
 {
@@ -2107,7 +2114,7 @@ static inline void mas_bulk_rebalance(st
  *
  * Return: The actual end of the data stored in @b_node
  */
-static inline void mas_store_b_node(struct ma_wr_state *wr_mas,
+static noinline_for_kasan void mas_store_b_node(struct ma_wr_state *wr_mas,
 		struct maple_big_node *b_node, unsigned char offset_end)
 {
 	unsigned char slot;
@@ -3579,7 +3586,7 @@ static inline bool mas_reuse_node(struct
  * @b_node: The maple big node
  * @end: The end of the data.
  */
-static inline int mas_commit_b_node(struct ma_wr_state *wr_mas,
+static noinline_for_kasan int mas_commit_b_node(struct ma_wr_state *wr_mas,
 			    struct maple_big_node *b_node, unsigned char end)
 {
 	struct maple_node *node;
_

Patches currently in -mm which might be from arnd@arndb.de are

maple_tree-reduce-stack-usage-with-gcc-9-and-earlier.patch

