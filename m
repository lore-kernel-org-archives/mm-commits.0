Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B55813FF1
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j8wh8Un+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8915CC433C7;
	Fri, 29 Dec 2023 20:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703881397;
	bh=xdS5mHcs8FKSs2TZx0J1ABMR0pXweqJ5Atf65P4zrNw=;
	h=Date:To:From:Subject:From;
	b=j8wh8Un+x+xNY31Bcc/+DeyK9DdRHa/OxPNRY4VgeQ1mz7fSjeAYI96lvBZEzwUhM
	 7jeg1ni3S1tzPoHh4QA8s7TBjWQMQXFhTNTNUdMto5Q3ao/2mIDoKuBNsXzjvOdeus
	 ttfM55yxn17gIQL76SFwno0E2oNqBUaWMVWCBvIY=
Date: Fri, 29 Dec 2023 12:23:17 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,yangtiezhu@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-checkstackpl-remove-ia64-support.patch removed from -mm tree
Message-Id: <20231229202317.8915CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/checkstack.pl: remove ia64 support
has been removed from the -mm tree.  Its filename was
     scripts-checkstackpl-remove-ia64-support.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


