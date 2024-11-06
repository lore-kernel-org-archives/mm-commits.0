Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B3113D52B
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854821; cv=none; b=qYby6zMurSnmKLG9vR8bUp8Kz+nlAizv3KFNxoFVt3/7Mr0O8K84wMtkBo6MvavpzaDHijFB2tQBo8H+w11l4BdVimYhBtOWyshofUT1gAEVcMipH6o/Z1uz+eaOHG33S1SgD0+lbOMNudOjms9FRh9zL1CZFXRlt/lWg3uVvF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854821; c=relaxed/simple;
	bh=QbX+vu818RsewWaZmp7wCMhdoXkkn+T96p/WzV2/EhY=;
	h=Date:To:From:Subject:Message-Id; b=cw6nPpFrknT4RD171suYfgIhEl1MHpUKqpILRztWyi4ehMqwEwzqXUv+NAnvy4tOf/M1TXxMVIRcVsnSlO+DxOuf78hCIaDmF1b5jb0861ZoL9d+S0NlX+3cv1985+WXV3jZxEQtlq14PIWcuyDPNAECStdZaTHBLy0z6O74YH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eW4CL5KV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eW4CL5KV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ACF3C4CECF;
	Wed,  6 Nov 2024 01:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854821;
	bh=QbX+vu818RsewWaZmp7wCMhdoXkkn+T96p/WzV2/EhY=;
	h=Date:To:From:Subject:From;
	b=eW4CL5KVVvcqoQ20oJiDsdqYo4fg7TTbG4wVkdBiJNMgl+AppsriWeFtupQS24Pch
	 yFmSMP22U/NpW+8cNV4LXF5cxrSMwUBjCxv6aAXOi5nt7QHmE+NxLQ7kmEwf2mZFAg
	 44G0VVcI4Tmmjvl4YKGnmT+VDiGTVlXtyyhg+hbw=
Date: Tue, 05 Nov 2024 17:00:20 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-move-file_thp_enabled-into-huge_memoryc.patch removed from -mm tree
Message-Id: <20241106010021.6ACF3C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: huge_memory: move file_thp_enabled() into huge_memory.c
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-move-file_thp_enabled-into-huge_memoryc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: huge_memory: move file_thp_enabled() into huge_memory.c
Date: Thu, 17 Oct 2024 22:14:56 +0800

file_thp_enabled() is only used in __thp_vma_allowable_orders(), so move
it into huge_memory.c, also check READ_ONLY_THP_FOR_FS ahead to avoid
unnecessary code if config disabled.

Link: https://lkml.kernel.org/r/20241017141457.1169092-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   13 -------------
 mm/huge_memory.c        |   15 +++++++++++++++
 2 files changed, 15 insertions(+), 13 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-move-file_thp_enabled-into-huge_memoryc
+++ a/include/linux/huge_mm.h
@@ -253,19 +253,6 @@ static inline unsigned long thp_vma_suit
 	return orders;
 }
 
-static inline bool file_thp_enabled(struct vm_area_struct *vma)
-{
-	struct inode *inode;
-
-	if (!vma->vm_file)
-		return false;
-
-	inode = vma->vm_file->f_inode;
-
-	return (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS)) &&
-	       !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
-}
-
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 unsigned long vm_flags,
 					 unsigned long tva_flags,
--- a/mm/huge_memory.c~mm-huge_memory-move-file_thp_enabled-into-huge_memoryc
+++ a/mm/huge_memory.c
@@ -83,6 +83,21 @@ unsigned long huge_anon_orders_madvise _
 unsigned long huge_anon_orders_inherit __read_mostly;
 static bool anon_orders_configured __initdata;
 
+static inline bool file_thp_enabled(struct vm_area_struct *vma)
+{
+	struct inode *inode;
+
+	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
+		return false;
+
+	if (!vma->vm_file)
+		return false;
+
+	inode = file_inode(vma->vm_file);
+
+	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
+}
+
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 unsigned long vm_flags,
 					 unsigned long tva_flags,
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-use-aligned-address-in-clear_gigantic_page.patch
mm-use-aligned-address-in-copy_user_gigantic_page.patch

