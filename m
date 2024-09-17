Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379D314B948
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560581; cv=none; b=VNu2Ab+LjgaDdJ9XbS9PTGvJeavGgal6YOLgfVaR3c8oyuvTiWnWGkoritt6XRZYWAHfAWJfJ8p16O1P9Tv6RMUnMBgMqyEhqAyufWvG3SjT4NXDC72Rgt/wveTp+bNETij3xMZrY3i1hSHlAeBSl3FdRerDRF4uOhnxxSMJn8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560581; c=relaxed/simple;
	bh=sqpnM+0JuJ+aGewYsKtvfA1ooHD5mDmynJU97tGCbJs=;
	h=Date:To:From:Subject:Message-Id; b=YUCD6Z5mBUvWDCOBs+HY2sxD7uFAISLgZCz3xx41V1y42W3e/n+al7TBaYEjZ8kM4pf94Sed2QeF9qDy1ZUWBvjhmXParpljxdFI9F4HL82QQpvrNxQ2O/RmrBFKxF5sOHXJx4wzBP6NWfrvAPm4kZjFxuyC1zRO7d4b8V5GqZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ltJOn4HH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ltJOn4HH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE8DC4CEC7;
	Tue, 17 Sep 2024 08:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560581;
	bh=sqpnM+0JuJ+aGewYsKtvfA1ooHD5mDmynJU97tGCbJs=;
	h=Date:To:From:Subject:From;
	b=ltJOn4HHmh/0ud0GzeEAvr2WVYjELYQZDf12HFAheHn0R9Y6/kX/eAeJlbp4zZ9GC
	 3OJ9BNsKe0snDZGJ8wjjFasz9PEG/NIuoYQ+Dnw0YK+idOYFJW1Jp0/sdLK+p+Vnc3
	 468GvIavl9r743SbMCfq8An567UFL5kPdh7/CId8=
Date: Tue, 17 Sep 2024 01:09:38 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,svens@linux.ibm.com,peterz@infradead.org,namhyung@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mhiramat@kernel.org,mark.rutland@arm.com,kan.liang@linux.intel.com,jolsa@kernel.org,irogers@google.com,andrii@kernel.org,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] uprobes-turn-xol_area-pages-into-xol_area-page.patch removed from -mm tree
Message-Id: <20240917080940.8BE8DC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: uprobes: turn xol_area->pages[2] into xol_area->page
has been removed from the -mm tree.  Its filename was
     uprobes-turn-xol_area-pages-into-xol_area-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: uprobes: turn xol_area->pages[2] into xol_area->page
Date: Wed, 11 Sep 2024 15:14:37 +0200

Now that xol_mapping has its own ->fault() method we no longer need
xol_area->pages[1] == NULL, we need a single page.

Link: https://lkml.kernel.org/r/20240911131437.GC3448@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/kernel/events/uprobes.c~uprobes-turn-xol_area-pages-into-xol_area-page
+++ a/kernel/events/uprobes.c
@@ -99,7 +99,7 @@ struct xol_area {
 	atomic_t 			slot_count;	/* number of in-use slots */
 	unsigned long 			*bitmap;	/* 0 = free slot */
 
-	struct page 			*pages[2];
+	struct page			*page;
 	/*
 	 * We keep the vma's vm_start rather than a pointer to the vma
 	 * itself.  The probed process or a naughty kernel module could make
@@ -1437,7 +1437,7 @@ static vm_fault_t xol_fault(const struct
 {
 	struct xol_area *area = vma->vm_mm->uprobes_state.xol_area;
 
-	vmf->page = area->pages[0];
+	vmf->page = area->page;
 	get_page(vmf->page);
 	return 0;
 }
@@ -1512,10 +1512,9 @@ static struct xol_area *__create_xol_are
 	if (!area->bitmap)
 		goto free_area;
 
-	area->pages[0] = alloc_page(GFP_HIGHUSER);
-	if (!area->pages[0])
+	area->page = alloc_page(GFP_HIGHUSER);
+	if (!area->page)
 		goto free_bitmap;
-	area->pages[1] = NULL;
 
 	area->vaddr = vaddr;
 	init_waitqueue_head(&area->wq);
@@ -1523,12 +1522,12 @@ static struct xol_area *__create_xol_are
 	set_bit(0, area->bitmap);
 	atomic_set(&area->slot_count, 1);
 	insns = arch_uprobe_trampoline(&insns_size);
-	arch_uprobe_copy_ixol(area->pages[0], 0, insns, insns_size);
+	arch_uprobe_copy_ixol(area->page, 0, insns, insns_size);
 
 	if (!xol_add_vma(mm, area))
 		return area;
 
-	__free_page(area->pages[0]);
+	__free_page(area->page);
  free_bitmap:
 	kfree(area->bitmap);
  free_area:
@@ -1570,7 +1569,7 @@ void uprobe_clear_state(struct mm_struct
 	if (!area)
 		return;
 
-	put_page(area->pages[0]);
+	put_page(area->page);
 	kfree(area->bitmap);
 	kfree(area);
 }
@@ -1637,7 +1636,7 @@ static unsigned long xol_get_insn_slot(s
 	if (unlikely(!xol_vaddr))
 		return 0;
 
-	arch_uprobe_copy_ixol(area->pages[0], xol_vaddr,
+	arch_uprobe_copy_ixol(area->page, xol_vaddr,
 			      &uprobe->arch.ixol, sizeof(uprobe->arch.ixol));
 
 	return xol_vaddr;
_

Patches currently in -mm which might be from oleg@redhat.com are


