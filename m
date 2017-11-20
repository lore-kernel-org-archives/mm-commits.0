From: akpm@linux-foundation.org
Subject: [merged]
 scripts-checkpatchpl-avoid-false-warning-missing-break.patch removed from
 -mm tree
Date: Mon, 20 Nov 2017 13:24:36 -0800
Message-ID: <20171120212436.qlYDPUEfh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40532 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752962AbdKTVYh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:24:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org, xypron.glpk@gmx.de


The patch titled
     Subject: scripts/checkpatch.pl: avoid false warning missing break
has been removed from the -mm tree.  Its filename was
     scripts-checkpatchpl-avoid-false-warning-missing-break.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from xypron.glpk@gmx.de are


