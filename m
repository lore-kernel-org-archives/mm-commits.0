Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949E8223DD7
	for <mm-commits@vger.kernel.org>; Mon, 23 Jun 2025 21:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715599; cv=none; b=mbtwVj8Dr6DyAsxj+5ZhpoRU4bJKr5ugzYuohUe0XehCH8DbDJkGL2XcVmftGsktveh/9z4mVIN5pHAHA/+AcN+byTPY2rzn4WWFZd5DqArGl7W4R9OrwlS+WYzyO/wwihwlW7N1ZcP+JgPcxDotgepQ1VhF/7A/gvK62ZbR9Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715599; c=relaxed/simple;
	bh=lWY5y8+ojiJocO5A9aAH/RkLmq5k7auuylJ3nm7bQxo=;
	h=Date:To:From:Subject:Message-Id; b=dicsPm3gg9Z+8o66KbosAzU2XCpFcxYbcvfp3b+zG09WMwGQ2mQJMnUfTV1syq9f0eX3OyG7TpwwjAQvbozyEq2VlK9lDsctvfa89LAmlVhC/YI6M28Gm1jdoiFxYLUGPbQzZ0YQd3KxfAAZ2LNEsdJ7F7zC8IBGgjr/9AszBGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DWxMf7Xn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DWxMf7Xn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EEEEC4CEED;
	Mon, 23 Jun 2025 21:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750715599;
	bh=lWY5y8+ojiJocO5A9aAH/RkLmq5k7auuylJ3nm7bQxo=;
	h=Date:To:From:Subject:From;
	b=DWxMf7XnKo+Nq+5bKRzUU8CLJjzrv66mTH05um39e9h1qOjo0sN/TeWvq4VsueTk4
	 INjZm8XE5G8ViDGwDs5D+g7H07mhx1WmV60dKpzh+IyjDqiNICZL5zUKpshzbM+0Ep
	 UwCDCNEOQJG/3mscApsnwvo0rRXVp5AgOTj2hYk8=
Date: Mon, 23 Jun 2025 14:53:18 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,harry.yoo@oracle.com,00107082@163.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_vmallocc-use-late_initcall-if-built-in-for-init-ordering.patch added to mm-new branch
Message-Id: <20250623215319.4EEEEC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_vmalloc.c: use late_initcall() if built-in for init ordering
has been added to the -mm mm-new branch.  Its filename is
     lib-test_vmallocc-use-late_initcall-if-built-in-for-init-ordering.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_vmallocc-use-late_initcall-if-built-in-for-init-ordering.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: lib/test_vmalloc.c: use late_initcall() if built-in for init ordering
Date: Mon, 23 Jun 2025 20:40:34 +0200

When the vmalloc test code is compiled as a built-in, use late_initcall()
instead of module_init() to defer a vmalloc test execution until most
subsystems are up and running.

It avoids interfering with components that may not yet be initialized at
module_init() time.  For example, there was a recent report of memory
profiling infrastructure not being ready early enough leading to kernel
crash.

By using late_initcall() in the built-in case, we ensure the tests are run
at a safer point during a boot sequence.

Link: https://lkml.kernel.org/r/20250623184035.581229-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: David Wang <00107082@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/lib/test_vmalloc.c~lib-test_vmallocc-use-late_initcall-if-built-in-for-init-ordering
+++ a/lib/test_vmalloc.c
@@ -598,7 +598,11 @@ static int __init vmalloc_test_init(void
 	return IS_BUILTIN(CONFIG_TEST_VMALLOC) ? 0:-EAGAIN;
 }
 
+#ifdef MODULE
 module_init(vmalloc_test_init)
+#else
+late_initcall(vmalloc_test_init);
+#endif
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Uladzislau Rezki");
_

Patches currently in -mm which might be from urezki@gmail.com are

lib-test_vmallocc-use-late_initcall-if-built-in-for-init-ordering.patch
lib-test_vmallocc-restrict-default-test-mask-to-avoid-test-warnings.patch

