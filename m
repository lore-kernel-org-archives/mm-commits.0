Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8C28F4D
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560069; cv=none; b=GjMwhrqEqr8bJkWnCzpmhTweCNqP+S10V2PJCFy+6tuXg9qhJmCeziY/whZrCs3oZaAr7sPIMGkXnviGksGomtpZCRP85iZ6mCmT3xgLUxtRcqCdXjjPCLx8S6aJvmroTLpV6XCOOXCVTFw1zaCngoYX0dgMt0Twa/RPGwlq3bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560069; c=relaxed/simple;
	bh=KOl+I6AC3iJW8HtRd8oGhtZiRCeYkOMlKTSSiqyHu7M=;
	h=Date:To:From:Subject:Message-Id; b=IrIO3Gc23v+TKEVTBRBeVmVzTVfsaOpUWusARs4NsTDLW7E4+dWPnbmFDrWrzXPUxEALoPe4JjDWV34LvXsKX3XC/zK8tfDDZzidnwX/VAIL4EJk9QVq/Gp3BEpvDVyLg7xurNKhhMBCAAgz8fTxhAG4+I9Bb3tzmzxusNb6flA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=giz2Amg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="giz2Amg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D99CC43390;
	Thu, 22 Feb 2024 00:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560069;
	bh=KOl+I6AC3iJW8HtRd8oGhtZiRCeYkOMlKTSSiqyHu7M=;
	h=Date:To:From:Subject:From;
	b=giz2Amg6W0iHZCJCByaBWjciI93kZDifQUTIRvSSNpKD+mgd2MkqVEFZLBaRPbU4x
	 JW0HzSreyLcGFltVig+j+gcY1FZOc3eA/u72GnZAO4y3dif5yDWhZCzIbDcsJ9sI7R
	 cjaoifR28tCAj2RMQxNw6TzChtoU7TiXFqxRWO/I=
Date: Wed, 21 Feb 2024 16:01:08 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,riel@surriel.com,oliver.sang@intel.com,fengwei.yin@intel.com,cl@linux.com,yang@os.amperecomputing.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-no-need-to-call-khugepaged_enter_vma-for-stack.patch removed from -mm tree
Message-Id: <20240222000109.0D99CC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mmap: no need to call khugepaged_enter_vma() for stack
has been removed from the -mm tree.  Its filename was
     mm-mmap-no-need-to-call-khugepaged_enter_vma-for-stack.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Shi <yang@os.amperecomputing.com>
Subject: mm: mmap: no need to call khugepaged_enter_vma() for stack
Date: Wed, 20 Dec 2023 22:59:42 -0800

We avoid allocating THP for temporary stack, even though
khugepaged_enter_vma() is called for stack VMAs, it actualy returns
false.  So no need to call it in the first place at all.

Link: https://lkml.kernel.org/r/20231221065943.2803551-1-shy828301@gmail.com
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/mmap.c~mm-mmap-no-need-to-call-khugepaged_enter_vma-for-stack
+++ a/mm/mmap.c
@@ -2051,7 +2051,6 @@ static int expand_upwards(struct vm_area
 		}
 	}
 	anon_vma_unlock_write(vma->anon_vma);
-	khugepaged_enter_vma(vma, vma->vm_flags);
 	mas_destroy(&mas);
 	validate_mm(mm);
 	return error;
@@ -2145,7 +2144,6 @@ int expand_downwards(struct vm_area_stru
 		}
 	}
 	anon_vma_unlock_write(vma->anon_vma);
-	khugepaged_enter_vma(vma, vma->vm_flags);
 	mas_destroy(&mas);
 	validate_mm(mm);
 	return error;
_

Patches currently in -mm which might be from yang@os.amperecomputing.com are


