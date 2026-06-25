Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE12212564
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 04:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782360328; cv=none; b=QPr1vYoEIML8/HT/pWahNqr4RkrdRF6hXXduu0u0K4tS2DJyfw3EKEQX7TiJSmy7nzcQGfpxQNjOAqe5LtRzlYuofVrU47Y9BEpyn/WxIVURd6gViguZcY2CfGdYaHZwBKdM2Wj2bJAXjBcDBU14Ka2plnNXpxAn2DwSE+vYU0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782360328; c=relaxed/simple;
	bh=RhFTzL5N9BXcbwVU9p8ctYQFFyebDF+pdxB1Q7II7jY=;
	h=Date:To:From:Subject:Message-Id; b=uaYJ7lry6U3e7tBQxqM4jS8oRZH+VfyXbq+6om/SjRlMX1TmG3WRndRKEj4PWMeuqPUMJWaIg3AFEqUPp4fwOI5sPZadm1ouIunlVPvy5kjEqouDl7/rm6RhK0hpkoVDJ/Wzfz+AlD3mUj0W9Z7TxOWQMQvDKk1PmnQwmEvuW/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DSLENN4M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DSLENN4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611741F000E9;
	Thu, 25 Jun 2026 04:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782360327;
	bh=NRdh5epv9/E8PSUBIaqWIsDUqkoPxAvVnbyV33fIOzY=;
	h=Date:To:From:Subject;
	b=DSLENN4MCRJx7czoKrNQhNF3hZv+fc0eWPU238WV/idUXJxFpMT0n4VV8HXRxBZZQ
	 S+lRUDleN9eZeLljStC5QzYmIS1v7hlIM+b5kSqHpLubhoC8VJ+EC3YwVV+dPugk/o
	 vpBqQdaoyuTKf2w5Wty5OCFmf34KmDbpVPxfAT3M=
Date: Wed, 24 Jun 2026 21:05:26 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,glider@google.com,dvyukov@google.com,dja@axtens.net,elfring@users.sourceforge.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-use-more-common-error-handling-code-in-pcpu_get_vm_areas.patch added to mm-new branch
Message-Id: <20260625040527.611741F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: use more common error handling code in pcpu_get_vm_areas()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-use-more-common-error-handling-code-in-pcpu_get_vm_areas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-use-more-common-error-handling-code-in-pcpu_get_vm_areas.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: mm/vmalloc: use more common error handling code in pcpu_get_vm_areas()
Date: Tue, 16 Jun 2026 18:14:52 +0200

Use an existing label once more so that a bit of exception handling can be
better reused at the end of this function implementation.

This issue was detected by using the Coccinelle software.

Link: https://lore.kernel.org/453375c4-c3ca-4e6f-8880-0e6ff3c74ee3@web.de
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-more-common-error-handling-code-in-pcpu_get_vm_areas
+++ a/mm/vmalloc.c
@@ -5348,9 +5348,7 @@ err_free_shadow:
 		kfree(vms[area]);
 	}
 	spin_unlock(&free_vmap_area_lock);
-	kfree(vas);
-	kfree(vms);
-	return NULL;
+	goto err_free2;
 }
 
 /**
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are

mm-vmalloc-use-more-common-error-handling-code-in-pcpu_get_vm_areas.patch

