Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B4E290F
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 04:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730696072; cv=none; b=AykfJz3niZ51f0x/DllDQ5NYWLeoRMCO9AKOVglUWtGCYnOHu4SyjL8XM+Khy4eri7M+40FPZGpSWZ7SMtXA+KJ0ftSPwJfE2Q8jCwnKZK6i3sqov2YoUJV0IMPR2LcCdcrW3/dgSkt+9FAVUrm2h6bnqnaamB03wRsQBUx0pdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730696072; c=relaxed/simple;
	bh=2GBuCd11pP0Fn1Pu0orietPBQ04ToNg1ow486mcFgbE=;
	h=Date:To:From:Subject:Message-Id; b=huRohiuviFTtxTh86BEuE4zlQjzMO1zvI3MrwPQrjdw7xusg2lMyFiNR+gKc4j2062/HDurpNovhQPCD6mQkW7MIzZVDPSqil/Jo0Yu3LMMicNC1wA14QPJWd6ZSbPrEK5SiN2Vb8iUAXAQ7iVP9qNtonpbd44l3K2LcQcRQINI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qsDHET0S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qsDHET0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8067C4CECE;
	Mon,  4 Nov 2024 04:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730696071;
	bh=2GBuCd11pP0Fn1Pu0orietPBQ04ToNg1ow486mcFgbE=;
	h=Date:To:From:Subject:From;
	b=qsDHET0SpJvJ5SdotD7aMz/bsSyOrW+YYTLhMzQ8UADR7BU+H8FQKDvMYcje4Md5F
	 085SPtPanv9h3QfAfy0u53O/SxtXNWEBgxcYkIMIXtiShPPScbkRRtKgcvGGRoP1Vu
	 Or2nkP+VKmQvblEfJpnkOdlM1eLZBr0bTIetSe00=
Date: Sun, 03 Nov 2024 20:54:31 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,xiongwei.song@windriver.com,willy@infradead.org,vbabka@suse.cz,urezki@gmail.com,thuth@redhat.com,tglx@linutronix.de,souravpanda@google.com,samitolvanen@google.com,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,petr.pavlu@suse.com,paulmck@kernel.org,pasha.tatashin@soleen.com,minchan@google.com,mhocko@suse.com,mcgrof@kernel.org,Liam.Howlett@Oracle.com,kent.overstreet@linux.dev,keescook@chromium.org,kaleshsingh@google.com,jhubbard@nvidia.com,iamjoonsoo.kim@lge.com,hch@infradead.org,hannes@cmpxchg.org,dennis@kernel.org,david@redhat.com,dave@stgolabs.net,dan.carpenter@linaro.org,da.gomez@samsung.com,corbet@lwn.net,bp@alien8.de,arnd@arndb.de,ardb@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] alloc_tag-load-module-tags-into-separate-contiguous-memory-fix.patch removed from -mm tree
Message-Id: <20241104045431.B8067C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: fix empty codetag module section handling
has been removed from the -mm tree.  Its filename was
     alloc_tag-load-module-tags-into-separate-contiguous-memory-fix.patch

This patch was dropped because it was folded into alloc_tag-load-module-tags-into-separate-contiguous-memory.patch

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: fix empty codetag module section handling
Date: Thu, 31 Oct 2024 17:00:17 -0700

When a module does not have any allocations, it's allocation tag section
is empty and codetag_alloc_module_section() returns NULL.  However this
condition should never happen because codetag_needs_module_section() will
detect an empty section and avoid calling codetag_alloc_module_section(). 
Change codetag_alloc_module_section() to never return NULL, which should
prevent static checker warnings.  Add a WARN_ON() and a proper error
reporting in case codetag_alloc_module_section() returns NULL, to prevent
future codetag type implementations from returning NULL from their
cttype->desc.alloc_section_mem() operation.

Link: https://lkml.kernel.org/r/20241101000017.3856204-1-surenb@google.com
Fixes: 61c9e58f3a10 ("alloc_tag: load module tags into separate contiguous memory")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/50f12fa1-17c1-4940-a6bf-beaf61f6b17a@stanley.mountain/
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
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
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

 kernel/module/main.c |    4 ++++
 lib/alloc_tag.c      |    2 +-
 lib/codetag.c        |    2 +-
 3 files changed, 6 insertions(+), 2 deletions(-)

--- a/kernel/module/main.c~alloc_tag-load-module-tags-into-separate-contiguous-memory-fix
+++ a/kernel/module/main.c
@@ -2316,6 +2316,10 @@ static int move_module(struct module *mo
 		if (codetag_needs_module_section(mod, sname, shdr->sh_size)) {
 			dest = codetag_alloc_module_section(mod, sname, shdr->sh_size,
 					arch_mod_section_prepend(mod, i), shdr->sh_addralign);
+			if (WARN_ON(!dest)) {
+				ret = -EINVAL;
+				goto out_err;
+			}
 			if (IS_ERR(dest)) {
 				ret = PTR_ERR(dest);
 				goto out_err;
--- a/lib/alloc_tag.c~alloc_tag-load-module-tags-into-separate-contiguous-memory-fix
+++ a/lib/alloc_tag.c
@@ -262,7 +262,7 @@ static void *reserve_module_tags(struct
 
 	/* If no tags return NULL */
 	if (size < sizeof(struct alloc_tag))
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	/*
 	 * align is always power of 2, so we can use IS_ALIGNED and ALIGN.
--- a/lib/codetag.c~alloc_tag-load-module-tags-into-separate-contiguous-memory-fix
+++ a/lib/codetag.c
@@ -244,7 +244,7 @@ void *codetag_alloc_module_section(struc
 {
 	const char *type_name = name + strlen(CODETAG_SECTION_PREFIX);
 	struct codetag_type *cttype;
-	void *ret = NULL;
+	void *ret = ERR_PTR(-EINVAL);
 
 	mutex_lock(&codetag_lock);
 	list_for_each_entry(cttype, &codetag_types, link) {
_

Patches currently in -mm which might be from surenb@google.com are

maple_tree-add-mas_for_each_rev-helper.patch
alloc_tag-introduce-shutdown_mem_profiling-helper-function.patch
alloc_tag-load-module-tags-into-separate-contiguous-memory.patch
alloc_tag-populate-memory-for-module-tags-as-needed.patch
alloc_tag-populate-memory-for-module-tags-as-needed-fix.patch
alloc_tag-introduce-pgtag_ref_handle-to-abstract-page-tag-references.patch
alloc_tag-support-for-page-allocation-tag-compression.patch
mm-codetag-uninline-and-move-pgalloc_tag_copy-and-pgalloc_tag_split.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculation_beginend.patch

