Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FCB14A91
	for <mm-commits@vger.kernel.org>; Tue,  8 Oct 2024 00:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728347335; cv=none; b=WdqMvBm5gQwqehKJMhoLUa5XD78zjg5l4EaK5cZAg7xMc3Ug/aNjNjQvQCRR6uOcG3QCBxYK57juU8I5aL5emoqujc+g7uKlEBxZ8vJyKXbuUAjCr1nLD81zXe2s4TU1Wfu8IwoYuUT3npj9MywewgDGKlUVaCwZc/X4HWGUdI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728347335; c=relaxed/simple;
	bh=LT/XhgYb22qK9ydPHxbi/b2zZNVyfpt9vyecm1qaHpo=;
	h=Date:To:From:Subject:Message-Id; b=syQawI8j2YkF8qyPwCtQVgn62Q7l7jIPYyVUlqDVKGmwtzF2ljI5FPQrrMffmO3ZaFss4oHEH82MJlw7bZyUjMiyNV6vr3fBi3wBrSpZSSwTQPMo5T0jBBGKLK/2zHhKhh/7vGhJFXx1ZVl/FsGyMtAK9Logqf54BJe8mZ9mX9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qGpqHz+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qGpqHz+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B379C4CEC6;
	Tue,  8 Oct 2024 00:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728347334;
	bh=LT/XhgYb22qK9ydPHxbi/b2zZNVyfpt9vyecm1qaHpo=;
	h=Date:To:From:Subject:From;
	b=qGpqHz+uMwgmT8P+MVbFmAPgcezMhiHS2LWPrNKHlKpDadU5r+exLGiVxNVsFnN+D
	 sUOpjxMNT2Pn6NZwmp6vUn9T5wWG4CLXtbfl8vPqKzFG7tyBfHzeSbb/uBFcweY/7S
	 PVRE62IFNh22+6PloQJlb+Gfl3gvcrspjrT23/kI=
Date: Mon, 07 Oct 2024 17:28:53 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,oliver.sang@intel.com,cl@linux.com,dennis@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-fix-data-race-with-pcpu_nr_empty_pop_pages.patch added to mm-unstable branch
Message-Id: <20241008002854.7B379C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu: fix data race with pcpu_nr_empty_pop_pages
has been added to the -mm mm-unstable branch.  Its filename is
     percpu-fix-data-race-with-pcpu_nr_empty_pop_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-fix-data-race-with-pcpu_nr_empty_pop_pages.patch

This patch will later appear in the mm-unstable branch at
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
From: Dennis Zhou <dennis@kernel.org>
Subject: percpu: fix data race with pcpu_nr_empty_pop_pages
Date: Mon, 7 Oct 2024 17:19:42 -0700

Fixes the data race by moving the read to be behind the pcpu_lock. This
is okay because the code (initially) above it will not increase the
empty populated page count because it is populating backing pages that
already have allocations served out of them.

Link: https://lkml.kernel.org/r/20241008001942.8114-1-dennis@kernel.org
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202407191651.f24e499d-oliver.sang@intel.com
Signed-off-by: Dennis Zhou <dennis@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/percpu.c~percpu-fix-data-race-with-pcpu_nr_empty_pop_pages
+++ a/mm/percpu.c
@@ -1864,6 +1864,10 @@ restart:
 
 area_found:
 	pcpu_stats_area_alloc(chunk, size);
+
+	if (pcpu_nr_empty_pop_pages < PCPU_EMPTY_POP_PAGES_LOW)
+		pcpu_schedule_balance_work();
+
 	spin_unlock_irqrestore(&pcpu_lock, flags);
 
 	/* populate if not all pages are already there */
@@ -1891,9 +1895,6 @@ area_found:
 		mutex_unlock(&pcpu_alloc_mutex);
 	}
 
-	if (pcpu_nr_empty_pop_pages < PCPU_EMPTY_POP_PAGES_LOW)
-		pcpu_schedule_balance_work();
-
 	/* clear the areas and return address relative to base address */
 	for_each_possible_cpu(cpu)
 		memset((void *)pcpu_chunk_addr(chunk, cpu, 0) + off, 0, size);
_

Patches currently in -mm which might be from dennis@kernel.org are

percpu-fix-data-race-with-pcpu_nr_empty_pop_pages.patch

