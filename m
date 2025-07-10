Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A6828640C
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126374; cv=none; b=VmGD7T5bwRqVryjx64Z17mjUsEAcYNIAi/spVmM4iL/bSMDZIQJqYl9s9pXJ7u2vQFYgYPpW4emCuvnC06gzQIxMFClWCHfbDiHJoYsW6o678NndkBynphUdKR3Y523XZcBhQpya4KFAkTqLUVUPYgELnlbSySCrpcICVlu4H5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126374; c=relaxed/simple;
	bh=L4T98rTfXU3gUdCw7h4vVmfSsOlrLwjOVnmV0rV2o4w=;
	h=Date:To:From:Subject:Message-Id; b=V3EYHoSTMCGey/LeJ23QuOJpujHWqUPLT3uJs95Ee0llbWReGZbLqnUydrdsZC5lZ78rcl9z7Z0eO8IhqNBHtbk2Bv/NxEyWFi5HH5//nXfSWnB3Vjd8+bKKCrt9ntCvV41AYDaXSrG/gtLjB1/dmCCO5jSzcrdSmuWrxH3l648=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mcPvGDd8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mcPvGDd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E126CC4CEF4;
	Thu, 10 Jul 2025 05:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126374;
	bh=L4T98rTfXU3gUdCw7h4vVmfSsOlrLwjOVnmV0rV2o4w=;
	h=Date:To:From:Subject:From;
	b=mcPvGDd8WdqYmfP7slFJnlybDclLEydNj3NPPztN7ZtxSJAGZ6ac7OMgnOiUGqD6o
	 MsaAiFp3RnHqwDeeAP1T/c5pXM+JwnhoO41E9xA0iRCTStf6T0I/OlyF+/nNZfCYIX
	 Vf4619WO2RbRUSKwDB0I6IHoKnpZ/5Dvp4LOohOc=
Date: Wed, 09 Jul 2025 22:46:13 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,harry.yoo@oracle.com,bhe@redhat.com,00107082@163.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_vmallocc-use-late_initcall-if-built-in-for-init-ordering.patch removed from -mm tree
Message-Id: <20250710054613.E126CC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_vmalloc.c: use late_initcall() if built-in for init ordering
has been removed from the -mm tree.  Its filename was
     lib-test_vmallocc-use-late_initcall-if-built-in-for-init-ordering.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Baoquan He <bhe@redhat.com>
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


