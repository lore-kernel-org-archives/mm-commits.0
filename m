Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F2E19DF4B
	for <mm-commits@vger.kernel.org>; Wed, 23 Oct 2024 21:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729717523; cv=none; b=hNVhZxsncWIEIu1Q/cn27s/xWhhEZPyxIpWC9+RY06OvsdD+sZrwHXsr82oi5MtlKstVGOH4oEZ7KUPjq6d8ju4j0tnM2Nt+odifqziJAXA19f8/sW2MHEtAboSKvO5dTI9/0nC92cHMYBA5jOUPmmgHJtK2cBHK65NEc93uDc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729717523; c=relaxed/simple;
	bh=WPXMidKny/QZShoOLaxxmMnfpYCNvqYlu2kDyO8j838=;
	h=Date:To:From:Subject:Message-Id; b=UVe3sFa8BIvCpG1TqxFw0ixY0dUFndGxQYyPUrbz/pSmgsUYCg6/NJAfrOLHR5WcI0hwKs+NAPawUqNyMxSyACfBHpuplGEXA2WROORhycvRDTp3O5DFiZHjkMNNhSU7L5lPYn61Xt+z+CLH4vopm2/azBOMJBFirml3oOXAr+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZhdXAjIl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZhdXAjIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96A6C4CEC6;
	Wed, 23 Oct 2024 21:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729717522;
	bh=WPXMidKny/QZShoOLaxxmMnfpYCNvqYlu2kDyO8j838=;
	h=Date:To:From:Subject:From;
	b=ZhdXAjIla10Moqg8yLYye/uq0CEhj6ldp8Co5JxISoR6NMYx9Mztqiksbh3r8FX5g
	 3pZfSufyo6W1AZKFXo7huhTLEZdvL11Sqm3WNP8TvumCBBmIYVO/VgDkGkPM0eXsp2
	 piZFtBLW5ycxVRRGEnjHYr3J1z3VRNz0xJbyPqZI=
Date: Wed, 23 Oct 2024 14:05:15 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,xiongwei.song@windriver.com,willy@infradead.org,vbabka@suse.cz,urezki@gmail.com,thuth@redhat.com,tglx@linutronix.de,souravpanda@google.com,samitolvanen@google.com,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,petr.pavlu@suse.com,paulmck@kernel.org,pasha.tatashin@soleen.com,minchan@google.com,mhocko@suse.com,mcgrof@kernel.org,Liam.Howlett@Oracle.com,kent.overstreet@linux.dev,keescook@chromium.org,kaleshsingh@google.com,jhubbard@nvidia.com,iamjoonsoo.kim@lge.com,hch@infradead.org,hannes@cmpxchg.org,dennis@kernel.org,david@redhat.com,dave@stgolabs.net,da.gomez@samsung.com,corbet@lwn.net,bp@alien8.de,arnd@arndb.de,ardb@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-introduce-shutdown_mem_profiling-helper-function.patch added to mm-unstable branch
Message-Id: <20241023210521.B96A6C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: introduce shutdown_mem_profiling helper function
has been added to the -mm mm-unstable branch.  Its filename is
     alloc_tag-introduce-shutdown_mem_profiling-helper-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-introduce-shutdown_mem_profiling-helper-function.patch

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
Subject: alloc_tag: introduce shutdown_mem_profiling helper function
Date: Wed, 23 Oct 2024 10:07:55 -0700

Implement a helper function to disable memory allocation profiling and use
it when creation of /proc/allocinfo fails.  Ensure /proc/allocinfo does
not get created when memory allocation profiling is disabled.

Link: https://lkml.kernel.org/r/20241023170759.999909-3-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
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
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
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

 lib/alloc_tag.c |   33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

--- a/lib/alloc_tag.c~alloc_tag-introduce-shutdown_mem_profiling-helper-function
+++ a/lib/alloc_tag.c
@@ -8,6 +8,14 @@
 #include <linux/seq_buf.h>
 #include <linux/seq_file.h>
 
+#define ALLOCINFO_FILE_NAME		"allocinfo"
+
+#ifdef CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT
+static bool mem_profiling_support __meminitdata = true;
+#else
+static bool mem_profiling_support __meminitdata;
+#endif
+
 static struct codetag_type *alloc_tag_cttype;
 
 DEFINE_PER_CPU(struct alloc_tag_counters, _shared_alloc_tag);
@@ -144,9 +152,26 @@ size_t alloc_tag_top_users(struct codeta
 	return nr;
 }
 
+static void __init shutdown_mem_profiling(void)
+{
+	if (mem_alloc_profiling_enabled())
+		static_branch_disable(&mem_alloc_profiling_key);
+
+	if (!mem_profiling_support)
+		return;
+
+	mem_profiling_support = false;
+}
+
 static void __init procfs_init(void)
 {
-	proc_create_seq("allocinfo", 0400, NULL, &allocinfo_seq_op);
+	if (!mem_profiling_support)
+		return;
+
+	if (!proc_create_seq(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_seq_op)) {
+		pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME);
+		shutdown_mem_profiling();
+	}
 }
 
 static bool alloc_tag_module_unload(struct codetag_type *cttype,
@@ -174,12 +199,6 @@ static bool alloc_tag_module_unload(stru
 	return module_unused;
 }
 
-#ifdef CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT
-static bool mem_profiling_support __meminitdata = true;
-#else
-static bool mem_profiling_support __meminitdata;
-#endif
-
 static int __init setup_early_mem_profiling(char *str)
 {
 	bool enable;
_

Patches currently in -mm which might be from surenb@google.com are

maple_tree-add-mas_for_each_rev-helper.patch
alloc_tag-introduce-shutdown_mem_profiling-helper-function.patch
alloc_tag-load-module-tags-into-separate-contiguous-memory.patch
alloc_tag-populate-memory-for-module-tags-as-needed.patch
alloc_tag-introduce-pgtag_ref_handle-to-abstract-page-tag-references.patch
alloc_tag-support-for-page-allocation-tag-compression.patch

