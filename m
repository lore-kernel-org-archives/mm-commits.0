Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AC0339379
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465805; cv=none; b=AGzAmVMGeoGLTpBhUAVoai9iGHpqzodXE4i4WEl4bKWGy5JF7tf4pTfNOFxClYL4nb0UtIEBVH8B5EPhxnUSwGvZtDTwGXdRvmWLtrrKB0sQesJdLqFC9daBnJkXA7huMB0VHK+y3aWVtvmexrJKAcXhhDewgDphCLsbVtd47Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465805; c=relaxed/simple;
	bh=3ze/uuwUF4g9gO55kG+uFyYuSGOhNoosr0a1+hnxfV8=;
	h=Date:To:From:Subject:Message-Id; b=srTfcWcS2l/AIIrZS++2n8dBHD7fP9C9uLe8EqEncdQXzC2/0GB20D5SuHPFOTaX0EciRCVnj6h4EGP4DtD7IKZ1Sl9+cGa2HrzybUU/lGAS0mcLBJK8HlMjOek62LUoPw5PWxumzR7wEOqylU4rv2RCM8XJh/MKEHw2/tvUxz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VqBIrbj3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VqBIrbj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188181F00A3A;
	Fri, 31 Jul 2026 02:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465804;
	bh=e7sIhbRfxZCmiveQETTmSEXXjTE0qOno8RsiQ/XTRkg=;
	h=Date:To:From:Subject;
	b=VqBIrbj3qNINEO9j4KpBT/DLLEIi4U9F8uKVNkMPuuEqDrx3psSZnVcOuxN7Y6pU0
	 KHUp6t9mosow2CGXBYpXd18TLGrhAkvatZ60ZvNh2vXahSsk/dXeyPGppBJR8dwgDE
	 tb2vlxfZqVl8LMAF0k1qezq/9bwfz6eCl62+zxyQ=
Date: Thu, 30 Jul 2026 19:43:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,peterz@infradead.org,namhyung@kernel.org,mingo@redhat.com,mark.rutland@arm.com,jolsa@kernel.org,james.clark@linaro.org,irogers@google.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] perf-x86-intel-use-higher-level-allocator-api.patch removed from -mm tree
Message-Id: <20260731024324.188181F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: perf/x86/intel: use higher-level allocator API
has been removed from the -mm tree.  Its filename was
     perf-x86-intel-use-higher-level-allocator-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: perf/x86/intel: use higher-level allocator API
Date: Fri, 03 Jul 2026 12:31:48 +0000

The difference between __alloc_pages_node() and alloc_pages_node() is that
the latter allows you to pass NUMA_NO_NODE.

The former is going away and the latter works fine here so switch over.

No functional change intended.

Link: https://lore.kernel.org/20260703-alloc-trylock-v5-8-c87b714e19d3@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: James Clark <james.clark@linaro.org>
Assisted-by: Gemini:unknown-version
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/events/intel/ds.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/events/intel/ds.c~perf-x86-intel-use-higher-level-allocator-api
+++ a/arch/x86/events/intel/ds.c
@@ -832,7 +832,7 @@ static void *dsalloc_pages(size_t size,
 	int node = cpu_to_node(cpu);
 	struct page *page;
 
-	page = __alloc_pages_node(node, flags | __GFP_ZERO, order);
+	page = alloc_pages_node(node, flags | __GFP_ZERO, order);
 	return page ? page_address(page) : NULL;
 }
 
@@ -1088,9 +1088,9 @@ void init_arch_pebs_on_cpu(int cpu)
 
 	/*
 	 * 4KB-aligned pointer of the output buffer
-	 * (__alloc_pages_node() return page aligned address)
+	 * (alloc_pages_node() returns page aligned address)
 	 * Buffer Size = 4KB * 2^SIZE
-	 * contiguous physical buffer (__alloc_pages_node() with order)
+	 * contiguous physical buffer (alloc_pages_node() with order)
 	 */
 	arch_pebs_base = virt_to_phys(cpuc->pebs_vaddr) | PEBS_BUFFER_SHIFT;
 	wrmsrq_on_cpu(cpu, MSR_IA32_PEBS_BASE, arch_pebs_base);
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-secretmem-dont-allow-highmem-folios.patch
mm-page_alloc-dont-spin_trylock-in-nmi-on-up.patch
mm-page_alloc-dont-spin_trylock-when-disallowed-in-free_one_page.patch
mm-page_alloc-rename-fpi_trylock-fpi_nolock.patch
cgroup-cpuset-update-some-comments-about-the-page-allocator.patch
mm-page_alloc-fixup-alloc_pages_nolock_noprof-comment.patch
mm-page_alloc-remove-a-couple-of-vm_bug_onst.patch

