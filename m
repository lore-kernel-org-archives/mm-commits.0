Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381C431D39A
	for <mm-commits@vger.kernel.org>; Wed, 10 Sep 2025 05:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757482246; cv=none; b=gE097aYTe7cBRwQ7KdEBYs2Yw9tQkZ0O9mcuckUhQvRKpaQaKP+t1mB3Ayg1eMPbUwox3UUVvdEUl5Q79pFRQh0+pw6vQu2dfrnmfPmqvCtLeqi7gHrEGu2iI1/vC5MdSdhkPc84xHScLt2i9XcUWKr07VX/5Qtc2to0Y+W8HEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757482246; c=relaxed/simple;
	bh=K3wU9/m2vgwlxKnaVV7SAtsZUN/BC0nrB96LHGcmhjU=;
	h=Date:To:From:Subject:Message-Id; b=K1IHuUOiRY5035VzxU6t5hiv82HvmMj0xOm1fDOj/IclharuGIk89Zc87vAzKv/Fh7saVoI4lp0xFIX+zTYk02RTZJlgIu5gGO6jHErYwegVbRVW4YWzIGsugaMUA2c+TXgYA7BcYfNVrUe/vbgD27Y73BPJPfwptVlorROeVDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U1jefsHK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U1jefsHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2EFC4CEF0;
	Wed, 10 Sep 2025 05:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757482245;
	bh=K3wU9/m2vgwlxKnaVV7SAtsZUN/BC0nrB96LHGcmhjU=;
	h=Date:To:From:Subject:From;
	b=U1jefsHKNt86u18YI3p4bOkcSJXNSRl+g3YL1E17tbYO/1AmXg3xJ8F1uF7YByMEt
	 rvdSc5YR1wYH8SLk10ddqjGMtNzp35pLlCvo28mtBTiuCVl+H5JLIJ+JgiAuLlOINv
	 9sER8Fwu22WBBgmGbhI0JVgHEVFcC8iwqgy2NgsE=
Date: Tue, 09 Sep 2025 22:30:45 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,usamaarif642@gmail.com,souravpanda@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,rientjes@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,hannes@cmpxchg.org,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output.patch added to mm-new branch
Message-Id: <20250910053045.AB2EFC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: mark inaccurate allocation counters in /proc/allocinfo output
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output.patch

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
Subject: alloc_tag: mark inaccurate allocation counters in /proc/allocinfo output
Date: Tue, 9 Sep 2025 16:49:42 -0700

While rare, memory allocation profiling can contain inaccurate counters if
slab object extension vector allocation fails.  That allocation might
succeed later but prior to that, slab allocations that would have used
that object extension vector will not be accounted for.  To indicate
incorrect counters, mark them with an asterisk in the /proc/allocinfo
output.  Bump up /proc/allocinfo version to reflect change in the file
format.

Example output with invalid counters:
allocinfo - version: 2.0
           0        0 arch/x86/kernel/kdebugfs.c:105 func:create_setup_data_nodes
           0        0 arch/x86/kernel/alternative.c:2090 func:alternatives_smp_module_add
          0*       0* arch/x86/kernel/alternative.c:127 func:__its_alloc
           0        0 arch/x86/kernel/fpu/regset.c:160 func:xstateregs_set
           0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fpstate_realloc
           0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:arch_enable_hybrid_capacity_scale
           0        0 arch/x86/kernel/cpu/amd_cache_disable.c:258 func:init_amd_l3_attrs
      49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create
       32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func:mce_gen_pool_create
           0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mce_threshold_create_device

Link: https://lkml.kernel.org/r/20250909234942.1104356-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: David Wang <00107082@163.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h |   12 ++++++++++++
 include/linux/codetag.h   |    5 ++++-
 lib/alloc_tag.c           |    7 +++++--
 mm/slub.c                 |    2 ++
 4 files changed, 23 insertions(+), 3 deletions(-)

--- a/include/linux/alloc_tag.h~alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output
+++ a/include/linux/alloc_tag.h
@@ -221,6 +221,16 @@ static inline void alloc_tag_sub(union c
 	ref->ct = NULL;
 }
 
+static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
+{
+	tag->ct.flags |= CODETAG_FLAG_INACCURATE;
+}
+
+static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
+{
+	return !!(tag->ct.flags & CODETAG_FLAG_INACCURATE);
+}
+
 #define alloc_tag_record(p)	((p) = current->alloc_tag)
 
 #else /* CONFIG_MEM_ALLOC_PROFILING */
@@ -230,6 +240,8 @@ static inline bool mem_alloc_profiling_e
 static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag,
 				 size_t bytes) {}
 static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes) {}
+static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag) {}
+static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag) { return false; }
 #define alloc_tag_record(p)	do {} while (0)
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
--- a/include/linux/codetag.h~alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output
+++ a/include/linux/codetag.h
@@ -16,13 +16,16 @@ struct module;
 #define CODETAG_SECTION_START_PREFIX	"__start_"
 #define CODETAG_SECTION_STOP_PREFIX	"__stop_"
 
+/* codetag flags */
+#define CODETAG_FLAG_INACCURATE	(1 << 0)
+
 /*
  * An instance of this structure is created in a special ELF section at every
  * code location being tagged.  At runtime, the special section is treated as
  * an array of these.
  */
 struct codetag {
-	unsigned int flags; /* used in later patches */
+	unsigned int flags;
 	unsigned int lineno;
 	const char *modname;
 	const char *function;
--- a/lib/alloc_tag.c~alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output
+++ a/lib/alloc_tag.c
@@ -80,7 +80,7 @@ static void allocinfo_stop(struct seq_fi
 static void print_allocinfo_header(struct seq_buf *buf)
 {
 	/* Output format version, so we can change it. */
-	seq_buf_printf(buf, "allocinfo - version: 1.0\n");
+	seq_buf_printf(buf, "allocinfo - version: 2.0\n");
 	seq_buf_printf(buf, "#     <size>  <calls> <tag info>\n");
 }
 
@@ -90,7 +90,10 @@ static void alloc_tag_to_text(struct seq
 	struct alloc_tag_counters counter = alloc_tag_read(tag);
 	s64 bytes = counter.bytes;
 
-	seq_buf_printf(out, "%12lli %8llu ", bytes, counter.calls);
+	if (unlikely(alloc_tag_is_inaccurate(tag)))
+		seq_buf_printf(out, "%11lli* %7llu* ", bytes, counter.calls);
+	else
+		seq_buf_printf(out, "%12lli %8llu ", bytes, counter.calls);
 	codetag_to_text(out, ct);
 	seq_buf_putc(out, ' ');
 	seq_buf_putc(out, '\n');
--- a/mm/slub.c~alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output
+++ a/mm/slub.c
@@ -2143,6 +2143,8 @@ __alloc_tagging_slab_alloc_hook(struct k
 	 */
 	if (likely(obj_exts))
 		alloc_tag_add(&obj_exts->ref, current->alloc_tag, s->size);
+	else
+		alloc_tag_set_inaccurate(current->alloc_tag);
 }
 
 static inline void
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
alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output.patch

