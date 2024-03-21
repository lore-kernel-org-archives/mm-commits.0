Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3986133416
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 20:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711053771; cv=none; b=LnwEuJd65eyTzorNACE1RrwgkSEB+8Thxl+VdzxHgQS1rY4IaL6WR3VTv2koH/NFdLlC8IbYjom6tjsbdJoJAx2C1SWf0RWy9Q8pAHQi2WhEkla2CWUIPvi7ZpS32RvKhJAL+7cTgSQ+ArSjn80x7azSIjNLMMq+S0w69Qg5Za8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711053771; c=relaxed/simple;
	bh=uz0iBpMAIu0sX/zQS++tCbdE3swCoVmwtZ4liAz1EVY=;
	h=Date:To:From:Subject:Message-Id; b=pUn1E6v4Yu5itepacIyNLsc6rio7ksB+MFy+l9GJR1njOB71ucMFRSTkR6MT2XpkShkk4GZJ++T0qLwckzkCS/4o01WDBCjhdE/gH8sA3atI2MOCGzsbQP41XqIal7VlckSzY5qngqz9+6to+j9vWtB2gWs0R6gPmgChdZ8g/zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kmf1lQ5G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kmf1lQ5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1A0C433F1;
	Thu, 21 Mar 2024 20:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711053771;
	bh=uz0iBpMAIu0sX/zQS++tCbdE3swCoVmwtZ4liAz1EVY=;
	h=Date:To:From:Subject:From;
	b=kmf1lQ5GGYza6AyXY5aRs7LkSzR9thEkGu6/LOC8d4sZgKwnhK3x7hXD3MH80UIkh
	 8bCLuFB2qBvTqV2ZCohe65bh++Y8/Ss+x9x75bmAPeafMKsH8UKZ/xCqls5branS3W
	 mB5QKenaxWyvUV2ZCQscfa/4qEZa+sndeRUXazpI=
Date: Thu, 21 Mar 2024 13:42:50 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,surenb@google.com,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + asm-generic-ioh-kill-vmalloch-dependency.patch added to mm-unstable branch
Message-Id: <20240321204251.7A1A0C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: asm-generic/io.h: kill vmalloc.h dependency
has been added to the -mm mm-unstable branch.  Its filename is
     asm-generic-ioh-kill-vmalloch-dependency.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/asm-generic-ioh-kill-vmalloch-dependency.patch

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
From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: asm-generic/io.h: kill vmalloc.h dependency
Date: Thu, 21 Mar 2024 09:36:24 -0700

Needed to avoid a new circular dependency with the memory allocation
profiling series.

Naturally, a whole bunch of files needed to include vmalloc.h that were
previously getting it implicitly.

Link: https://lkml.kernel.org/r/20240321163705.3067592-3-surenb@google.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
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
Cc: Kees Cook <keescook@chromium.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/io.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/asm-generic/io.h~asm-generic-ioh-kill-vmalloch-dependency
+++ a/include/asm-generic/io.h
@@ -991,7 +991,6 @@ static inline void iowrite64_rep(volatil
 
 #ifdef __KERNEL__
 
-#include <linux/vmalloc.h>
 #define __io_virt(x) ((void __force *)(x))
 
 /*
_

Patches currently in -mm which might be from kent.overstreet@linux.dev are

fix-missing-vmalloch-includes.patch
asm-generic-ioh-kill-vmalloch-dependency.patch
mm-slub-mark-slab_free_freelist_hook-__always_inline.patch
scripts-kallysms-always-include-__start-and-__stop-symbols.patch
fs-convert-alloc_inode_sb-to-a-macro.patch
rust-add-a-rust-helper-for-krealloc.patch
mempool-hook-up-to-memory-allocation-profiling.patch
mm-percpu-introduce-pcpuobj_ext.patch
mm-percpu-add-codetag-reference-into-pcpuobj_ext.patch
mm-vmalloc-enable-memory-allocation-profiling.patch
rhashtable-plumb-through-alloc-tag.patch
maintainers-add-entries-for-code-tagging-and-memory-allocation-profiling.patch
memprofiling-documentation.patch

