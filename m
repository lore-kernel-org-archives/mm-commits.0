Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DD538A9B1
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898338; cv=none; b=EBCs3xhnkYSO+h/BAviiYM+eoq0ISa0LZJlf51MASkL6jEuK9uby7INpZVaHqB5ohPrTYH1ZSsof4xCBBOuc6fZd66gM+8FD7yCar552ycTqHEc3BKE3ddky7zwpqDTq/3o4TXlILrHwZsxvMUica4e5KgdaLSXQCMrg8Nk0Q8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898338; c=relaxed/simple;
	bh=5qGlN7wmQgGEDgoi9bTUCEHr7AXAiclKyW76ExdJquU=;
	h=Date:To:From:Subject:Message-Id; b=oLNzupoAtURqC/h8BhnsufTD2wAvCp7tztp4ZwKCYkde+2OZTU3WFj7Han+pYlrSVDE4mFfsfqgb+7yrTRyNfTQ/zpfFC2U1r0bxgYV9rBnI2oHhBeQJF6cSfVuvNhxSO7Rn93rYocch7IaB4gouriznCd8mxL0VIuy7MP8U1sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s+kUgsaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s+kUgsaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951BEC4CEF1;
	Sat, 31 Jan 2026 22:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898337;
	bh=5qGlN7wmQgGEDgoi9bTUCEHr7AXAiclKyW76ExdJquU=;
	h=Date:To:From:Subject:From;
	b=s+kUgsaHIySMf2cfNUMoxyVl5vGfyli6oJeIsYD436uCGVD3YKhF+P1ZiilFwDiY1
	 lGzM9KdhndN0tSUPcQzaNbGLScg9w0tazvckxz27stHYNpSls0Ok/9lEo6QZ3XUY9b
	 INDafe7e9TWo1linTcyzcDWJIoFI9tLZBupd/LK4=
Date: Sat, 31 Jan 2026 14:25:37 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-document-damon_call_control-dealloc_on_cancel-repeat-behavior.patch removed from -mm tree
Message-Id: <20260131222537.951BEC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: document damon_call_control->dealloc_on_cancel repeat behavior
has been removed from the -mm tree.  Its filename was
     mm-damon-document-damon_call_control-dealloc_on_cancel-repeat-behavior.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: document damon_call_control->dealloc_on_cancel repeat behavior
Date: Sat, 17 Jan 2026 09:52:52 -0800

damon_call_control->dealloc_on_cancel works only when ->repeat is true. 
But the behavior is not clearly documented.  DAMON API callers can
understand the behavior only after reading kdamond_call() code.  Document
the behavior on the kernel-doc comment of damon_call_control.

Link: https://lkml.kernel.org/r/20260117175256.82826-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-document-damon_call_control-dealloc_on_cancel-repeat-behavior
+++ a/include/linux/damon.h
@@ -663,7 +663,7 @@ struct damon_operations {
  * @data:		Data that will be passed to @fn.
  * @repeat:		Repeat invocations.
  * @return_code:	Return code from @fn invocation.
- * @dealloc_on_cancel:	De-allocate when canceled.
+ * @dealloc_on_cancel:	If @repeat is true, de-allocate when canceled.
  *
  * Control damon_call(), which requests specific kdamond to invoke a given
  * function.  Refer to damon_call() for more details.
_

Patches currently in -mm which might be from sj@kernel.org are


