From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-dont-check-c99-types-like-uint8_t-under-tools.patch removed from -mm tree
Date: Wed, 14 Dec 2016 11:27:56 -0800
Message-ID: <58519d3c.A50m9Yp1Fk3vcQaT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45834 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756534AbcLNT3j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:29:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomas.winkler@intel.com, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: don't check c99 types like uint8_t under tools
has been removed from the -mm tree.  Its filename was
     checkpatch-dont-check-c99-types-like-uint8_t-under-tools.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tomas Winkler <tomas.winkler@intel.com>
Subject: checkpatch: don't check c99 types like uint8_t under tools

Tools contains user space code so uintX_t types are just fine.

Link: http://lkml.kernel.org/r/1479286379-853-1-git-send-email-tomas.winkler@intel.com
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-dont-check-c99-types-like-uint8_t-under-tools scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-dont-check-c99-types-like-uint8_t-under-tools
+++ a/scripts/checkpatch.pl
@@ -5560,8 +5560,9 @@ sub process {
 			      "Using weak declarations can have unintended link defects\n" . $herecurr);
 		}
 
-# check for c99 types like uint8_t used outside of uapi/
+# check for c99 types like uint8_t used outside of uapi/ and tools/
 		if ($realfile !~ m@\binclude/uapi/@ &&
+		    $realfile !~ m@\btools/@ &&
 		    $line =~ /\b($Declare)\s*$Ident\s*[=;,\[]/) {
 			my $type = $1;
 			if ($type =~ /\b($typeC99Typedefs)\b/) {
_

Patches currently in -mm which might be from tomas.winkler@intel.com are


