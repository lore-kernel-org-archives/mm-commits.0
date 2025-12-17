Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3D130B509
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 20:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766004302; cv=none; b=opM4H75PXA5cWRDqbXACqVsS2+s/nxz/go10E1LhfUNnz1AIlGuBGPyzbIgm734XeJ/jp5Q1ROzWrBIq4ANbZElFPhocKdv391qgMtE/BnWtaXrGMbEnG2DnSNlQD9GRm5wfUX+6/ArCU5zp/rL2I02YYfu+D/n4hYkD8ElK94M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766004302; c=relaxed/simple;
	bh=FCs2EXzvT4mkcgJvJc4GSOzxWtne48pOZ7Q3qov+gi0=;
	h=Date:To:From:Subject:Message-Id; b=uPvPJBvx3FO4qA9gCL7BKBCw2cioVsTVXQJiGNEe5T83y1/6sJvtNxu0g8eaoyh37z1buAMvaKJv3I1CYNuWsiH15DnopKuUlECr4UWUR3iLvoSJna2qAT4jRvzE9EUWecDWYpWwd960ll9T9fmq1nb/JMFqlFz3zmOvme1V9x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K02RIYHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K02RIYHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABE8C4CEF5;
	Wed, 17 Dec 2025 20:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766004301;
	bh=FCs2EXzvT4mkcgJvJc4GSOzxWtne48pOZ7Q3qov+gi0=;
	h=Date:To:From:Subject:From;
	b=K02RIYHowkqIx6/HasDIrnIz52ysFnMHmdW1tsa0J0VGQzNaQnKaR2MeY6ydYohv9
	 VcN0DHfkjmX9xpc/XpGiW/+QDNvmYyT0pWxvEU+EKD1f2p4/u1x5qtKDarnvNYbbvA
	 thxgR7GkpikXVhTHYZ0WoPK3zXjuOCSEZwpIJ2L0=
Date: Wed, 17 Dec 2025 12:45:01 -0800
To: mm-commits@vger.kernel.org,sakamo.ryota@gmail.com,geert@linux-m68k.org,davidgow@google.com,brendan.higgins@linux.dev,andriy.shevchenko@linux.intel.com,lukas.bulwahn@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-tests-convert-test_uuid-module-to-kunit-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20251217204501.CABE8C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: adjust file entry in UUID HELPERS
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-tests-convert-test_uuid-module-to-kunit-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-tests-convert-test_uuid-module-to-kunit-fix.patch

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
From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: MAINTAINERS: adjust file entry in UUID HELPERS
Date: Wed, 17 Dec 2025 06:39:07 +0100

Commit e61d3add3e7f ("lib/tests: convert test_uuid module to KUnit") moves
lib/test_uuid.c to lib/tests/uuid_kunit.c, but misses to adjust the file
entry in the MAINTAINERS section UUID HELPERS.

Adjust the file entry in that section after this file movement.

Link: https://lkml.kernel.org/r/20251217053907.2778515-1-lukas.bulwahn@redhat.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Acked-by: David Gow <davidgow@google.com>
Acked-by: Ryota Sakamoto <sakamo.ryota@gmail.com>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~lib-tests-convert-test_uuid-module-to-kunit-fix
+++ a/MAINTAINERS
@@ -27245,7 +27245,7 @@ R:	Andy Shevchenko <andriy.shevchenko@li
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	include/linux/uuid.h
-F:	lib/test_uuid.c
+F:	lib/tests/uuid_kunit.c
 F:	lib/uuid.c
 
 UV SYSFS DRIVER
_

Patches currently in -mm which might be from lukas.bulwahn@redhat.com are

lib-tests-convert-test_uuid-module-to-kunit-fix.patch

