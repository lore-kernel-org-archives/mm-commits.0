Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37CC0C4320A
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 20:10:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 253AB6103A
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 20:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233843AbhHQUL1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 Aug 2021 16:11:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233841AbhHQUL0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 17 Aug 2021 16:11:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B6ED60F41;
        Tue, 17 Aug 2021 20:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629231052;
        bh=VevWRjEFwmI2gDJz7PqkzQlq8fBbRROoMp4LzzoCLLw=;
        h=Date:From:To:Subject:From;
        b=ij3m14omMsG/4YK7ciWMDBsJTvMunUPOgxQDZzLrVDtdJRSSGoQ7FgzdajgKTg22l
         M0tM4CDoP7nYwaFJ5Jj5d+OFbxBQSZ2BqHSLNSKlz993Fr/Dk/ZlAm5aUoNhzEK0fx
         aeqbmYmYnUZ5z3jvriOg1P80g49ECHMlhXUam+2U=
Date:   Tue, 17 Aug 2021 13:10:52 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shy828301@gmail.com, shakeelb@google.com, riel@surriel.com,
        mike.kravetz@oracle.com, mhocko@suse.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, hughd@google.com
Subject:  + huge-tmpfs-move-shmem_huge_enabled-upwards.patch added to
 -mm tree
Message-ID: <20210817201052.m4tht%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: move shmem_huge_enabled() upwards
has been added to the -mm tree.  Its filename is
     huge-tmpfs-move-shmem_huge_enabled-upwards.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/huge-tmpfs-move-shmem_huge_enabled-upwards.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/huge-tmpfs-move-shmem_huge_enabled-upwards.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: huge tmpfs: move shmem_huge_enabled() upwards

shmem_huge_enabled() is about to be enhanced into shmem_is_huge(), so that
it can be used more widely throughout: before making functional changes,
shift it to its final position (to avoid forward declaration).

Link: https://lkml.kernel.org/r/16fec7b7-5c84-415a-8586-69d8bf6a6685@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   72 ++++++++++++++++++++++++---------------------------
 1 file changed, 35 insertions(+), 37 deletions(-)

--- a/mm/shmem.c~huge-tmpfs-move-shmem_huge_enabled-upwards
+++ a/mm/shmem.c
@@ -473,6 +473,41 @@ static bool shmem_confirm_swap(struct ad
 
 static int shmem_huge __read_mostly;
 
+bool shmem_huge_enabled(struct vm_area_struct *vma)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
+	loff_t i_size;
+	pgoff_t off;
+
+	if ((vma->vm_flags & VM_NOHUGEPAGE) ||
+	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
+		return false;
+	if (shmem_huge == SHMEM_HUGE_FORCE)
+		return true;
+	if (shmem_huge == SHMEM_HUGE_DENY)
+		return false;
+	switch (sbinfo->huge) {
+	case SHMEM_HUGE_NEVER:
+		return false;
+	case SHMEM_HUGE_ALWAYS:
+		return true;
+	case SHMEM_HUGE_WITHIN_SIZE:
+		off = round_up(vma->vm_pgoff, HPAGE_PMD_NR);
+		i_size = round_up(i_size_read(inode), PAGE_SIZE);
+		if (i_size >= HPAGE_PMD_SIZE &&
+				i_size >> PAGE_SHIFT >= off)
+			return true;
+		fallthrough;
+	case SHMEM_HUGE_ADVISE:
+		/* TODO: implement fadvise() hints */
+		return (vma->vm_flags & VM_HUGEPAGE);
+	default:
+		VM_BUG_ON(1);
+		return false;
+	}
+}
+
 #if defined(CONFIG_SYSFS)
 static int shmem_parse_huge(const char *str)
 {
@@ -3979,43 +4014,6 @@ struct kobj_attribute shmem_enabled_attr
 	__ATTR(shmem_enabled, 0644, shmem_enabled_show, shmem_enabled_store);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE && CONFIG_SYSFS */
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-bool shmem_huge_enabled(struct vm_area_struct *vma)
-{
-	struct inode *inode = file_inode(vma->vm_file);
-	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
-	loff_t i_size;
-	pgoff_t off;
-
-	if ((vma->vm_flags & VM_NOHUGEPAGE) ||
-	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
-		return false;
-	if (shmem_huge == SHMEM_HUGE_FORCE)
-		return true;
-	if (shmem_huge == SHMEM_HUGE_DENY)
-		return false;
-	switch (sbinfo->huge) {
-		case SHMEM_HUGE_NEVER:
-			return false;
-		case SHMEM_HUGE_ALWAYS:
-			return true;
-		case SHMEM_HUGE_WITHIN_SIZE:
-			off = round_up(vma->vm_pgoff, HPAGE_PMD_NR);
-			i_size = round_up(i_size_read(inode), PAGE_SIZE);
-			if (i_size >= HPAGE_PMD_SIZE &&
-					i_size >> PAGE_SHIFT >= off)
-				return true;
-			fallthrough;
-		case SHMEM_HUGE_ADVISE:
-			/* TODO: implement fadvise() hints */
-			return (vma->vm_flags & VM_HUGEPAGE);
-		default:
-			VM_BUG_ON(1);
-			return false;
-	}
-}
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-
 #else /* !CONFIG_SHMEM */
 
 /*
_

Patches currently in -mm which might be from hughd@google.com are

fs-mm-fix-race-in-unlinking-swapfile.patch
huge-tmpfs-fix-fallocatevanilla-advance-over-huge-pages.patch
huge-tmpfs-fix-split_huge_page-after-falloc_fl_keep_size.patch
huge-tmpfs-remove-shrinklist-addition-from-shmem_setattr.patch
huge-tmpfs-revert-shmems-use-of-transhuge_vma_enabled.patch
huge-tmpfs-move-shmem_huge_enabled-upwards.patch
huge-tmpfs-sgp_noalloc-to-stop-collapse_file-on-race.patch
huge-tmpfs-shmem_is_hugevma-inode-index.patch
huge-tmpfs-decide-statst_blksize-by-shmem_is_huge.patch
shmem-shmem_writepage-split-unlikely-i915-thp.patch

