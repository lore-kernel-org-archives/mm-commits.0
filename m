Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717C715E89;
	Sat,  3 Aug 2024 18:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722709024; cv=none; b=bawqSWJflN8zwRo5rqztWo8/GKI9uFGge3AFoq/MttlQFPWvtzApaWIFOvwsvanbssK3V5Kt/lO6dN7Uo9AXFbQ8dH+W/atNlZogOPRxmSm9UyrIWcwmib10xhLKVDltL6vkRyYLzrea+lSdJpVWw5zHQ/MSLLDiBnP0HuI0fK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722709024; c=relaxed/simple;
	bh=ZbP1XcN0ax1Cb5kQ38tJDDhPz7zzEmmpqlBnAVRPiMY=;
	h=Date:To:From:Subject:Message-Id; b=Xg1wI4Ddb8Bz4AbzXXXAfdHE2vW/oqZjMD9vErz6iCmjVsXNgkZojFyaofN4FpPjjvVLgJo4mevKfI2+EUDIPnMRhoy+WYFC4kILeeWNZ9UEjNdAHmx3mw2mlYsUWee3r2lLokaTRP2W4jBCj3IcQT7IfGn884vq08TEoP+7spA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ig6wEoAB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ig6wEoAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FAFC116B1;
	Sat,  3 Aug 2024 18:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722709023;
	bh=ZbP1XcN0ax1Cb5kQ38tJDDhPz7zzEmmpqlBnAVRPiMY=;
	h=Date:To:From:Subject:From;
	b=Ig6wEoAB1J53TR/4I78319z/s9ZM/baYwfsAV9g8Dl11p9rsWtHMHyf8PSjWk2kpT
	 zuVm+53jZEO2Qoxl5z5bUlL3Wsei7sQNHbSLa12CWOi0IR9JpKe+4foNTOCZrGp1BD
	 ijeAKsAcm4aF2Jn+mE8RPUP/aECLZnlkH6lu1uDU=
Date: Sat, 03 Aug 2024 11:17:03 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mcgrof@kernel.org,mark.rutland@arm.com,linux@armlinux.org.uk,linus.walleij@linaro.org,kees@kernel.org,alex@ghiti.fr,davidgow@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-only-enforce-minimum-stack-gap-size-if-its-sensible.patch added to mm-unstable branch
Message-Id: <20240803181703.C7FAFC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: only enforce minimum stack gap size if it's sensible
has been added to the -mm mm-unstable branch.  Its filename is
     mm-only-enforce-minimum-stack-gap-size-if-its-sensible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-only-enforce-minimum-stack-gap-size-if-its-sensible.patch

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
From: David Gow <davidgow@google.com>
Subject: mm: only enforce minimum stack gap size if it's sensible
Date: Sat, 3 Aug 2024 15:46:41 +0800

The generic mmap_base code tries to leave a gap between the top of the
stack and the mmap base address, but enforces a minimum gap size (MIN_GAP)
of 128MB, which is too large on some setups.  In particular, on arm tasks
without ADDR_LIMIT_32BIT, the STACK_TOP value is less than 128MB, so it's
impossible to fit such a gap in.

Only enforce this minimum if MIN_GAP < MAX_GAP, as we'd prefer to honour
MAX_GAP, which is defined proportionally, so scales better and always
leaves us with both _some_ stack space and some room for mmap.

This fixes the usercopy KUnit test suite on 32-bit arm, as it doesn't set
any personality flags so gets the default (in this case 26-bit) task size.
This test can be run with: ./tools/testing/kunit/kunit.py run --arch arm
usercopy --make_options LLVM=1

Link: https://lkml.kernel.org/r/20240803074642.1849623-2-davidgow@google.com
Fixes: dba79c3df4a2 ("arm: use generic mmap top-down layout and brk randomization")
Signed-off-by: David Gow <davidgow@google.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Kees Cook <kees@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/util.c~mm-only-enforce-minimum-stack-gap-size-if-its-sensible
+++ a/mm/util.c
@@ -463,7 +463,7 @@ static unsigned long mmap_base(unsigned
 	if (gap + pad > gap)
 		gap += pad;
 
-	if (gap < MIN_GAP)
+	if (gap < MIN_GAP && MIN_GAP < MAX_GAP)
 		gap = MIN_GAP;
 	else if (gap > MAX_GAP)
 		gap = MAX_GAP;
_

Patches currently in -mm which might be from davidgow@google.com are

mm-only-enforce-minimum-stack-gap-size-if-its-sensible.patch

