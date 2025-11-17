Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D552721CC51
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343129; cv=none; b=pITYNiVi6IgqunS7jwkYYiNH8EDf2txUltlrUBtn3hGjDxz7LKpGcimaRKwck0Nr3qGdFGbsB9Ipx/2adxj/4RuFwVOCKXC/TrNnEWqBm7szNCo2narXfIkYRB+3+K3/UcsCuGWuCleK9+yxGJ4V1hEgKb60R3wc84wwz4bZ3GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343129; c=relaxed/simple;
	bh=ZDA+uPgOl3X7ZroJt2qhwN0hYfXpCp8q2d1ZGkTNaQ0=;
	h=Date:To:From:Subject:Message-Id; b=gA/xD/Kbk3O7tXdPbhEat3dOV1heVMPiMHmo7LVGXMEzOjrVMFpDSwU8r9TwcMkcxbm3cX0gXVY05u6uO+LoHKGtfykUqMDVVhySaPe9z1LK/qELg67fC8oO+a1gB17ocGC7AqWQi/eLqA2Pxw+QJMQBqB2a4QmKe/EeeXk25kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TGg+w3wz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TGg+w3wz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D22C116D0;
	Mon, 17 Nov 2025 01:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343129;
	bh=ZDA+uPgOl3X7ZroJt2qhwN0hYfXpCp8q2d1ZGkTNaQ0=;
	h=Date:To:From:Subject:From;
	b=TGg+w3wzsimDNd5thrurpVPijzsQSo7etOL1g1Hf4Xn4Bc+BL10SskNE4nTYWGIF0
	 CvXNTT7LA6w3OOfVuY8N+SN+pylHRXTbNzOFYfxRbs4p4VuHA1NV9dvufk61Ih53XH
	 bpJZ38CYxM2HjWzn0bjE0EyyuW8NifVrURJPqpc0=
Date: Sun, 16 Nov 2025 17:32:09 -0800
To: mm-commits@vger.kernel.org,john.g.garry@oracle.com,johannes.thumshirn@wdc.com,hch@lst.de,hare@suse.de,david@redhat.com,axboe@kernel.dk,anshuman.khandual@arm.com,chenhuacai@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-the-bounce-config-option.patch removed from -mm tree
Message-Id: <20251117013209.A8D22C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove the BOUNCE config option
has been removed from the -mm tree.  Its filename was
     mm-remove-the-bounce-config-option.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huacai Chen <chenhuacai@loongson.cn>
Subject: mm: remove the BOUNCE config option
Date: Mon, 13 Oct 2025 17:56:20 +0800

Commit eeadd68e2a5f ("block: remove bounce buffering support") remove
block/bounce.c but left the BOUNCE config option.  Now this option has no
users, so remove it.

Link: https://lkml.kernel.org/r/20251013095620.1111061-1-chenhuacai@loongson.cn
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    9 ---------
 1 file changed, 9 deletions(-)

--- a/mm/Kconfig~mm-remove-the-bounce-config-option
+++ a/mm/Kconfig
@@ -695,15 +695,6 @@ config PCP_BATCH_SCALE_MAX
 config PHYS_ADDR_T_64BIT
 	def_bool 64BIT
 
-config BOUNCE
-	bool "Enable bounce buffers"
-	default y
-	depends on BLOCK && MMU && HIGHMEM
-	help
-	  Enable bounce buffers for devices that cannot access the full range of
-	  memory available to the CPU. Enabled by default when HIGHMEM is
-	  selected, but you may say n to override this.
-
 config MMU_NOTIFIER
 	bool
 	select INTERVAL_TREE
_

Patches currently in -mm which might be from chenhuacai@loongson.cn are

mm-refine-__pgdp4dpudpmdpte_alloc_one_-about-highmem.patch

