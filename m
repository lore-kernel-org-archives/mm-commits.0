Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AE878C7C
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103879; cv=none; b=ccH+XFPiaedwRR4pZ77oO8M7k4xB9bBe2/4SQZlAIwsQcQ8ZNaoL5c0zW2lCin6dZVOTIiF9XANS0GXIhbtGoH4RIOuPTDoIPRgTE/wGFOY8888UUdaj1XUgpyXvEqd1m7X4oZZqL8e7INgQH+yGkO/Lk1Bt349bLi7lm/Gwo9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103879; c=relaxed/simple;
	bh=RvVMopRIAMcSVqAjrG9NYXicaRYLzMQWrR/qGnsliDc=;
	h=Date:To:From:Subject:Message-Id; b=WsnEdZtclqaWVEcK+ZXsny7BPIPfpdoQXDlX48C7wAta7enrYFYHii0EdaqzYZEXzc009RXXGfCqfnkPOrbBatu0kaw/EVWsR4EYWpq5UkTMdof+zBVLbOiYGszVPnX1cZZ+qJjkaDemgtMzLwUIUUnQxs6rQELz9JzqM/G3tdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BoyTPXAZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BoyTPXAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66767C113CD;
	Fri, 26 Apr 2024 03:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103879;
	bh=RvVMopRIAMcSVqAjrG9NYXicaRYLzMQWrR/qGnsliDc=;
	h=Date:To:From:Subject:From;
	b=BoyTPXAZY5dJ8CvCLLyBhgkg01MbOd17V7CvCvm+5AsfIEVPqyhlGCiifjYlpNFR/
	 OuombKEdP4pLO2XZEEbd9cEZK1a0QvqHPyehf1qRet+Ycd4Wb/13lb/MCF9ZnF3rQD
	 u/yEQtKcvi63vbQUqw4pzgVGaph1mP9ZBNPJKVDQ=
Date: Thu, 25 Apr 2024 20:57:58 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,surenb@google.com,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] asm-generic-ioh-kill-vmalloch-dependency.patch removed from -mm tree
Message-Id: <20240426035759.66767C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: asm-generic/io.h: kill vmalloc.h dependency
has been removed from the -mm tree.  Its filename was
     asm-generic-ioh-kill-vmalloch-dependency.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -992,7 +992,6 @@ static inline void iowrite64_rep(volatil
 
 #ifdef __KERNEL__
 
-#include <linux/vmalloc.h>
 #define __io_virt(x) ((void __force *)(x))
 
 /*
_

Patches currently in -mm which might be from kent.overstreet@linux.dev are


