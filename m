Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E952285CB3;
	Thu, 10 Jul 2025 05:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126366; cv=none; b=p+xDLn2GCJHoxlCnBQCW98aD4bWj2pe/UnISaMdt8se8CuOGO057kYeznIeaf/2t/TEA/NIPp9FoE8JIROgYf8DJiZCdNaFOX00nTg7ELwFt0pT21H6NwESWj7Rfbpi45q1xanLuqZz2wZIDyRoE3iS5IpanyNHUjFYk0VWOFSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126366; c=relaxed/simple;
	bh=mMJw3qN7xBWYMFed7RotGp+EeqE3Q3iMoWZChDD72DA=;
	h=Date:To:From:Subject:Message-Id; b=Vq9Qzp4WNSGFkcPVTEYv75Hu4r7rsnZdjoerHlwh+b4bOWmyJPHZmwpT5jFbEz7id8G8yN957IxDpOE2hbFhRuHj0x4VRMP4wXoqB9dd87R7C/U1WSipvonXo9be9Rf39fiWfEYgc3SH7J10BuGWT/9lw35x5z3sRdhmmYvvGEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pYnW4UJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pYnW4UJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8589C4CEE3;
	Thu, 10 Jul 2025 05:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126365;
	bh=mMJw3qN7xBWYMFed7RotGp+EeqE3Q3iMoWZChDD72DA=;
	h=Date:To:From:Subject:From;
	b=pYnW4UJnX5n1WE0eq6+ZQT68qvjEy3yImY1jcGUwagsmuF4+R2GGP73KRhaj7UDpf
	 ufDZHVAuZof69E020d1cFK/iWUdbFH3JsXEx+OqaFSacEjG+vR/H1G7qHVKx9Tcqqr
	 7PiGAdZzoaZXkWMtpFRHsvsufbarVcFKtwvtRu4s=
Date: Wed, 09 Jul 2025 22:46:05 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,svens@linux.ibm.com,stable@vger.kernel.org,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dev.jain@arm.com,david@redhat.com,catalin.marinas@arm.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ptdump-take-the-memory-hotplug-lock-inside-ptdump_walk_pgd.patch removed from -mm tree
Message-Id: <20250710054605.B8589C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ptdump: take the memory hotplug lock inside ptdump_walk_pgd()
has been removed from the -mm tree.  Its filename was
     mm-ptdump-take-the-memory-hotplug-lock-inside-ptdump_walk_pgd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/ptdump: take the memory hotplug lock inside ptdump_walk_pgd()
Date: Fri, 20 Jun 2025 10:54:27 +0530

Memory hot remove unmaps and tears down various kernel page table regions
as required.  The ptdump code can race with concurrent modifications of
the kernel page tables.  When leaf entries are modified concurrently, the
dump code may log stale or inconsistent information for a VA range, but
this is otherwise not harmful.

But when intermediate levels of kernel page table are freed, the dump code
will continue to use memory that has been freed and potentially
reallocated for another purpose.  In such cases, the ptdump code may
dereference bogus addresses, leading to a number of potential problems.

To avoid the above mentioned race condition, platforms such as arm64,
riscv and s390 take memory hotplug lock, while dumping kernel page table
via the sysfs interface /sys/kernel/debug/kernel_page_tables.

Similar race condition exists while checking for pages that might have
been marked W+X via /sys/kernel/debug/kernel_page_tables/check_wx_pages
which in turn calls ptdump_check_wx().  Instead of solving this race
condition again, let's just move the memory hotplug lock inside generic
ptdump_check_wx() which will benefit both the scenarios.

Drop get_online_mems() and put_online_mems() combination from all existing
platform ptdump code paths.

Link: https://lkml.kernel.org/r/20250620052427.2092093-1-anshuman.khandual@arm.com
Fixes: bbd6ec605c0f ("arm64/mm: Enable memory hot remove")
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>	[s390]
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/ptdump_debugfs.c |    3 ---
 arch/riscv/mm/ptdump.c         |    3 ---
 arch/s390/mm/dump_pagetables.c |    2 --
 mm/ptdump.c                    |    2 ++
 4 files changed, 2 insertions(+), 8 deletions(-)

--- a/arch/arm64/mm/ptdump_debugfs.c~mm-ptdump-take-the-memory-hotplug-lock-inside-ptdump_walk_pgd
+++ a/arch/arm64/mm/ptdump_debugfs.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/debugfs.h>
-#include <linux/memory_hotplug.h>
 #include <linux/seq_file.h>
 
 #include <asm/ptdump.h>
@@ -9,9 +8,7 @@ static int ptdump_show(struct seq_file *
 {
 	struct ptdump_info *info = m->private;
 
-	get_online_mems();
 	ptdump_walk(m, info);
-	put_online_mems();
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(ptdump);
--- a/arch/riscv/mm/ptdump.c~mm-ptdump-take-the-memory-hotplug-lock-inside-ptdump_walk_pgd
+++ a/arch/riscv/mm/ptdump.c
@@ -6,7 +6,6 @@
 #include <linux/efi.h>
 #include <linux/init.h>
 #include <linux/debugfs.h>
-#include <linux/memory_hotplug.h>
 #include <linux/seq_file.h>
 #include <linux/ptdump.h>
 
@@ -413,9 +412,7 @@ bool ptdump_check_wx(void)
 
 static int ptdump_show(struct seq_file *m, void *v)
 {
-	get_online_mems();
 	ptdump_walk(m, m->private);
-	put_online_mems();
 
 	return 0;
 }
--- a/arch/s390/mm/dump_pagetables.c~mm-ptdump-take-the-memory-hotplug-lock-inside-ptdump_walk_pgd
+++ a/arch/s390/mm/dump_pagetables.c
@@ -247,11 +247,9 @@ static int ptdump_show(struct seq_file *
 		.marker = markers,
 	};
 
-	get_online_mems();
 	mutex_lock(&cpa_mutex);
 	ptdump_walk_pgd(&st.ptdump, &init_mm, NULL);
 	mutex_unlock(&cpa_mutex);
-	put_online_mems();
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(ptdump);
--- a/mm/ptdump.c~mm-ptdump-take-the-memory-hotplug-lock-inside-ptdump_walk_pgd
+++ a/mm/ptdump.c
@@ -176,6 +176,7 @@ void ptdump_walk_pgd(struct ptdump_state
 {
 	const struct ptdump_range *range = st->range;
 
+	get_online_mems();
 	mmap_write_lock(mm);
 	while (range->start != range->end) {
 		walk_page_range_debug(mm, range->start, range->end,
@@ -183,6 +184,7 @@ void ptdump_walk_pgd(struct ptdump_state
 		range++;
 	}
 	mmap_write_unlock(mm);
+	put_online_mems();
 
 	/* Flush out the last page */
 	st->note_page_flush(st);
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


