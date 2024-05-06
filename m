Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3516628DDE
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957085; cv=none; b=tBEB8p4kwo7mk9DzKxOOeiJ1LNs9uD+7BK+8XGcDv37PF0Pr0sTgkR50HX+BKXVb3Q5dbXXQSn7kiK6Tq6lNzNgHWadrxryHWAiLsRf4NDp9BoWtxL5aEzkvD8ZmlS6ghuHU2Gt4COs1hgBCoUJLzCU8hs5UfxbqTguqHRxmd1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957085; c=relaxed/simple;
	bh=rBQuavvOKyOqWTh5TpuPqcoYbwR3WDLe/6ehw6GdC0U=;
	h=Date:To:From:Subject:Message-Id; b=SNImBgVVxvPxuEeOrZhVcJxVpiSlex2sok1AjcTzImi5jqderaAujiiH2orexsTB4mfG3pagQjfjPtNAUGpmaXepv9PGRUJeaNfwCwHqfXOr/HBvJYiETWPlEBoq4iaEXqCrrHIFk46xE9nTxidRZVshwy+oZWFZqVGu6kOe/nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vz5K2jw4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vz5K2jw4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0251DC113CC;
	Mon,  6 May 2024 00:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957085;
	bh=rBQuavvOKyOqWTh5TpuPqcoYbwR3WDLe/6ehw6GdC0U=;
	h=Date:To:From:Subject:From;
	b=Vz5K2jw4TdB58MJ51vTeNJ9pEw9eOqTI5/p/yUU8ZRoAALSPcr49vKPDQF95of2TG
	 ly968iSMkTUE2HUR3lJQJOmH8LgaTJgcMyUM8NbtqYeNufxqWut/t6zR7hblOBaj29
	 r5jl+9Bofmj7KncEx4vfkDo04OKTyd4GVcv9VdQU=
Date: Sun, 05 May 2024 17:58:04 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,linmiaohe@huawei.com,jane.chu@oracle.com,dan.j.williams@intel.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-pass-addr-to-__add_to_kill.patch removed from -mm tree
Message-Id: <20240506005805.0251DC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: pass addr to __add_to_kill()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-pass-addr-to-__add_to_kill.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/memory-failure: pass addr to __add_to_kill()
Date: Fri, 12 Apr 2024 20:34:59 +0100

Handle anon/file folios the same way as KSM & DAX folios by passing in the
address.

Link: https://lkml.kernel.org/r/20240412193510.2356957-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-pass-addr-to-__add_to_kill
+++ a/mm/memory-failure.c
@@ -443,7 +443,7 @@ static void __add_to_kill(struct task_st
 		return;
 	}
 
-	tk->addr = addr ? addr : page_address_in_vma(p, vma);
+	tk->addr = addr;
 	if (is_zone_device_page(p))
 		tk->size_shift = dev_pagemap_mapping_shift(vma, tk->addr);
 	else
@@ -476,7 +476,8 @@ static void add_to_kill_anon_file(struct
 				  struct vm_area_struct *vma,
 				  struct list_head *to_kill)
 {
-	__add_to_kill(tsk, p, vma, to_kill, 0);
+	unsigned long addr = page_address_in_vma(p, vma);
+	__add_to_kill(tsk, p, vma, to_kill, addr);
 }
 
 #ifdef CONFIG_KSM
@@ -492,6 +493,7 @@ static bool task_in_to_kill_list(struct
 
 	return false;
 }
+
 void add_to_kill_ksm(struct task_struct *tsk, struct page *p,
 		     struct vm_area_struct *vma, struct list_head *to_kill,
 		     unsigned long addr)
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

