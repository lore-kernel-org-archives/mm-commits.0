From: akpm@linux-foundation.org
Subject: [merged] checkpatch-prefer-__printf-not-__attribute__formatprintf.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:31:02 -0800
Message-ID: <20120111213102.9126610004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:42148 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933921Ab2AKVbD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:31:03 -0500
Received: by mail-yx0-f202.google.com with SMTP id m1so7711yen.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:31:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: prefer __printf over __attribute__((format(printf,...)))
has been removed from the -mm tree.  Its filename was
     checkpatch-prefer-__printf-not-__attribute__formatprintf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: prefer __printf over __attribute__((format(printf,...)))

Add a warn for not using __printf.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-prefer-__printf-not-__attribute__formatprintf scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-prefer-__printf-not-__attribute__formatprintf
+++ a/scripts/checkpatch.pl
@@ -3114,6 +3114,12 @@ sub process {
 			     "__aligned(size) is preferred over __attribute__((aligned(size)))\n" . $herecurr);
 		}
 
+# Check for __attribute__ format(printf, prefer __printf
+		if ($line =~ /\b__attribute__\s*\(\s*\(\s*format\s*\(\s*printf/) {
+			WARN("PREFER_PRINTF",
+			     "__printf(string-index, first-to-check) is preferred over __attribute__((format(printf, string-index, first-to-check)))\n" . $herecurr);
+		}
+
 # check for sizeof(&)
 		if ($line =~ /\bsizeof\s*\(\s*\&/) {
 			WARN("SIZEOF_ADDRESS",
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-staging-cx25821-add-l-linux-media.patch
kernelh-neaten-panic-prototype.patch
linkage-remove-unused-noret_and-macro.patch
treewide-remove-useless-noret_type-macro-and-uses.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
linkage-remove-unused-attrib_noret-macro.patch

