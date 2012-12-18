From: akpm@linux-foundation.org
Subject: [merged] checkpatch-warn-about-using-config_experimental.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:06:41 -0800
Message-ID: <20121218200642.8A35A200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:47445 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab2LRUGp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:06:45 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so63487wey.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:06:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn about using CONFIG_EXPERIMENTAL
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-about-using-config_experimental.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: checkpatch: warn about using CONFIG_EXPERIMENTAL

This config item has not carried much meaning for a while now and is
almost always enabled by default.  As agreed during the Linux kernel
summit, it is being removed.  This will discourage future addition of
CONFIG_EXPERIMENTAL while it is being phased out.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-warn-about-using-config_experimental scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-about-using-config_experimental
+++ a/scripts/checkpatch.pl
@@ -1757,6 +1757,13 @@ sub process {
 			#print "is_start<$is_start> is_end<$is_end> length<$length>\n";
 		}
 
+# discourage the addition of CONFIG_EXPERIMENTAL in Kconfig.
+		if ($realfile =~ /Kconfig/ &&
+		    $line =~ /.\s*depends on\s+.*\bEXPERIMENTAL\b/) {
+			WARN("CONFIG_EXPERIMENTAL",
+			     "Use of CONFIG_EXPERIMENTAL is deprecated. For alternatives, see https://lkml.org/lkml/2012/10/23/580\n");
+		}
+
 		if (($realfile =~ /Makefile.*/ || $realfile =~ /Kbuild.*/) &&
 		    ($line =~ /\+(EXTRA_[A-Z]+FLAGS).*/)) {
 			my $flag = $1;
@@ -1912,6 +1919,12 @@ sub process {
 # check we are in a valid C source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c)$/);
 
+# discourage the addition of CONFIG_EXPERIMENTAL in #if(def).
+		if ($line =~ /^\+\s*\#\s*if.*\bCONFIG_EXPERIMENTAL\b/) {
+			WARN("CONFIG_EXPERIMENTAL",
+			     "Use of CONFIG_EXPERIMENTAL is deprecated. For alternatives, see https://lkml.org/lkml/2012/10/23/580\n");
+		}
+
 # check for RCS/CVS revision markers
 		if ($rawline =~ /^\+.*\$(Revision|Log|Id)(?:\$|)/) {
 			WARN("CVS_KEYWORD",
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
linux-next.patch
audit-create-explicit-audit_seccomp-event-type.patch
audit-catch-possible-null-audit-buffers.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
exec-do-not-leave-bprm-interp-on-stack.patch

