From: akpm@linux-foundation.org
Subject: - checkpatch-try-to-catch-missing-vmlinux_symbol-in-vmlinuxldsh.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:16:58 -0800
Message-ID: <200901072216.n07MGwwC016616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762001AbZAGWRC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:17:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: try to catch missing VMLINUX_SYMBOL() in vmlinux.lds.h
has been removed from the -mm tree.  Its filename was
     checkpatch-try-to-catch-missing-vmlinux_symbol-in-vmlinuxldsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

