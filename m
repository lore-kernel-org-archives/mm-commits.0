Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044212F855
	for <mm-commits@vger.kernel.org>; Fri,  6 Dec 2024 01:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733447635; cv=none; b=hfTPiCPPg7kZjvO1q/F65c4+pkVy38b+onaebYsfIhzvdg47+VatDcZdnr9zzCbsK1rzb+vzmSmSp7ug/MkO5pPynpOLnSajRecZ5vTzVF7R5GmhPBnv2K84ygA7zuZifr9FrVIJY0ZMkT6+cwAQ8VCQBdMF2nlDZitJVKaMO/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733447635; c=relaxed/simple;
	bh=92tqxoLasY9evny2oS11NN10bcYWaVTW2XvxOILP6S8=;
	h=Date:To:From:Subject:Message-Id; b=kwoNXTaYrGwmVTOQBmZPZLAjEMEhHKIrJxkRWDMAUeZbmrPfPWiIFHIuwdaB5mFmpeMjH5rkJDPSDlm1Vk5NEpc6Wk7jsQenZ2N0FjWa8BimQwfh1VYv9vVGdOmYGHwT6vyF3kV5uSmR/KnmJCnDS3KrsCFSBCgeLws4dUt2/9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CUGBlG8Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CUGBlG8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74EC7C4CED1;
	Fri,  6 Dec 2024 01:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733447634;
	bh=92tqxoLasY9evny2oS11NN10bcYWaVTW2XvxOILP6S8=;
	h=Date:To:From:Subject:From;
	b=CUGBlG8ZlzXyYiGqmSuPB+mABJGbSm7vARo7uYcKE7yHhErDguJ3Am8VylleoNLjP
	 36ggHOvxd/D0+zkkcfYPmqmB2ATvWimm3fq1pkz6XtIxsRc8LdcRXGt9C2JEykuDhU
	 AHg3SMElBkM1hvhcDvzlKBzPLqTmFTO8iQvFe9V4=
Date: Thu, 05 Dec 2024 17:13:53 -0800
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,oleg@redhat.com,nicolas@fjasle.eu,nathan@kernel.org,masahiroy@kernel.org,lukas.bulwahn@gmail.com,linux@rasmusvillemoes.dk,joe@perches.com,dwaipayanray1@gmail.com,arnd@arndb.de,apw@canonical.com,geert+renesas@glider.be,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kbuild-drop-support-for-include-asm-arch-in-headers_checkpl.patch added to mm-nonmm-unstable branch
Message-Id: <20241206011354.74EC7C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kbuild: drop support for include/asm-<arch> in headers_check.pl
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kbuild-drop-support-for-include-asm-arch-in-headers_checkpl.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kbuild-drop-support-for-include-asm-arch-in-headers_checkpl.patch

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
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: kbuild: drop support for include/asm-<arch> in headers_check.pl
Date: Thu, 5 Dec 2024 14:20:43 +0100

"include/asm-<arch>" was replaced by "arch/<arch>/include/asm" a long time
ago.  All assembler header files are now included using "#include
<asm/*>", so there is no longer a need to rewrite paths.

Link: https://lkml.kernel.org/r/19fb5b49396239d28020015ba2640d77dacdb6c2.1733404444.git.geert+renesas@glider.be
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 usr/include/headers_check.pl |    4 ----
 1 file changed, 4 deletions(-)

--- a/usr/include/headers_check.pl~kbuild-drop-support-for-include-asm-arch-in-headers_checkpl
+++ a/usr/include/headers_check.pl
@@ -55,10 +55,6 @@ sub check_include
 		my $found;
 		$found = stat($dir . "/" . $inc);
 		if (!$found) {
-			$inc =~ s#asm/#asm-$arch/#;
-			$found = stat($dir . "/" . $inc);
-		}
-		if (!$found) {
 			printf STDERR "$filename:$lineno: included file '$inc' is not exported\n";
 			$ret = 1;
 		}
_

Patches currently in -mm which might be from geert+renesas@glider.be are

checkpatch-update-reference-to-include-asm-arch.patch
kbuild-drop-support-for-include-asm-arch-in-headers_checkpl.patch
include-update-references-to-include-asm-arch.patch

