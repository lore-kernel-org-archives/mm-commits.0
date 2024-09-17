Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C894114B948
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560577; cv=none; b=JpQVNAMZWVCSidOTsuBilskaz+zSQCEocoExv9YU9HlyQmtKeqiYIwUt6EajoyOWGxskP2jtY8cUW7u4OHGUlkUKyRKMUhZk44WeUH0mhjdg0ttJLVvrw42XyBw9eOxH4cqxv3DnxGf8AoDTVZRGqyu46Vk/UMJyS0cL1jQ9LtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560577; c=relaxed/simple;
	bh=hQAS5+5SvBPmtfBTL9q6eQuLnGxLpRdQeL1a+v4Wcgc=;
	h=Date:To:From:Subject:Message-Id; b=UZSXdoDiG9aLfi07jwTDHIMbe2ip1ZLB+rzD/dHmd9YRZ8Q/QgsURtSOUd87Hi2pymUOpy8garr+/giATr0x9GqpxEfeh7d1TK8a9wIlX19Jq3pIk82w06DrXOA1NiNZQsyRwa0k70XTV9Hduf8uOfWd51340AkM/XBcF2ZNkTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1tOJalr9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1tOJalr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55090C4CEC6;
	Tue, 17 Sep 2024 08:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560577;
	bh=hQAS5+5SvBPmtfBTL9q6eQuLnGxLpRdQeL1a+v4Wcgc=;
	h=Date:To:From:Subject:From;
	b=1tOJalr9DIKw6BDcti8exoCg4t73lsX37exd4zRMFhMrJddQqSbuXPLX+u6Rb3+wV
	 4WVu4XiFkG0eSiYb72WWCn0eCL8+G2ll+dh7awJuQ+xn9ycY3a2DjKcX3wsSONC4x3
	 +j5oqrYy7y1Urc2H+Gb67BKJZISLfQ872aRd35b8=
Date: Tue, 17 Sep 2024 01:09:34 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,svens@linux.ibm.com,peterz@infradead.org,namhyung@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mhiramat@kernel.org,mark.rutland@arm.com,kan.liang@linux.intel.com,jolsa@kernel.org,irogers@google.com,andrii@kernel.org,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] uprobes-introduce-the-global-struct-vm_special_mapping-xol_mapping.patch removed from -mm tree
Message-Id: <20240917080937.55090C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: uprobes: introduce the global struct vm_special_mapping xol_mapping
has been removed from the -mm tree.  Its filename was
     uprobes-introduce-the-global-struct-vm_special_mapping-xol_mapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: uprobes: introduce the global struct vm_special_mapping xol_mapping
Date: Wed, 11 Sep 2024 15:14:07 +0200

Currently each xol_area has its own instance of vm_special_mapping, this
is suboptimal and ugly.  Kill xol_area->xol_mapping and add a single
global instance of vm_special_mapping, the ->fault() method can use
area->pages rather than xol_mapping->pages.

As a side effect this fixes the problem introduced by the recent commit
223febc6e557 ("mm: add optional close() to struct vm_special_mapping"), if
special_mapping_close() is called from the __mmput() paths, it will use
vma->vm_private_data = &area->xol_mapping freed by uprobe_clear_state().

Link: https://lkml.kernel.org/r/20240911131407.GB3448@redhat.com
Fixes: 223febc6e557 ("mm: add optional close() to struct vm_special_mapping")
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Sven Schnelle <svens@linux.ibm.com>
Closes: https://lore.kernel.org/all/yt9dy149vprr.fsf@linux.ibm.com/
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/kernel/events/uprobes.c~uprobes-introduce-the-global-struct-vm_special_mapping-xol_mapping
+++ a/kernel/events/uprobes.c
@@ -99,7 +99,6 @@ struct xol_area {
 	atomic_t 			slot_count;	/* number of in-use slots */
 	unsigned long 			*bitmap;	/* 0 = free slot */
 
-	struct vm_special_mapping	xol_mapping;
 	struct page 			*pages[2];
 	/*
 	 * We keep the vma's vm_start rather than a pointer to the vma
@@ -1433,6 +1432,21 @@ void uprobe_munmap(struct vm_area_struct
 		set_bit(MMF_RECALC_UPROBES, &vma->vm_mm->flags);
 }
 
+static vm_fault_t xol_fault(const struct vm_special_mapping *sm,
+			    struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct xol_area *area = vma->vm_mm->uprobes_state.xol_area;
+
+	vmf->page = area->pages[0];
+	get_page(vmf->page);
+	return 0;
+}
+
+static const struct vm_special_mapping xol_mapping = {
+	.name = "[uprobes]",
+	.fault = xol_fault,
+};
+
 /* Slot allocation for XOL */
 static int xol_add_vma(struct mm_struct *mm, struct xol_area *area)
 {
@@ -1459,7 +1473,7 @@ static int xol_add_vma(struct mm_struct
 
 	vma = _install_special_mapping(mm, area->vaddr, PAGE_SIZE,
 				VM_EXEC|VM_MAYEXEC|VM_DONTCOPY|VM_IO,
-				&area->xol_mapping);
+				&xol_mapping);
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
 		goto fail;
@@ -1498,9 +1512,6 @@ static struct xol_area *__create_xol_are
 	if (!area->bitmap)
 		goto free_area;
 
-	area->xol_mapping.name = "[uprobes]";
-	area->xol_mapping.fault = NULL;
-	area->xol_mapping.pages = area->pages;
 	area->pages[0] = alloc_page(GFP_HIGHUSER);
 	if (!area->pages[0])
 		goto free_bitmap;
_

Patches currently in -mm which might be from oleg@redhat.com are


