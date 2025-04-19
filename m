Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FFE4A3C
	for <mm-commits@vger.kernel.org>; Sat, 19 Apr 2025 20:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745096152; cv=none; b=oAa2EqtjXd3HNZHduSq4e6yN7DHTf1YmrPo6z2ZTHC+nmJoFAWRbEunW77xP7/KKzvAtsC6cckEB/N0lUcTwpt2nuKZbydzfNtbz40RD031HThJb3yQCJUevPwgYVUMdxHNJuYrpq9chDJpaf7QsbuLotuhzUW8JJZES5f9HxYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745096152; c=relaxed/simple;
	bh=4Q3Vl5qKfxLaGxir0HfT+X9i0HaE2VVeaI6q7m2tYF8=;
	h=Date:To:From:Subject:Message-Id; b=cEQX0i0ceFkEt4FgCOA7BJzOr/IhZ2R9V8hOF+WLIWKJ0xdzhtcpIkm4WGLjKZMBCPNzSb8Z+rNn/k8ThViAZ6zqTFFoG12NGDAMmmhC8qdiZDOb5Bb13vazc3Zs/Wd1xFwJp5keb1CWabW5htqm21510VS5KuhDujVJX9hyknA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E7b5y5P9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E7b5y5P9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FC9C4CEE7;
	Sat, 19 Apr 2025 20:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745096151;
	bh=4Q3Vl5qKfxLaGxir0HfT+X9i0HaE2VVeaI6q7m2tYF8=;
	h=Date:To:From:Subject:From;
	b=E7b5y5P9c6ZI7cxHqat3QV/Y9OzyEgXh7XvzJNzrd8m0Tb5Dagb2Sfuf8i/uN6wSY
	 OB6NlpJuUHtz/1Q0UOhx9Z5k7+pdT6jJng1FOpL59L2fxutYKNdShsERvs4A5Og2um
	 z3m2y3qg+YSWB+i2eRYF6OQ77ybdY0fiLVjaZshk=
Date: Sat, 19 Apr 2025 13:55:50 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,linux@roeck-us.net,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-disable-image-size-check-for-test-builds-fix-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20250419205551.A8FC9C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86-disable-image-size-check-for-test-builds-fix-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     x86-disable-image-size-check-for-test-builds-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-disable-image-size-check-for-test-builds-fix-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: x86-disable-image-size-check-for-test-builds-fix-fix
Date: Sat Apr 19 01:54:50 PM PDT 2025

fix comment snafu

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202504191813.4r9H6Glt-lkp@intel.com/
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/vmlinux.lds.S |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/kernel/vmlinux.lds.S~x86-disable-image-size-check-for-test-builds-fix-fix
+++ a/arch/x86/kernel/vmlinux.lds.S
@@ -473,7 +473,6 @@ SECTIONS
  */
 #ifndef CONFIG_COMPILE_TEST
 /*
-/*
  * The ASSERT() sync to . is intentional, for binutils 2.14 compatibility:
  */
 . = ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

x86-disable-image-size-check-for-test-builds-fix.patch
x86-disable-image-size-check-for-test-builds-fix-fix.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
mm-add-zblock-allocator-fix.patch

