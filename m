Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357317A15D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103909; cv=none; b=PJhIOE3U8xUBD+bc7SFfmBtwR+OeWN730kLrjZG8RafOaVvdJ93c8CQakAEp1XD1p/Stkt4HxS2PgaZeAdU3n/eS2plaaBTPVrYChzzzpZVJlRqDucKr+36xD2ZYPLO+uZE2YJGaW3u2IgSvi78r1cx1rqXSGbkNeH9eI7qDuYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103909; c=relaxed/simple;
	bh=s8/trrfZVifwc2HWy+aGCaW3UFFdSXyE68Ajwvv9GzY=;
	h=Date:To:From:Subject:Message-Id; b=H0piLXE9nBDHALXYpUEE9BnwTfy1KXwyoD/WEKcc2syxmmo7UyW0pTaZ89LjBezgdoeLscZsyf1dCTeu2k6j84s1SKgHp/35CW65nCrZUjiSWq2v/pcvAHxx7Yk0x2KA8ZZMtgmsPgsZaLGG6IHPDou9ho697ECpRAJALmyK7ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cz8SnrqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cz8SnrqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB82C113CD;
	Fri, 26 Apr 2024 03:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103909;
	bh=s8/trrfZVifwc2HWy+aGCaW3UFFdSXyE68Ajwvv9GzY=;
	h=Date:To:From:Subject:From;
	b=Cz8SnrqC47CO6oAxtOU8DdyIDGnS6C4vvcnKQodVKd+0DT8IKjI8FQLEocxx81Yxk
	 yK3nnSk9RMybbZL2/dC35Y2SsBkkL3jyWP5ZuZn8fZS08UpNAeHOmnIU9esYII3biD
	 b7YPbl+48+E0x04lhpIbAxuaaQIiAzVRHE1U6O48=
Date: Thu, 25 Apr 2024 20:58:28 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,surenb@google.com,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] rust-add-a-rust-helper-for-krealloc.patch removed from -mm tree
Message-Id: <20240426035829.0AB82C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rust: add a rust helper for krealloc()
has been removed from the -mm tree.  Its filename was
     rust-add-a-rust-helper-for-krealloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: rust: add a rust helper for krealloc()
Date: Thu, 21 Mar 2024 09:36:46 -0700

Memory allocation profiling is turning krealloc() into a nontrivial macro
- so for now, we need a helper for it.

Until we have proper support on the rust side for memory allocation
profiling this does mean that all Rust allocations will be accounted to
the helper.

Link: https://lkml.kernel.org/r/20240321163705.3067592-25-surenb@google.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Tested-by: Kees Cook <keescook@chromium.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: "Björn Roy Baron" <bjorn3_gh@protonmail.com>
Cc: Benno Lossin <benno.lossin@proton.me>
Cc: Andreas Hindborg <a.hindborg@samsung.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/helpers.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/rust/helpers.c~rust-add-a-rust-helper-for-krealloc
+++ a/rust/helpers.c
@@ -28,6 +28,7 @@
 #include <linux/mutex.h>
 #include <linux/refcount.h>
 #include <linux/sched/signal.h>
+#include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
@@ -157,6 +158,13 @@ void rust_helper_init_work_with_key(stru
 }
 EXPORT_SYMBOL_GPL(rust_helper_init_work_with_key);
 
+void * __must_check __realloc_size(2)
+rust_helper_krealloc(const void *objp, size_t new_size, gfp_t flags)
+{
+	return krealloc(objp, new_size, flags);
+}
+EXPORT_SYMBOL_GPL(rust_helper_krealloc);
+
 /*
  * `bindgen` binds the C `size_t` type as the Rust `usize` type, so we can
  * use it in contexts where Rust expects a `usize` like slice (array) indices.
_

Patches currently in -mm which might be from kent.overstreet@linux.dev are


