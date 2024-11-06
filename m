Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0AC1714C0
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854855; cv=none; b=ghi3y0bBCUqtvHgCkytf4GuK3RdUt/UmNDH+LA5PwdzMStK2tPVY9nCI0ega6SJSoKengxDM7nOve6iocyqAgiO45cen/6Yw0royNwv1eFQECRigXV/PnmdfhSe/8/2EVIbNTkUSFRJFQnm2BeCKhKg7wspqz8C73dATKoDrkAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854855; c=relaxed/simple;
	bh=EgYRuufh460yogG0MIrqD/QragQvCmFBv1UvB0zpMmw=;
	h=Date:To:From:Subject:Message-Id; b=juvAhUm2ga8CJfKFko81AbZVBVXZHI4OHjPO7FBdAieeB65dRC424MLi2g/ENrJ6xT65LndzwujOzq2Mx7Mdz/Hfbv6BqoWsFfEkSKw0OlU/mdBIh7/oc3xEflh9G35vdM7GvI7AOiH6cDmjSj08w9nwWktLZYtBCoYExfed+Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XPqws1/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XPqws1/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7A2C4CECF;
	Wed,  6 Nov 2024 01:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854855;
	bh=EgYRuufh460yogG0MIrqD/QragQvCmFBv1UvB0zpMmw=;
	h=Date:To:From:Subject:From;
	b=XPqws1/YhwbWOh6EgJZ/MG52DGBK6SKcg2VqsNjd1MjR8d2cPxSaOaV81YpK2o4se
	 r72T/rgiqZgqW3AWZ5sWgzsv9SNZ3PzNNvq8sTsBwsC8/yF2Mdb/zFcsM9l6We+9/a
	 oON3+mGQ3h5PLtq9ftUHqQ3mBJ2029Fc6bVKZuJY=
Date: Tue, 05 Nov 2024 17:00:54 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,xiongwei.song@windriver.com,willy@infradead.org,vbabka@suse.cz,urezki@gmail.com,thuth@redhat.com,tglx@linutronix.de,souravpanda@google.com,samitolvanen@google.com,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,petr.pavlu@suse.com,paulmck@kernel.org,pasha.tatashin@soleen.com,minchan@google.com,mhocko@suse.com,mcgrof@kernel.org,Liam.Howlett@Oracle.com,kent.overstreet@linux.dev,keescook@chromium.org,kaleshsingh@google.com,jhubbard@nvidia.com,iamjoonsoo.kim@lge.com,hch@infradead.org,hannes@cmpxchg.org,dennis@kernel.org,david@redhat.com,dave@stgolabs.net,da.gomez@samsung.com,corbet@lwn.net,bp@alien8.de,arnd@arndb.de,ardb@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alloc_tag-introduce-shutdown_mem_profiling-helper-function.patch removed from -mm tree
Message-Id: <20241106010055.5D7A2C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: introduce shutdown_mem_profiling helper function
has been removed from the -mm tree.  Its filename was
     alloc_tag-introduce-shutdown_mem_profiling-helper-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculation_beginend.patch

