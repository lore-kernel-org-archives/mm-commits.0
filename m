Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF38366804
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 18:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772820487; cv=none; b=cKyyQd3Hpv2zD85tdW5zrz1whhctWWVQxWhlRk8bb88FEw/DFSXwluud1dWm1YVnPFZMERBX60lL75zKGP39pfa5e1Pcvyq/TIpsxL8WbDT1NCDKvtPjok+XtUc5o0Rw4PMbDXkuPWKhP2KfhTnpwfzljdx160bGIXqMtoO5v1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772820487; c=relaxed/simple;
	bh=Y8wLx1ZAAUvihIHO6+sCAZOBr8227Ku8zI3sRp0O4ck=;
	h=Date:To:From:Subject:Message-Id; b=kXtn5Ea9BBCCEudOQE1u1bI/iYMmBI6SDBGBqJStgF2Mrg+ISrF6u16bM97XegrsC/G/YIt9fCIO9vRyffSZwgXZoSMhZD83VL+FDU0iXB91gNL7ER+VvSFKy4Mz2hBJ0iyBTHl2TiPpmlhPyBsrXhIyXso83wudOPSZmQVJ9sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jw3eg5jO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jw3eg5jO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CB5C4CEF7;
	Fri,  6 Mar 2026 18:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772820486;
	bh=Y8wLx1ZAAUvihIHO6+sCAZOBr8227Ku8zI3sRp0O4ck=;
	h=Date:To:From:Subject:From;
	b=jw3eg5jOu2Xnt+W8s8k8sPbb9wY9vzgvCdxTfsQLc84IQoqudz46YdHWf+0GG8YHQ
	 6lurpbogveHWNo0mmxmXuiV2z9Y9OeIYts0/xQxkLvCbH250DWXXwbH7ElqE/wZrSo
	 u9Idt3353zDYs7AkYAiAmjwqkuBpE/PGy0XtwRok=
Date: Fri, 06 Mar 2026 10:08:06 -0800
To: mm-commits@vger.kernel.org,objecting@objecting.org,hlcj1234567@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-inflate-fix-grammar-in-comment-variable-to-variables.patch added to mm-nonmm-unstable branch
Message-Id: <20260306180806.D4CB5C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/inflate: fix grammar in comment: "variable" to "variables"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-inflate-fix-grammar-in-comment-variable-to-variables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-inflate-fix-grammar-in-comment-variable-to-variables.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Josh Law <hlcj1234567@gmail.com>
Subject: lib/inflate: fix grammar in comment: "variable" to "variables"
Date: Fri, 6 Mar 2026 16:17:07 +0000

Fix "all variable" to "all variables" in the file header comment.

Link: https://lkml.kernel.org/r/20260306161707.2812005-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/inflate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/inflate.c~lib-inflate-fix-grammar-in-comment-variable-to-variables
+++ a/lib/inflate.c
@@ -9,7 +9,7 @@
  * based on gzip-1.0.3 
  *
  * Nicolas Pitre <nico@fluxnic.net>, 1999/04/14 :
- *   Little mods for all variable to reside either into rodata or bss segments
+ *   Little mods for all variables to reside either into rodata or bss segments
  *   by marking constant variables with 'const' and initializing all the others
  *   at run-time only.  This allows for the kernel uncompressor to run
  *   directly from Flash or ROM memory on embedded systems.
_

Patches currently in -mm which might be from hlcj1234567@gmail.com are

lib-glob-add-missing-spdx-license-identifier.patch
lib-uuid-fix-typo-reversion-to-revision-in-comment.patch
lib-inflate-fix-memory-leak-in-inflate_fixed-on-inflate_codes-failure.patch
lib-inflate-fix-memory-leak-in-inflate_dynamic-on-inflate_codes-failure.patch
lib-inflate-fix-grammar-in-comment-variable-to-variables.patch
lib-inflate-fix-typo-this-results-to-the-results-in-comment.patch

