Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9B7256E
	for <mm-commits@vger.kernel.org>; Fri,  6 Dec 2024 01:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733447633; cv=none; b=RYh/CHYN50Gde5jVIlGrhXWsFBH1ILClaDYhlEexWuPisYCK0Hei/Qh9yw1DnHGVXahDAUYK+yQDC6HxbjfN21TEc5gh7Fbmn38alinW20IePBH4J4CQBkR/nu7tYdmm5Pkp5IWWJ4i8Y/ErG6PJZI6eVXu0qhLRd9BohqDm2S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733447633; c=relaxed/simple;
	bh=Tf/ReEW7tZKXSBmFRq//M6bAZm7aiYijX3OlhdukEGE=;
	h=Date:To:From:Subject:Message-Id; b=TQjxYLWEIAh9sAA5hfsI7iKQWpD5Gs19Qp6xvD01rVOQ9EkuIR9CtF9+cFU4LujD2rwobPhr6Ukp3RRUNZy/zHLej/V65k0MqzTPluSJGMaGTzv7+0+XHIQx6PZ2/1HVFrdZ1SYGhoU6ypY9g6f0/m0JNqFNCqxDQPtJgQ2M0Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aX7LVmCo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aX7LVmCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E85C4CED1;
	Fri,  6 Dec 2024 01:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733447632;
	bh=Tf/ReEW7tZKXSBmFRq//M6bAZm7aiYijX3OlhdukEGE=;
	h=Date:To:From:Subject:From;
	b=aX7LVmCozt/qNcT6FA61XdQbBVhaiK7VbXveA31+3WInIovdZEBAD6mjghSUAUYAw
	 86vB4itwTZQ+J/2MoKwkdCDSHk/DTr0CalrXX0BAS6EvOA9JYEpA0cBZkCW7Ea8QRg
	 5kQwuZkjqD9vlW1LczRo7Kj6+xPG49jGO8ytp/bA=
Date: Thu, 05 Dec 2024 17:13:51 -0800
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,oleg@redhat.com,nicolas@fjasle.eu,nathan@kernel.org,masahiroy@kernel.org,lukas.bulwahn@gmail.com,linux@rasmusvillemoes.dk,joe@perches.com,dwaipayanray1@gmail.com,arnd@arndb.de,apw@canonical.com,geert+renesas@glider.be,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-update-reference-to-include-asm-arch.patch added to mm-nonmm-unstable branch
Message-Id: <20241206011352.81E85C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: update reference to include/asm-<arch>
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-update-reference-to-include-asm-arch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-update-reference-to-include-asm-arch.patch

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
Subject: checkpatch: update reference to include/asm-<arch>
Date: Thu, 5 Dec 2024 14:20:42 +0100

Patch series "Update reference to include/asm-<arch>".

Despite "include/asm-<arch>" having been replaced by
"arch/<arch>/include/asm" 15 years ago, there are still several
references left.

This patch series updates the most visible ones.


This patch (of 3):

"include/asm-<arch>" was replaced by "arch/<arch>/include/asm" a long
time ago.

Link: https://lkml.kernel.org/r/cover.1733404444.git.geert+renesas@glider.be
Link: https://lkml.kernel.org/r/2c4a75726a976d117055055b68a31c40dcab044e.1733404444.git.geert+renesas@glider.be
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

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-update-reference-to-include-asm-arch
+++ a/scripts/checkpatch.pl
@@ -2875,7 +2875,7 @@ sub process {
 
 			if ($realfile =~ m@^include/asm/@) {
 				ERROR("MODIFIED_INCLUDE_ASM",
-				      "do not modify files in include/asm, change architecture specific files in include/asm-<architecture>\n" . "$here$rawline\n");
+				      "do not modify files in include/asm, change architecture specific files in arch/<architecture>/include/asm\n" . "$here$rawline\n");
 			}
 			$found_file = 1;
 		}
_

Patches currently in -mm which might be from geert+renesas@glider.be are

checkpatch-update-reference-to-include-asm-arch.patch
kbuild-drop-support-for-include-asm-arch-in-headers_checkpl.patch
include-update-references-to-include-asm-arch.patch

