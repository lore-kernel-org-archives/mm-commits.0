Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680E112E45
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 07:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255717; cv=none; b=VowzlIOhNMRNihTk/nUeFqjNSScKHiTSr08E+K8VSEMRBp+RKHcPuIiUb4YPYn9VssJ9yLbh86DWTYh+O84OTBtldR1iAA65UPkZ9pzXqzPfvGVQ01Annfk6eX9/OSsAp8u6R4xx1xdWo7p09Kzcgi5+LbRzvew2gPtZ+oBY+og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255717; c=relaxed/simple;
	bh=eIwUXcQHBnAGzlhtata3vWH445M9PMgPEZjqeoidM/k=;
	h=Date:To:From:Subject:Message-Id; b=qCgviBxZ42raPlC5ADqJ7vpF26Rr7gHIDX9PPM8XR6XT5q1x8/vwiZ7peAXENJ7HC3/+/8ODMkJ5UUfFkas4fhtZw5bFyTqVenDBlxFDml9d5jGlaNs6dVBRg9RBVcpFENqNnZBb9e9hR1nEf68w1hGdLE5sS3uYw0ScfyfZebc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OZ8LgvLL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OZ8LgvLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DE3C433C7;
	Fri, 26 Jan 2024 07:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706255716;
	bh=eIwUXcQHBnAGzlhtata3vWH445M9PMgPEZjqeoidM/k=;
	h=Date:To:From:Subject:From;
	b=OZ8LgvLLigkdeBtYwl3w7pUUJzru77nAu1tQ+xUjQPPxe95dqcJoAICv3XTB929dy
	 8QQaR7yAIix8RYWS2Y6t6yxpvcTdMroaTBPRXOKNgjSV/rDMBqhuxguyi4abrRjxDh
	 4cOvxcg36S4mdhaP6LrFbNShtWYyXs184COOfW4A=
Date: Thu, 25 Jan 2024 23:55:14 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,stable@vger.kerenl.org,riel@surriel.com,oliver.sang@intel.com,fengwei.yin@intel.com,cl@linux.com,yang@os.amperecomputing.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-map-map_stack-to-vm_nohugepage.patch removed from -mm tree
Message-Id: <20240126075516.76DE3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mmap: map MAP_STACK to VM_NOHUGEPAGE
has been removed from the -mm tree.  Its filename was
     mm-mmap-map-map_stack-to-vm_nohugepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Shi <yang@os.amperecomputing.com>
Subject: mm: mmap: map MAP_STACK to VM_NOHUGEPAGE
Date: Wed, 20 Dec 2023 22:59:43 -0800

commit efa7df3e3bb5 ("mm: align larger anonymous mappings on THP
boundaries") incured regression for stress-ng pthread benchmark [1].  It
is because THP get allocated to pthread's stack area much more possible
than before.  Pthread's stack area is allocated by mmap without
VM_GROWSDOWN or VM_GROWSUP flag, so kernel can't tell whether it is a
stack area or not.

The MAP_STACK flag is used to mark the stack area, but it is a no-op on
Linux.  Mapping MAP_STACK to VM_NOHUGEPAGE to prevent from allocating THP
for such stack area.

With this change the stack area looks like:

fffd18e10000-fffd19610000 rw-p 00000000 00:00 0
Size:               8192 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Rss:                  12 kB
Pss:                  12 kB
Pss_Dirty:            12 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        12 kB
Referenced:           12 kB
Anonymous:            12 kB
KSM:                   0 kB
LazyFree:              0 kB
AnonHugePages:         0 kB
ShmemPmdMapped:        0 kB
FilePmdMapped:         0 kB
Shared_Hugetlb:        0 kB
Private_Hugetlb:       0 kB
Swap:                  0 kB
SwapPss:               0 kB
Locked:                0 kB
THPeligible:           0
VmFlags: rd wr mr mw me ac nh

The "nh" flag is set.

[1] https://lore.kernel.org/linux-mm/202312192310.56367035-oliver.sang@intel.com/

Link: https://lkml.kernel.org/r/20231221065943.2803551-2-shy828301@gmail.com
Fixes: efa7df3e3bb5 ("mm: align larger anonymous mappings on THP boundaries")
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Tested-by: Oliver Sang <oliver.sang@intel.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christopher Lameter <cl@linux.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: <stable@vger.kerenl.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mman.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/mman.h~mm-mmap-map-map_stack-to-vm_nohugepage
+++ a/include/linux/mman.h
@@ -156,6 +156,7 @@ calc_vm_flag_bits(unsigned long flags)
 	return _calc_vm_trans(flags, MAP_GROWSDOWN,  VM_GROWSDOWN ) |
 	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    ) |
 	       _calc_vm_trans(flags, MAP_SYNC,	     VM_SYNC      ) |
+	       _calc_vm_trans(flags, MAP_STACK,	     VM_NOHUGEPAGE) |
 	       arch_calc_vm_flag_bits(flags);
 }
 
_

Patches currently in -mm which might be from yang@os.amperecomputing.com are

mm-mmap-no-need-to-call-khugepaged_enter_vma-for-stack.patch

