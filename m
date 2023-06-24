Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3244EB64DA
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 20:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjFXUEX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 24 Jun 2023 16:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjFXUEW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 24 Jun 2023 16:04:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A414E10F1
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 13:04:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBFCF60A27
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 20:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11807C433C0;
        Sat, 24 Jun 2023 20:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687637059;
        bh=NizFCxsQrWBFoAPzNKXrtBe5P7GqU4aiqZOD4Y/IwZE=;
        h=Date:To:From:Subject:From;
        b=mkQK75xoUlmmsB/aMdzE8FaMKflconKyN1jZP3++7/qXSgfUp2sVbsxcwy8KBxkgc
         Hb+iA5uooQ8yfqDJWjZ4RIFtHW1799C7ALn08m/QInD4REuKHkYRcq1guDBGTIf6FB
         uODPSyyTrxcrplui6nmJ8iO4aF+HucSLjpmCaKrw=
Date:   Sat, 24 Jun 2023 13:04:18 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        sdonthineni@nvidia.com, Liam.Howlett@oracle.com,
        tglx@linutronix.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-a-few-documentation-issues.patch added to mm-unstable branch
Message-Id: <20230624200419.11807C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix a few documentation issues
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-fix-a-few-documentation-issues.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-a-few-documentation-issues.patch

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
From: Thomas Gleixner <tglx@linutronix.de>
Subject: maple_tree: fix a few documentation issues
Date: Tue, 23 May 2023 22:51:01 +0200

The documentation of mt_next() claims that it starts the search at the
provided index.  That's incorrect as it starts the search after the
provided index.

The documentation of mt_find() is slightly confusing.  "Handles locking"
is not really helpful as it does not explain how the "locking" works. 
Also the documentation of index talks about a range, while in reality the
index is updated on a succesful search to the index of the found entry
plus one.

Fix similar issues for mt_find_after() and mt_prev().

Reword the confusing "Note: Will not return the zero entry." comment on
mt_for_each() and document @__index correctly.

Link: https://lkml.kernel.org/r/87ttw2n556.ffs@tglx
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Shanker Donthineni <sdonthineni@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    5 +++--
 lib/maple_tree.c           |   26 +++++++++++++++++++++-----
 2 files changed, 24 insertions(+), 7 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-fix-a-few-documentation-issues
+++ a/include/linux/maple_tree.h
@@ -662,10 +662,11 @@ void *mt_next(struct maple_tree *mt, uns
  * mt_for_each - Iterate over each entry starting at index until max.
  * @__tree: The Maple Tree
  * @__entry: The current entry
- * @__index: The index to update to track the location in the tree
+ * @__index: The index to start the search from. Subsequently used as iterator.
  * @__max: The maximum limit for @index
  *
- * Note: Will not return the zero entry.
+ * This iterator skips all entries, which resolve to a NULL pointer,
+ * e.g. entries which has been reserved with XA_ZERO_ENTRY.
  */
 #define mt_for_each(__tree, __entry, __index, __max) \
 	for (__entry = mt_find(__tree, &(__index), __max); \
--- a/lib/maple_tree.c~maple_tree-fix-a-few-documentation-issues
+++ a/lib/maple_tree.c
@@ -5749,7 +5749,11 @@ EXPORT_SYMBOL_GPL(mas_next_range);
  * @index: The start index
  * @max: The maximum index to check
  *
- * Return: The entry at @index or higher, or %NULL if nothing is found.
+ * Takes RCU read lock internally to protect the search, which does not
+ * protect the returned pointer after dropping RCU read lock.
+ * See also: Documentation/core-api/maple_tree.rst
+ *
+ * Return: The entry higher than @index or %NULL if nothing is found.
  */
 void *mt_next(struct maple_tree *mt, unsigned long index, unsigned long max)
 {
@@ -5855,7 +5859,11 @@ EXPORT_SYMBOL_GPL(mas_prev_range);
  * @index: The start index
  * @min: The minimum index to check
  *
- * Return: The entry at @index or lower, or %NULL if nothing is found.
+ * Takes RCU read lock internally to protect the search, which does not
+ * protect the returned pointer after dropping RCU read lock.
+ * See also: Documentation/core-api/maple_tree.rst
+ *
+ * Return: The entry before @index or %NULL if nothing is found.
  */
 void *mt_prev(struct maple_tree *mt, unsigned long index, unsigned long min)
 {
@@ -6467,9 +6475,15 @@ EXPORT_SYMBOL(mtree_destroy);
  * mt_find() - Search from the start up until an entry is found.
  * @mt: The maple tree
  * @index: Pointer which contains the start location of the search
- * @max: The maximum value to check
+ * @max: The maximum value of the search range
  *
- * Handles locking.  @index will be incremented to one beyond the range.
+ * Takes RCU read lock internally to protect the search, which does not
+ * protect the returned pointer after dropping RCU read lock.
+ * See also: Documentation/core-api/maple_tree.rst
+ *
+ * In case that an entry is found @index is updated to point to the next
+ * possible entry independent whether the found entry is occupying a
+ * single index or a range if indices.
  *
  * Return: The entry at or after the @index or %NULL
  */
@@ -6527,7 +6541,9 @@ EXPORT_SYMBOL(mt_find);
  * @index: Pointer which contains the start location of the search
  * @max: The maximum value to check
  *
- * Handles locking, detects wrapping on index == 0
+ * Same as mt_find() except that it checks @index for 0 before
+ * searching. If @index == 0, the search is aborted. This covers a wrap
+ * around of @index to 0 in an iterator loop.
  *
  * Return: The entry at or after the @index or %NULL
  */
_

Patches currently in -mm which might be from tglx@linutronix.de are

maple_tree-fix-a-few-documentation-issues.patch

