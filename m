From: akpm@linux-foundation.org
Subject: + checkpatch-try-to-catch-missing-vmlinux_symbol-in-vmlinuxldsh.patch added to -mm tree
Date: Mon, 08 Dec 2008 16:04:34 -0800
Message-ID: <200812090004.mB904Y2J031146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754247AbYLIAFG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 19:05:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, apw@canonical.com


The patch titled
     checkpatch: try to catch missing VMLINUX_SYMBOL() in vmlinux.lds.h
has been added to the -mm tree.  Its filename is
     checkpatch-try-to-catch-missing-vmlinux_symbol-in-vmlinuxldsh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: try to catch missing VMLINUX_SYMBOL() in vmlinux.lds.h
From: Mike Frysinger <vapier@gentoo.org>

Seems like every other release we have someone who updates vmlinux.lds.h
and adds C-visible symbols without VMLINUX_SYMBOL() around them.  So start
checking the file and reject assignments which have plain symbols on
either side.

[apw@canonical.com: soften the check, add tests]
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-try-to-catch-missing-vmlinux_symbol-in-vmlinuxldsh scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-try-to-catch-missing-vmlinux_symbol-in-vmlinuxldsh
+++ a/scripts/checkpatch.pl
@@ -2224,6 +2224,15 @@ sub process {
 			}
 		}
 
+# make sure symbols are always wrapped with VMLINUX_SYMBOL() ...
+# all assignments may have only one of the following with an assignment:
+#	.
+#	ALIGN(...)
+#	VMLINUX_SYMBOL(...)
+		if ($realfile eq 'vmlinux.lds.h' && $line =~ /(?:(?:^|\s)$Ident\s*=|=\s*$Ident(?:\s|$))/) {
+			WARN("vmlinux.lds.h needs VMLINUX_SYMBOL() around C-visible symbols\n" . $herecurr);
+		}
+
 # check for redundant bracing round if etc
 		if ($line =~ /(^.*)\bif\b/ && $1 !~ /else\s*$/) {
 			my ($level, $endln, @chunks) =
_

Patches currently in -mm which might be from vapier@gentoo.org are

linux-next.patch
linux-timexh-cleanup-for-userspace.patch
mtd-physmap-make-physmap-compat-explicit.patch
autodetect_raid-add-missing-__init-marking.patch
checkpatch-try-to-catch-missing-vmlinux_symbol-in-vmlinuxldsh.patch

