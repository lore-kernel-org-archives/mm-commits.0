Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D522D0283
	for <mm-commits@vger.kernel.org>; Tue,  4 Nov 2025 22:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762296199; cv=none; b=hcwl0JhJgAUXjRKwvGRNCQ2mvUbGcBC9Uga9+qO/s29rYaEi9RFrJsYei28NVCGkqOdBDTMABZL4DGI2Pt2seA2W5rnumUZLhYm0QP7mX4IhfZM2k2XC441+3EbGpMTeZuAPse8346/KFoFQmMwtBoNHgN/VXua9afnK2vxBnU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762296199; c=relaxed/simple;
	bh=lmiDAF49SRrHTZUMJ/aCRX5sA9ItREqTSOrNuLObsvU=;
	h=Date:To:From:Subject:Message-Id; b=Xx5nLPDkd1m0ErGLwDIGo6tq/ZAO7wD4W78h/9r8jxWwFtatEUojBFIGcERxqWHKT/4IiGvqxFFKS6xFNU1H0BxUjZIbRMpI1cawkx1XMQHvVMMfC8WxVia1eeZUuSokj+rGQgpO6zd2VtrXJYnkNDX31zFWMIsHR37I5fqUnI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oUqTL50w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oUqTL50w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90D4C4CEF7;
	Tue,  4 Nov 2025 22:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762296198;
	bh=lmiDAF49SRrHTZUMJ/aCRX5sA9ItREqTSOrNuLObsvU=;
	h=Date:To:From:Subject:From;
	b=oUqTL50wLVdCk8lVreM8/pzdHsW+sL0FzZKxMK6x4Ht3Kz2IV9uoTyMIfCII9Aqsc
	 cJO9bPxYZWWJyzsup5qOCptFuF0G7vG7EtnAPjihf7wOsDDttC0GQIqyPDkcw4TErC
	 N+CiZxvAh9b/XJwgN93enGu8dUIyock7qXmFXqLk=
Date: Tue, 04 Nov 2025 14:43:18 -0800
To: mm-commits@vger.kernel.org,mhiramat@kernel.org,lance.yang@linux.dev,kent.overstreet@linux.dev,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-hung_task-unexport-sysctl_hung_task_timeout_secs.patch added to mm-nonmm-unstable branch
Message-Id: <20251104224318.D90D4C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/hung_task: unexport sysctl_hung_task_timeout_secs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-hung_task-unexport-sysctl_hung_task_timeout_secs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-hung_task-unexport-sysctl_hung_task_timeout_secs.patch

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
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
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

kernel-hung_task-unexport-sysctl_hung_task_timeout_secs.patch

