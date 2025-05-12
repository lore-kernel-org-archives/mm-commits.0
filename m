Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADD118A953
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011058; cv=none; b=G5492GY3xZxfICb2aH1a6bpJNh2Ek25yFZmuLoQnVmj4MlNIzGi2PITV6qAh/vAsKymTPxTzXXxM8buv4pfkFeXPB83fTbXL8sm3gK8u0/16Fsj4wk7EEnGcfaZDBnvSPpxVivbGVKq6jpjWZo+Gbbm8QOLRPFt6sITSGSBXe/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011058; c=relaxed/simple;
	bh=JjLQxzwBm9pnBSws3po0DSHrhiZEoS7XKZZ3aqwhqmg=;
	h=Date:To:From:Subject:Message-Id; b=QfAiii4ks36Nx1yBR7EtUKMpxs8ywJwUY4EFQkoDGrh7hOonZcynps9w8EdDdVajrrIyZxLov7HEB6+fd0LaLYjM1pI3SQnu0aVLc7scHcGJY/d3KCjkNGSKpqFL4UcsEDgiZeD8Va9Z0Rv9uyzQwwIHMwRHPY7Q31DJLAHG8Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A8wLnL61; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A8wLnL61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013DDC4CEE4;
	Mon, 12 May 2025 00:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011058;
	bh=JjLQxzwBm9pnBSws3po0DSHrhiZEoS7XKZZ3aqwhqmg=;
	h=Date:To:From:Subject:From;
	b=A8wLnL6186FBvx7os80uAw3nzXj/SsNdJcYNy5gvy/dntdsEURroAur2OkWtJRr81
	 X5PEhmaVYxFaEphow4Z1bPZCBkkYYbopgP5dr3Bo3RpkCkH9v/hghRupqeXxACBTCb
	 D/ElA63L1b5qH9m2XT1XUrv/53LcjkRiJ/91Bo6U=
Date: Sun, 11 May 2025 17:50:57 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tongtiangen@huawei.com,peterz@infradead.org,olsajiri@gmail.com,oleg@redhat.com,namhyung@kernel.org,mingo@redhat.com,mhiramat@kernel.org,mark.rutland@arm.com,linux@armlinux.org.uk,kan.liang@linux.intel.com,irogers@google.com,andrii.nakryiko@gmail.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kernel-events-uprobes-pass-vma-instead-of-mm-to-remove_breakpoint.patch removed from -mm tree
Message-Id: <20250512005058.013DDC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/events/uprobes: pass VMA instead of MM to remove_breakpoint()
has been removed from the -mm tree.  Its filename was
     kernel-events-uprobes-pass-vma-instead-of-mm-to-remove_breakpoint.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
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

selftests-mm-add-simple-vm_pfnmap-tests-based-on-mmaping-dev-mem.patch

