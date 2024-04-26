Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7707C086
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103930; cv=none; b=lxwp8DCXqwC3MkSgkHL7R5UxNvimccMmeTTKzDRvd2CIaH8OQkZAVKXf3g19NjhBy/MNUh9OlRymEtrov8yooX7eN4EJMyUQ6ZLAz0+6WT3ukjT6sgsoLBVhnvYe3UpBq2uGiW9QMSDjhCMAVjw942xd1OzQ9xoCOFzTnTuiF60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103930; c=relaxed/simple;
	bh=ED24KbIioKni4j8eru/6Z0VMOwjQ0j324VEQaA+qaIA=;
	h=Date:To:From:Subject:Message-Id; b=DM/XC8C4i3dTwO3Df9l2btLEAe2142jhwA9UAVJ5qomBt2ZJfvFx4cAY/ojXqFZT1x16YHf0AHJnJXhtquCf/fYCKI70jeYGgvsldPuJR1AnnqNPr2YJlhLAFANvoQmVvTNeifI7+VznBcdw0RSGzxZ7p3i906Oj9tyihI1Yvjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kKB4u3Dz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kKB4u3Dz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94545C113CD;
	Fri, 26 Apr 2024 03:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103930;
	bh=ED24KbIioKni4j8eru/6Z0VMOwjQ0j324VEQaA+qaIA=;
	h=Date:To:From:Subject:From;
	b=kKB4u3DzdPWsqt16P8/QT1EbTYgHViQXQX5x+XNuUYD6PoKDK9njHr5ewp/T7OIc6
	 o+yVQEO4lrbW6GCnD2NuFRW9KcMFzoosZgKkXWA6HE9Y7FQseaa+uopKPZwtDeBreN
	 jijm599Tvc0SHoBu4/6h1bc9A6Rl8B4l4jIpJIhY=
Date: Thu, 25 Apr 2024 20:58:50 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,surenb@google.com,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memprofiling-documentation.patch removed from -mm tree
Message-Id: <20240426035850.94545C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memprofiling: documentation
has been removed from the -mm tree.  Its filename was
     memprofiling-documentation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: memprofiling: documentation
Date: Thu, 21 Mar 2024 09:36:59 -0700

Provide documentation for memory allocation profiling.

Link: https://lkml.kernel.org/r/20240321163705.3067592-38-surenb@google.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Kees Cook <keescook@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@samsung.com>
Cc: Benno Lossin <benno.lossin@proton.me>
Cc: "Björn Roy Baron" <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/allocation-profiling.rst |  100 ++++++++++++++++++++
 Documentation/mm/index.rst                |    1 
 2 files changed, 101 insertions(+)

--- /dev/null
+++ a/Documentation/mm/allocation-profiling.rst
@@ -0,0 +1,100 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===========================
+MEMORY ALLOCATION PROFILING
+===========================
+
+Low overhead (suitable for production) accounting of all memory allocations,
+tracked by file and line number.
+
+Usage:
+kconfig options:
+- CONFIG_MEM_ALLOC_PROFILING
+
+- CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT
+
+- CONFIG_MEM_ALLOC_PROFILING_DEBUG
+  adds warnings for allocations that weren't accounted because of a
+  missing annotation
+
+Boot parameter:
+  sysctl.vm.mem_profiling=0|1|never
+
+  When set to "never", memory allocation profiling overhead is minimized and it
+  cannot be enabled at runtime (sysctl becomes read-only).
+  When CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT=y, default value is "1".
+  When CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT=n, default value is "never".
+
+sysctl:
+  /proc/sys/vm/mem_profiling
+
+Runtime info:
+  /proc/allocinfo
+
+Example output::
+
+  root@moria-kvm:~# sort -g /proc/allocinfo|tail|numfmt --to=iec
+        2.8M    22648 fs/kernfs/dir.c:615 func:__kernfs_new_node
+        3.8M      953 mm/memory.c:4214 func:alloc_anon_folio
+        4.0M     1010 drivers/staging/ctagmod/ctagmod.c:20 [ctagmod] func:ctagmod_start
+        4.1M        4 net/netfilter/nf_conntrack_core.c:2567 func:nf_ct_alloc_hashtable
+        6.0M     1532 mm/filemap.c:1919 func:__filemap_get_folio
+        8.8M     2785 kernel/fork.c:307 func:alloc_thread_stack_node
+         13M      234 block/blk-mq.c:3421 func:blk_mq_alloc_rqs
+         14M     3520 mm/mm_init.c:2530 func:alloc_large_system_hash
+         15M     3656 mm/readahead.c:247 func:page_cache_ra_unbounded
+         55M     4887 mm/slub.c:2259 func:alloc_slab_page
+        122M    31168 mm/page_ext.c:270 func:alloc_page_ext
+
+===================
+Theory of operation
+===================
+
+Memory allocation profiling builds off of code tagging, which is a library for
+declaring static structs (that typically describe a file and line number in
+some way, hence code tagging) and then finding and operating on them at runtime,
+- i.e. iterating over them to print them in debugfs/procfs.
+
+To add accounting for an allocation call, we replace it with a macro
+invocation, alloc_hooks(), that
+- declares a code tag
+- stashes a pointer to it in task_struct
+- calls the real allocation function
+- and finally, restores the task_struct alloc tag pointer to its previous value.
+
+This allows for alloc_hooks() calls to be nested, with the most recent one
+taking effect. This is important for allocations internal to the mm/ code that
+do not properly belong to the outer allocation context and should be counted
+separately: for example, slab object extension vectors, or when the slab
+allocates pages from the page allocator.
+
+Thus, proper usage requires determining which function in an allocation call
+stack should be tagged. There are many helper functions that essentially wrap
+e.g. kmalloc() and do a little more work, then are called in multiple places;
+we'll generally want the accounting to happen in the callers of these helpers,
+not in the helpers themselves.
+
+To fix up a given helper, for example foo(), do the following:
+- switch its allocation call to the _noprof() version, e.g. kmalloc_noprof()
+
+- rename it to foo_noprof()
+
+- define a macro version of foo() like so:
+
+  #define foo(...) alloc_hooks(foo_noprof(__VA_ARGS__))
+
+It's also possible to stash a pointer to an alloc tag in your own data structures.
+
+Do this when you're implementing a generic data structure that does allocations
+"on behalf of" some other code - for example, the rhashtable code. This way,
+instead of seeing a large line in /proc/allocinfo for rhashtable.c, we can
+break it out by rhashtable type.
+
+To do so:
+- Hook your data structure's init function, like any other allocation function.
+
+- Within your init function, use the convenience macro alloc_tag_record() to
+  record alloc tag in your data structure.
+
+- Then, use the following form for your allocations:
+  alloc_hooks_tag(ht->your_saved_tag, kmalloc_noprof(...))
--- a/Documentation/mm/index.rst~memprofiling-documentation
+++ a/Documentation/mm/index.rst
@@ -26,6 +26,7 @@ see the :doc:`admin guide <../admin-guid
    page_cache
    shmfs
    oom
+   allocation-profiling
 
 Legacy Documentation
 ====================
_

Patches currently in -mm which might be from kent.overstreet@linux.dev are


