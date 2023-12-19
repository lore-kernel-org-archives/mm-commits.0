Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A6539AF2
	for <mm-commits@vger.kernel.org>; Tue, 19 Dec 2023 20:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SdCpALZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A01FC433C7;
	Tue, 19 Dec 2023 20:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703019545;
	bh=R71ueXYQLW3olGkU8UjGgIQ8EvZIr1x4wrf8RQfwEwA=;
	h=Date:To:From:Subject:From;
	b=SdCpALZ0bDxFkRWq84Ex4M/IhPPdqYt2Ni6HRtwQpFeHlj114057y67lkb63bcKAF
	 HgfQnsnO1Dk3neS3FnodNhBF59x36Gfr7E9lkwanUnkSjQQc1NMURsIKJQz21iP2db
	 d508YhyylIcVPCodg6TuJLRrShBi5dDKxPjPTAno=
Date: Tue, 19 Dec 2023 12:59:04 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,yangtiezhu@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-checkstackpl-remove-ia64-support.patch added to mm-nonmm-unstable branch
Message-Id: <20231219205905.7A01FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/checkstack.pl: remove ia64 support
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-checkstackpl-remove-ia64-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-checkstackpl-remove-ia64-support.patch

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
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: scripts/checkstack.pl: remove ia64 support
Date: Tue, 19 Dec 2023 20:49:57 +0800

Patch series "Modify some code about checkstack".


This patch (of 5):

After commit cf8e8658100d ("arch: Remove Itanium (IA-64) architecture"),
the ia64 port has been removed from the kernel, so also remove the ia64
specific bits from the checkstack.pl script.

Link: https://lkml.kernel.org/r/20231219125008.23007-1-yangtiezhu@loongson.cn
Link: https://lkml.kernel.org/r/20231219125008.23007-2-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkstack.pl |    4 ----
 1 file changed, 4 deletions(-)

--- a/scripts/checkstack.pl~scripts-checkstackpl-remove-ia64-support
+++ a/scripts/checkstack.pl
@@ -8,7 +8,6 @@
 #	Original idea maybe from Keith Owens
 #	s390 port and big speedup by Arnd Bergmann <arnd@bergmann-dalldorf.de>
 #	Mips port by Juan Quintela <quintela@mandrakesoft.com>
-#	IA64 port via Andreas Dilger
 #	Arm port by Holger Schurig
 #	Random bits by Matt Mackall <mpm@selenic.com>
 #	M68k port by Geert Uytterhoeven and Andreas Schwab
@@ -69,9 +68,6 @@ my (@stack, $re, $dre, $sub, $x, $xs, $f
 		#    2f60:    48 81 ec e8 05 00 00       sub    $0x5e8,%rsp
 		$re = qr/^.*[as][du][db]    \$(0x$x{1,8}),\%(e|r)sp$/o;
 		$dre = qr/^.*[as][du][db]    (%.*),\%(e|r)sp$/o;
-	} elsif ($arch eq 'ia64') {
-		#e0000000044011fc:       01 0f fc 8c     adds r12=-384,r12
-		$re = qr/.*adds.*r12=-(([0-9]{2}|[3-9])[0-9]{2}),r12/o;
 	} elsif ($arch eq 'm68k') {
 		#    2b6c:       4e56 fb70       linkw %fp,#-1168
 		#  1df770:       defc ffe4       addaw #-28,%sp
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

scripts-checkstackpl-remove-ia64-support.patch
scripts-checkstackpl-add-min_stack-to-the-usage-comment.patch
scripts-checkstackpl-match-all-stack-sizes-for-some-archs.patch
scripts-checkstackpl-change-min_stack-to-512-by-default.patch
docs-submit-checklist-remove-all-of-make-namespacecheck.patch

