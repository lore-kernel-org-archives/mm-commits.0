Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C58F4C00140
	for <mm-commits@archiver.kernel.org>; Wed, 24 Aug 2022 18:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238932AbiHXSRK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 14:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239836AbiHXSRJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 14:17:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFE02DD7
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 11:17:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B441E6174C
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 18:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A87C433C1;
        Wed, 24 Aug 2022 18:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661365027;
        bh=ik2ekqCMp6CA4VtPxvkqj+amIhv34p5TIC82XiU8+uQ=;
        h=Date:To:From:Subject:From;
        b=YbCJLpUAwy+LS6OHPsjLIH/roAtYBAMogZYPI1Niy0BbMRFwOKH9iHDjsseK8cjpN
         Dj3lilleZQXYViAH7kYsMm46e6PPS/RawmK68aYLPII5I7cUbdW8bV8EcCTaC2C9bv
         EJ7+Ab31GHtbmo08IxZzYDU0j4NCUD/qTBS4aS2E=
Date:   Wed, 24 Aug 2022 11:17:06 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-new-data-structure-fix.patch added to mm-unstable branch
Message-Id: <20220824181707.19A87C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix documentation warnings
has been added to the -mm mm-unstable branch.  Its filename is
     maple-tree-add-new-data-structure-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple-tree-add-new-data-structure-fix.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: fix documentation warnings
Date: Tue, 23 Aug 2022 15:22:59 +0000

Update the argument names in the documentation to match the functions

Link: https://lkml.kernel.org/r/20220823152212.1795380-1-Liam.Howlett@oracle.com
Fixes: 96ba2a9525fb (Maple Tree: add new data structure)
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/include/linux/maple_tree.h~maple-tree-add-new-data-structure-fix
+++ a/include/linux/maple_tree.h
@@ -220,7 +220,7 @@ struct maple_tree {
 /**
  * MTREE_INIT() - Initialize a maple tree
  * @name: The maple tree name
- * @flags: The maple tree flags
+ * @__flags: The maple tree flags
  *
  */
 #define MTREE_INIT(name, __flags) {					\
@@ -232,8 +232,8 @@ struct maple_tree {
 /**
  * MTREE_INIT_EXT() - Initialize a maple tree with an external lock.
  * @name: The tree name
- * @flags: The maple tree flags
- * @lock: The external lock
+ * @__flags: The maple tree flags
+ * @__lock: The external lock
  */
 #ifdef CONFIG_LOCKDEP
 #define MTREE_INIT_EXT(name, __flags, __lock) {				\
@@ -509,9 +509,9 @@ static inline void mas_reset(struct ma_s
 
 /**
  * mas_for_each() - Iterate over a range of the maple tree.
- * @mas: Maple Tree operation state (maple_state)
- * @entry: Entry retrieved from the tree
- * @max: maximum index to retrieve from the tree
+ * @__mas: Maple Tree operation state (maple_state)
+ * @__entry: Entry retrieved from the tree
+ * @__max: maximum index to retrieve from the tree
  *
  * When returned, mas->index and mas->last will hold the entire range for the
  * entry.
@@ -646,10 +646,10 @@ void *mt_next(struct maple_tree *mt, uns
 
 /**
  * mt_for_each - Iterate over each entry starting at index until max.
- * @tree: The Maple Tree
- * @entry: The current entry
- * @index: The index to update to track the location in the tree
- * @max: The maximum limit for @index
+ * @__tree: The Maple Tree
+ * @__entry: The current entry
+ * @__index: The index to update to track the location in the tree
+ * @__max: The maximum limit for @index
  *
  * Note: Will not return the zero entry.
  */
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

binder_alloc-add-missing-mmap_lock-calls-when-using-the-vma.patch
maple-tree-add-new-data-structure-fix.patch
mm-vmscan-use-vma-iterator-instead-of-vm_next.patch

