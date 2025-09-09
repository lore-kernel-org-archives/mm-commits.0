Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A2C22422A
	for <mm-commits@vger.kernel.org>; Tue,  9 Sep 2025 23:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757461942; cv=none; b=ADyXkLEvVgN9VZelDt6uyHA3TnbTDsuhfZ+yz1UjV8saJM/5gYOU/syVwtHGkGlPdcFnLFXm4D+nLa3fL9gRfeLmTyCxplxtgdhMZ3iZ/yafvhK03dJwhbqu105jYN+MGHNdejk3gsmuztMaCfHHspDLeyBId3q0ZEgpOJ4doKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757461942; c=relaxed/simple;
	bh=knSvot9B5NVAFJRNuMbGRwAHWdoNf5yWkpVl518eZ38=;
	h=Date:To:From:Subject:Message-Id; b=jBleZUJ9nsdoyaao9rbbQqeAGA8rDjcJPBCufus8y8A85s7DZY/G/GaOmd1ssgSRFWRLSqsb3GJFxCxUK7ykWU+IG4txhFX5nGNJAmU/Fu61+LrfpxcEWqESvYK5OEzcRrk7z23VlPIh9/drU8clQqyIdY/J/nQYKS0P6N0FHnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=drCQXngi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="drCQXngi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DBDC4CEF4;
	Tue,  9 Sep 2025 23:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757461942;
	bh=knSvot9B5NVAFJRNuMbGRwAHWdoNf5yWkpVl518eZ38=;
	h=Date:To:From:Subject:From;
	b=drCQXngi5P2rQyvrXN8V5GU3l91TOGpBkyexOeZ2zuB8/qlO0IS9x6YPGtxsla+dE
	 PvUu6GZL19U1pJVG6w3/8RViZC/naBi7BlleC5ChwvmwanSbvuyFqzkDjjH5MmfCVJ
	 U21K6z5PJD+3AgB9xy6fXDAABGVMggEoNklWCySM=
Date: Tue, 09 Sep 2025 16:52:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,usamaarif642@gmail.com,souravpanda@google.com,shakeel.butt@linux.dev,pasha.tatashin@soleen.com,mhocko@suse.com,kent.overstreet@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-prevent-enabling-memory-profiling-if-it-was-shut-down.patch added to mm-new branch
Message-Id: <20250909235222.08DBDC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: prevent enabling memory profiling if it was shut down
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-prevent-enabling-memory-profiling-if-it-was-shut-down.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-prevent-enabling-memory-profiling-if-it-was-shut-down.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: prevent enabling memory profiling if it was shut down
Date: Tue, 9 Sep 2025 16:34:08 -0700

Memory profiling can be shut down due to reasons like a failure during
initialization.  When this happens, the user should not be able to
re-enable it.  Current sysctrl interface does not handle this properly and
will allow re-enabling memory profiling.  Fix this by checking for this
condition during sysctrl write operation.

Link: https://lkml.kernel.org/r/20250909233409.1013367-3-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Wang <00107082@163.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/lib/alloc_tag.c~alloc_tag-prevent-enabling-memory-profiling-if-it-was-shut-down
+++ a/lib/alloc_tag.c
@@ -767,6 +767,16 @@ struct page_ext_operations page_alloc_ta
 EXPORT_SYMBOL(page_alloc_tagging_ops);
 
 #ifdef CONFIG_SYSCTL
+static int proc_mem_profiling_handler(const struct ctl_table *table, int write,
+				      void *buffer, size_t *lenp, loff_t *ppos)
+{
+	if (!mem_profiling_support && write)
+		return -EINVAL;
+
+	return proc_do_static_key(table, write, buffer, lenp, ppos);
+}
+
+
 static struct ctl_table memory_allocation_profiling_sysctls[] = {
 	{
 		.procname	= "mem_profiling",
@@ -776,7 +786,7 @@ static struct ctl_table memory_allocatio
 #else
 		.mode		= 0644,
 #endif
-		.proc_handler	= proc_do_static_key,
+		.proc_handler	= proc_mem_profiling_handler,
 	},
 };
 
_

Patches currently in -mm which might be from surenb@google.com are

mm-limit-the-scope-of-vma_start_read.patch
mm-change-vma_start_read-to-drop-rcu-lock-on-failure.patch
selftests-proc-test-procmap_query-ioctl-while-vma-is-concurrently-modified.patch
fs-proc-task_mmu-factor-out-proc_maps_private-fields-used-by-procmap_query.patch
fs-proc-task_mmu-execute-procmap_query-ioctl-under-per-vma-locks.patch
alloc_tag-use-release_pages-in-the-cleanup-path.patch
alloc_tag-prevent-enabling-memory-profiling-if-it-was-shut-down.patch
alloc_tag-avoid-warnings-when-freeing-non-compound-tail-pages.patch

