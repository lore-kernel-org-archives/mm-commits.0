Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FDFFC433B4
	for <mm-commits@archiver.kernel.org>; Tue, 13 Apr 2021 17:50:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC48D613BB
	for <mm-commits@archiver.kernel.org>; Tue, 13 Apr 2021 17:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbhDMRvH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:51:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231238AbhDMRvG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Apr 2021 13:51:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D861613B6;
        Tue, 13 Apr 2021 17:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618336246;
        bh=B6AujFWH1YmlX7n4mkBokgdyvIkLMKkxSzzhmc6TP3M=;
        h=Date:From:To:Subject:From;
        b=FmC0U9xUTz2XGYsUkP0I4owXJq0sQbnGKv3+Jun4oO/5PwLxFl4QMYGPs5X7kvStp
         0gAcBmsasH9DqNkgpc5gVrBb0v4BcCtTxiob8Zz74xiGMhZun/BpCbKmjVRIxqZuDA
         HTSaS05Ttz3ZhvJTe7yBzS7+S1+PEqZt+YPxX1ZY=
Date:   Tue, 13 Apr 2021 10:50:46 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
        jiri@nvidia.com, rdunlap@infradead.org
Subject:  + lib-remove-expecting-prototype-kernel-doc-warnings.patch
 added to -mm tree
Message-ID: <20210413175046.kzFKp%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: remove "expecting prototype" kernel-doc warnings
has been added to the -mm tree.  Its filename is
     lib-remove-expecting-prototype-kernel-doc-warnings.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-remove-expecting-prototype-kernel-doc-warnings.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-remove-expecting-prototype-kernel-doc-warnings.patch

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
Subject: lib: remove "expecting prototype" kernel-doc warnings

Fix various kernel-doc warnings in lib/ due to missing or
erroneous function names.
Add kernel-doc for some function parameters that was missing.
Use kernel-doc "Return:" notation in earlycpio.c.

Quietens the following warnings:

../lib/earlycpio.c:61: warning: expecting prototype for cpio_data find_cpio_data(). Prototype was for find_cpio_data() instead

../lib/lru_cache.c:640: warning: expecting prototype for lc_dump(). Prototype was for lc_seq_dump_details() instead
lru_cache.c:90: warning: Function parameter or member 'cache' not described in 'lc_create'

../lib/parman.c:368: warning: expecting prototype for parman_item_del(). Prototype was for parman_item_remove() instead
parman.c:309: warning: Excess function parameter 'prority' description in 'parman_prio_init'

../lib/radix-tree.c:703: warning: expecting prototype for __radix_tree_insert(). Prototype was for radix_tree_insert() instead
radix-tree.c:180: warning: Excess function parameter 'addr' description in 'radix_tree_find_next_bit'
radix-tree.c:180: warning: Excess function parameter 'size' description in 'radix_tree_find_next_bit'
radix-tree.c:931: warning: Function parameter or member 'iter' not described in 'radix_tree_iter_replace'

Link: https://lkml.kernel.org/r/20210411221756.15461-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Jiri Pirko <jiri@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/earlycpio.c  |    4 ++--
 lib/lru_cache.c  |    3 ++-
 lib/parman.c     |    4 ++--
 lib/radix-tree.c |   11 ++++++-----
 4 files changed, 12 insertions(+), 10 deletions(-)

--- a/lib/earlycpio.c~lib-remove-expecting-prototype-kernel-doc-warnings
+++ a/lib/earlycpio.c
@@ -40,7 +40,7 @@ enum cpio_fields {
 };
 
 /**
- * cpio_data find_cpio_data - Search for files in an uncompressed cpio
+ * find_cpio_data - Search for files in an uncompressed cpio
  * @path:       The directory to search for, including a slash at the end
  * @data:       Pointer to the cpio archive or a header inside
  * @len:        Remaining length of the cpio based on data pointer
@@ -49,7 +49,7 @@ enum cpio_fields {
  *              matching file itself. It can be used to iterate through the cpio
  *              to find all files inside of a directory path.
  *
- * @return:     struct cpio_data containing the address, length and
+ * Return:      &struct cpio_data containing the address, length and
  *              filename (with the directory path cut off) of the found file.
  *              If you search for a filename and not for files in a directory,
  *              pass the absolute path of the filename in the cpio and make sure
--- a/lib/lru_cache.c~lib-remove-expecting-prototype-kernel-doc-warnings
+++ a/lib/lru_cache.c
@@ -76,6 +76,7 @@ int lc_try_lock(struct lru_cache *lc)
 /**
  * lc_create - prepares to track objects in an active set
  * @name: descriptive name only used in lc_seq_printf_stats and lc_seq_dump_details
+ * @cache: cache root pointer
  * @max_pending_changes: maximum changes to accumulate until a transaction is required
  * @e_count: number of elements allowed to be active simultaneously
  * @e_size: size of the tracked objects
@@ -627,7 +628,7 @@ void lc_set(struct lru_cache *lc, unsign
 }
 
 /**
- * lc_dump - Dump a complete LRU cache to seq in textual form.
+ * lc_seq_dump_details - Dump a complete LRU cache to seq in textual form.
  * @lc: the lru cache to operate on
  * @seq: the &struct seq_file pointer to seq_printf into
  * @utext: user supplied additional "heading" or other info
--- a/lib/parman.c~lib-remove-expecting-prototype-kernel-doc-warnings
+++ a/lib/parman.c
@@ -297,7 +297,7 @@ EXPORT_SYMBOL(parman_destroy);
  * parman_prio_init - initializes a parman priority chunk
  * @parman:	parman instance
  * @prio:	parman prio structure to be initialized
- * @prority:	desired priority of the chunk
+ * @priority:	desired priority of the chunk
  *
  * Note: all locking must be provided by the caller.
  *
@@ -356,7 +356,7 @@ int parman_item_add(struct parman *parma
 EXPORT_SYMBOL(parman_item_add);
 
 /**
- * parman_item_del - deletes parman item
+ * parman_item_remove - deletes parman item
  * @parman:	parman instance
  * @prio:	parman prio instance to delete the item from
  * @item:	parman item instance
--- a/lib/radix-tree.c~lib-remove-expecting-prototype-kernel-doc-warnings
+++ a/lib/radix-tree.c
@@ -166,9 +166,9 @@ static inline void all_tag_set(struct ra
 /**
  * radix_tree_find_next_bit - find the next set bit in a memory region
  *
- * @addr: The address to base the search on
- * @size: The bitmap size in bits
- * @offset: The bitnumber to start searching at
+ * @node: where to begin the search
+ * @tag: the tag index
+ * @offset: the bitnumber to start searching at
  *
  * Unrollable variant of find_next_bit() for constant size arrays.
  * Tail bits starting from size to roundup(size, BITS_PER_LONG) must be zero.
@@ -461,7 +461,7 @@ out:
 
 /**
  *	radix_tree_shrink    -    shrink radix tree to minimum height
- *	@root		radix tree root
+ *	@root:		radix tree root
  */
 static inline bool radix_tree_shrink(struct radix_tree_root *root)
 {
@@ -691,7 +691,7 @@ static inline int insert_entries(struct
 }
 
 /**
- *	__radix_tree_insert    -    insert into a radix tree
+ *	radix_tree_insert    -    insert into a radix tree
  *	@root:		radix tree root
  *	@index:		index key
  *	@item:		item to insert
@@ -919,6 +919,7 @@ EXPORT_SYMBOL(radix_tree_replace_slot);
 /**
  * radix_tree_iter_replace - replace item in a slot
  * @root:	radix tree root
+ * @iter:	iterator state
  * @slot:	pointer to slot
  * @item:	new item to store in the slot.
  *
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-eliminate-expecting-prototype-kernel-doc-warnings.patch
csky-change-a-kconfig-symbol-name-to-fix-e1000-build-error.patch
ia64-remove-duplicate-entries-in-generic_defconfig.patch
ia64-fix-discontigc-section-mismatches.patch
lib-remove-expecting-prototype-kernel-doc-warnings.patch
vfs-fs_parser-clean-up-kernel-doc-warnings.patch
lib-parser-clean-up-kernel-doc.patch

