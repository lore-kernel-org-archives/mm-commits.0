Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E0E155A4E
	for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2025 00:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755734483; cv=none; b=Wvz3KMjMxOCsEpQNL2TOkXGm6h36Jbfx6zn/pd0C7ocCKL7W4aVz07fDS1jpzv6hRbalS5GuHAwMaEsnJC6SvNg3O1XvPxJlyqHyI3Yw/P+Fy3mm0s07dAcRp8l7VXHQwLkbIi31qHzhfSAjaa7qwE2yAn4Y8JW0UzdoWj4dT48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755734483; c=relaxed/simple;
	bh=3Mh4jCS6CkUL4lVu4ndxorW/lpiiut4WieWp3qqYhE8=;
	h=Date:To:From:Subject:Message-Id; b=mKCEQoInWdLYIDZb0INpnclINkWWi48LigfPyBp4PMqnltX/Lzc7gxgkXEZfTuL8J8k9qpk0tDQnwyMt4+tyH8NKygMMFAq8GWzNF4fzvGN0UasCt9XmCoV9TpS6yIJW6TWVXVuDfseWIsXHrl878+XkfZc5EH6wFV+sg3nAywE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1xU7gZcl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1xU7gZcl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C622C4CEE7;
	Thu, 21 Aug 2025 00:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755734482;
	bh=3Mh4jCS6CkUL4lVu4ndxorW/lpiiut4WieWp3qqYhE8=;
	h=Date:To:From:Subject:From;
	b=1xU7gZclZloBtSgiK74arOmaL4iRYuuGX8ik3tCtQUjQs3ntu3owfOih5BStd4LmD
	 YH+dKkNDpybCoT0BL73f/YaQM4a1Ti2TbZFXe9L5wRQrGQfNTNz9Oz9D3bXF4gIyFa
	 F7etRtNK4drWL0n5HT4PxHuGwEaStlAXok0E8tTg=
Date: Wed, 20 Aug 2025 17:01:22 -0700
To: mm-commits@vger.kernel.org,tmgross@umich.edu,ojeda@kernel.org,lossin@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,gary@garyguo.net,dakr@kernel.org,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@kernel.org,shankari.ak0208@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rust-mm-update-aref-and-alwaysrefcounted-imports-from-sync-aref.patch added to mm-new branch
Message-Id: <20250821000122.9C622C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rust: mm: update ARef and AlwaysRefCounted imports from sync::aref
has been added to the -mm mm-new branch.  Its filename is
     rust-mm-update-aref-and-alwaysrefcounted-imports-from-sync-aref.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rust-mm-update-aref-and-alwaysrefcounted-imports-from-sync-aref.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Shankari Anand <shankari.ak0208@gmail.com>
Subject: rust: mm: update ARef and AlwaysRefCounted imports from sync::aref
Date: Wed, 16 Jul 2025 14:41:58 +0530

Update call sites in the mm subsystem to import `ARef` and
`AlwaysRefCounted` from `sync::aref` instead of `types`.

This aligns with the ongoing effort to move `ARef` and `AlwaysRefCounted`
to sync.

Link: https://lkml.kernel.org/r/20250716091158.812860-1-shankari.ak0208@gmail.com
Signed-off-by: Shankari Anand <shankari.ak0208@gmail.com>
Suggested-by: Benno Lossin <lossin@kernel.org>
Link: https://github.com/Rust-for-Linux/linux/issues/1173
Acked-by: Alice Ryhl <aliceryhl@google.com>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Trevor Gross <tmgross@umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/kernel/mm.rs             |    3 ++-
 rust/kernel/mm/mmput_async.rs |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/rust/kernel/mm/mmput_async.rs~rust-mm-update-aref-and-alwaysrefcounted-imports-from-sync-aref
+++ a/rust/kernel/mm/mmput_async.rs
@@ -10,7 +10,7 @@
 use crate::{
     bindings,
     mm::MmWithUser,
-    types::{ARef, AlwaysRefCounted},
+    sync::aref::{ARef, AlwaysRefCounted},
 };
 use core::{ops::Deref, ptr::NonNull};
 
--- a/rust/kernel/mm.rs~rust-mm-update-aref-and-alwaysrefcounted-imports-from-sync-aref
+++ a/rust/kernel/mm.rs
@@ -13,7 +13,8 @@
 
 use crate::{
     bindings,
-    types::{ARef, AlwaysRefCounted, NotThreadSafe, Opaque},
+    sync::aref::{ARef, AlwaysRefCounted},
+    types::{NotThreadSafe, Opaque},
 };
 use core::{ops::Deref, ptr::NonNull};
 
_

Patches currently in -mm which might be from shankari.ak0208@gmail.com are

rust-mm-update-aref-and-alwaysrefcounted-imports-from-sync-aref.patch

