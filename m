Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DEF431E64;
	Wed,  1 Jul 2026 22:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782945989; cv=none; b=b02kOSp97HJjlrX/e4Kdz4bkGKSB5Tv9lbBFhgWvLHA1mmN5XllRiJnatTM1MB8t8HWJUVQylDo9N1aodNK5wZp5Md1M/kWRPpzLtDaePcwmQypFNjStoPcvd+0rN0EIwe3XnaNmPyITY/fWFzSfodFgp1Q20lPQBDzKc4t27oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782945989; c=relaxed/simple;
	bh=4BQJ6/La1Zi2CpPURsblT4GCBiuiaNq4adJS1fpqD7I=;
	h=Date:To:From:Subject:Message-Id; b=dM9P3p0XOffh/4PIXYD0ZuxQ5I5JZ4LD2MdoEAE1sgbY2HvaC6PoZnSAzwhYpspoobRk8pIsY60I+cJ9NUQFysV86WFrY7WAzjEsmR198dMUNN9rWNQsBTroAzgOuHo8hovFopRQWDdoprr1DsgGCWdozil5ogjHITZN3fGurQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i18iBZCM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i18iBZCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07E61F000E9;
	Wed,  1 Jul 2026 22:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782945988;
	bh=W6fw8oIYPIPzVJtISldNy1Ra4fPh7hv35nBAA7MOXeA=;
	h=Date:To:From:Subject;
	b=i18iBZCMsnU5FSyElcXjd7gJNcnOAmaznCriHLx9lOgagi/2LoYZQsPgGIC5T4r/8
	 nDT93b9ODG4SXu2k+UqSSaKafaxi5Nf6m7aVnGbY3InXTqqTiw8S2oUCWqLb1rk5wM
	 Qj17U+mVOSlGkybsPdwg9ciiAeZbYnx/cL486EbU=
Date: Wed, 01 Jul 2026 15:46:27 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,nathan@kernel.org,david.laight.linux@gmail.com,rkr0k0r@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-compiler-match-glibc-242-definition-of-__attribute_const__.patch added to mm-nonmm-unstable branch
Message-Id: <20260701224627.E07E61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/compiler: match glibc 2.42 definition of __attribute_const__
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tools-compiler-match-glibc-242-definition-of-__attribute_const__.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-compiler-match-glibc-242-definition-of-__attribute_const__.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Joy H.J. Lee" <rkr0k0r@gmail.com>
Subject: tools/compiler: match glibc 2.42 definition of __attribute_const__
Date: Thu, 2 Jul 2026 05:06:35 +0900

glibc 2.42 added __attribute_const__ to sys/cdefs.h:

    # define __attribute_const__ __attribute__ ((__const__))

GCC 15 warns when a macro is redefined to a different replacement list
(-Wbuiltin-macro-redefined). Since host tool Makefiles (resolve_btfids,
objtool) pass -Werror, this conflict becomes fatal.

The warning is suppressed on standard native builds because GCC treats
/usr/include as a system header path (-isystem), and macro-redefinition
warnings from system headers are silently suppressed by GCC. It fires
when glibc headers are on a regular include path (-I) instead, which
is the case in cross-compilation setups such as NixOS, where the
sysroot's glibc is passed explicitly via -I rather than -isystem.

Per (C11 6.10.3), identical replacement lists are accepted silently.
Match the glibc definition exactly, including the space before "((", so
the redefinition is accepted without warning regardless of whether
glibc headers are treated as system or non-system includes.

Link: https://lore.kernel.org/20260701200635.3992767-1-rkr0k0r@gmail.com
Signed-off-by: Joy H.J. Lee <rkr0k0r@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/linux/compiler.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/include/linux/compiler.h~tools-compiler-match-glibc-242-definition-of-__attribute_const__
+++ a/tools/include/linux/compiler.h
@@ -119,7 +119,7 @@
 #define __read_mostly
 
 #ifndef __attribute_const__
-# define __attribute_const__
+# define __attribute_const__ __attribute__ ((__const__))
 #endif
 
 #ifndef __maybe_unused
_

Patches currently in -mm which might be from rkr0k0r@gmail.com are

tools-compiler-match-glibc-242-definition-of-__attribute_const__.patch

