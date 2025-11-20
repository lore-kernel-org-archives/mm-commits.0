Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E08723A9B3
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676262; cv=none; b=pKHMxio0p4R09IlNVm7zxwWVi7HlKbRTnNn9rraFiNdxe5gVsUeIOaaWp5LMA/cNdyJgLgd+DQXBokO+JFLFbR6tGCk5z0tGSxaeMTZzxJBzz1JcgxhCo6u/Qef8b5H1hacF2E9g+1jIGTYf2/x57RG5K/tAAE6wrjd5Z1wrAMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676262; c=relaxed/simple;
	bh=9qYR0n5ROz3KEEtPZqAtu1Cz4U1u+iQ2kg0UjgYlL+Y=;
	h=Date:To:From:Subject:Message-Id; b=a1LXMYi/wwBfY3Y1TaOxQUETPDyQOjN1iVGRvc/oTCSjbU9sz/gPgDSwEmDC5ggEcrWt7BhwZTMBa6R11BPKdtJdheXEff0axVgx5EP1bLD9CVJpdDfXHvq7OFYuNGxMHpyaZVJxiPDKxcPrwhg9DahaHiajC+PrAYE2mJfUslw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wePVCN8o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wePVCN8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B1AC4CEF1;
	Thu, 20 Nov 2025 22:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676262;
	bh=9qYR0n5ROz3KEEtPZqAtu1Cz4U1u+iQ2kg0UjgYlL+Y=;
	h=Date:To:From:Subject:From;
	b=wePVCN8oeGQ73EkxtYgkRVHzevFXE5hGhtL+hmUr9Kz5hcV6y66x73UoXZPcYEo4W
	 lreS7u18PYzaojjg1MCTCFunXQD7+yA3Z3GE1p3FQtbOmHNxuD4MGiEi+/GBMnju/w
	 zMH5QQL85S+/A1f0wQ5dM0iQGMSaydSGOYxbaYUc=
Date: Thu, 20 Nov 2025 14:04:21 -0800
To: mm-commits@vger.kernel.org,mhiramat@kernel.org,lance.yang@linux.dev,kent.overstreet@linux.dev,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-hung_task-unexport-sysctl_hung_task_timeout_secs.patch removed from -mm tree
Message-Id: <20251120220422.11B1AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/hung_task: unexport sysctl_hung_task_timeout_secs
has been removed from the -mm tree.  Its filename was
     kernel-hung_task-unexport-sysctl_hung_task_timeout_secs.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: kernel/hung_task: unexport sysctl_hung_task_timeout_secs
Date: Tue, 4 Nov 2025 07:19:20 -0500

This was added by the bcachefs pull requests despite various
objections, and with bcachefs removed is now unused.

This reverts commit 5c3273ec3c6a ("kernel/hung_task.c: export
sysctl_hung_task_timeout_secs").

Link: https://lkml.kernel.org/r/20251104121920.2430568-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/hung_task.c~kernel-hung_task-unexport-sysctl_hung_task_timeout_secs
+++ a/kernel/hung_task.c
@@ -50,7 +50,6 @@ static unsigned long __read_mostly sysct
  * Zero means infinite timeout - no checking done:
  */
 unsigned long __read_mostly sysctl_hung_task_timeout_secs = CONFIG_DEFAULT_HUNG_TASK_TIMEOUT;
-EXPORT_SYMBOL_GPL(sysctl_hung_task_timeout_secs);
 
 /*
  * Zero (default value) means use sysctl_hung_task_timeout_secs:
_

Patches currently in -mm which might be from hch@lst.de are


