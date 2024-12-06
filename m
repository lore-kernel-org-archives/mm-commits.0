Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542CE1940B2;
	Fri,  6 Dec 2024 03:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733457338; cv=none; b=RimdlqJQvsATCmBt9HJGpEKFixzDAjeKJljXyTIp64CHm6ECcU6WFSRtfc5lx6D2wbNPwXQ9VC/PxC86ePl9MpMJxOKzE9F81/G3Weks/vF2Wo/p/orBppKreZ//TvVaMxatQZvDXKjP/WqNdVwtAvP1KHOQ4NKUYZLLVFJ8bsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733457338; c=relaxed/simple;
	bh=kFtsmkabA/fOvYUS+mNJSJWzfwy5zVbU6o026n551a8=;
	h=Date:To:From:Subject:Message-Id; b=qwh3jyyCX9aojYo0TBlP+5kH0eCv+UpiQnuBngB2E/0wfzo/4fOTJVOgV6dlarK+UOLvTq7ri0XPEa4gmM1f5Vf+aox/1hioTjaJ+2l0lJM6LeYY26CI7JwwFCIJkPYlW9jQBTvFNVOesl9g6KfbrKXHTU6rRubwi/eUlaHEXMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NFeyR3rW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NFeyR3rW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298E1C4CED1;
	Fri,  6 Dec 2024 03:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733457338;
	bh=kFtsmkabA/fOvYUS+mNJSJWzfwy5zVbU6o026n551a8=;
	h=Date:To:From:Subject:From;
	b=NFeyR3rWf2wRkLXgvCQxW34sBsVnQUU+fHJYyiyIJb7afIRpUcoX8VZIjtdtXURDM
	 ZaLGWWD9gd++LsYuciYWeV38wZpvTZ1PFtLC5R9+tJeFOvH9D3i0unq1oxevFPnXCo
	 cKq3TbVspblfdvZ8OiAGI6z0//ML4vSbU8lu8QM8=
Date: Thu, 05 Dec 2024 19:55:37 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kees@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-stackinit-hide-never-taken-branch-from-compiler.patch removed from -mm tree
Message-Id: <20241206035538.298E1C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: stackinit: hide never-taken branch from compiler
has been removed from the -mm tree.  Its filename was
     lib-stackinit-hide-never-taken-branch-from-compiler.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kees Cook <kees@kernel.org>
Subject: lib: stackinit: hide never-taken branch from compiler
Date: Sun, 17 Nov 2024 03:38:13 -0800

The never-taken branch leads to an invalid bounds condition, which is by
design. To avoid the unwanted warning from the compiler, hide the
variable from the optimizer.

../lib/stackinit_kunit.c: In function 'do_nothing_u16_zero':
../lib/stackinit_kunit.c:51:49: error: array subscript 1 is outside array bounds of 'u16[0]' {aka 'short unsigned int[]'} [-Werror=array-bounds=]
   51 | #define DO_NOTHING_RETURN_SCALAR(ptr)           *(ptr)
      |                                                 ^~~~~~
../lib/stackinit_kunit.c:219:24: note: in expansion of macro 'DO_NOTHING_RETURN_SCALAR'
  219 |                 return DO_NOTHING_RETURN_ ## which(ptr + 1);    \
      |                        ^~~~~~~~~~~~~~~~~~

Link: https://lkml.kernel.org/r/20241117113813.work.735-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackinit_kunit.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/stackinit_kunit.c~lib-stackinit-hide-never-taken-branch-from-compiler
+++ a/lib/stackinit_kunit.c
@@ -212,6 +212,7 @@ static noinline void test_ ## name (stru
 static noinline DO_NOTHING_TYPE_ ## which(var_type)		\
 do_nothing_ ## name(var_type *ptr)				\
 {								\
+	OPTIMIZER_HIDE_VAR(ptr);				\
 	/* Will always be true, but compiler doesn't know. */	\
 	if ((unsigned long)ptr > 0x2)				\
 		return DO_NOTHING_RETURN_ ## which(ptr);	\
_

Patches currently in -mm which might be from kees@kernel.org are


