Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2669478C7C
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103888; cv=none; b=WoVUZoYtiHccVAiIuj/FvRvG75UCivzFvJQZLx28KaGyn2apKJsEJlwO6S6fhVUuoUHtxi9XZHe0zPIzHPnKPegKfYW7ktec4srUtnV9DICx1Kai1l6Kg+XmbZtmFGerCF37nasVrQjyyMg7Ptc64QQgC92AtW1/BWgIF4ncJ0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103888; c=relaxed/simple;
	bh=q9gip3lnGc+Z2wXFcV30nbitotukXD+LUUP3tgutuZc=;
	h=Date:To:From:Subject:Message-Id; b=Ow6MH0hSaprIPk1x78SS1+O7isDWFUqQzYp8wESegvKBmZeJ7Yg638nb595hLFVkQsQx7c9ghyssJAtavY30QkySK3tlAxta8RhrEpvyIGj8mL7exzvp8Gjid7hGbCcbt7FGwHnGp3q5q3oChGan6hJEf25rvfG/qCfP6ZchR9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UrRnwx/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UrRnwx/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD41C116B1;
	Fri, 26 Apr 2024 03:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103888;
	bh=q9gip3lnGc+Z2wXFcV30nbitotukXD+LUUP3tgutuZc=;
	h=Date:To:From:Subject:From;
	b=UrRnwx/e9zGENY0+eJJpDkUQtNDpKHf89FvYjFp5Kooj5MyPA6FPCYX7hZgPn0IcI
	 oT1sgI81wNJXtHqdQJ8+gDetPK01Q+TlaJzOOKw5BMgzW7hEzDEEg0cs72MsDvU9bY
	 dCK59W8zkuw2/X46hTxn4RCJzqboLTVNplLe9KN0=
Date: Thu, 25 Apr 2024 20:58:07 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,kent.overstreet@linux.dev,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] slab-objext-introduce-objext_flags-as-extension-to-page_memcg_data_flags.patch removed from -mm tree
Message-Id: <20240426035807.ECD41C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: slab: objext: introduce objext_flags as extension to page_memcg_data_flags
has been removed from the -mm tree.  Its filename was
     slab-objext-introduce-objext_flags-as-extension-to-page_memcg_data_flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: slab: objext: introduce objext_flags as extension to page_memcg_data_flags
Date: Thu, 21 Mar 2024 09:36:31 -0700

Introduce objext_flags to store additional objext flags unrelated to memcg.

Link: https://lkml.kernel.org/r/20240321163705.3067592-10-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
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
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   29 ++++++++++++++++++++++-------
 mm/slab.h                  |    5 +----
 2 files changed, 23 insertions(+), 11 deletions(-)

--- a/include/linux/memcontrol.h~slab-objext-introduce-objext_flags-as-extension-to-page_memcg_data_flags
+++ a/include/linux/memcontrol.h
@@ -357,7 +357,22 @@ enum page_memcg_data_flags {
 	__NR_MEMCG_DATA_FLAGS  = (1UL << 2),
 };
 
-#define MEMCG_DATA_FLAGS_MASK (__NR_MEMCG_DATA_FLAGS - 1)
+#define __FIRST_OBJEXT_FLAG	__NR_MEMCG_DATA_FLAGS
+
+#else /* CONFIG_MEMCG */
+
+#define __FIRST_OBJEXT_FLAG	(1UL << 0)
+
+#endif /* CONFIG_MEMCG */
+
+enum objext_flags {
+	/* the next bit after the last actual flag */
+	__NR_OBJEXTS_FLAGS  = __FIRST_OBJEXT_FLAG,
+};
+
+#define OBJEXTS_FLAGS_MASK (__NR_OBJEXTS_FLAGS - 1)
+
+#ifdef CONFIG_MEMCG
 
 static inline bool folio_memcg_kmem(struct folio *folio);
 
@@ -391,7 +406,7 @@ static inline struct mem_cgroup *__folio
 	VM_BUG_ON_FOLIO(memcg_data & MEMCG_DATA_OBJEXTS, folio);
 	VM_BUG_ON_FOLIO(memcg_data & MEMCG_DATA_KMEM, folio);
 
-	return (struct mem_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
+	return (struct mem_cgroup *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
 }
 
 /*
@@ -412,7 +427,7 @@ static inline struct obj_cgroup *__folio
 	VM_BUG_ON_FOLIO(memcg_data & MEMCG_DATA_OBJEXTS, folio);
 	VM_BUG_ON_FOLIO(!(memcg_data & MEMCG_DATA_KMEM), folio);
 
-	return (struct obj_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
+	return (struct obj_cgroup *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
 }
 
 /*
@@ -469,11 +484,11 @@ static inline struct mem_cgroup *folio_m
 	if (memcg_data & MEMCG_DATA_KMEM) {
 		struct obj_cgroup *objcg;
 
-		objcg = (void *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
+		objcg = (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
 		return obj_cgroup_memcg(objcg);
 	}
 
-	return (struct mem_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
+	return (struct mem_cgroup *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
 }
 
 /*
@@ -512,11 +527,11 @@ static inline struct mem_cgroup *folio_m
 	if (memcg_data & MEMCG_DATA_KMEM) {
 		struct obj_cgroup *objcg;
 
-		objcg = (void *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
+		objcg = (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
 		return obj_cgroup_memcg(objcg);
 	}
 
-	return (struct mem_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
+	return (struct mem_cgroup *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
 }
 
 static inline struct mem_cgroup *page_memcg_check(struct page *page)
--- a/mm/slab.h~slab-objext-introduce-objext_flags-as-extension-to-page_memcg_data_flags
+++ a/mm/slab.h
@@ -554,11 +554,8 @@ static inline struct slabobj_ext *slab_o
 	VM_BUG_ON_PAGE(obj_exts && !(obj_exts & MEMCG_DATA_OBJEXTS),
 							slab_page(slab));
 	VM_BUG_ON_PAGE(obj_exts & MEMCG_DATA_KMEM, slab_page(slab));
-
-	return (struct slabobj_ext *)(obj_exts & ~MEMCG_DATA_FLAGS_MASK);
-#else
-	return (struct slabobj_ext *)obj_exts;
 #endif
+	return (struct slabobj_ext *)(obj_exts & ~OBJEXTS_FLAGS_MASK);
 }
 
 #else /* CONFIG_SLAB_OBJ_EXT */
_

Patches currently in -mm which might be from surenb@google.com are

userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

