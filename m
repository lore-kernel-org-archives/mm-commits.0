Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAB815199A
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 05:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744003216; cv=none; b=QBCpv9zaJ/JWcsmofXvyi9w69eqkm6rfHQ7lFRQDvgsWxjZAixoJ+WTa5oIpNBmIz8cxrl2wEUrbiiZUPb/ijMc7UwbdaJ8VrmeegchDzBgPP4as7Z/S6dzNYPtcfmqnumlDEqRietFFhHr2o0tBp4Mql7XurCEdYePdDVGbzn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744003216; c=relaxed/simple;
	bh=IEPOb3w3OY9zLrD7IcmUv+3IBSsPvki+r4qC5NFdBKo=;
	h=Date:To:From:Subject:Message-Id; b=q+og9xswT1tRjg7h2QftcbhvQvIAQltBKAgM4WbOkPHDfODP4gwDZ0JMsWpaxMzqFUiWG9OGziHAz8FBLsYXYBztSX43xoDkxb4kqXBW7jL72+8rG4/RfMGtUnzawx8N5Ii9U7k9Lmlv5beDFBdmm5PG+18uPGh0SYgUtO9KmYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W7dM4j54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W7dM4j54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C3BC4CEE8;
	Mon,  7 Apr 2025 05:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744003216;
	bh=IEPOb3w3OY9zLrD7IcmUv+3IBSsPvki+r4qC5NFdBKo=;
	h=Date:To:From:Subject:From;
	b=W7dM4j54lV8j3+MDOazm30LYrwfSC4NglaBlO7GIbrxY2kBQsrIdXlUywkthwG2V/
	 1K9OU6dvzErGBfmmxqrRZY+U/pJXvGxCa64urtL5Mg/uEQIfYbMOfJONdDin4dWHDV
	 AY8qeLrxP4/HLctlAQYWzHoVLMqvgqxgcnOqFHcI=
Date: Sun, 06 Apr 2025 22:20:15 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tongtiangen@huawei.com,peterz@infradead.org,olsajiri@gmail.com,oleg@redhat.com,namhyung@kernel.org,mingo@redhat.com,mhiramat@kernel.org,mark.rutland@arm.com,linux@armlinux.org.uk,kan.liang@linux.intel.com,irogers@google.com,andrii.nakryiko@gmail.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-events-uprobes-pass-vma-instead-of-mm-to-remove_breakpoint.patch added to mm-new branch
Message-Id: <20250407052015.E2C3BC4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/events/uprobes: pass VMA instead of MM to remove_breakpoint()
has been added to the -mm mm-new branch.  Its filename is
     kernel-events-uprobes-pass-vma-instead-of-mm-to-remove_breakpoint.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-events-uprobes-pass-vma-instead-of-mm-to-remove_breakpoint.patch

This patch will later appear in the mm-new branch at
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
From: David Hildenbrand <david@redhat.com>
Subject: kernel/events/uprobes: pass VMA instead of MM to remove_breakpoint()
Date: Fri, 21 Mar 2025 12:37:11 +0100

Patch series "kernel/events/uprobes: uprobe_write_opcode() rewrite", v3.

Currently, uprobe_write_opcode() implements COW-breaking manually, which
is really far from ideal.  Further, there is interest in supporting
uprobes on hugetlb pages [1], and leaving at least the COW-breaking to the
core will make this much easier.

Also, I think the current code doesn't really handle some things properly
(see patch #3) when replacing/zapping pages.

Let's rewrite it, to leave COW-breaking to the fault handler, and handle
registration/unregistration by temporarily unmapping the anonymous page,
modifying it, and mapping it again.  We still have to implement zapping of
anonymous pages ourselves, unfortunately.

We could look into not performing the temporary unmapping if we can
perform the write atomically, which would likely also make adding hugetlb
support a lot easier.  But, limited (e.g., only PMD/PUD) hugetlb support
could be added on top of this with some tweaking.

Note that we now won't have to allocate another anonymous folio when
unregistering (which will be beneficial for hugetlb as well), we can
simply modify the already-mapped one from the registration (if any).  When
registering a uprobe, we'll first trigger a ptrace-like write fault to
break COW, to then modify the already-mapped page.

Briefly sanity tested with perf probes and with the bpf uprobes selftest.


This patch (of 3):

Pass VMA instead of MM to remove_breakpoint() and remove the "MM" argument
from install_breakpoint(), because it can easily be derived from the VMA.

Link: https://lkml.kernel.org/r/20250321113713.204682-1-david@redhat.com
Link: https://lkml.kernel.org/r/20250321113713.204682-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Namhyung kim <namhyung@kernel.org>
Cc: Russel King <linux@armlinux.org.uk>
Cc: tongtiangen <tongtiangen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/kernel/events/uprobes.c~kernel-events-uprobes-pass-vma-instead-of-mm-to-remove_breakpoint
+++ a/kernel/events/uprobes.c
@@ -1134,10 +1134,10 @@ static bool filter_chain(struct uprobe *
 	return ret;
 }
 
-static int
-install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
-			struct vm_area_struct *vma, unsigned long vaddr)
+static int install_breakpoint(struct uprobe *uprobe, struct vm_area_struct *vma,
+		unsigned long vaddr)
 {
+	struct mm_struct *mm = vma->vm_mm;
 	bool first_uprobe;
 	int ret;
 
@@ -1162,9 +1162,11 @@ install_breakpoint(struct uprobe *uprobe
 	return ret;
 }
 
-static int
-remove_breakpoint(struct uprobe *uprobe, struct mm_struct *mm, unsigned long vaddr)
+static int remove_breakpoint(struct uprobe *uprobe, struct vm_area_struct *vma,
+		unsigned long vaddr)
 {
+	struct mm_struct *mm = vma->vm_mm;
+
 	set_bit(MMF_RECALC_UPROBES, &mm->flags);
 	return set_orig_insn(&uprobe->arch, mm, vaddr);
 }
@@ -1296,10 +1298,10 @@ register_for_each_vma(struct uprobe *upr
 		if (is_register) {
 			/* consult only the "caller", new consumer. */
 			if (consumer_filter(new, mm))
-				err = install_breakpoint(uprobe, mm, vma, info->vaddr);
+				err = install_breakpoint(uprobe, vma, info->vaddr);
 		} else if (test_bit(MMF_HAS_UPROBES, &mm->flags)) {
 			if (!filter_chain(uprobe, mm))
-				err |= remove_breakpoint(uprobe, mm, info->vaddr);
+				err |= remove_breakpoint(uprobe, vma, info->vaddr);
 		}
 
  unlock:
@@ -1472,7 +1474,7 @@ static int unapply_uprobe(struct uprobe
 			continue;
 
 		vaddr = offset_to_vaddr(vma, uprobe->offset);
-		err |= remove_breakpoint(uprobe, mm, vaddr);
+		err |= remove_breakpoint(uprobe, vma, vaddr);
 	}
 	mmap_read_unlock(mm);
 
@@ -1610,7 +1612,7 @@ int uprobe_mmap(struct vm_area_struct *v
 		if (!fatal_signal_pending(current) &&
 		    filter_chain(uprobe, vma->vm_mm)) {
 			unsigned long vaddr = offset_to_vaddr(vma, uprobe->offset);
-			install_breakpoint(uprobe, vma->vm_mm, vma, vaddr);
+			install_breakpoint(uprobe, vma, vaddr);
 		}
 		put_uprobe(uprobe);
 	}
_

Patches currently in -mm which might be from david@redhat.com are

x86-mm-pat-untrack_pfn_copy-fix-improvements.patch
kernel-events-uprobes-pass-vma-instead-of-mm-to-remove_breakpoint.patch
kernel-events-uprobes-pass-vma-to-set_swbp-set_orig_insn-and-uprobe_write_opcode.patch
kernel-events-uprobes-uprobe_write_opcode-rewrite.patch

