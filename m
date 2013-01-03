From: akpm@linux-foundation.org
Subject: + checkpatch-warn-on-unnecessary-__devfoo-section-markings.patch added to -mm tree
Date: Thu, 03 Jan 2013 14:06:08 -0800
Message-ID: <20130103220608.976F2100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:50785 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab3ACWGJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jan 2013 17:06:09 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so1679378vbi.3
        for <mm-commits@vger.kernel.org>; Thu, 03 Jan 2013 14:06:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com, greg@kroah.com


The patch titled
     Subject: checkpatch: warn on unnecessary __dev<foo> section markings
has been added to the -mm tree.  Its filename is
     checkpatch-warn-on-unnecessary-__devfoo-section-markings.patch

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
Subject: checkpatch: warn on unnecessary __dev<foo> section markings

Get people to stop adding __devinit and __devexit section markings.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Andy Whitcroft <apw@canonical.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-warn-on-unnecessary-__devfoo-section-markings scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-on-unnecessary-__devfoo-section-markings
+++ a/scripts/checkpatch.pl
@@ -1931,6 +1931,12 @@ sub process {
 			      "use the SSYNC() macro in asm/blackfin.h\n" . $herevet);
 		}
 
+# check for old HOTPLUG __dev<foo> section markings
+		if ($line =~ /\b(__dev(init|exit)(data|const|))\b/) {
+			WARN("HOTPLUG_SECTION",
+			     "Using $1 is unnecessary\n" . $herecurr);
+		}
+
 # Check for potential 'bare' types
 		my ($stat, $cond, $line_nr_next, $remain_next, $off_next,
 		    $realline_next);
_

Patches currently in -mm which might be from joe@perches.com are

printk-fix-incorrect-length-from-print_time-when-seconds-99999.patch
linux-next.patch
compiler-gcc4h-reorder-macros-based-upon-gcc-ver.patch
compiler-gcch-add-gcc-recommended-gcc_version-macro.patch
compiler-gcc34h-use-gcc_version-macro.patch
compiler-gcc4h-bugh-remove-duplicate-macros.patch
bugh-fix-build_bug_on-macro-in-__checker__.patch
bugh-prevent-double-evaulation-of-in-build_bug_on.patch
bugh-make-build_bug_on-generate-compile-time-error.patch
compilerh-bugh-prevent-double-error-messages-with-build_bug_on.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg.patch
get_maintainerpl-find-maintainers-for-removed-files.patch
checkpatch-prefer-dev_level-to-dev_printkkern_level.patch
checkpatch-warn-on-unnecessary-__devfoo-section-markings.patch

