Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52A579945
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103906; cv=none; b=ubmnidGayNHnGcSdhQot+nxwmbxieFys7cRy6SFazxY6Q+5nDOGdyS4zBg6kRVf3b3UGKzLi7xLhV42G3ZcDkrpNCk9+2gmpjdsjx3HxpbPfcpATRiWt4uJaBNmtSHXYwEJkLPYYlGzDr8rpRB0qn1fJaqda+YWHcwrDQ3H5lcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103906; c=relaxed/simple;
	bh=YAAxF2h3GjPq8Dp+nxgiPtpXuRjkgsONQReZSevufKg=;
	h=Date:To:From:Subject:Message-Id; b=T1nIbVaAaLcktcI+dx36deHWKDGU/f3SchLP4qV4QfXrP2M+gyvpXrFBDTSFjk5ppZRLSONppLUkjr9O0pL5afsp8S92pEQbbQDkIpgmVMwh5ACIoaRrWwaorPehTzxTJ4ZkXspy6UZM4yLMV0CpZCFIfS1aQp4mUuJ5woiOlrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZqiJYIQH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZqiJYIQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF47C113CD;
	Fri, 26 Apr 2024 03:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103906;
	bh=YAAxF2h3GjPq8Dp+nxgiPtpXuRjkgsONQReZSevufKg=;
	h=Date:To:From:Subject:From;
	b=ZqiJYIQHOOzjCDeqRw4tb9mH9LJje7vv0hrrTEH0WeH3d+icHPzKXezdAJ8NQVLIl
	 9oK460gSCIJkEPYxsRHkwo9c5I01nuWqxrk9cuTtmtPT9eO/EaQdnWxMosSbX8a4Wg
	 w7rA+QQQ5woq3k3vdQaCXCYT+rsT77bxME7SbkXs=
Date: Thu, 25 Apr 2024 20:58:26 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,kent.overstreet@linux.dev,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-add-codetag-reference-into-slabobj_ext.patch removed from -mm tree
Message-Id: <20240426035826.9AF47C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: add codetag reference into slabobj_ext
has been removed from the -mm tree.  Its filename was
     lib-add-codetag-reference-into-slabobj_ext.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: lib: add codetag reference into slabobj_ext
Date: Thu, 21 Mar 2024 09:36:44 -0700

To store code tag for every slab object, a codetag reference is embedded
into slabobj_ext when CONFIG_MEM_ALLOC_PROFILING=y.

Link: https://lkml.kernel.org/r/20240321163705.3067592-23-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Co-developed-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
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
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 +++++
 lib/Kconfig.debug          |    1 +
 2 files changed, 6 insertions(+)

--- a/include/linux/memcontrol.h~lib-add-codetag-reference-into-slabobj_ext
+++ a/include/linux/memcontrol.h
@@ -1653,7 +1653,12 @@ unsigned long mem_cgroup_soft_limit_recl
  * if MEMCG_DATA_OBJEXTS is set.
  */
 struct slabobj_ext {
+#ifdef CONFIG_MEMCG_KMEM
 	struct obj_cgroup *objcg;
+#endif
+#ifdef CONFIG_MEM_ALLOC_PROFILING
+	union codetag_ref ref;
+#endif
 } __aligned(8);
 
 static inline void __inc_lruvec_kmem_state(void *p, enum node_stat_item idx)
--- a/lib/Kconfig.debug~lib-add-codetag-reference-into-slabobj_ext
+++ a/lib/Kconfig.debug
@@ -979,6 +979,7 @@ config MEM_ALLOC_PROFILING
 	depends on !DEBUG_FORCE_WEAK_PER_CPU
 	select CODE_TAGGING
 	select PAGE_EXTENSION
+	select SLAB_OBJ_EXT
 	help
 	  Track allocation source code and record total allocation size
 	  initiated at that code location. The mechanism can be used to track
_

Patches currently in -mm which might be from surenb@google.com are

userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

