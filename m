Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C8B1386A6
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 20:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711053873; cv=none; b=Enf0E03myW4G00yBFuBFHHAk8WrJmDg8y5+4+eGagpCDo2H+UwPa+mZovWKfeQU1qlRNApjEeh1EFn4rb01Q3IwDAfM5ssiyNrc/lIai0j5buxGmNJcp8pjjv0arzLr00gDJ0IR2xjtxIvwKqqrvVBpfWdG+dn7hw66NqvUpDKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711053873; c=relaxed/simple;
	bh=EG2D+jdlk+edU8sg8k1LwlBTo3cqyh3LicNIz/YybKc=;
	h=Date:To:From:Subject:Message-Id; b=fbWdXEUlYQ02VI4XyzKlUhqhjnUZViTkzS0R2ZiyV9FGOeFJZXipVPrRjTdtv3+9FChmtgKUVJwab22KPNHQtcDxoP2X+JbWkhM1iY1Nrzgelb8dGX/eTO/M6w3G9y0OMBFM+p1H9LR6xUVvVOT3gULN9jwt8c8R0BNJPq5CRjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B25CgOfJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B25CgOfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96808C43390;
	Thu, 21 Mar 2024 20:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711053873;
	bh=EG2D+jdlk+edU8sg8k1LwlBTo3cqyh3LicNIz/YybKc=;
	h=Date:To:From:Subject:From;
	b=B25CgOfJdOvYdcu0f64tYVQ2Ic4FeBrjZyoCaAPNe/BSxg3vaDbkQPGRfC7wP5IaB
	 0JeDbJYEIFghXnkXoWk1cSdLV6PZUUIuHgaukqUZ7JCjOjnA3v0Iuxr+/ko8ymKptL
	 ppLl9M6mLGppCoMEVTFDLZMD8W18MVbwNm6MWNXk=
Date: Thu, 21 Mar 2024 13:44:33 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,surenb@google.com,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-entries-for-code-tagging-and-memory-allocation-profiling.patch added to mm-unstable branch
Message-Id: <20240321204433.96808C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add entries for code tagging and memory allocation profiling
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-add-entries-for-code-tagging-and-memory-allocation-profiling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-entries-for-code-tagging-and-memory-allocation-profiling.patch

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
Subject: MAINTAINERS: add entries for code tagging and memory allocation profiling
Date: Thu, 21 Mar 2024 09:36:58 -0700

The new code & libraries added are being maintained - mark them as such.

Link: https://lkml.kernel.org/r/20240321163705.3067592-37-surenb@google.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
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

 MAINTAINERS |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/MAINTAINERS~maintainers-add-entries-for-code-tagging-and-memory-allocation-profiling
+++ a/MAINTAINERS
@@ -5241,6 +5241,13 @@ S:	Supported
 F:	Documentation/process/code-of-conduct-interpretation.rst
 F:	Documentation/process/code-of-conduct.rst
 
+CODE TAGGING
+M:	Suren Baghdasaryan <surenb@google.com>
+M:	Kent Overstreet <kent.overstreet@linux.dev>
+S:	Maintained
+F:	include/linux/codetag.h
+F:	lib/codetag.c
+
 COMEDI DRIVERS
 M:	Ian Abbott <abbotti@mev.co.uk>
 M:	H Hartley Sweeten <hsweeten@visionengravers.com>
@@ -14123,6 +14130,16 @@ F:	mm/memblock.c
 F:	mm/mm_init.c
 F:	tools/testing/memblock/
 
+MEMORY ALLOCATION PROFILING
+M:	Suren Baghdasaryan <surenb@google.com>
+M:	Kent Overstreet <kent.overstreet@linux.dev>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	include/linux/alloc_tag.h
+F:	include/linux/codetag_ctx.h
+F:	lib/alloc_tag.c
+F:	lib/pgalloc_tag.c
+
 MEMORY CONTROLLER DRIVERS
 M:	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
 L:	linux-kernel@vger.kernel.org
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

