Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC89219596F
	for <mm-commits@vger.kernel.org>; Wed, 10 Jul 2024 18:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720637972; cv=none; b=u+A8tPrwagyDSoceCL3t4jrrZVHb+/9eT8zHrWJkRKa90Xli2rwnykXwc2hptD4PfDlg8rtyUv5UPx7YXtde9EkwBEfKf6RbPmG7mnseFDaB6VIRvQ7gmz8+IvdhX7JjKhoVpul5d6FWM/UHS8BEZg55s45aJEjSTlp/bUSF/wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720637972; c=relaxed/simple;
	bh=p2mQ29IXOIju9mJLIvBX5o322vYOyX6tExcHOGHGbQ0=;
	h=Date:To:From:Subject:Message-Id; b=c67g9zQ2OPQLYVwERe829Bv3el8rVIDtrNrWt6I7/IA7xbX8xEL9/JzV/KvYSqVXRaz8XNZgU/gd6jMZQMN0y02NvPiVozywRmnqlWz273LO8PfNkVcfc2JtwOk2mquXyy2Ste1JT26hWAfzZv5q5XDEEHxgFuzL89nZWI4MPpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lNFy6yzj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lNFy6yzj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F9DC32781;
	Wed, 10 Jul 2024 18:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720637971;
	bh=p2mQ29IXOIju9mJLIvBX5o322vYOyX6tExcHOGHGbQ0=;
	h=Date:To:From:Subject:From;
	b=lNFy6yzjGIouqSQl0c1cj/K5dj9jcxMpijNjPMVALku3FGRiBdOJKfDkDImtmXYMu
	 GXGFhpMjuL5Z1bV5HUvtEh++4XeoCaJ6JlywdH/KxX8oKFFrPX5J3vjUt1fCkTKmGW
	 5g0W0+Q+KlsGeV90WA9XDa/ww+zQtvfkMHaMqXzA=
Date: Wed, 10 Jul 2024 11:59:30 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,masahiroy@kernel.org,sfr@canb.auug.org.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-modpost-conditionally-check-section-mismatch-to-__meminit-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20240710185931.88F9DC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init-modpost-conditionally-check-section-mismatch-to-__meminit-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-modpost-conditionally-check-section-mismatch-to-__meminit-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-modpost-conditionally-check-section-mismatch-to-__meminit-fix.patch

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
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: init-modpost-conditionally-check-section-mismatch-to-__meminit-fix
Date: Wed, 10 Jul 2024 09:28:02 +1000

remove MEM_KEEP from arch/powerpc/kernel/vmlinux.lds.S

Link: https://lkml.kernel.org/r/20240710093213.2aefb25f@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/vmlinux.lds.S |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/powerpc/kernel/vmlinux.lds.S~init-modpost-conditionally-check-section-mismatch-to-__meminit-fix
+++ a/arch/powerpc/kernel/vmlinux.lds.S
@@ -123,8 +123,6 @@ SECTIONS
 		 */
 		*(.sfpr);
 		*(.text.asan.* .text.tsan.*)
-		MEM_KEEP(init.text)
-		MEM_KEEP(exit.text)
 	} :text
 
 	. = ALIGN(PAGE_SIZE);
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

init-modpost-conditionally-check-section-mismatch-to-__meminit-fix.patch

