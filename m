Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACDE29992B
	for <mm-commits@vger.kernel.org>; Sat, 30 May 2026 02:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780107293; cv=none; b=Fvo/CxwaZkJ/x0++3JNuZvQDws6ZADF1wYrCSCnn3IqBIP5YZ09+NS4+Z0lhRXWpMEhjBRlFujj4OJt8Rlygq4oIKymToYZ+YdTv4q5kI94oSp5f9MQ5SAbK3B7wK+RQ0rFCzXU/gSSLvlf4u/Y7+Rt8LbxVhcEVvJiO8g4O7FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780107293; c=relaxed/simple;
	bh=6VliTg/x3FXSW55cZmS2/pxPU6Y3Emc6VqGJRNcAruM=;
	h=Date:To:From:Subject:Message-Id; b=WMxLN4whHixPHCBDGzaYec87DkfIWNfpNKNOKK5LiSlwdRg0oY2VU2cW4hXDe5b4j1taZ3xjNjbLc06S3izftlCqTILrzObl/Ho4wtOU/j9cgHX4Lt0aVw52tGcRYqS8jM5fsV38gISwDA6I9MVeaqF1aDamBbmEPc7NbqYIh/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eKn6btqy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eKn6btqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679931F00893;
	Sat, 30 May 2026 02:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780107291;
	bh=f62ZqQo1hidK9EfLIxFJ9p3uf5gKWCUt+PiN6WSQVEU=;
	h=Date:To:From:Subject;
	b=eKn6btqyGWDCOUZxmHpJjoxlafJ6VSUlNGmL5tumYvgL2zsz7GS7tiCMiu0P71Wtu
	 RQyFVkTdScDZPkamnpJ47ARMgbtaucW0Ocpcc4zglV1YNknfnVhQYsN4UWj3OFvLjt
	 JfoZjoyZJqDnwsMHB6eajnI2IRFeVq9w/lEbRN70=
Date: Fri, 29 May 2026 19:14:50 -0700
To: mm-commits@vger.kernel.org,tmgross@umich.edu,ojeda@kernel.org,ljs@kernel.org,liam@infradead.org,gary@garyguo.net,dakr@kernel.org,bjorn3_gh@protonmail.com,aliceryhl@google.com,a.hindborg@kernel.org,nakamura.shuta@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rust-page-mark-page-nid-as-inline.patch added to mm-new branch
Message-Id: <20260530021451.679931F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rust: page: mark Page::nid as inline
has been added to the -mm mm-new branch.  Its filename is
     rust-page-mark-page-nid-as-inline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rust-page-mark-page-nid-as-inline.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Nakamura Shuta <nakamura.shuta@gmail.com>
Subject: rust: page: mark Page::nid as inline
Date: Fri, 29 May 2026 17:53:16 +0900

When building the kernel, the following Rust symbol is generated:

  $ nm vmlinux | grep ' _R'.*Page | rustfilt
  <kernel::page::Page>::nid

`Page::nid` is a trivial wrapper around the C function `page_to_nid`.  It
does not make sense to go through a trivial wrapper for this function, so
mark it inline.

This follows commit 878620c5a93a ("rust: page: optimize rust symbol
generation for Page"), which did the same for `alloc_page` and `drop`.

Link: https://github.com/Rust-for-Linux/linux/issues/1145
Link: https://lore.kernel.org/20260529085316.27432-1-nakamura.shuta@gmail.com
Signed-off-by: Nakamura Shuta <nakamura.shuta@gmail.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Trevor Gross <tmgross@umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/kernel/page.rs |    1 +
 1 file changed, 1 insertion(+)

--- a/rust/kernel/page.rs~rust-page-mark-page-nid-as-inline
+++ a/rust/kernel/page.rs
@@ -193,6 +193,7 @@ impl Page {
     }
 
     /// Get the node id containing this page.
+    #[inline]
     pub fn nid(&self) -> i32 {
         // SAFETY: Always safe to call with a valid page.
         unsafe { bindings::page_to_nid(self.as_ptr()) }
_

Patches currently in -mm which might be from nakamura.shuta@gmail.com are

rust-page-mark-page-nid-as-inline.patch

