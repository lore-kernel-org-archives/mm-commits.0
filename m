Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF3833C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293151; cv=none; b=pFi7TcpWlrg9mUUGJiTIA88ANBIvCzLgcajb9TgarPbDPrfXpIXskT0ihlKMeDEUmXQqk4RmAtERD7+hQcSYHTgtqpJz2efX4hQYDGkHpCC+d3drKeU+rN7ubqIEwxNST2jSpy8f3yAPyEZm1jwxIHusG2wWigz54iqQUupyvrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293151; c=relaxed/simple;
	bh=rt8LL8JJzKsYoMu3kKzgZAKlkN10OeRUO3aMvVJPnIQ=;
	h=Date:To:From:Subject:Message-Id; b=s2UVkObXYxwcFQQNyp6l7Keei5APk1NvaS0KL8V9o4V9a0niaLtn8ab2V7z9NMD//CgydpfbhcEekbNIr4UkKdqQKdOpqtD0QuOihnOeM32VqfsetbfVpLTQstgGyOzqfjzVmyEbNpkFLw03+gGo/AxbbaLO8jcRT/xyXMRaCyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CUmQNDFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CUmQNDFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD09C32782;
	Tue, 25 Jun 2024 05:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293150;
	bh=rt8LL8JJzKsYoMu3kKzgZAKlkN10OeRUO3aMvVJPnIQ=;
	h=Date:To:From:Subject:From;
	b=CUmQNDFeXs8RZ3CXOwBmKFAPUd+HCfvEsFzFmS4fF3qxhi0d4ov4x3dQzKeo6yL+v
	 j+/Nocqv6boxLgzLGH6DzIiGKfRKG4CPzIM2l6envqUIsqj/L9h+kucfwmJT/z6/p0
	 4YpXYYUvXcl9RkMNRdWqK9I+LMARX32k9DGj3Tic=
Date: Mon, 24 Jun 2024 22:25:50 -0700
To: mm-commits@vger.kernel.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] backtracetest-add-module_description.patch removed from -mm tree
Message-Id: <20240625052550.CBD09C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: backtracetest: add MODULE_DESCRIPTION()
has been removed from the -mm tree.  Its filename was
     backtracetest-add-module_description.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: backtracetest: add MODULE_DESCRIPTION()
Date: Sat, 18 May 2024 16:12:05 -0700

Fix the 'make W=1' warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in kernel/backtracetest.o

Link: https://lkml.kernel.org/r/20240518-md-backtracetest-v1-1-fab9f942c139@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/backtracetest.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/backtracetest.c~backtracetest-add-module_description
+++ a/kernel/backtracetest.c
@@ -74,5 +74,6 @@ static void exitf(void)
 
 module_init(backtrace_regression_test);
 module_exit(exitf);
+MODULE_DESCRIPTION("Simple stack backtrace regression test module");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Arjan van de Ven <arjan@linux.intel.com>");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

kfifo-add-missing-module_description-macros.patch
resource-add-missing-module_description.patch
selftests-fpu-add-missing-module_description-macro.patch

