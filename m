From: akpm@linux-foundation.org
Subject: [patch 41/94] scripts/checkpatch.pl: avoid false warning
 missing break
Date: Fri, 17 Nov 2017 15:28:38 -0800
Message-ID: <20171117232838.9sS0kH2Vr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55634 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965766AbdKQX2j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:28:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, xypron.glpk@gmx.de

From: Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: scripts/checkpatch.pl: avoid false warning missing break

void foo(int a)
	switch (a) {
	case 'h':
		fun1();
		exit(1);
	default:
}

creates a warning "Possible switch case/default not preceded by break or
fallthrough comment".

exit( should be treated like return.

Link: http://lkml.kernel.org/r/20170910154618.25819-1-xypron.glpk@gmx.de
Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~scripts-checkpatchpl-avoid-false-warning-missing-break scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~scripts-checkpatchpl-avoid-false-warning-missing-break
+++ a/scripts/checkpatch.pl
@@ -6109,7 +6109,7 @@ sub process {
 				next if ($fline =~ /^.[\s$;]*$/);
 				$has_statement = 1;
 				$count++;
-				$has_break = 1 if ($fline =~ /\bswitch\b|\b(?:break\s*;[\s$;]*$|return\b|goto\b|continue\b)/);
+				$has_break = 1 if ($fline =~ /\bswitch\b|\b(?:break\s*;[\s$;]*$|exit\s*\(\b|return\b|goto\b|continue\b)/);
 			}
 			if (!$has_break && $has_statement) {
 				WARN("MISSING_BREAK",
_
