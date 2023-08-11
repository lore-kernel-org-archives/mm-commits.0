Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DAD6C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234928AbjHKW63 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233844AbjHKW61 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:58:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90E91AE
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:58:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D75064E63
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCB0C433C8;
        Fri, 11 Aug 2023 22:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794705;
        bh=aCh4Moy0dlN4TCzVQYeIiPyC38B2L3VOSBYEu9/bfQU=;
        h=Date:To:From:Subject:From;
        b=Y6c6Qm/v6mfURUispgboQ4SuiV+6TU5l0syhSt65zg/P9s1HCHnquCmtaj6V8CA2X
         4TMg3s10OKa5eYCjx0GqiUvvQYwS1hBu+FIVqLqy9VyCAT+2oQS+38KpDytTrpBbFr
         Qv7T4A6JVa2iInfqDsdTofHx/LbMNCdsYnohIgvg=
Date:   Fri, 11 Aug 2023 15:58:25 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        sdonthineni@nvidia.com, Liam.Howlett@oracle.com,
        tglx@linutronix.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-fix-a-few-documentation-issues.patch removed from -mm tree
Message-Id: <20230811225825.BFCB0C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: fix a few documentation issues
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-a-few-documentation-issues.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -5750,7 +5750,11 @@ EXPORT_SYMBOL_GPL(mas_next_range);
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
@@ -5856,7 +5860,11 @@ EXPORT_SYMBOL_GPL(mas_prev_range);
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
@@ -6468,9 +6476,15 @@ EXPORT_SYMBOL(mtree_destroy);
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
@@ -6528,7 +6542,9 @@ EXPORT_SYMBOL(mt_find);
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


