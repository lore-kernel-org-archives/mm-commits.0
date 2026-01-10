Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B0E288C3D
	for <mm-commits@vger.kernel.org>; Sat, 10 Jan 2026 23:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768089459; cv=none; b=HtwCwRU4YOFyId5aygXx2eXhOn1brq6a/EZejRW+8AaO+o0lf5lYkeBGpYFsLFrDAYemnrVzEy9LSJSgeHLLqG/33n0Me+ysB/HAqu/002TRqoBXC3+EfRRtntH7jGSGqS4c65rWzKnUPuMuIU7IteiMkJhIC19w1nxn+pJ2GEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768089459; c=relaxed/simple;
	bh=UzXcn+A76/M2xBpiDQypaSfCnh4kgxDgpMEBcUCFEZg=;
	h=Date:To:From:Subject:Message-Id; b=kYDwbKsX4YU07fEjhPqGJZg+p71xuNq0RlZu3gPiJpXrH+SRjhykCjQ61rplj5xIvjc30wO2vHmFL7htVXSp5ta3yPZRUN90A8Llqq9y+iH7WD5/Z3zYf4nn5tbWCo6T/jnRtxJpPVxmlXWpD69yxQRqpATrEWB0heK8fwnHQbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GRTtormw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GRTtormw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F9BC4CEF1;
	Sat, 10 Jan 2026 23:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768089459;
	bh=UzXcn+A76/M2xBpiDQypaSfCnh4kgxDgpMEBcUCFEZg=;
	h=Date:To:From:Subject:From;
	b=GRTtormwbyC5O3Efyq+GE47oYPvjzoQyV0FJ2K0O+Z0kDO04I5dHq0o5TugJhM6Ww
	 kH5wWpheym2LylnnqdiGMYzfScxTsf/voHCX1fQGe8SfMVWb/bMZzQaHNecstqI0RP
	 IrJp6lg8EF9nU8Uy3TpnAiUVwTJmbxpMXnXTLlx4=
Date: Sat, 10 Jan 2026 15:57:38 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,akpm@linux-foundation.org,houwenlong.hwl@antgroup.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-early_ioremap-print-the-starting-physical-address-in-__early_ioremap.patch added to mm-new branch
Message-Id: <20260110235738.F3F9BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/early_ioremap: print the starting physical address in __early_ioremap()
has been added to the -mm mm-new branch.  Its filename is
     mm-early_ioremap-print-the-starting-physical-address-in-__early_ioremap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-early_ioremap-print-the-starting-physical-address-in-__early_ioremap.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
Subject: mm/early_ioremap: print the starting physical address in __early_ioremap()
Date: Fri, 9 Jan 2026 21:31:51 +0800

The debug WARN() printing occurs after the while loop, so the 'phys_addr'
reflects the last physical address rather than the actual starting
physical address, which is not useful for debugging.  To simplify, the
WARN() statement could be moved up before the loop instead of introducing
a new variable to record the original 'phys_addr' value.  Additionally,
swap the print order of 'slot_virt[slot]' and 'offset', as this will
enhance output readability.

Link: https://lkml.kernel.org/r/aa2d44c34f44c31b50285b7592ed4fd78d6f59ba.1767965415.git.houwenlong.hwl@antgroup.com
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/early_ioremap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/early_ioremap.c~mm-early_ioremap-print-the-starting-physical-address-in-__early_ioremap
+++ a/mm/early_ioremap.c
@@ -139,6 +139,9 @@ __early_ioremap(resource_size_t phys_add
 	if (WARN_ON(nrpages > NR_FIX_BTMAPS))
 		return NULL;
 
+	WARN(early_ioremap_debug, "%s(%pa, %08lx) [%d] => %08lx + %08lx\n",
+	     __func__, &phys_addr, size, slot, slot_virt[slot], offset);
+
 	/*
 	 * Ok, go for it..
 	 */
@@ -152,8 +155,6 @@ __early_ioremap(resource_size_t phys_add
 		--idx;
 		--nrpages;
 	}
-	WARN(early_ioremap_debug, "%s(%pa, %08lx) [%d] => %08lx + %08lx\n",
-	     __func__, &phys_addr, size, slot, offset, slot_virt[slot]);
 
 	prev_map[slot] = (void __iomem *)(offset + slot_virt[slot]);
 	return prev_map[slot];
_

Patches currently in -mm which might be from houwenlong.hwl@antgroup.com are

mm-early_ioremap-print-the-starting-physical-address-in-__early_ioremap.patch

