Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A993E76408
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103928; cv=none; b=u29ouKpHpsEssFbD3WoZdVFvWIAedWzS6rts08+jx1G5EJCubfHrkDlZWAj8caZnvfDIL/s8Wev8z9Z8+e/M+gc5wNgDgL5iEBbIGH/SSuooFstKcc4LAYmKqoas7qveOCiHIhg0oLzi6A6wFwOYc0zGsX1bvKodSJMOvUi+BKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103928; c=relaxed/simple;
	bh=9XmM5BytLAQXU7Rd4LXXmkdzbBxLr+kRRpjdxkl4M1o=;
	h=Date:To:From:Subject:Message-Id; b=VkUFrJD/hjRNw5JsT8re160vSaUWDeBcvdSYHiTd+6km1G4Rv6b7wtp81HbpsfTK3FoC3uGAnLOTOLBfUkNTgQ6ctFIti8UsaBnylam2LEtW9Zm9+2ZhLx9D792CVp5rLfzHlg5Z0mfWxYKisHxTzMqZPY+yrgyOe11dREaWfCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LRJZsSSH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LRJZsSSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0D2C113CD;
	Fri, 26 Apr 2024 03:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103928;
	bh=9XmM5BytLAQXU7Rd4LXXmkdzbBxLr+kRRpjdxkl4M1o=;
	h=Date:To:From:Subject:From;
	b=LRJZsSSH4nSDtybLGLGgI9LC8UsNYlfrd2dspx6EuahF9U7ft0Ihkg1a/a4vLf0XX
	 JQzzhNRUFvhw2I7wC44V0A+AgimP37ZlHcbq9nMBluVf6dverHRzgnGzehrVsy9DSY
	 /+SoQKtIg6TV0xbTshQA8cCBcdxJgEdy4jFbCGsA=
Date: Thu, 25 Apr 2024 20:58:47 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,surenb@google.com,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,lukas.bulwahn@redhat.com,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-entries-for-code-tagging-and-memory-allocation-profiling.patch removed from -mm tree
Message-Id: <20240426035848.7F0D2C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add entries for code tagging and memory allocation profiling
has been removed from the -mm tree.  Its filename was
     maintainers-add-entries-for-code-tagging-and-memory-allocation-profiling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: MAINTAINERS: add entries for code tagging and memory allocation profiling
Date: Thu, 21 Mar 2024 09:36:58 -0700

The new code & libraries added are being maintained - mark them as such.

[lbulwahn@redhat.com: MAINTAINERS: improve entries]
  Link: https://lkml.kernel.org/r/20240411064717.51140-1-lukas.bulwahn@redhat.com
Link: https://lkml.kernel.org/r/20240321163705.3067592-37-surenb@google.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/MAINTAINERS~maintainers-add-entries-for-code-tagging-and-memory-allocation-profiling
+++ a/MAINTAINERS
@@ -5252,6 +5252,14 @@ S:	Supported
 F:	Documentation/process/code-of-conduct-interpretation.rst
 F:	Documentation/process/code-of-conduct.rst
 
+CODE TAGGING
+M:	Suren Baghdasaryan <surenb@google.com>
+M:	Kent Overstreet <kent.overstreet@linux.dev>
+S:	Maintained
+F:	include/asm-generic/codetag.lds.h
+F:	include/linux/codetag.h
+F:	lib/codetag.c
+
 COMEDI DRIVERS
 M:	Ian Abbott <abbotti@mev.co.uk>
 M:	H Hartley Sweeten <hsweeten@visionengravers.com>
@@ -14151,6 +14159,16 @@ F:	mm/memblock.c
 F:	mm/mm_init.c
 F:	tools/testing/memblock/
 
+MEMORY ALLOCATION PROFILING
+M:	Suren Baghdasaryan <surenb@google.com>
+M:	Kent Overstreet <kent.overstreet@linux.dev>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	Documentation/mm/allocation-profiling.rst
+F:	include/linux/alloc_tag.h
+F:	include/linux/pgalloc_tag.h
+F:	lib/alloc_tag.c
+
 MEMORY CONTROLLER DRIVERS
 M:	Krzysztof Kozlowski <krzk@kernel.org>
 L:	linux-kernel@vger.kernel.org
_

Patches currently in -mm which might be from kent.overstreet@linux.dev are


