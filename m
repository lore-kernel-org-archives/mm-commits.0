Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68A02931F1
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 01:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785893124; cv=none; b=hLZWX6Egsv2SJkyq2tN/HI5sdMR6ZW7HcWyJ9vIFJo55YeJkdRJF4Z7wmklTULG9yJYOIPjbKMPV7BNVB1OWB+Qq7EVTF+vlV2ful3vqn2tdxqenRDjWhUQmWnDlhC9uiTZfSdUFaTqeSIII/skBcRcM5bJ+jHfj0aIcsqljoao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785893124; c=relaxed/simple;
	bh=eZ7UdoRYjR3u4LAzVgR8uoTxG5LADqDc+kcviYoUhO8=;
	h=Date:To:From:Subject:Message-Id; b=bkdvl8UBjtBjexpnR3G85EBt10pPmJ8YN8zAVXR2Xj5KA4kMiVu25jeMiVral/vJu2+j9jCp1SIsCxEei3josYuxf2bj/Gv8QVY+Y3StqPtLubrQxfV2rn7jihsUXSS2+DVEHdudHNIA0Q/jioeMR0hT71WblFe/kIDmK4TmTZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xQF6v0zf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xQF6v0zf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749731F000E9;
	Wed,  5 Aug 2026 01:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785893123;
	bh=lizClo/o0ftZGCAaVGC1qnte3d6i0eOGzeSIzXJ1rWk=;
	h=Date:To:From:Subject;
	b=xQF6v0zfOXGV6mX6A3cKbdoEE3YnmbQ8aK7BOlYXfHKVa7CeyikTsD6W8D5w/V784
	 rhGmK6PzqTg+/ONW6iCGO+VUGuEJrBX7qn9yzvCvoFqxuEDtkCSGBHB96t8ODWwwZO
	 A6Y73WUgD+KrHP2jYoqXJhwzHlHY/3jbHB6Z6KP0=
Date: Tue, 04 Aug 2026 18:25:23 -0700
To: mm-commits@vger.kernel.org,liuyongqiang13@huawei.com,hughd@google.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,yujiacheng3@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shmem-downgrade-final-i_blocks-check-in-shmem_evict_inode-to-pr_warn-fix.patch removed from -mm tree
Message-Id: <20260805012523.749731F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-shmem-downgrade-final-i_blocks-check-in-shmem_evict_inode-to-pr_warn-fix
has been removed from the -mm tree.  Its filename was
     mm-shmem-downgrade-final-i_blocks-check-in-shmem_evict_inode-to-pr_warn-fix.patch

This patch was dropped because it was folded into mm-shmem-downgrade-final-i_blocks-check-in-shmem_evict_inode-to-pr_warn.patch

------------------------------------------------------
From: Jiacheng Yu <yujiacheng3@huawei.com>
Subject: mm-shmem-downgrade-final-i_blocks-check-in-shmem_evict_inode-to-pr_warn-fix
Date: Wed, 29 Jul 2026 12:12:00 +0000

drop redundant casts in shmem_evict_inode() pr_warn

blkcnt_t and i_ino are u64, %llu matches both directly, so drop the casts.

Link: https://lore.kernel.org/20260729121201.776566-1-yujiacheng3@huawei.com
Signed-off-by: Jiacheng Yu <yujiacheng3@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Yongqiang Liu <liuyongqiang13@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-downgrade-final-i_blocks-check-in-shmem_evict_inode-to-pr_warn-fix
+++ a/mm/shmem.c
@@ -1442,8 +1442,7 @@ static void shmem_evict_inode(struct ino
 	shmem_free_inode(inode->i_sb, freed);
 	if (inode->i_blocks)
 		pr_warn("%s: ino=%llu i_blocks=%llu alloced=%lu swapped=%lu nrpages=%lu\n",
-			__func__, (unsigned long long)inode->i_ino,
-			(unsigned long long)inode->i_blocks,
+			__func__, inode->i_ino, inode->i_blocks,
 			info->alloced, info->swapped, inode->i_mapping->nrpages);
 	clear_inode(inode);
 #ifdef CONFIG_TMPFS_QUOTA
_

Patches currently in -mm which might be from yujiacheng3@huawei.com are

mm-shmem-downgrade-final-i_blocks-check-in-shmem_evict_inode-to-pr_warn.patch

