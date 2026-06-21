Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0CE3655D0
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067101; cv=none; b=BfiJe+akvBn8Eh72hmOh7tozb5uZcEkQegAr/Y33YiiyPayVvNFnyFSvhk6KzYKubmh+UVHSF6FcGIABZ9//lKafUBv/hHhVgtg8ZpPK90NkO9wpHLhpaTAgAnekj3rl+Jno1Cyhq7M8rs5Fy9+BAgM7LnJLQjV60eVBQAUi8gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067101; c=relaxed/simple;
	bh=bMEs3b1eQkbXDI469btLYRVXAlVEi3DfnsuX/KzhmWg=;
	h=Date:To:From:Subject:Message-Id; b=BObtNpUS9N2ci9xwf3LZHHtjgSACnef84yS+PRhQlNEDfXmKGgEJkjrBKf3lucjpH2gr96ebnSvB7ob4OeL1yNuCvWfSBnHKyvbTEHfjEk1sF9cPDFFUZFwmq0muEx32qGa8vEeknKHcShcAjTd+SzFbqfk9X5iNU4bXlEhtojg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jq1vHvGm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jq1vHvGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222121F000E9;
	Sun, 21 Jun 2026 18:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067100;
	bh=6jOkQGAawsZxDPELGxL8V4RuCsUUVgaQEcu4v9IVoS0=;
	h=Date:To:From:Subject;
	b=Jq1vHvGmfH7OZqjDoFFmCYJPafQoygGdBcfWTGk1K3x3c3gor/YuM85faP8tdYIOX
	 AA55RLh8YC3N9YmuDfUuaAQ1Wz9HDfV23sT2svlTwgCsEojo6vRCYWe3mDIP9wNWir
	 00Y5Z69kTbxmolK/fclIyBJScmX1jHW0TKFqf4p0=
Date: Sun, 21 Jun 2026 11:38:19 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@kernel.org,surenb@google.com,songliubraving@fb.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jack@suse.cz,dsterba@suse.com,dev.jain@arm.com,david@kernel.org,clm@fb.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-remove-read_only_thp_for_fs-check-in-hugepage_enabled.patch removed from -mm tree
Message-Id: <20260621183820.222121F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: remove READ_ONLY_THP_FOR_FS check in hugepage_enabled()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-remove-read_only_thp_for_fs-check-in-hugepage_enabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/khugepaged: remove READ_ONLY_THP_FOR_FS check in hugepage_enabled()
Date: Sun, 17 May 2026 09:54:06 -0400

Remove the READ_ONLY_THP_FOR_FS gate and khugepaged for file-backed
pmd-sized hugepages are enabled by the global transparent hugepage
control.  khugepaged can still be enabled by per-size control for anon and
shmem when the global control is off.

Add shmem_hpage_pmd_enabled() stub for !CONFIG_SHMEM to remove
IS_ENABLED(SHMEM) in hugepage_enabled().

Clean up hugepage_enabled() by moving anon code to anon_hpage_enabled().

Link: https://lore.kernel.org/20260517135416.1434539-5-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Nico Pache <npache@redhat.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    2 +-
 mm/khugepaged.c          |   26 ++++++++++++++++----------
 2 files changed, 17 insertions(+), 11 deletions(-)

--- a/include/linux/shmem_fs.h~mm-khugepaged-remove-read_only_thp_for_fs-check-in-hugepage_enabled
+++ a/include/linux/shmem_fs.h
@@ -127,7 +127,7 @@ int shmem_writeout(struct folio *folio,
 void shmem_truncate_range(struct inode *inode, loff_t start, uoff_t end);
 int shmem_unuse(unsigned int type);
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SHMEM)
 unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
 				loff_t write_end, bool shmem_huge_force);
--- a/mm/khugepaged.c~mm-khugepaged-remove-read_only_thp_for_fs-check-in-hugepage_enabled
+++ a/mm/khugepaged.c
@@ -503,26 +503,32 @@ static inline int collapse_test_exit_or_
 		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
 }
 
+static inline bool anon_hpage_enabled(void)
+{
+	if (READ_ONCE(huge_anon_orders_always))
+		return true;
+	if (READ_ONCE(huge_anon_orders_madvise))
+		return true;
+	if (READ_ONCE(huge_anon_orders_inherit) &&
+	    hugepage_global_enabled())
+		return true;
+	return false;
+}
+
 static bool hugepage_enabled(void)
 {
 	/*
 	 * We cover the anon, shmem and the file-backed case here; file-backed
-	 * hugepages, when configured in, are determined by the global control.
+	 * hugepages are determined by the global control.
 	 * Anon hugepages are determined by its per-size mTHP control.
 	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
 	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
 	 */
-	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-	    hugepage_global_enabled())
-		return true;
-	if (READ_ONCE(huge_anon_orders_always))
+	if (hugepage_global_enabled())
 		return true;
-	if (READ_ONCE(huge_anon_orders_madvise))
-		return true;
-	if (READ_ONCE(huge_anon_orders_inherit) &&
-	    hugepage_global_enabled())
+	if (anon_hpage_enabled())
 		return true;
-	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
+	if (shmem_hpage_pmd_enabled())
 		return true;
 	return false;
 }
_

Patches currently in -mm which might be from ziy@nvidia.com are


