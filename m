From: akpm@linux-foundation.org
Subject: + checkpatch-warn-when-declaring-struct-spinlock-foo.patch added to -mm tree
Date: Thu, 29 Nov 2012 13:35:59 -0800
Message-ID: <20121129213600.261E3100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f202.google.com ([209.85.210.202]:45969 "EHLO
	mail-ia0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab2K2VgD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Nov 2012 16:36:03 -0500
Received: by mail-ia0-f202.google.com with SMTP id k10so3284008iag.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Nov 2012 13:36:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, mcgrof@do-not-panic.com


The patch titled
     Subject: checkpatch: warn when declaring "struct spinlock foo;"
has been added to the -mm tree.  Its filename is
     checkpatch-warn-when-declaring-struct-spinlock-foo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: warn when declaring "struct spinlock foo;"

spinlock_t should always be used.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-warn-when-declaring-struct-spinlock-foo scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-when-declaring-struct-spinlock-foo
+++ a/scripts/checkpatch.pl
@@ -3344,6 +3344,12 @@ sub process {
 			     "Avoid line continuations in quoted strings\n" . $herecurr);
 		}
 
+# check for struct spinlock declarations
+		if ($line =~ /^.\s*\bstruct\s+spinlock\s+\w+\s*;/) {
+			WARN("USE_SPINLOCK_T",
+			     "struct spinlock should be spinlock_t\n" . $herecurr);
+		}
+
 # Check for misused memsets
 		if ($^V && $^V ge 5.10.0 &&
 		    defined $stat &&
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
printk-boot_delay-should-only-affect-output.patch
maintainers-chinese-maintainers-mailing-list-is-subscribers-only.patch
checkpatch-warn-on-unnecessary-line-continuations.patch
checkpatch-warn-about-using-config_experimental.patch
checkpatch-remove-reference-to-feature-removal-scheduletxt.patch
checkpatch-consolidate-if-foo-barfoo-checks-and-add-debugfs_remove.patch
checkpatch-allow-control-over-line-length-warning-default-remains-80.patch
checkpatch-extend-line-continuation-test.patch
checkpatch-add-strict-messages-for-blank-lines-around-braces.patch
checkpatch-warn-when-declaring-struct-spinlock-foo.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

