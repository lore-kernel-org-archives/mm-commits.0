Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD0A1876
	for <mm-commits@vger.kernel.org>; Thu, 25 Jul 2024 19:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721937149; cv=none; b=E6pVRxbOre0MkHZZLVsLka2eAlXT1riFvmsU5VhkVgkUzrpfYsAtYd6EhPJimIxUXYN8JHyDF3ZdXWBWPsfPhmtz5sHNKxituAcEZPNtWkAqvWlntpl3Doxq50mvCI1K1M5Ahol3DV/yToA3eHC4xZbadfJ3dVSQrT+4LCg3w/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721937149; c=relaxed/simple;
	bh=FqQHkQUAkxaOPI8h42a3jDSwDrd5TubMiiEheVciw1g=;
	h=Date:To:From:Subject:Message-Id; b=rV/CuLe8MQt+Y+1V4bVppiqQ/KWHuNRj9Uei7nXbMrH/oDhAtQAfcqvaxVrLmAWJrgo4Xl9MCxHcwQLNJR+6K4Z2futHSUng5IFj/06aZMq4HDYbaLB2uhRXtw9N6end5Q53raI7t+kjYKXUYRQeuOBjvIcO0NcxMo9N/8kTZKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jU10FxXs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jU10FxXs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AECC116B1;
	Thu, 25 Jul 2024 19:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721937149;
	bh=FqQHkQUAkxaOPI8h42a3jDSwDrd5TubMiiEheVciw1g=;
	h=Date:To:From:Subject:From;
	b=jU10FxXsgcF/xzwdvlWHLuEc65mx4VLU45qx/kKLrFJv3F/sew0wxSycv6NDsN5Kk
	 UySnmvqWLiAIAj4clrNJMxobj0H1afqQs6Y+Dp/J0HhOmHAwP1fhO00tc7O/o8zVRq
	 O1W1xCv5m6LMU7VAPSLoaeAaOfkGSpFabgg/Duc0=
Date: Thu, 25 Jul 2024 12:52:28 -0700
To: mm-commits@vger.kernel.org,dakr@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-implement-vrealloc-fix.patch added to mm-unstable branch
Message-Id: <20240725195229.08AECC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vrealloc: fix missing nommu implementation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-implement-vrealloc-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-implement-vrealloc-fix.patch

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
From: Danilo Krummrich <dakr@kernel.org>
Subject: mm: vrealloc: fix missing nommu implementation
Date: Thu, 25 Jul 2024 16:11:59 +0200

Commit 5ec6d992f460 ("mm: vmalloc: implement vrealloc()") introduces
vrealloc(), but lacks the implementation of the nommu version of this
function.

Note that currently nommu isn't actually broken without this.  The only
user, kvrealloc(), never actually calls into vrealloc() with nommu, since
it's guarded by is_vmalloc_addr(), which for nommu always returns false.

However, since this becomes a real issue once vrealloc() is used by other
code, fix this.

Link: https://lkml.kernel.org/r/20240725141227.13954-1-dakr@kernel.org
Fixes: 5ec6d992f460 ("mm: vmalloc: implement vrealloc()")
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/nommu.c~mm-vmalloc-implement-vrealloc-fix
+++ a/mm/nommu.c
@@ -126,6 +126,11 @@ void *__vmalloc_noprof(unsigned long siz
 }
 EXPORT_SYMBOL(__vmalloc_noprof);
 
+void *vrealloc_noprof(const void *p, size_t size, gfp_t flags)
+{
+	return krealloc_noprof(p, size, (flags | __GFP_COMP) & ~__GFP_HIGHMEM);
+}
+
 void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 		unsigned long start, unsigned long end, gfp_t gfp_mask,
 		pgprot_t prot, unsigned long vm_flags, int node,
_

Patches currently in -mm which might be from dakr@kernel.org are

mm-vmalloc-implement-vrealloc.patch
mm-vmalloc-implement-vrealloc-fix.patch
mm-kvmalloc-align-kvrealloc-with-krealloc.patch

