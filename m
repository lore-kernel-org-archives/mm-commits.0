Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3930C626
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970684; cv=none; b=QlM0lWCKl4yCB9flAwm5w2Yvr3fopramWmL2Gi714IOXw/XAPZ4LpRCFOMLVNPuEy77BSt9OHXd5gTxMP1WlacoRaqpCcs/qJ7Qh3QrBEIuvEh8uhqIsEU6lR7P3DtLbjYmeBs+MuzdFPOw1Rb5bZ9XaIK/Xkh5HrmhEdLGw6kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970684; c=relaxed/simple;
	bh=JCA/vgyQw7vD9eyDRb/GNRtMJ7FFoTxlqX6iPvDDlfM=;
	h=Date:To:From:Subject:Message-Id; b=SxAi65TR0qkavzYLBPPN+ni3d37PEz1VvGVdVHo0NSrHPHt6FyGuH6adm3pZa8c/cNXsDA0D4ej/Y7gMiFaFPtO2R3/qCZNoTaC7NWQeCMs/paTYVngG+kupx7qNk8ODtzGiZMvkbvSPiQPhluOxHFQ2J+AgqZMFZgufhrtrfL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=azbqd79d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="azbqd79d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932EEC433F1;
	Tue, 23 Jan 2024 00:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970684;
	bh=JCA/vgyQw7vD9eyDRb/GNRtMJ7FFoTxlqX6iPvDDlfM=;
	h=Date:To:From:Subject:From;
	b=azbqd79d5sYEwU0SV9EjtXJcn9+3F+Pj7+c+ZZkpCstGdq/lK3ViWfoIRyiSCkjKF
	 /JQaRhqhfGy3WRPyky5zkDpogNs77HEWd3oG1HnO+qOJyX1Dpt4c5i1EboxuRiJt9+
	 wuF8JNArM6gXDqw93KzvCdZhJiPAfAMypZSQJbcg=
Date: Mon, 22 Jan 2024 16:44:40 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,riel@surriel.com,jirislaby@kernel.org,cl@linux.com,yang@os.amperecomputing.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-dont-force-huge-page-alignment-on-32-bit.patch added to mm-hotfixes-unstable branch
Message-Id: <20240123004443.932EEC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: huge_memory: don't force huge page alignment on 32 bit
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-dont-force-huge-page-alignment-on-32-bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-dont-force-huge-page-alignment-on-32-bit.patch

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
From: Yang Shi <yang@os.amperecomputing.com>
Subject: mm: huge_memory: don't force huge page alignment on 32 bit
Date: Thu, 18 Jan 2024 10:05:05 -0800

commit efa7df3e3bb5 ("mm: align larger anonymous mappings on THP
boundaries") caused two issues [1] [2] reported on 32 bit system or compat
userspace.

It doesn't make too much sense to force huge page alignment on 32 bit
system due to the constrained virtual address space.

[1] https://lore.kernel.org/linux-mm/d0a136a0-4a31-46bc-adf4-2db109a61672@kernel.org/
[2] https://lore.kernel.org/linux-mm/CAJuCfpHXLdQy1a2B6xN2d7quTYwg2OoZseYPZTRpU0eHHKD-sQ@mail.gmail.com/

Link: https://lkml.kernel.org/r/20240118180505.2914778-1-shy828301@gmail.com
Fixes: efa7df3e3bb5 ("mm: align larger anonymous mappings on THP boundaries")
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Reported-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Jiri Slaby <jirislaby@kernel.org>
Tested-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Christopher Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/huge_memory.c~mm-huge_memory-dont-force-huge-page-alignment-on-32-bit
+++ a/mm/huge_memory.c
@@ -37,6 +37,7 @@
 #include <linux/page_owner.h>
 #include <linux/sched/sysctl.h>
 #include <linux/memory-tiers.h>
+#include <linux/compat.h>
 
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
@@ -811,6 +812,9 @@ static unsigned long __thp_get_unmapped_
 	loff_t off_align = round_up(off, size);
 	unsigned long len_pad, ret;
 
+	if (IS_ENABLED(CONFIG_32BIT) || in_compat_syscall())
+		return 0;
+
 	if (off_end <= off_align || (off_end - off_align) < size)
 		return 0;
 
_

Patches currently in -mm which might be from yang@os.amperecomputing.com are

mm-mmap-map-map_stack-to-vm_nohugepage.patch
mm-huge_memory-dont-force-huge-page-alignment-on-32-bit.patch
mm-mmap-no-need-to-call-khugepaged_enter_vma-for-stack.patch

