Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBB61E2826
	for <mm-commits@vger.kernel.org>; Wed, 23 Oct 2024 21:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729717481; cv=none; b=JJjnKmby6ZZNyn5mtxC15m8GvIBhlxe9nLdLr+5ypZMAH0r15nlmJ0dWqu+tkyLWbBLnnbVbCGr0zQC87FkvzwpISOed82iT+5RK+JWX5weF+XdhB4xbKbmvmV/w00iYVXO+33u08xoCzGaZ5cmtpX89Wg0YwEYMopSFHeD00YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729717481; c=relaxed/simple;
	bh=7knages4CaxxWfgUr0sAu1kpOkL6GVVQg+x0bZ8oZLo=;
	h=Date:To:From:Subject:Message-Id; b=e+bJvJ4+hCqPSVX/TtQ2w5hT5BknLljNzcLxoI5RrfFydJCLKgSdl1ehedOK17dt+x0iYm+nJy1hXC4GbYtfc5U2QlwQgGfkY59VbqWnraA8al4396Rn3Nz81JS2bPDqIJq7xP8fZzeSOMfmDtdA0YNuxoGLkPF/GVT8A/F+9vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HngFVss5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HngFVss5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE60C4CEC6;
	Wed, 23 Oct 2024 21:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729717481;
	bh=7knages4CaxxWfgUr0sAu1kpOkL6GVVQg+x0bZ8oZLo=;
	h=Date:To:From:Subject:From;
	b=HngFVss5cuPbxmJ2Q4//W85ZkWlQJ3PjFlYiLHuc6wWhLCy+AmMIfhxDM2rfcL3SS
	 G0jl54REFYO6LzV05mFlHQLTUNV9z0/hI/9K8XU192D5BzfZKsVgPrgBLImU3GnD1c
	 ATZ9+0BCm5dAcEyU0PupCbpXze4kyGUuEdTZKgkQ=
Date: Wed, 23 Oct 2024 14:04:38 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,xiongwei.song@windriver.com,willy@infradead.org,vbabka@suse.cz,urezki@gmail.com,thuth@redhat.com,tglx@linutronix.de,souravpanda@google.com,samitolvanen@google.com,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,petr.pavlu@suse.com,paulmck@kernel.org,pasha.tatashin@soleen.com,minchan@google.com,mhocko@suse.com,mcgrof@kernel.org,Liam.Howlett@Oracle.com,kent.overstreet@linux.dev,keescook@chromium.org,kaleshsingh@google.com,jhubbard@nvidia.com,iamjoonsoo.kim@lge.com,hch@infradead.org,hannes@cmpxchg.org,dennis@kernel.org,david@redhat.com,dave@stgolabs.net,da.gomez@samsung.com,corbet@lwn.net,bp@alien8.de,arnd@arndb.de,ardb@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-mas_for_each_rev-helper.patch added to mm-unstable branch
Message-Id: <20241023210439.BDE60C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: add mas_for_each_rev() helper
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-add-mas_for_each_rev-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-mas_for_each_rev-helper.patch

This patch will later appear in the mm-unstable branch at
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
From: Suren Baghdasaryan <surenb@google.com>
Subject: maple_tree: add mas_for_each_rev() helper
Date: Wed, 23 Oct 2024 10:07:54 -0700

Patch series "page allocation tag compression", v4.

This patchset implements several improvements:

1. Gracefully handles module unloading while there are used
   allocations allocated from that module;

2. Provides an option to store page allocation tag references in the
   page flags, removing dependency on page extensions and eliminating the
   memory overhead from storing page allocation references (~0.2% of total
   system memory).  This also improves page allocation performance when
   CONFIG_MEM_ALLOC_PROFILING is enabled by eliminating page extension
   lookup.  Page allocation performance overhead is reduced from 41% to
   5.5%.

Patch #1 introduces mas_for_each_rev() helper function.

Patch #2 introduces shutdown_mem_profiling() helper function to be used
when disabling memory allocation profiling.

Patch #3 copies module tags into virtually contiguous memory which
serves two purposes:

- Lets us deal with the situation when module is unloaded while there
  are still live allocations from that module.  Since we are using a copy
  version of the tags we can safely unload the module.  Space and gaps in
  this contiguous memory are managed using a maple tree.

- Enables simple indexing of the tags in the later patches.

Patch #4 changes the way we allocate virtually contiguous memory for
module tags to reserve only vitrual area and populate physical pages only
as needed at module load time.

Patch #5 abstracts page allocation tag reference to simplify later
changes.

Patch #6 adds compression option to the sysctl.vm.mem_profiling boot
parameter for storing page allocation tag references inside page flags if
they fit.  If the number of available page flag bits is insufficient to
address all kernel allocations, memory allocation profiling gets disabled
with an appropriate warning.


This patch (of 6):

Add mas_for_each_rev() function to iterate maple tree nodes in reverse
order.

Link: https://lkml.kernel.org/r/20241023170759.999909-1-surenb@google.com
Link: https://lkml.kernel.org/r/20241023170759.999909-2-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Minchan Kim <minchan@google.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xiongwei Song <xiongwei.song@windriver.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/include/linux/maple_tree.h~maple_tree-add-mas_for_each_rev-helper
+++ a/include/linux/maple_tree.h
@@ -592,6 +592,20 @@ static __always_inline void mas_reset(st
 #define mas_for_each(__mas, __entry, __max) \
 	while (((__entry) = mas_find((__mas), (__max))) != NULL)
 
+/**
+ * mas_for_each_rev() - Iterate over a range of the maple tree in reverse order.
+ * @__mas: Maple Tree operation state (maple_state)
+ * @__entry: Entry retrieved from the tree
+ * @__min: minimum index to retrieve from the tree
+ *
+ * When returned, mas->index and mas->last will hold the entire range for the
+ * entry.
+ *
+ * Note: may return the zero entry.
+ */
+#define mas_for_each_rev(__mas, __entry, __min) \
+	while (((__entry) = mas_find_rev((__mas), (__min))) != NULL)
+
 #ifdef CONFIG_DEBUG_MAPLE_TREE
 enum mt_dump_format {
 	mt_dump_dec,
_

Patches currently in -mm which might be from surenb@google.com are

maple_tree-add-mas_for_each_rev-helper.patch
alloc_tag-introduce-shutdown_mem_profiling-helper-function.patch
alloc_tag-load-module-tags-into-separate-contiguous-memory.patch
alloc_tag-populate-memory-for-module-tags-as-needed.patch
alloc_tag-introduce-pgtag_ref_handle-to-abstract-page-tag-references.patch
alloc_tag-support-for-page-allocation-tag-compression.patch

