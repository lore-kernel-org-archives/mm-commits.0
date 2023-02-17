Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C83C05027
	for <mm-commits@archiver.kernel.org>; Fri, 17 Feb 2023 04:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjBQEpz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Feb 2023 23:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjBQEpD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2023 23:45:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D06564B4
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 20:44:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 338E061366
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2023 04:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89221C433D2;
        Fri, 17 Feb 2023 04:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676609093;
        bh=lzivtJV8u28vLIBK994zXciEa5kNNnrLpgtemOcysaU=;
        h=Date:To:From:Subject:From;
        b=aQfXU/ZI9tut52A/sCLTmqK6JKLTh7xpMJJONTa2YJlI0het19SNvJIcXny+skhY9
         HcW88sBntll8w/M1x0bf32ha3Lpsh7YHIk+Zw8OimYYEkO6tPCELC83QbeUTsEDFtM
         DdgxPqAa/GdQU5mUfa0MTNoyK/6ta/NymbdIOE4Q=
Date:   Thu, 16 Feb 2023 20:44:52 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        vernon2gm@gmail.com, ryabinin.a.a@gmail.com,
        Liam.Howlett@oracle.com, glider@google.com, dvyukov@google.com,
        david@redhat.com, andreyknvl@gmail.com, arnd@arndb.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-reduce-stack-usage-with-gcc-9-and-earlier.patch removed from -mm tree
Message-Id: <20230217044453.89221C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: reduce stack usage with gcc-9 and earlier
has been removed from the -mm tree.  Its filename was
     maple_tree-reduce-stack-usage-with-gcc-9-and-earlier.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
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

kasan-mark-addr_has_metadata-__always_inline.patch
kmsan-disable-ftrace-in-kmsan-core-code.patch
objtool-add-uaccess-exceptions-for-__tsan_volatile_read-write.patch

