Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058691C4A24
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 22:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766962599; cv=none; b=CUJDOxYtq8IVsPZPiHSt0CmwMM+xQUbH+9eeq3MELF6oY/vYIFCQHADyp0sw/jEPM87R1kASSgsjepCQyDJodKCZ63EvIZ6+lvpGsfXFzx6vrDlWTM2u3L6gT/s3Up21deft0mdnt+NNzb7jDbYRiTPWRak5ytJBflD1EBfAxZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766962599; c=relaxed/simple;
	bh=DKyswewyQdxr369ObR0qlWfKZRQFQRWj5RQ0tMKtHgw=;
	h=Date:To:From:Subject:Message-Id; b=gLp/hozdc7Ww6asHQSMOrKX6JFvmFH3/zg1WpwLjtbsOGJNQlaVl7dSmjxF8FBB9fdWvTWQpp6wrmW/gHriGH7EpE/ixBF+25uS6iVp2jdgRjg668ASjfD1TN1wsIWapkBOmZCntmijL8vXnr6SxeJ2STGlQupkaoDMsBhCB26U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hbwK0vyJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hbwK0vyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F23C4CEFB;
	Sun, 28 Dec 2025 22:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766962598;
	bh=DKyswewyQdxr369ObR0qlWfKZRQFQRWj5RQ0tMKtHgw=;
	h=Date:To:From:Subject:From;
	b=hbwK0vyJQr9ZarOvxox7JIGTpXJspohp9FhaS04SUg9JhP76qdGUuyhNUFNUbj+zP
	 jk98WdPVsoTx9fwqe1SkH5JhdqhGT12z9ex71+zhBSOm0IM7LW21v61PVBkEQ+FAM/
	 hgm43joR2HbDQAMDaJ/pmbUdjWS0GX2dA8Ohi+Aw=
Date: Sun, 28 Dec 2025 14:56:37 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,yosry.ahmed@linux.dev,willy@infradead.org,weixugc@google.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,nphamcs@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,david.laight.linux@gmail.com,david@kernel.org,chengming.zhou@linux.dev,axelrasmussen@google.com,chandna.sahil@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-pagewalk-simplify-hugepage-boundary-calculation.patch removed from -mm tree
Message-Id: <20251228225638.68F23C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pagewalk: simplify hugepage boundary calculation
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-simplify-hugepage-boundary-calculation.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Sahil Chandna <chandna.sahil@gmail.com>
Subject: mm: pagewalk: simplify hugepage boundary calculation
Date: Fri, 28 Nov 2025 12:31:42 +0530

Patch series "mm: Coccinelle-driven cleanups across memory management
code", v4.

This patch series contains three minor cleanups identified by Coccinelle
scripts under scripts/coccinelle/misc/:

  * Use ALIGN() to compute the next hugepage boundary instead of the
    open-coded expression and use min() macro to improve readability.
  * Use the %pe printk format specifier for PTR_ERR() reporting
    in vmscan.c and zswap.c
Found using:
  make coccicheck MODE=report M=mm/


This patch (of 3):

Replace hugepage boundary computation with ALIGN() helper instead of an
open coded expression.  This helps to improves code readability.

This was flagged by Coccinelle (misc/minmax.cocci) as an opportunity to
use min(), after which the boundary computation was updated following
review suggestions.

Found by: make coccicheck MODE=report M=mm/
No functional change intended.

Link: https://lkml.kernel.org/r/cover.1764312627.git.chandna.sahil@gmail.com
Link: https://lkml.kernel.org/r/35ab82f052d248c0047c10bf01853e37e4f9b4e4.1764312627.git.chandna.sahil@gmail.com
Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Suggested-by: David Laight <david.laight.linux@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/pagewalk.c~mm-pagewalk-simplify-hugepage-boundary-calculation
+++ a/mm/pagewalk.c
@@ -312,8 +312,7 @@ static int walk_pgd_range(unsigned long
 static unsigned long hugetlb_entry_end(struct hstate *h, unsigned long addr,
 				       unsigned long end)
 {
-	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
-	return boundary < end ? boundary : end;
+	return min(ALIGN(addr, huge_page_size(h)), end);
 }
 
 static int walk_hugetlb_range(unsigned long addr, unsigned long end,
_

Patches currently in -mm which might be from chandna.sahil@gmail.com are

mm-vmscan-use-%pe-to-print-error-pointers.patch
mm-zswap-use-%pe-to-print-error-pointers.patch

