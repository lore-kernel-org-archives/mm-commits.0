Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D121C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F20760E76
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350399AbhICU6M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350309AbhICU6F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:58:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7482C60E76;
        Fri,  3 Sep 2021 20:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702624;
        bh=ux9L6M49WyB5bZ8dj8HkRRl8+FJLOiBsUchYTHH6X9Y=;
        h=Date:From:To:Subject:From;
        b=AU8WXqyyl70C2AvlG2kT32RBivfXgj66GCEjcR9zwUTDgmk+QSVrjG5dqkCT46rtA
         ln0FZrJXjxrLEvAiUs0Qdql097IZdMz8975fPUXD/yepdI0CetLGUQOuMV7PMMutgV
         yNb40y6t7+JuCuP2ErzE4uxryqyJwQWA7XJkZXnA=
Date:   Fri, 03 Sep 2021 13:57:04 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, riel@surriel.com, shakeelb@google.com,
        shy828301@gmail.com, willy@infradead.org
Subject:  [merged] huge-tmpfs-move-shmem_huge_enabled-upwards.patch
 removed from -mm tree
Message-ID: <20210903205704.rSKtMvuC4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: move shmem_huge_enabled() upwards
has been removed from the -mm tree.  Its filename was
     huge-tmpfs-move-shmem_huge_enabled-upwards.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


