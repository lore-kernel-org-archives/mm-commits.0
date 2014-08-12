From: akpm@linux-foundation.org
Subject: [merged]
 scripts-checkstackpl-automatically-handle-32-bit-and-64-bit-mode-for-arch=x86.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:41:46 -0700
Message-ID: <53ea6dfa.4vMHFECNPocli5Bo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:45562 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbaHLTlr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:41:47 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so1069298igd.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:41:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, dwmw2@infradead.org, geert@linux-m68k.org, hpa@zytor.com, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/checkstack.pl: automatically handle 32-bit and 64-bit mode for ARCH=x86
has been removed from the -mm tree.  Its filename was
     scripts-checkstackpl-automatically-handle-32-bit-and-64-bit-mode-for-arch=x86.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: scripts/checkstack.pl: automatically handle 32-bit and 64-bit mode for ARCH=x86

This patch adds support for ARCH=x86 into checkstack.

commit ffee0de411fd4f7 ("x86: Default to ARCH=x86 to avoid overriding
CONFIG_64BIT") had merged ARCH=i386 and ARCH=x86_64 into one ARCH=x86. 
checkstack.pl searches patterns of machine instructions which are usually
used for allocating stack frames.  checkstalk.pl needs either i386 or
x86_64, x86 isn't enough:

$ make checkstack
objdump -d vmlinux $(find . -name '*.ko') | \
perl linux/scripts/checkstack.pl x86
wrong or unknown architecture "x86"

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkstack.pl |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN scripts/checkstack.pl~scripts-checkstackpl-automatically-handle-32-bit-and-64-bit-mode-for-arch=x86 scripts/checkstack.pl
--- a/scripts/checkstack.pl~scripts-checkstackpl-automatically-handle-32-bit-and-64-bit-mode-for-arch=x86
+++ a/scripts/checkstack.pl
@@ -52,14 +52,12 @@ my (@stack, $re, $dre, $x, $xs, $funcre)
 		#8000008a:       20 1d           sub sp,4
 		#80000ca8:       fa cd 05 b0     sub sp,sp,1456
 		$re = qr/^.*sub.*sp.*,([0-9]{1,8})/o;
-	} elsif ($arch =~ /^i[3456]86$/) {
+	} elsif ($arch =~ /^x86(_64)?$/ || $arch =~ /^i[3456]86$/) {
 		#c0105234:       81 ec ac 05 00 00       sub    $0x5ac,%esp
-		$re = qr/^.*[as][du][db]    \$(0x$x{1,8}),\%esp$/o;
-		$dre = qr/^.*[as][du][db]    (%.*),\%esp$/o;
-	} elsif ($arch eq 'x86_64') {
-		#    2f60:	48 81 ec e8 05 00 00 	sub    $0x5e8,%rsp
-		$re = qr/^.*[as][du][db]    \$(0x$x{1,8}),\%rsp$/o;
-		$dre = qr/^.*[as][du][db]    (\%.*),\%rsp$/o;
+		# or
+		#    2f60:    48 81 ec e8 05 00 00       sub    $0x5e8,%rsp
+		$re = qr/^.*[as][du][db]    \$(0x$x{1,8}),\%(e|r)sp$/o;
+		$dre = qr/^.*[as][du][db]    (%.*),\%(e|r)sp$/o;
 	} elsif ($arch eq 'ia64') {
 		#e0000000044011fc:       01 0f fc 8c     adds r12=-384,r12
 		$re = qr/.*adds.*r12=-(([0-9]{2}|[3-9])[0-9]{2}),r12/o;
_

Patches currently in -mm which might be from koct9i@gmail.com are

origin.patch
linux-next.patch

