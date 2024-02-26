Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D89131750
	for <mm-commits@vger.kernel.org>; Mon, 26 Feb 2024 22:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708985652; cv=none; b=I5jNJ5KOeqGEfXqakuVoYeP3OIVnAZUPgGFz43dEDV78Nm4/eoxAw1L56+Ln6h9jIbj1ytSBinJegU5e/l/UGqkyzGjMt1gNXmG7bN/4Og5hZ2K6Hd2lRamfVCC4hfDIlJu1ILiet0zOgkbcdqJx28vow6Z8f5OKbybXhmXfzeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708985652; c=relaxed/simple;
	bh=hJzJeyp4eK+cH/VAYIChGLVZMxbOoAFL/Fb/IF22LLk=;
	h=Date:To:From:Subject:Message-Id; b=ZAn/LBw9rUZuczZfMksdqy3+x4A5wjDAImqqKvZAsXxuz3o1vmK9aQGX9Fs4u/+7X3/cCoEN9kEMamuLhicPz0NU2kqsDv4T8I/Jz3TSvd14EHOXfuGONZK2zVwLj2G8HEdCbfvvKVPjBoYIJauV3nVI4BX55Ma/KLAooH92sCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jSydH95t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jSydH95t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B93EC433C7;
	Mon, 26 Feb 2024 22:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708985651;
	bh=hJzJeyp4eK+cH/VAYIChGLVZMxbOoAFL/Fb/IF22LLk=;
	h=Date:To:From:Subject:From;
	b=jSydH95t9T57e6OebMgFXcx0WaKPiWvVOJ6wB5EhDFSSccWH2mjkssz4Q5IoXlV4d
	 XwuclFtt+3XsNa4kOg5Hzj6/vQMDMWSRVIkf94qcEsw9flUzZUfVfg+bNsXZEUdVBj
	 curTtRZsL9Wtdlb9R7yJZlJ9r5L/pvC7hKTr4bwI=
Date: Mon, 26 Feb 2024 14:14:10 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,martin@kaiser.cx,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_vmallocc-fix-typo-in-function-name.patch added to mm-nonmm-unstable branch
Message-Id: <20240226221411.8B93EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_vmalloc.c: fix typo in function name
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-test_vmallocc-fix-typo-in-function-name.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_vmallocc-fix-typo-in-function-name.patch

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
Subject: lib/test_vmalloc.c: fix typo in function name
Date: Mon, 26 Feb 2024 20:11:57 +0100

Fix a typo and change the function name to init_test_configuration.  Both
caller and definition have the same typo, so the current code already
works.

Link: https://lkml.kernel.org/r/20240226191159.39509-2-martin@kaiser.cx
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/test_vmalloc.c~lib-test_vmallocc-fix-typo-in-function-name
+++ a/lib/test_vmalloc.c
@@ -501,7 +501,7 @@ static int test_func(void *private)
 }
 
 static int
-init_test_configurtion(void)
+init_test_configuration(void)
 {
 	/*
 	 * A maximum number of workers is defined as hard-coded
@@ -531,7 +531,7 @@ static void do_concurrent_test(void)
 	/*
 	 * Set some basic configurations plus sanity check.
 	 */
-	ret = init_test_configurtion();
+	ret = init_test_configuration();
 	if (ret < 0)
 		return;
 
_

Patches currently in -mm which might be from martin@kaiser.cx are

lib-test_vmallocc-fix-typo-in-function-name.patch
lib-test_vmallocc-drop-empty-exit-function.patch
lib-test_vmallocc-use-unsigned-long-constant.patch

