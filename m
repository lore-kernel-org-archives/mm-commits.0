Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3125263CB
	for <mm-commits@vger.kernel.org>; Sat, 30 Mar 2024 03:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711770734; cv=none; b=PB4Q7RpzraJ3uswuwOO+an6mwgkADUQ4XMfQRgVNee+z1e2dTUKlSpTpq1ideALFtF7emAeeLBmiIlgSh/79jftCuvQxsbbwcyaIn/Ab3aZfPFk3J3ook8UVexxfz/ZMmncHw1fk5cqcGiBsMJqPk4LZkVWhRB2z5+YoG0CkBs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711770734; c=relaxed/simple;
	bh=NaTAlKLwzcikRxvTxtYbEmQtbfRxPkaCSPgdM9JxfDU=;
	h=Date:To:From:Subject:Message-Id; b=k5brK5zxtBOYvQKNLlBNUUoI9aAewhIfkbj4XSxetQVhatsBGvu0elo0G2XVf0Rt9+fyfKlIVP2rue9qhzHPkzANJYbN+1wp4QffOCcygfQgjXhvf+N/31PZ0zwwcpwEQQzsyeYnxPwm2EZwLkFz4zeVRMtPpZjXnmXNS77vPjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H6A0erxe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H6A0erxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8642C433F1;
	Sat, 30 Mar 2024 03:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711770733;
	bh=NaTAlKLwzcikRxvTxtYbEmQtbfRxPkaCSPgdM9JxfDU=;
	h=Date:To:From:Subject:From;
	b=H6A0erxee4tNmih/HH5p5boWnMTXwz60IrIqPVBGZ8bTfgLiJspn8K/3fAef4xFhK
	 7SZWc7xgcY1H/lXaaLRq9Jon+flC8uWVJi03bG3f/G7FGwG4XjsC9d/x0db5qE1dxE
	 ND2unkwRoY9bkFAmXbYY6JO5HSAabETk7aUaIRqo=
Date: Fri, 29 Mar 2024 20:52:13 -0700
To: mm-commits@vger.kernel.org,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,justinstitt@google.com,dvyukov@google.com,andreyknvl@gmail.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-avoid-clang-out-of-range-warning.patch added to mm-nonmm-unstable branch
Message-Id: <20240330035213.B8642C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kcov: avoid clang out-of-range warning
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kcov-avoid-clang-out-of-range-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcov-avoid-clang-out-of-range-warning.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: kcov: avoid clang out-of-range warning
Date: Thu, 28 Mar 2024 15:30:42 +0100

The area_size is never larger than the maximum on 64-bit architectutes:

kernel/kcov.c:634:29: error: result of comparison of constant 1152921504606846975 with expression of type '__u32' (aka 'unsigned int') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
                if (remote_arg->area_size > LONG_MAX / sizeof(unsigned long))
                    ~~~~~~~~~~~~~~~~~~~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The compiler can correctly optimize the check away and the code appears
correct to me, so just add a cast to avoid the warning.

Link: https://lkml.kernel.org/r/20240328143051.1069575-5-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/kcov.c~kcov-avoid-clang-out-of-range-warning
+++ a/kernel/kcov.c
@@ -627,7 +627,8 @@ static int kcov_ioctl_locked(struct kcov
 		mode = kcov_get_mode(remote_arg->trace_mode);
 		if (mode < 0)
 			return mode;
-		if (remote_arg->area_size > LONG_MAX / sizeof(unsigned long))
+		if ((unsigned long)remote_arg->area_size >
+		    LONG_MAX / sizeof(unsigned long))
 			return -EINVAL;
 		kcov->mode = mode;
 		t->kcov = kcov;
_

Patches currently in -mm which might be from arnd@arndb.de are

nilfs2-fix-out-of-range-warning.patch
kcov-avoid-clang-out-of-range-warning.patch

