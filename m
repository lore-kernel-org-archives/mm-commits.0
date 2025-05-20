Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACBF182BC
	for <mm-commits@vger.kernel.org>; Tue, 20 May 2025 00:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747699477; cv=none; b=RlYEsyvg1YBxF4nKlJimS/BWcnNFwECSwTc+u4bnU/XdS7eCTi1B2riBSBJNd0MuymjH9DPYIqEBxc+5+BWDlEUNq12VFgmnM3al3VwxeIOn9LinWVxrQcWzFTfUH4U9pZptYrFXF4jE7VfBf9sQeKnRTAyFmmPF7AGPZNoOBfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747699477; c=relaxed/simple;
	bh=pVmnVGkKBA3WDrAOCutTDN8dEwxFlU5/VsgHXFaAz2I=;
	h=Date:To:From:Subject:Message-Id; b=P2RPtVrTvFni5bYytIntMuH2tWd2aAVSONM1KyPoCK8paV64jed2IqqFozBp5F5OhwTZLh4qmZDccuVYSzHzlOI6yk53mCSK/W+TyMs5HePv98ASPI3CD0bnitQi6TdJwga/8/n8wj1qwPqfcC2t8u/zFURrEAssVHsZV/dy9a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dFpHLV9q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dFpHLV9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0C4C4CEE4;
	Tue, 20 May 2025 00:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747699476;
	bh=pVmnVGkKBA3WDrAOCutTDN8dEwxFlU5/VsgHXFaAz2I=;
	h=Date:To:From:Subject:From;
	b=dFpHLV9qbSZrw/mAN2OyUOTP8hupOB9xLEaZgOH/7/+4JO4IxNldDWP5hwKMaXid/
	 8g7hDGvI+Ud3H68q02pBIJeoxv4px9bKQxncQsf1fxMaYGUFBgiZkJTfum3BiWrqFw
	 OLoyu8t0/aXbCpUyI0vo2lj/3zQ3SQGmNG7eS/h4=
Date: Mon, 19 May 2025 17:04:35 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,shung-hsi.yu@suse.com,pawan.kumar.gupta@linux.intel.com,erhard_f@mailbox.org,eddyz87@gmail.com,dakr@kernel.org,kees@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-actually-use-the-in-place-vrealloc-region.patch added to mm-hotfixes-unstable branch
Message-Id: <20250520000436.7D0C4C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmalloc: actually use the in-place vrealloc region
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmalloc-actually-use-the-in-place-vrealloc-region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-actually-use-the-in-place-vrealloc-region.patch

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
Subject: mm: vmalloc: actually use the in-place vrealloc region
Date: Thu, 15 May 2025 14:42:15 -0700

Patch series "mm: vmalloc: Actually use the in-place vrealloc region".

This fixes a performance regression[1] with vrealloc()[1].


The refactoring to not build a new vmalloc region only actually worked
when shrinking.  Actually return the resized area when it grows.  Ugh.

Link: https://lkml.kernel.org/r/20250515214217.619685-1-kees@kernel.org
Fixes: a0309faf1cb0 ("mm: vmalloc: support more granular vrealloc() sizing")
Signed-off-by: Kees Cook <kees@kernel.org>
Reported-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Closes: https://lore.kernel.org/all/20250515-bpf-verifier-slowdown-vwo2meju4cgp2su5ckj@6gi6ssxbnfqg [1]
Tested-by: Eduard Zingerman <eddyz87@gmail.com>
Tested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Cc: "Erhard F." <erhard_f@mailbox.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmalloc.c~mm-vmalloc-actually-use-the-in-place-vrealloc-region
+++ a/mm/vmalloc.c
@@ -4111,6 +4111,7 @@ void *vrealloc_noprof(const void *p, siz
 		if (want_init_on_alloc(flags))
 			memset((void *)p + old_size, 0, size - old_size);
 		vm->requested_size = size;
+		return (void *)p;
 	}
 
 	/* TODO: Grow the vm_area, i.e. allocate and map additional pages. */
_

Patches currently in -mm which might be from kees@kernel.org are

mm-vmalloc-actually-use-the-in-place-vrealloc-region.patch
mm-vmalloc-only-zero-init-on-vrealloc-shrink.patch

