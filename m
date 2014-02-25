From: akpm@linux-foundation.org
Subject: +
 checkpatch-add-test-for-char-arrays-that-could-be-static-const.patch added
 to -mm tree
Date: Mon, 24 Feb 2014 16:16:29 -0800
Message-ID: <530be0dd.9aII1OV2kAj79Hft%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaBYAQa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Feb 2014 19:16:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-add-test-for-char-arrays-that-could-be-static-const.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Mon, 24 Feb 2014 16:16:29 -0800


The patch titled
     Subject: checkpatch: add test for char * arrays that could be static const
has been added to the -mm tree.  Its filename is
     checkpatch-add-test-for-char-arrays-that-could-be-static-const.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-test-for-char-arrays-that-could-be-static-const.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-test-for-char-arrays-that-could-be-static-const.patch

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
Subject: checkpatch: add test for char * arrays that could be static const

static const char* arrays create smaller text as each function call does
not have to populate the array.

Emit a warning when char *arrays aren't static const and the array is not
apparently global by being declared in the first column.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-test-for-char-arrays-that-could-be-static-const scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-test-for-char-arrays-that-could-be-static-const
+++ a/scripts/checkpatch.pl
@@ -2675,6 +2675,13 @@ sub process {
 				$herecurr);
                }
 
+# check for non-global char *foo[] = {"bar", ...} declarations.
+		if ($line =~ /^.\s+(?:static\s+|const\s+)?char\s+\*\s*\w+\s*\[\s*\]\s*=\s*\{/) {
+			WARN("STATIC_CONST_CHAR_ARRAY",
+			     "char * array declaration might be better as static const\n" .
+				$herecurr);
+               }
+
 # check for function declarations without arguments like "int foo()"
 		if ($line =~ /(\b$Type\s+$Ident)\s*\(\s*\)/) {
 			if (ERROR("FUNCTION_WITHOUT_ARGS",
_

Patches currently in -mm which might be from joe@perches.com are

drivers-iommu-omap-iommu-debugc-fix-decimal-permissions.patch
drivers-fmc-fmc-write-eepromc-fix-decimal-permissions.patch
maintainers-update-l-misuses.patch
lib-random32c-minor-cleanups-and-kdoc-fix.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-test-for-long-udelay.patch
checkpatch-dont-warn-on-some-function-pointer-return-styles.patch
checkpatch-add-checks-for-constant-non-octal-permissions.patch
checkpatch-warn-on-uses-of-__constant_foo-functions.patch
checkpatch-update-octal-permissions-warning.patch
checkpatch-avoid-sscanf-test-duplicated-messages.patch
checkpatch-fix-jiffies-comparison-and-others.patch
checkpatch-add-test-for-char-arrays-that-could-be-static-const.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

