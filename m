Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFF3274B57
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490010; cv=none; b=odXLhVdLoOqUveFKHRfNGERo6ze14q0yEhpCPkRoI8mVxg+cMNdOVyjypiZ2mWXeFKu06h+v2PHBDKBtZG8RZN9kKYVb06YR8AlOFqs74f7u13mzFYOgelhaK/AkRB/zeO/DjuFRNIb6nf3QMVSDj5KDNVAWOiKbgiIoRv369vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490010; c=relaxed/simple;
	bh=66sSV34I9ze5WtwQrNecscfCy45uVJFXfy4iURzxrYA=;
	h=Date:To:From:Subject:Message-Id; b=aTx0LT8P5UVW4SCAuAno0FU9+EPrOdAOV/bV1rb875KYCqtE/osgUIELk27O/1FA0mJ2qZQqvUQfVAsez6DMGaE7fRCoYKdwtFje9WWKaq22m3WHg1OrKp9gMgWUa8uf9paZgTanH3k1Su99DCDLK19pWqgu6WTNCLEZ7VUp8IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fMx+Gqi9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fMx+Gqi9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FD0C4CEE7;
	Sun, 21 Sep 2025 21:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758490009;
	bh=66sSV34I9ze5WtwQrNecscfCy45uVJFXfy4iURzxrYA=;
	h=Date:To:From:Subject:From;
	b=fMx+Gqi9uA6gQOYFLFqXIlhV468uuzDb2/Cuh0uRpJMD1uqISiykhJ0yjtV31RwBd
	 qV/O500CbSJB3BmQgfLcm7MrY6wKUBX/1jfTMm0CfsQDhFoj/OY/xsWK2YbzINZ7zs
	 eiN1xKScYKSJq8lBc2M+wZ/mz4PUmecow7PXWFzk=
Date: Sun, 21 Sep 2025 14:26:49 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,usamaarif642@gmail.com,souravpanda@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,rientjes@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,hannes@cmpxchg.org,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output.patch removed from -mm tree
Message-Id: <20250921212649.D6FD0C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: mark inaccurate allocation counters in /proc/allocinfo output
has been removed from the -mm tree.  Its filename was
     alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: mark inaccurate allocation counters in /proc/allocinfo output
Date: Mon, 15 Sep 2025 16:02:24 -0700

While rare, memory allocation profiling can contain inaccurate counters if
slab object extension vector allocation fails.  That allocation might
succeed later but prior to that, slab allocations that would have used
that object extension vector will not be accounted for.  To indicate
incorrect counters, "accurate:no" marker is appended to the call site line
in the /proc/allocinfo output.  Bump up /proc/allocinfo version to reflect
the change in the file format and update documentation.

Example output with invalid counters:
allocinfo - version: 2.0
           0        0 arch/x86/kernel/kdebugfs.c:105 func:create_setup_data_nodes
           0        0 arch/x86/kernel/alternative.c:2090 func:alternatives_smp_module_add
           0        0 arch/x86/kernel/alternative.c:127 func:__its_alloc accurate:no
           0        0 arch/x86/kernel/fpu/regset.c:160 func:xstateregs_set
           0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fpstate_realloc
           0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:arch_enable_hybrid_capacity_scale
           0        0 arch/x86/kernel/cpu/amd_cache_disable.c:258 func:init_amd_l3_attrs
       49152       48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create accurate:no
       32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func:mce_gen_pool_create
           0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mce_threshold_create_device

[surenb@google.com: document new "accurate:no" marker]
  Fixes: 39d117e04d15 ("alloc_tag: mark inaccurate allocation counters in /proc/allocinfo output")
[akpm@linux-foundation.org: simplification per Usama, reflow text]
[akpm@linux-foundation.org: add newline to prevent docs warning, per Randy]
Link: https://lkml.kernel.org/r/20250915230224.4115531-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: David Wang <00107082@163.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |   13 +++++++++++++
 include/linux/alloc_tag.h          |   12 ++++++++++++
 include/linux/codetag.h            |    5 ++++-
 lib/alloc_tag.c                    |    4 +++-
 mm/slub.c                          |    2 ++
 5 files changed, 34 insertions(+), 2 deletions(-)

--- a/Documentation/filesystems/proc.rst~alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output
+++ a/Documentation/filesystems/proc.rst
@@ -1009,6 +1009,19 @@ number, module (if originates from a loa
 the allocation. The number of bytes allocated and number of calls at each
 location are reported. The first line indicates the version of the file, the
 second line is the header listing fields in the file.
+If file version is 2.0 or higher then each line may contain additional
+<key>:<value> pairs representing extra information about the call site.
+For example if the counters are not accurate, the line will be appended with
+"accurate:no" pair.
+
+Supported markers in v2:
+accurate:no
+
+              Absolute values of the counters in this line are not accurate
+              because of the failure to allocate memory to track some of the
+              allocations made at this location.  Deltas in these counters are
+              accurate, therefore counters can be used to track allocation size
+              and count changes.
 
 Example output.
 
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
 
@@ -92,6 +92,8 @@ static void alloc_tag_to_text(struct seq
 
 	seq_buf_printf(out, "%12lli %8llu ", bytes, counter.calls);
 	codetag_to_text(out, ct);
+	if (unlikely(alloc_tag_is_inaccurate(tag)))
+		seq_buf_printf(out, " accurate:no");
 	seq_buf_putc(out, ' ');
 	seq_buf_putc(out, '\n');
 }
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


