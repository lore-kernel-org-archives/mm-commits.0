Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC73478C8A
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103897; cv=none; b=j8JaMrdpbpgBHOIkU2XtfnAjH/gQxntmVKt5C2VbULc4+BOwXwnOdC9fkqNL8YZo7UCBCVtxgH2Gy3RzmfCMsANisGKSBMgLZTlyMabT1VtcV47ghbGvZwyqxb1fuX4W9uc48i8xKHK+3JvDf4ITz4NgnSt3zR4tZtaAQX0ZrFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103897; c=relaxed/simple;
	bh=itooxhCVxFtmwg5amWdiAlkjzdfxoIcnxBlbD12bJNs=;
	h=Date:To:From:Subject:Message-Id; b=DZH4LxPYV9eFPtukibd9Y74DiCTmueBVrwkSTP5AEdLVgsWQAjwTXTvopeNHykKFakFZ/l2lnB4qVOcru/AMB96W/+GyAv+pOrcFgwYCEZp9uUAf05uAvLRTIRBiC8HUrlRcEWDhb8r6XTp6YuF1m9bB9VQI6NLHZt3l9IUEYc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CVjaEwDZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CVjaEwDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80805C113CD;
	Fri, 26 Apr 2024 03:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103897;
	bh=itooxhCVxFtmwg5amWdiAlkjzdfxoIcnxBlbD12bJNs=;
	h=Date:To:From:Subject:From;
	b=CVjaEwDZiRTpLkaZckKsGxv97G0fsu8A6M8sU4ooSUb6S7Hc6J5OIlg5GaQlDPAL5
	 /ZsZAKho5PfO6HItba66oLCHERTiBYaVCZGHEhweIz0GErXbePRGR94DgLdT0uC30O
	 xwoLPngoXxUHFEkQWO23PIc4gi0ByLuVYMB2WF80=
Date: Thu, 25 Apr 2024 20:58:16 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,kent.overstreet@linux.dev,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags.patch removed from -mm tree
Message-Id: <20240426035817.80805C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: percpu: increase PERCPU_MODULE_RESERVE to accommodate allocation tags
has been removed from the -mm tree.  Its filename was
     mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: percpu: increase PERCPU_MODULE_RESERVE to accommodate allocation tags
Date: Thu, 21 Mar 2024 09:36:38 -0700

As each allocation tag generates a per-cpu variable, more space is
required to store them.  Increase PERCPU_MODULE_RESERVE to provide enough
area.  A better long-term solution would be to allocate this memory
dynamically.

[surenb@google.com: increase PERCPU_MODULE_RESERVE to accommodate allocation tags]
  Link: https://lkml.kernel.org/r/20240406214044.1114406-1-surenb@google.com
Link: https://lkml.kernel.org/r/20240321163705.3067592-17-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Tested-by: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/percpu.h~mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags
+++ a/include/linux/percpu.h
@@ -14,7 +14,11 @@
 
 /* enough to cover all DEFINE_PER_CPUs in modules */
 #ifdef CONFIG_MODULES
+#ifdef CONFIG_MEM_ALLOC_PROFILING
+#define PERCPU_MODULE_RESERVE		(8 << 13)
+#else
 #define PERCPU_MODULE_RESERVE		(8 << 10)
+#endif
 #else
 #define PERCPU_MODULE_RESERVE		0
 #endif
_

Patches currently in -mm which might be from surenb@google.com are

userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

