Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E633191D8
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486692; cv=none; b=bwW9xIT+td3l5ibZdJQ2KmtuZtQhWkNl0UDOY/1exmlyQisQvBs8fpPc/EOHZpJ9jWXVjWEnTOQUw6P+TvnMpM3zaYsmegf04IFX8h42gRrvkWPuO9RuDi5TUobTe89ELhZ+wpd07otY4BIhUE79/gE/4q1DYRozzZnGgmgG1AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486692; c=relaxed/simple;
	bh=pARCXiIrGn6X7OpJpZfY9kbWTPczrHBIIQKaIsKPbtg=;
	h=Date:To:From:Subject:Message-Id; b=JMPfBSNI6xM9oGcSDyDEoJD07wnUy8ypNxDSPlPMFGm8qbP+hIg4DLIG8oaavRDUFvIffwF0FSqecJ7eNhxbMqj27oNnIiH/jYZDSKZF6RxtYy7pHYPoRmKp1ainQ56jWQ9FrflfrZXFw9ofXEYTBk6PU0WoOSCmVpkkhMiYrXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RhtqTRHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RhtqTRHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4CAC116C6;
	Tue, 27 Jan 2026 04:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486692;
	bh=pARCXiIrGn6X7OpJpZfY9kbWTPczrHBIIQKaIsKPbtg=;
	h=Date:To:From:Subject:From;
	b=RhtqTRHP3+4i5FSE4x/JQ87Ub7fTzpR/zwGwBUzyimKrgfC839IxQIBmrZ7QElGY+
	 cZJrky2vUJlLOUgmtyF8ObJljsVsSv/QGB6K/vSywAQmR08VPTkboJDFlVSo7T6QeT
	 RmBvZERACVNp/dEQ6GRktHxn4lIq+39D9icOYick=
Date: Mon, 26 Jan 2026 20:04:51 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,houwenlong.hwl@antgroup.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-early_ioremap-clean-up-the-use-of-warn-for-debugging.patch removed from -mm tree
Message-Id: <20260127040452.1E4CAC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/early_ioremap: clean up the use of WARN() for debugging
has been removed from the -mm tree.  Its filename was
     mm-early_ioremap-clean-up-the-use-of-warn-for-debugging.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
Subject: mm/early_ioremap: clean up the use of WARN() for debugging
Date: Mon, 12 Jan 2026 20:24:29 +0800

Using WARN() for debugging is strange when nothing is wrong, so replace
WARN(early_ioremap_debug) with pr_warn() + dump_stack().

Link: https://lkml.kernel.org/r/d4470531ce0c03fd80f9a1be7e8d8ae1bc60fcd1.1768220636.git.houwenlong.hwl@antgroup.com
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Suggested-by: Mike Rapoport <rppt@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/early_ioremap.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/mm/early_ioremap.c~mm-early_ioremap-clean-up-the-use-of-warn-for-debugging
+++ a/mm/early_ioremap.c
@@ -30,6 +30,14 @@ static int __init early_ioremap_debug_se
 }
 early_param("early_ioremap_debug", early_ioremap_debug_setup);
 
+#define early_ioremap_dbg(fmt, args...)			\
+	do {						\
+		if (unlikely(early_ioremap_debug)) {	\
+			pr_warn(fmt, ##args);		\
+			dump_stack();			\
+		}					\
+	} while (0)
+
 static int after_paging_init __initdata;
 
 pgprot_t __init __weak early_memremap_pgprot_adjust(resource_size_t phys_addr,
@@ -139,8 +147,8 @@ __early_ioremap(resource_size_t phys_add
 	if (WARN_ON(nrpages > NR_FIX_BTMAPS))
 		return NULL;
 
-	WARN(early_ioremap_debug, "%s(%pa, %08lx) [%d] => %08lx + %08lx\n",
-	     __func__, &phys_addr, size, slot, slot_virt[slot], offset);
+	early_ioremap_dbg("%s(%pa, %08lx) [%d] => %08lx + %08lx\n",
+			  __func__, &phys_addr, size, slot, slot_virt[slot], offset);
 
 	/*
 	 * Ok, go for it..
@@ -185,8 +193,7 @@ void __init early_iounmap(void __iomem *
 		  __func__, addr, size, slot, prev_size[slot]))
 		return;
 
-	WARN(early_ioremap_debug, "%s(%p, %08lx) [%d]\n",
-	      __func__, addr, size, slot);
+	early_ioremap_dbg("%s(%p, %08lx) [%d]\n", __func__, addr, size, slot);
 
 	virt_addr = (unsigned long)addr;
 	if (WARN_ON(virt_addr < fix_to_virt(FIX_BTMAP_BEGIN)))
_

Patches currently in -mm which might be from houwenlong.hwl@antgroup.com are


