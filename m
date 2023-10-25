Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE4B1C25B6B
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbjJYXup (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbjJYXtc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:49:32 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A97719D
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:49:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490B4C433C7;
        Wed, 25 Oct 2023 23:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277748;
        bh=3+gaS3rBE2ywxANL0keH7Ek0e6iW3JEIIx0qbdL7wN0=;
        h=Date:To:From:Subject:From;
        b=ZtHUaSiTrGJrwTjWC13fMjKsV5jqwh6ku5JJ0iiz1I224XzfbJ8A65/9nkYczxh6F
         tztvWE6YMnXr71cN3VAkji6IqrpvV6dXV45GCPPqmq0mOwN7XQJful2Nr8fmUiFEDG
         +Nr8GGVFzhLj4bBkOGscm5n/O1lqIHlcWmAdmd2g=
Date:   Wed, 25 Oct 2023 16:49:07 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rdunlap@infradead.org, James.Bottomley@HansenPartnership.com,
        m.muzzammilashraf@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fixed-multiple-typos-in-multiple-files.patch removed from -mm tree
Message-Id: <20231025234908.490B4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix multiple typos in multiple files
has been removed from the -mm tree.  Its filename was
     mm-fixed-multiple-typos-in-multiple-files.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Muzammil <m.muzzammilashraf@gmail.com>
Subject: mm: fix multiple typos in multiple files
Date: Mon, 23 Oct 2023 17:44:05 +0500

Link: https://lkml.kernel.org/r/20231023124405.36981-1-m.muzzammilashraf@gmail.com
Signed-off-by: Muhammad Muzammil <m.muzzammilashraf@gmail.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muhammad Muzammil <m.muzzammilashraf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    4 ++--
 mm/internal.h         |    2 +-
 mm/memcontrol.c       |    4 ++--
 mm/mmap.c             |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-fixed-multiple-typos-in-multiple-files
+++ a/mm/debug_vm_pgtable.c
@@ -1322,8 +1322,8 @@ static int __init debug_vm_pgtable(void)
 	 * true irrespective of the starting protection value for a
 	 * given page table entry.
 	 *
-	 * Protection based vm_flags combinatins are always linear
-	 * and increasing i.e starting from VM_NONE and going upto
+	 * Protection based vm_flags combinations are always linear
+	 * and increasing i.e starting from VM_NONE and going up to
 	 * (VM_SHARED | READ | WRITE | EXEC).
 	 */
 #define VM_FLAGS_START	(VM_NONE)
--- a/mm/internal.h~mm-fixed-multiple-typos-in-multiple-files
+++ a/mm/internal.h
@@ -592,7 +592,7 @@ extern bool mlock_future_ok(struct mm_st
  * range.
  * "fully mapped" means all the pages of folio is associated with the page
  * table of range while this function just check whether the folio range is
- * within the range [start, end). Funcation caller nees to do page table
+ * within the range [start, end). Function caller needs to do page table
  * check if it cares about the page table association.
  *
  * Typical usage (like mlock or madvise) is:
--- a/mm/memcontrol.c~mm-fixed-multiple-typos-in-multiple-files
+++ a/mm/memcontrol.c
@@ -819,7 +819,7 @@ void __mod_memcg_lruvec_state(struct lru
 	memcg = pn->memcg;
 
 	/*
-	 * The caller from rmap relay on disabled preemption becase they never
+	 * The caller from rmap relies on disabled preemption because they never
 	 * update their counter from in-interrupt context. For these two
 	 * counters we check that the update is never performed from an
 	 * interrupt context while other caller need to have disabled interrupt.
@@ -8044,7 +8044,7 @@ static struct cftype memsw_files[] = {
  *
  * This doesn't check for specific headroom, and it is not atomic
  * either. But with zswap, the size of the allocation is only known
- * once compression has occured, and this optimistic pre-check avoids
+ * once compression has occurred, and this optimistic pre-check avoids
  * spending cycles on compression when there is already no room left
  * or zswap is disabled altogether somewhere in the hierarchy.
  */
--- a/mm/mmap.c~mm-fixed-multiple-typos-in-multiple-files
+++ a/mm/mmap.c
@@ -1223,7 +1223,7 @@ unsigned long do_mmap(struct file *file,
 	 * Does the application expect PROT_READ to imply PROT_EXEC?
 	 *
 	 * (the exception is when the underlying filesystem is noexec
-	 *  mounted, in which case we dont add PROT_EXEC.)
+	 *  mounted, in which case we don't add PROT_EXEC.)
 	 */
 	if ((prot & PROT_READ) && (current->personality & READ_IMPLIES_EXEC))
 		if (!(file && path_noexec(&file->f_path)))
_

Patches currently in -mm which might be from m.muzzammilashraf@gmail.com are


