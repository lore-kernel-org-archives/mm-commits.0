Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769876311F
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 07:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255773; cv=none; b=N0KimA0x/FUgldwfFWcX+ZYKbiS7IB2X4qhNNgZwJ3ig2vgPSauX01g/U/AT8aPkqjAV0OCM0EAQ4gLBdnUsLdWGPXgjvw0rBlbh9KDSHXLegwfBlHjPILH6E+17rEJPaM9PwEWv9t5/mMeGKyYqKJe1OtMF/JQjViDY9e3elfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255773; c=relaxed/simple;
	bh=ctNmqds34dyhaLpDDOFEmyik/56DE+WAwXvvVBDAjTI=;
	h=Date:To:From:Subject:Message-Id; b=Wu5l0z2ScRs6L2jZ2GbltpPNz/m+enL3pCE1592+71Zgr+uzHAvZyFxsCzUxSblo9tKorm8nypxzuBJSwK71uF78/B9u7XOEfZIJDeRYDDyi2oXJAsD/wt4m4Z8y1axfpfC+kctYAA9rs9Tw0oIcBoZozctbhqZhP+2HussYCHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hkxy/EUJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hkxy/EUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87780C433F1;
	Fri, 26 Jan 2024 07:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706255773;
	bh=ctNmqds34dyhaLpDDOFEmyik/56DE+WAwXvvVBDAjTI=;
	h=Date:To:From:Subject:From;
	b=Hkxy/EUJ3KUySPzcsKvBIh+z7ic3CpFWcgsqH+IhJjDuHiI2GnDHkV+jBnFlFzOQl
	 gJjTo5SnOzE9PEHzZvQKwNgi62iPy/HCl9VwUKfjSel6G97klPWpP9wWU8dnQrYdKx
	 NZtssg3gf/88HhAXqFWqLzeGm3wB/QVAHanwJX4A=
Date: Thu, 25 Jan 2024 23:56:09 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,riel@surriel.com,jirislaby@kernel.org,cl@linux.com,yang@os.amperecomputing.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-dont-force-huge-page-alignment-on-32-bit.patch removed from -mm tree
Message-Id: <20240126075612.87780C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: huge_memory: don't force huge page alignment on 32 bit
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-dont-force-huge-page-alignment-on-32-bit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-mmap-no-need-to-call-khugepaged_enter_vma-for-stack.patch

