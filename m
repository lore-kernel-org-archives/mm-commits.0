Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998D056741
	for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2024 19:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710789268; cv=none; b=cTRkeazEYr3oQNxWBjUBSPGrvsIx4EDiMI4sv2xNxXB0z9pLROhmBglsUyqJpd+cstzi9aYDhbG8Gp6fVWKFxyNChMp60I8aRBAQczOwdEAGZ084kjiPu4ATmJfWt6Kr5kVGLW3qah3tMUeaCtJoEC11bcEtUx3KT47I0EBFOaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710789268; c=relaxed/simple;
	bh=F62eVLQsPoy5mNt6AOAFUV1D2PqkDnLdH3Ml6n7VKqM=;
	h=Date:To:From:Subject:Message-Id; b=YsVp977Rwr0tG2LC57FWiLYk9jcTvBYMDOcY0SlbY2tnannzrBgsLbuPTu6fjEZ93K32k5CLRA11FkwGa1TkwvDsASlDXEv9DF4BNW0pyIFitDsa0KtfjtLsnFwQ9IHRiYbnfdHbjc3xCjKLfyyhIMuEOAt+Khp2qEHekfVI4vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AfXTE4tA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AfXTE4tA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20985C433C7;
	Mon, 18 Mar 2024 19:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710789268;
	bh=F62eVLQsPoy5mNt6AOAFUV1D2PqkDnLdH3Ml6n7VKqM=;
	h=Date:To:From:Subject:From;
	b=AfXTE4tATEWsKtsmMW4lrsu95QMF4aTRz6sdEm//gEozPXwoE31H8iiyKEaktEsd6
	 6NsgrD23JuIZV6U0cT/34QA/DjB2WjyUBTxFrEfSFa183/+hD2WMx3UI3ZQwpIacPn
	 +BdRJgsNZHij4ktC8h5BQxDOOhGua/sxSOL6bf7c=
Date: Mon, 18 Mar 2024 12:14:27 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-guard-around-pgd_offset_k-macro.patch added to mm-unstable branch
Message-Id: <20240318191428.20985C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove guard around pgd_offset_k() macro
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-guard-around-pgd_offset_k-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-guard-around-pgd_offset_k-macro.patch

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
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm: remove guard around pgd_offset_k() macro
Date: Sat, 16 Mar 2024 12:52:41 +0100

The last architecture redefining pgd_offset_k() was IA64 and it was
removed by commit cf8e8658100d ("arch: Remove Itanium (IA-64)
architecture")

There is no need anymore to guard generic version of pgd_offset_k()
with #ifndef pgd_offset_k

Link: https://lkml.kernel.org/r/59d3f47d5615d18cca1986f269be2fcb3df34556.1710589838.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/pgtable.h~mm-remove-guard-around-pgd_offset_k-macro
+++ a/include/linux/pgtable.h
@@ -149,9 +149,7 @@ static inline pgd_t *pgd_offset_pgd(pgd_
  * a shortcut which implies the use of the kernel's pgd, instead
  * of a process's
  */
-#ifndef pgd_offset_k
 #define pgd_offset_k(address)		pgd_offset(&init_mm, (address))
-#endif
 
 /*
  * In many cases it is known that a virtual address is mapped at PMD or PTE
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-remove-guard-around-pgd_offset_k-macro.patch

