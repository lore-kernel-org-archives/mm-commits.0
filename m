Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357C32F49F0
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 19:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768245170; cv=none; b=mtclzMjKBRMToBgGZ2z/ZIaXNpiWVHiWZmmFQx/MGvP1/VL9aPjUxuhrVVaRzrcH/rRU3AoiVi0dLI2kU7S7Xb4ndcIXV3DrlI0Hi5icI1vnNU2ckUEakYWfJGARYf20rczvOLohkPzidA0CdQq8jtjb2+lcQCEyzCERXpwj3es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768245170; c=relaxed/simple;
	bh=3nl2TrE+amSgChRefbtjUjyDTihrpMBS5NLmJtN+UZQ=;
	h=Date:To:From:Subject:Message-Id; b=txZUu5q6ShWyARFpdhFqKE+q7/ckCeiByhWfOyHkquTFeyXn7xf3JDv4EEF/bypT6QsQI2leMnzCFCcUlGpVN1xA0WvZr6f9JrAbp9xwJlpCRuYuRT9SMh8cq3YSwgBcYFffaHfcJru7IQ2r8FXYwdDxYmSoFEIvU71HGaOMwW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=av3I4ihx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="av3I4ihx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA444C116D0;
	Mon, 12 Jan 2026 19:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768245169;
	bh=3nl2TrE+amSgChRefbtjUjyDTihrpMBS5NLmJtN+UZQ=;
	h=Date:To:From:Subject:From;
	b=av3I4ihxRCiJVajrgPjhQNgfGGzRFp/IqCCzDQ0h9X48eaxsEUeQUAEpV1725nV51
	 JdB46lyul5vCr+AZ+a8QSd7Be2mGlHRBhbf1TUUh/ojryYjQ1jOoGKSZKseEUc0NaE
	 NDB6ohBENSjx3vayuJZ3sTSm+YUxy1c8Ftux3P+4=
Date: Mon, 12 Jan 2026 11:12:49 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,houwenlong.hwl@antgroup.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-early_ioremap-clean-up-the-use-of-warn-for-debugging.patch added to mm-new branch
Message-Id: <20260112191249.BA444C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/early_ioremap: clean up the use of WARN() for debugging
has been added to the -mm mm-new branch.  Its filename is
     mm-early_ioremap-clean-up-the-use-of-warn-for-debugging.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-early_ioremap-clean-up-the-use-of-warn-for-debugging.patch

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

mm-early_ioremap-print-the-starting-physical-address-in-__early_ioremap.patch
mm-early_ioremap-clean-up-the-use-of-warn-for-debugging.patch

