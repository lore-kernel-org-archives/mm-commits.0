Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E19B254B18;
	Mon, 20 Jul 2026 23:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784591588; cv=none; b=ZeUFBlUC/e2yRXXHyv2/3QdJ/qpdUf567r7aBg84jwDYTDEZjzB0szukWmfp6TKCdw7RS3IB+fQka5CBU5AbNEaeMjsPEudiiVu7sjAPcwUTC36fM6XnGxHwLDwnq0NR9PVCf+F6HwYvMXFeBQad03Ir4sxtlIXBjamoxjnxUGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784591588; c=relaxed/simple;
	bh=QmahCUAmMZfkxBGGKF0ZKn5AdSJVCmgxFxI3XKvPW0A=;
	h=Date:To:From:Subject:Message-Id; b=atINFvc9cqdf8Lx6HixU1KP4XCu8xt//b7zIBZSsVtZ2erH4prJFqRe6+yWXbxgabd7LD34NCU8psaKuZX3XyY4XDXv3CUoqWCYw+OYZNSwECUNSyVMielNZwcpaZJ4nVoHKQeGfMfxsUV7v4Y9BT4Up2WYIIS1lBECOp+w6vcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rDOMa6Fr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rDOMa6Fr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC151F000E9;
	Mon, 20 Jul 2026 23:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784591587;
	bh=n6yLmeod/u2My2SmLF1kBtHDGkL2GnWU6vtUkUlaPUw=;
	h=Date:To:From:Subject;
	b=rDOMa6FrqTrctUvOozqTs7xwXoJE5I5M4CvV9KdkYnmDe0898EfcukCCLCMQwKsT0
	 8rLswesCU2kG6x9HB0Yb8EBta/vUK2FDfTivXWrlI1WGa0rwbmZo9J8hftbv+PTfQQ
	 riZqtr0w4URTI8Q1TR2rzHOBerpN50hk48+FI99c=
Date: Mon, 20 Jul 2026 16:53:06 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,linux@roeck-us.net,kees@kernel.org,david@davidgow.net,brendan.higgins@linux.dev,aesteve@redhat.com,acarmina@redhat.com,bartosz.golaszewski@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] bug-fix-warning-suppressions-with-kunit-built-as-module.patch removed from -mm tree
Message-Id: <20260720235307.2DC151F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bug: fix warning suppressions with kunit built as module
has been removed from the -mm tree.  Its filename was
     bug-fix-warning-suppressions-with-kunit-built-as-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: bug: fix warning suppressions with kunit built as module
Date: Wed, 8 Jul 2026 11:54:58 +0200

CONFIG_KUNIT is a tristate symbol but the warning suppression code in
lib/bug.c is only built if it's built-in due to it using a plain #ifdef,
rendering warning suppressions broken for kunit build as loadable module.

kunit_is_suppressed_warning() already has a stub for when kunit is
disabled so drop that guard entirely.

Link: https://lore.kernel.org/20260708095459.12111-1-bartosz.golaszewski@oss.qualcomm.com
Fixes: 85347718ab0d ("bug/kunit: Core support for suppressing warning backtraces")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Suggested-by: Albert Esteve <aesteve@redhat.com>
Reviewed-by: Albert Esteve <aesteve@redhat.com>
Reviewed-by: David Gow <david@davidgow.net>
Cc: Alessandro Carminati <acarmina@redhat.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Guenetr Roeck <linux@roeck-us.net>
Cc: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bug.c |    2 --
 1 file changed, 2 deletions(-)

--- a/lib/bug.c~bug-fix-warning-suppressions-with-kunit-built-as-module
+++ a/lib/bug.c
@@ -219,14 +219,12 @@ static enum bug_trap_type __report_bug(s
 	no_cut   = bug->flags & BUGFLAG_NO_CUT_HERE;
 	has_args = bug->flags & BUGFLAG_ARGS;
 
-#ifdef CONFIG_KUNIT
 	/*
 	 * Before the once logic so suppressed warnings do not consume
 	 * the single-fire budget of WARN_ON_ONCE().
 	 */
 	if (warning && kunit_is_suppressed_warning(true))
 		return BUG_TRAP_TYPE_WARN;
-#endif
 
 	disable_trace_on_warning();
 
_

Patches currently in -mm which might be from bartosz.golaszewski@oss.qualcomm.com are


