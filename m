Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030EF54907;
	Mon,  2 Sep 2024 03:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247757; cv=none; b=lNpPAbJmJpoU5wHx2/fAoZKDO4Km7LTOeuk3mVfYNIFLGopWN8ayAWvXz+CaB08YCpHK4oAdu838yKU0SJ9e+rfLKHMD1JwxzhWLMavzBQUU4+3IXQboAp04OcHxvivbZWYnpxr23rD/vW4RbpxLUm4og/AevTkASFHDg/Cd3aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247757; c=relaxed/simple;
	bh=pz0WxglGqzLEjF1NmqqPccZlOy1fRvfLZ2ihSanfnPI=;
	h=Date:To:From:Subject:Message-Id; b=jJC6kpviibKLi5jd/MWIWIiSDc3Jb5jLz66Rhr/m5XBgLP/il1TvBJQ5PGzXAlxd0Ztw92Inr09BN+g/wK/T8GONpjfRJJEky6RPG6nVIap4JAEg7WLeNmOiWaOFISXEsL6Zsgk9pmrKgfsKc1XWmUFs7e6RjeToc5hHrFjCO/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rwoywP37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rwoywP37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D61C4CEC2;
	Mon,  2 Sep 2024 03:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247756;
	bh=pz0WxglGqzLEjF1NmqqPccZlOy1fRvfLZ2ihSanfnPI=;
	h=Date:To:From:Subject:From;
	b=rwoywP37PuqIcLGvVZZl8zpUGzJaD4bZC2EATqXesDAcBolMe5ADn+HmHcXXPi43a
	 FZuiOek29U19QRHItyr1ADEE4Pnd/H2RetMf772DSGgKSpVL3DhcWdYZlJbp8AcAsm
	 W/UH8WQ1RgeQlUq/9XwYVQCiwG2MmnUJiT/GrPjs=
Date: Sun, 01 Sep 2024 20:29:16 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mcgrof@kernel.org,mark.rutland@arm.com,linux@armlinux.org.uk,linus.walleij@linaro.org,kees@kernel.org,alex@ghiti.fr,davidgow@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-only-enforce-minimum-stack-gap-size-if-its-sensible.patch removed from -mm tree
Message-Id: <20240902032916.C6D61C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: only enforce minimum stack gap size if it's sensible
has been removed from the -mm tree.  Its filename was
     mm-only-enforce-minimum-stack-gap-size-if-its-sensible.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Kees Cook <kees@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>
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


