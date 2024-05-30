Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744734D8DD;
	Thu, 30 May 2024 20:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717099551; cv=none; b=I9zh/jeEgNRmw5Dwpo1p2kczZ3VdUEp7Btmd1nQXnSjRLcSAVI5NmVl3PJuzpxxu9f2MD+E1cLdeQUAJV4c+y1Nq7tH6pw67wbCMxXO54CBznvrmp1hLpLPD3itQlP3cnYbki4hwKkts5darxptXhrU9ta8g6LFjO+FcfEIwmt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717099551; c=relaxed/simple;
	bh=EiMlIOlSM0Rwsr2BLYTLTBQ5OLses7NcEFn+0gX9OXo=;
	h=Date:To:From:Subject:Message-Id; b=YTeGSsnzH48KMfngZ+My3JB3UZE6r/nmuaS5Zv4jo8aY62z3wzoghki1O3gYV8DK5rgVNKhQp6JoB8E0LNcSZBL8s8KcumruTzvfd0JH7mZW5MTB1cPZ07cLWpvu7Dr2jW8Kj9NQxdeglvVaUtRK2hho6cTUuwBuO2XLcr3ONMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PqVn6/sR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PqVn6/sR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354DFC2BBFC;
	Thu, 30 May 2024 20:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717099551;
	bh=EiMlIOlSM0Rwsr2BLYTLTBQ5OLses7NcEFn+0gX9OXo=;
	h=Date:To:From:Subject:From;
	b=PqVn6/sR4ObkUi22tt1DxXqDmIVdrdoVo/GNlxl59zamQ5Bz+6Mchw1YIPjmnYm2E
	 G49QluUjuY8GdBxEM4ABomHtT1bAOvwKQRtXLP291SEyqjy+SxCPa4UcN981MNzz6f
	 9r+iQaV0xIAmvCquc9wwjya1W9kxMNl8Ijbyw2N8=
Date: Thu, 30 May 2024 13:05:50 -0700
To: mm-commits@vger.kernel.org,zhaoyang.huang@unisoc.com,xiang@kernel.org,urezki@gmail.com,stable@vger.kernel.org,lstoakes@gmail.com,liuhailong@oppo.com,hch@infradead.org,guangye.yang@mediatek.com,21cnbao@gmail.com,hailong.liu@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-fix-vbq-free-breakage.patch added to mm-hotfixes-unstable branch
Message-Id: <20240530200551.354DFC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: fix vbq->free breakage
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmalloc-fix-vbq-free-breakage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-fix-vbq-free-breakage.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "hailong.liu" <hailong.liu@oppo.com>
Subject: mm/vmalloc: fix vbq->free breakage
Date: Thu, 30 May 2024 17:31:08 +0800

The function xa_for_each() in _vm_unmap_aliases() loops through all vbs. 
However, since commit 062eacf57ad9 ("mm: vmalloc: remove a global
vmap_blocks xarray") the vb from xarray may not be on the corresponding
CPU vmap_block_queue.  Consequently, purge_fragmented_block() might use
the wrong vbq->lock to protect the free list, leading to vbq->free
breakage.

Link: https://lkml.kernel.org/r/20240530093108.4512-1-hailong.liu@oppo.com
Fixes: fc1e0d980037 ("mm/vmalloc: prevent stale TLBs in fully utilized blocks")
Signed-off-by: Hailong.Liu <liuhailong@oppo.com>
Reported-by: Guangye Yang <guangye.yang@mediatek.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Guangye Yang <guangye.yang@mediatek.com>
Cc: liuhailong <liuhailong@oppo.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-vbq-free-breakage
+++ a/mm/vmalloc.c
@@ -2830,10 +2830,9 @@ static void _vm_unmap_aliases(unsigned l
 	for_each_possible_cpu(cpu) {
 		struct vmap_block_queue *vbq = &per_cpu(vmap_block_queue, cpu);
 		struct vmap_block *vb;
-		unsigned long idx;
 
 		rcu_read_lock();
-		xa_for_each(&vbq->vmap_blocks, idx, vb) {
+		list_for_each_entry_rcu(vb, &vbq->free, free_list) {
 			spin_lock(&vb->lock);
 
 			/*
_

Patches currently in -mm which might be from hailong.liu@oppo.com are

mm-vmalloc-fix-vbq-free-breakage.patch

