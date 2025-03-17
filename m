Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2817F2153F7
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188238; cv=none; b=r+BRcXKjgH0bl/4qLwOQbhbSLdlC5tNMT767Ufqpz0iSqv1SBnIMgelwC74jm9tMEDCmjYXFaH0b3S+McZbTKMdNzlCpqCAgA7Z6XidUrdzwkxXGJAgOAMXDrtnlv/d/qkBZa9O035WbY9r0HAUY3uIDntiL7fa5KtZ4KfgGLxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188238; c=relaxed/simple;
	bh=Rx12VO0SY62+2GpnCfSNOfwXialVhMbvtTtudb+D+bQ=;
	h=Date:To:From:Subject:Message-Id; b=WIv9xKWh8jcawT1i5v/PNwkI8OWVo9yp5D/DHMDILUtE2A8ZC0mwddlIuLidO5tqlMFpmNEcRUOqyhLsBeq/aK2PddQ9qjRwfqwJAHVn+u5ZxwEcrqLVawzAM9OtJyi0L+VWeI935k8YHrdiRCHz8XOhLDzcrZPgV49jtVZO4u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MLKVDwpr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MLKVDwpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F89C4CEEC;
	Mon, 17 Mar 2025 05:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188237;
	bh=Rx12VO0SY62+2GpnCfSNOfwXialVhMbvtTtudb+D+bQ=;
	h=Date:To:From:Subject:From;
	b=MLKVDwprGy4FJxywuF70nCvQPLdNy4Q1xVhFRQyFQGVAonOXeRra/LQ28BaDYV6EZ
	 7d0arUxXjTUT6hMc7KZ70Op0CH6DDTxC3sUW66iy85vYlPtoLRLQY7cOhoxVpDXWHC
	 lP20WEdP18tvRn/1JL0ZFcDwjOse4/iagiCCxXz8=
Date: Sun, 16 Mar 2025 22:10:37 -0700
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,chrisl@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-remove-swap_flag_prio_shift.patch removed from -mm tree
Message-Id: <20250317051037.99F89C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: remove SWAP_FLAG_PRIO_SHIFT
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-swap_flag_prio_shift.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/swap: remove SWAP_FLAG_PRIO_SHIFT
Date: Wed, 5 Feb 2025 17:27:12 +0800

It doesn't make sense to have a zero value of shift.  Remove it to avoid
confusion.

Link: https://lkml.kernel.org/r/20250205092721.9395-4-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 -
 mm/swapfile.c        |    3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/swap.h~mm-swap-remove-swap_flag_prio_shift
+++ a/include/linux/swap.h
@@ -24,7 +24,6 @@ struct pagevec;
 
 #define SWAP_FLAG_PREFER	0x8000	/* set if swap priority specified */
 #define SWAP_FLAG_PRIO_MASK	0x7fff
-#define SWAP_FLAG_PRIO_SHIFT	0
 #define SWAP_FLAG_DISCARD	0x10000 /* enable discard for swap */
 #define SWAP_FLAG_DISCARD_ONCE	0x20000 /* discard swap area at swapon-time */
 #define SWAP_FLAG_DISCARD_PAGES 0x40000 /* discard page-clusters after use */
--- a/mm/swapfile.c~mm-swap-remove-swap_flag_prio_shift
+++ a/mm/swapfile.c
@@ -3453,8 +3453,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 	mutex_lock(&swapon_mutex);
 	prio = -1;
 	if (swap_flags & SWAP_FLAG_PREFER)
-		prio =
-		  (swap_flags & SWAP_FLAG_PRIO_MASK) >> SWAP_FLAG_PRIO_SHIFT;
+		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
 	enable_swap_info(si, prio, swap_map, cluster_info, zeromap);
 
 	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
_

Patches currently in -mm which might be from bhe@redhat.com are


