Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B97663B9
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854854; cv=none; b=oLR+0BOx5yPFePF2fBlYsOAS13kZIqBg9Oc+YoficImcocmXZ/BwnajhTJ5YK6OE9a2DuaOT6nmXWl2FGzbNqZ/WJ9ov9J93SDsU5qqiEReap2HLimKOYIOUj2oxp7Ti49/CwN+l2ausxMXkX8k+G1BFzQOVTNbJpnCHNkMWYQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854854; c=relaxed/simple;
	bh=kPC4CKhH8cWtQRK6LjWw+/zV1Igl5OX2lFPAQVdRR3s=;
	h=Date:To:From:Subject:Message-Id; b=mMQV3izHmURT+NMtRMkJdKeeCNdEql+Ift2uFMEIejHmBU1hOIL6XEuPQaLU3Mskru4yHjRWFclux6pBgI7bCp4U1Unwtv11/bkS68YXrFuOhl58w2uij1XHB6pku5R8+beYdlv3q4hL2mn0aKOINhPaaqH/M6o+3uQcy32gMyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=az/RrHfY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="az/RrHfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E043CC4CECF;
	Wed,  6 Nov 2024 01:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854854;
	bh=kPC4CKhH8cWtQRK6LjWw+/zV1Igl5OX2lFPAQVdRR3s=;
	h=Date:To:From:Subject:From;
	b=az/RrHfYAaeigg+7SpHg7Xi2eZDqix+5+7K6HN69CfsMEhS/KRjZqA9PBR1d5NwiO
	 SCoyqBTVgdxl3vyROZEKeAvTrzKYw3ye+RBcrWl46HMhts7a96YE9hba3qI11JSbvN
	 8jACLyl3MM/0soV4remUreAP1bHK/bZPvEvCKI1Q=
Date: Tue, 05 Nov 2024 17:00:53 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,xiongwei.song@windriver.com,willy@infradead.org,vbabka@suse.cz,urezki@gmail.com,thuth@redhat.com,tglx@linutronix.de,souravpanda@google.com,samitolvanen@google.com,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,petr.pavlu@suse.com,paulmck@kernel.org,pasha.tatashin@soleen.com,minchan@google.com,mhocko@suse.com,mcgrof@kernel.org,Liam.Howlett@Oracle.com,kent.overstreet@linux.dev,keescook@chromium.org,kaleshsingh@google.com,jhubbard@nvidia.com,iamjoonsoo.kim@lge.com,hch@infradead.org,hannes@cmpxchg.org,dennis@kernel.org,david@redhat.com,dave@stgolabs.net,da.gomez@samsung.com,corbet@lwn.net,bp@alien8.de,arnd@arndb.de,ardb@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-add-mas_for_each_rev-helper.patch removed from -mm tree
Message-Id: <20241106010053.E043CC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: add mas_for_each_rev() helper
has been removed from the -mm tree.  Its filename was
     maple_tree-add-mas_for_each_rev-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculation_beginend.patch

