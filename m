From: akpm@linux-foundation.org
Subject: + scripts-checkpatchpl-avoid-false-warning-missing-break.patch
 added to -mm tree
Date: Mon, 02 Oct 2017 16:07:53 -0700
Message-ID: <59d2c6c9.vGBB4ghlo81NbHDL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45882 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbdJBXHy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2017 19:07:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xypron.glpk@gmx.de, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/checkpatch.pl: avoid false warning missing break
has been added to the -mm tree.  Its filename is
     scripts-checkpatchpl-avoid-false-warning-missing-break.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-checkpatchpl-avoid-false-warning-missing-break.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-checkpatchpl-avoid-false-warning-missing-break.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

scripts-checkpatchpl-avoid-false-warning-missing-break.patch

