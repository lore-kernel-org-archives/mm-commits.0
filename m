Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3106CEEA8
	for <mm-commits@vger.kernel.org>; Tue, 20 May 2025 00:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747699479; cv=none; b=CfX+UzNe2oAHSZ3Tmca9OVLZIEsxoSLZmUyvJazVeVRUqA3pgY8wNwIpTaR8a/D5LUBmBIoPXXvHELbSEt1itpZatCAXK8eyUn7Z8DJen/Lb2izL7WQb5hL8H9cxqyzF2ETd0zDz070GwF7OUaYMLuFq5lzNbpuVgb0+ZAu4mUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747699479; c=relaxed/simple;
	bh=eh7s5oAvqdPyFH4jnSBv+v30Z3IS2CQ5q6dacX36Wak=;
	h=Date:To:From:Subject:Message-Id; b=fGpQDld7hPMd9J+CdiUzN8mrUp94FUDL5P6s33YE328LY6ksC/XP9EaZSDghqr78iMA3fcSutL3INPxVcXcQoakvGPtayCB+mRezrVAYG3Av45u2ElZ7XHSjIj0cAxgm1yZfej49+vCo4UOacAWwQ4lPS8hlC5V4XU+1YpL+rEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pxCyeRI4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pxCyeRI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7594AC4CEE4;
	Tue, 20 May 2025 00:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747699478;
	bh=eh7s5oAvqdPyFH4jnSBv+v30Z3IS2CQ5q6dacX36Wak=;
	h=Date:To:From:Subject:From;
	b=pxCyeRI4pA9su5YX0GixD40wZD8iuT0H9ToC1DlEyxsdIBcmTDjMN2MlewTmH0YIt
	 WJmoxYKueG9Osk46kf6ke33YQzH2RPM5K1Iv5nJk8iAuRROl56TZ49Goxu04qHzg/s
	 358ks8zbsn65/9QV7b6PIEGsHJ/4A6HHcVxSNvPY=
Date: Mon, 19 May 2025 17:04:37 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,shung-hsi.yu@suse.com,pawan.kumar.gupta@linux.intel.com,erhard_f@mailbox.org,eddyz87@gmail.com,dakr@kernel.org,kees@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-only-zero-init-on-vrealloc-shrink.patch added to mm-hotfixes-unstable branch
Message-Id: <20250520000438.7594AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmalloc: only zero-init on vrealloc shrink
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmalloc-only-zero-init-on-vrealloc-shrink.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-only-zero-init-on-vrealloc-shrink.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Kees Cook <kees@kernel.org>
Subject: mm: vmalloc: only zero-init on vrealloc shrink
Date: Thu, 15 May 2025 14:42:16 -0700

The common case is to grow reallocations, and since init_on_alloc will
have already zeroed the whole allocation, we only need to zero when
shrinking the allocation.

Link: https://lkml.kernel.org/r/20250515214217.619685-2-kees@kernel.org
Fixes: a0309faf1cb0 ("mm: vmalloc: support more granular vrealloc() sizing")
Signed-off-by: Kees Cook <kees@kernel.org>
Tested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: "Erhard F." <erhard_f@mailbox.org>
Cc: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-only-zero-init-on-vrealloc-shrink
+++ a/mm/vmalloc.c
@@ -4093,8 +4093,8 @@ void *vrealloc_noprof(const void *p, siz
 	 * would be a good heuristic for when to shrink the vm_area?
 	 */
 	if (size <= old_size) {
-		/* Zero out "freed" memory. */
-		if (want_init_on_free())
+		/* Zero out "freed" memory, potentially for future realloc. */
+		if (want_init_on_free() || want_init_on_alloc(flags))
 			memset((void *)p + size, 0, old_size - size);
 		vm->requested_size = size;
 		kasan_poison_vmalloc(p + size, old_size - size);
@@ -4107,9 +4107,11 @@ void *vrealloc_noprof(const void *p, siz
 	if (size <= alloced_size) {
 		kasan_unpoison_vmalloc(p + old_size, size - old_size,
 				       KASAN_VMALLOC_PROT_NORMAL);
-		/* Zero out "alloced" memory. */
-		if (want_init_on_alloc(flags))
-			memset((void *)p + old_size, 0, size - old_size);
+		/*
+		 * No need to zero memory here, as unused memory will have
+		 * already been zeroed at initial allocation time or during
+		 * realloc shrink time.
+		 */
 		vm->requested_size = size;
 		return (void *)p;
 	}
_

Patches currently in -mm which might be from kees@kernel.org are

mm-vmalloc-actually-use-the-in-place-vrealloc-region.patch
mm-vmalloc-only-zero-init-on-vrealloc-shrink.patch

