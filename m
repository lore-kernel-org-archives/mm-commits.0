Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB74131750
	for <mm-commits@vger.kernel.org>; Mon, 26 Feb 2024 22:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708985653; cv=none; b=Sy3ms/wIWHqobhLyWV5Jzmg5AdfN2/RRA6P9CgvTVGrJ/YeBUHcyCkxJ7+04zPYzXaQEtx+oWUeWhSSPmA104HLy2v02nmBwZqCwTngTbc2jOew0B9HsRBgdyOEhLZ4dY8gqKyXjqbamHvSolttjI/Du4l69P+Y0o5eyp0e0KLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708985653; c=relaxed/simple;
	bh=XjnQADXRFOy4ZLrBQ7YsfNRJqbSwS+W6vWiJ6T+0s/E=;
	h=Date:To:From:Subject:Message-Id; b=SYvJEndTlIJxYJPeTsozhRbv8Yv3YAtdvBlIgXkfkFFqZ9IKf+cxOpBHmCcK8N4jR86koy2LVBjznJAVwIou30dni0fTo9vSz6wjGvX7WSVWaCZsb9vTfCHdx5hmMmgPHZJQFK2MwyeAJilLdlFhVI+tGhONUYP+BSJSQzaGe08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iZLGcclM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iZLGcclM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B82C433C7;
	Mon, 26 Feb 2024 22:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708985653;
	bh=XjnQADXRFOy4ZLrBQ7YsfNRJqbSwS+W6vWiJ6T+0s/E=;
	h=Date:To:From:Subject:From;
	b=iZLGcclMNKBD2n7hMRuwodTA52ZmMw+PCKOdyxn6tzz9k1KwbBMPYj6R2fsfwUSge
	 A/u6Nm4X8fc8UkusvWK0K6tx++/Q+ZTv4Vw4f8vYYN3zyG0NDSoHTmXaXucWE4zNVj
	 7hRAzUds/j+jwlxcE1Rb2BESmVmy0gjQroHdSDA0=
Date: Mon, 26 Feb 2024 14:14:12 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,martin@kaiser.cx,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_vmallocc-drop-empty-exit-function.patch added to mm-nonmm-unstable branch
Message-Id: <20240226221412.D5B82C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_vmalloc.c: drop empty exit function
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-test_vmallocc-drop-empty-exit-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_vmallocc-drop-empty-exit-function.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Martin Kaiser <martin@kaiser.cx>
Subject: lib/test_vmalloc.c: drop empty exit function
Date: Mon, 26 Feb 2024 20:11:58 +0100

The module is never loaded successfully.  Therefore, it'll never be
unloaded and we can remove the exit function.

Link: https://lkml.kernel.org/r/20240226191159.39509-3-martin@kaiser.cx
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/lib/test_vmalloc.c~lib-test_vmallocc-drop-empty-exit-function
+++ a/lib/test_vmalloc.c
@@ -600,12 +600,7 @@ static int vmalloc_test_init(void)
 	return -EAGAIN; /* Fail will directly unload the module */
 }
 
-static void vmalloc_test_exit(void)
-{
-}
-
 module_init(vmalloc_test_init)
-module_exit(vmalloc_test_exit)
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Uladzislau Rezki");
_

Patches currently in -mm which might be from martin@kaiser.cx are

lib-test_vmallocc-fix-typo-in-function-name.patch
lib-test_vmallocc-drop-empty-exit-function.patch
lib-test_vmallocc-use-unsigned-long-constant.patch

