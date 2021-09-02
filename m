Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A48C43217
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09EB6610A2
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347880AbhIBVzp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:55:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347858AbhIBVzk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:55:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B0A660E8B;
        Thu,  2 Sep 2021 21:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619671;
        bh=V9JwnuXxltUQ4xqwBRV5WPo2eVXq2PvS8CKvoNapaGQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=L9odSsvAwM17yTw5aOPCB+1DCUz8zcYzME0XEZfBa8/V4lcteh4a80iQI1diRSGwY
         IovSkPDJii2KSvdtO8awMl2oPbMJOS6MrQct6ZlA5PCdkniHE0KJ7vD38JB8Wi8DZm
         /zD5NRh5kUfDKHW7GGJabJolCS5vyAtnh7nuubMY=
Date:   Thu, 02 Sep 2021 14:54:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, riel@surriel.com, shakeelb@google.com,
        shy828301@gmail.com, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 087/212] huge tmpfs: move shmem_huge_enabled()
 upwards
Message-ID: <20210902215431.ko_KBRhrD%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
