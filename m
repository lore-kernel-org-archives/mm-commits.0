Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE28614B96E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908558; cv=none; b=fFXsd3vF2RASpYi+cMn7+KdOvP/BfLe4GsxHoulXVuD2QZ0hZaczNzQ52UPG/vWYak/60zQGFa8QN8LbrKYD/GB/EzNW+MsnPwBCsUtEgKzfiX4W/5QZi81yGYCYew2GVPBDdt+jTdIyUqFlo/1/QQz4bVwS4VDTBY+dIT5mXWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908558; c=relaxed/simple;
	bh=oySGlIIemeCYu6LZxMlBe4ZgCiyclQ0Xrc7oWuVxtC0=;
	h=Date:To:From:Subject:Message-Id; b=NrQYpV5pMwAX+kSKGAbUaSpsnfnfoWpmaeCyFuhXkWdnVsDCueyXe8QzwdfeQVmgM2ExB09dYkBDz9jXb9NS8ady5WJ1Z3DYHbXsi+RmzK5MTsG15z42ThMbXnEXyEMMcFlQIYl97aiQg8MPDxkbdCIn8aKzguXUIr5uwWQ80aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L43oV9ZR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L43oV9ZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47710C4CEFB;
	Wed, 12 Nov 2025 00:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908558;
	bh=oySGlIIemeCYu6LZxMlBe4ZgCiyclQ0Xrc7oWuVxtC0=;
	h=Date:To:From:Subject:From;
	b=L43oV9ZR63NEtEucSMOPipKJpZhzcTQDH9Kgd9xRiNxLXbN5m8YEIaHw0Je4gPK0e
	 E2RbO+xh4FD5dxfPqJ930KXQkyZu6FOhEATTxJzfSguYKue2Ig87mNZDOCujInhlFX
	 +/ceiXrPDKmo3AMEAkp5WICR9LC8u/e0IA5UQbCw=
Date: Tue, 11 Nov 2025 16:49:17 -0800
To: mm-commits@vger.kernel.org,zhouyuhang@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] samples-fix-coding-style-issues-in-kconfig.patch removed from -mm tree
Message-Id: <20251112004918.47710C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples: fix coding style issues in Kconfig
has been removed from the -mm tree.  Its filename was
     samples-fix-coding-style-issues-in-kconfig.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhou Yuhang <zhouyuhang@kylinos.cn>
Subject: samples: fix coding style issues in Kconfig
Date: Mon, 29 Sep 2025 14:24:34 +0800

Fix some coding style issues in Kconfig: use one tab to indent lines under
a config definition, and use an additional two spaces to indent help text.

Link: https://lkml.kernel.org/r/20250929062434.4114607-1-zhouyuhang1010@163.com
Signed-off-by: Zhou Yuhang <zhouyuhang@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/Kconfig |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/samples/Kconfig~samples-fix-coding-style-issues-in-kconfig
+++ a/samples/Kconfig
@@ -23,11 +23,11 @@ config SAMPLE_TRACE_CUSTOM_EVENTS
 	  This builds the custom trace event example module.
 
 config SAMPLE_TRACE_PRINTK
-        tristate "Build trace_printk module - tests various trace_printk formats"
+	tristate "Build trace_printk module - tests various trace_printk formats"
 	depends on EVENT_TRACING && m
 	help
-	 This builds a module that calls trace_printk() and can be used to
-	 test various trace_printk() calls from a module.
+	  This builds a module that calls trace_printk() and can be used to
+	  test various trace_printk() calls from a module.
 
 config SAMPLE_FTRACE_DIRECT
 	tristate "Build register_ftrace_direct() example"
@@ -54,11 +54,11 @@ config SAMPLE_FTRACE_OPS
 	  measures the time taken to invoke one function a number of times.
 
 config SAMPLE_TRACE_ARRAY
-        tristate "Build sample module for kernel access to Ftrace instances"
+	tristate "Build sample module for kernel access to Ftrace instances"
 	depends on EVENT_TRACING && m
 	help
-	 This builds a module that demonstrates the use of various APIs to
-	 access Ftrace instances from within the kernel.
+	  This builds a module that demonstrates the use of various APIs to
+	  access Ftrace instances from within the kernel.
 
 config SAMPLE_KOBJECT
 	tristate "Build kobject examples"
@@ -290,11 +290,11 @@ config SAMPLE_CORESIGHT_SYSCFG
 	  configurations and easily load them into the system at runtime.
 
 config SAMPLE_KMEMLEAK
-        tristate "Simple test for the kernel memory leak detector"
-        depends on DEBUG_KMEMLEAK && m
-        help
-          Build a sample program which have explicitly leaks memory to test
-          kmemleak
+	tristate "Simple test for the kernel memory leak detector"
+	depends on DEBUG_KMEMLEAK && m
+	help
+	  Build a sample program which have explicitly leaks memory to test
+	  kmemleak.
 
 config SAMPLE_CGROUP
 	bool "Build cgroup sample code"
_

Patches currently in -mm which might be from zhouyuhang@kylinos.cn are


