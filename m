From: akpm@linux-foundation.org
Subject: + checkpatch-warn-about-using-config_experimental.patch added to -mm tree
Date: Mon, 12 Nov 2012 15:24:59 -0800
Message-ID: <20121112232459.89267100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:60577 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab2KLXZA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Nov 2012 18:25:00 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so792861qcq.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Nov 2012 15:25:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: keescook@chromium.org, apw@canonical.com, joe@perches.com


The patch titled
     Subject: checkpatch: warn about using CONFIG_EXPERIMENTAL
has been added to the -mm tree.  Its filename is
     checkpatch-warn-about-using-config_experimental.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
fs-pstore-ramc-fix-up-section-annotations.patch
checkpatch-warn-about-using-config_experimental.patch
proc-dont-show-nonexistent-capabilities.patch
proc-pid-status-add-seccomp-field.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch

