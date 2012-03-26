From: akpm@linux-foundation.org
Subject: [merged] checkpatch-whitespace-add-remove-blank-lines.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:30:32 -0700
Message-ID: <20120326193032.54214A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:54481 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab2CZTad (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:30:33 -0400
Received: by mail-vb0-f74.google.com with SMTP id l22so508210vbn.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:30:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: whitespace - add/remove blank lines
has been removed from the -mm tree.  Its filename was
     checkpatch-whitespace-add-remove-blank-lines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: whitespace - add/remove blank lines

Add blank lines between a few tests, remove an extraneous one.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-whitespace-add-remove-blank-lines scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-whitespace-add-remove-blank-lines
+++ a/scripts/checkpatch.pl
@@ -3354,18 +3354,20 @@ sub process {
 		if ($line =~ /^.\s*sema_init.+,\W?0\W?\)/) {
 			WARN("CONSIDER_COMPLETION",
 			     "consider using a completion\n" . $herecurr);
-
 		}
+
 # recommend kstrto* over simple_strto* and strict_strto*
 		if ($line =~ /\b((simple|strict)_(strto(l|ll|ul|ull)))\s*\(/) {
 			WARN("CONSIDER_KSTRTO",
 			     "$1 is obsolete, use k$3 instead\n" . $herecurr);
 		}
+
 # check for __initcall(), use device_initcall() explicitly please
 		if ($line =~ /^.\s*__initcall\s*\(/) {
 			WARN("USE_DEVICE_INITCALL",
 			     "please use device_initcall() instead of __initcall()\n" . $herecurr);
 		}
+
 # check for various ops structs, ensure they are const.
 		my $struct_ops = qr{acpi_dock_ops|
 				address_space_operations|
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-fix-remoteproc-f-typo.patch
checkpatch-suggest-pr_level-over-printkkern_level.patch

