Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C128B215191
	for <mm-commits@vger.kernel.org>; Thu,  1 May 2025 19:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746126718; cv=none; b=Zj6TGC643HGU24wvDg1YY336CSEo3hK9WWNI17r9a9MrosNrigXGm0b7EkzkkQ2B84CpvRvvCE9532v6vCkyK+O0klSk0qg/x/78F02ZfxNW5Mh2mtvyOkmff+jRtlKAiHw8EB9778GNwkQeZgVo8rcltJPMKoz6kDI0Ug9hgtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746126718; c=relaxed/simple;
	bh=xpHXHRPX2HEs5pxMRLv0umS87QdlwiSWuFFnPMaaejg=;
	h=Date:To:From:Subject:Message-Id; b=h95ZBt/qSu6bhGW5b7fekm4F/7VZlrOZWxTM0sIzTkJNKt1Y4kW3TXyz880GlLGXOu3BuBzrwFT+vYe8vXvmp1fnLLMXw5LrMBzLazAI1+rqpqoo3vFFthDumqXfkoh6YnUAjFHH3eG+KHPiQdeL6MsVA8PgaaQ4c5RLCFq+qgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Neenk4Dp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Neenk4Dp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F26AC4CEE3;
	Thu,  1 May 2025 19:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746126718;
	bh=xpHXHRPX2HEs5pxMRLv0umS87QdlwiSWuFFnPMaaejg=;
	h=Date:To:From:Subject:From;
	b=Neenk4DpotQm65Yk+L0E/3NPPdRHDiHy7WpoaejvfGPoDck10+NeYYmlS/f0uyXja
	 hvTnTnQWqTf+zhUzmnVSRkGHTEg9GCEa9ncZnDzJdZgn3VJwxswSVwaSKQFvdpGiUu
	 Vsl7+pG5MxaKS5y4UgTnosDhHkKPagJkDn96RAVQ=
Date: Thu, 01 May 2025 12:11:58 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,catalin.marinas@arm.com,luizcap@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-mark-variables-as-__read_mostly.patch added to mm-unstable branch
Message-Id: <20250501191158.1F26AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kmemleak: mark variables as __read_mostly
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmemleak-mark-variables-as-__read_mostly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-mark-variables-as-__read_mostly.patch

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
From: Luiz Capitulino <luizcap@redhat.com>
Subject: mm: kmemleak: mark variables as __read_mostly
Date: Wed, 30 Apr 2025 16:59:47 -0400

The variables kmemleak_enabled and kmemleak_free_enabled are read in the
kmemleak alloc and free path respectively, but are only written to if/when
kmemleak is disabled.

Link: https://lkml.kernel.org/r/4016090e857e8c4c2ade4b20df312f7f38325c15.1746046744.git.luizcap@redhat.com
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-mark-variables-as-__read_mostly
+++ a/mm/kmemleak.c
@@ -210,9 +210,9 @@ static struct kmem_cache *object_cache;
 static struct kmem_cache *scan_area_cache;
 
 /* set if tracing memory operations is enabled */
-static int kmemleak_enabled = 1;
+static int kmemleak_enabled __read_mostly = 1;
 /* same as above but only for the kmemleak_free() callback */
-static int kmemleak_free_enabled = 1;
+static int kmemleak_free_enabled __read_mostly = 1;
 /* set in the late_initcall if there were no errors */
 static int kmemleak_late_initialized;
 /* set if a fatal kmemleak error has occurred */
_

Patches currently in -mm which might be from luizcap@redhat.com are

mm-kmemleak-drop-kmemleak_warning-variable.patch
mm-kmemleak-drop-wrong-comment.patch
mm-kmemleak-mark-variables-as-__read_mostly.patch

