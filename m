From: akpm@linux-foundation.org
Subject: [merged] checkpatch-allow-simple-character-constants-in-defines.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:30:20 -0700
Message-ID: <20120326193020.5E361A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:63241 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab2CZTaW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:30:22 -0400
Received: by mail-we0-f202.google.com with SMTP id x9so290130wej.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:30:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: allow simple character constants in #defines
has been removed from the -mm tree.  Its filename was
     checkpatch-allow-simple-character-constants-in-defines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andy Whitcroft <apw@canonical.com>
Subject: checkpatch: allow simple character constants in #defines

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-allow-simple-character-constants-in-defines scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-allow-simple-character-constants-in-defines
+++ a/scripts/checkpatch.pl
@@ -2911,6 +2911,7 @@ sub process {
 			    $dstat !~ /^(?:$Ident|-?$Constant),$/ &&			# 10, // foo(),
 			    $dstat !~ /^(?:$Ident|-?$Constant);$/ &&			# foo();
 			    $dstat !~ /^(?:$Ident|-?$Constant)$/ &&			# 10 // foo()
+			    $dstat !~ /^'X'$/ &&					# character constants
 			    $dstat !~ /$exceptions/ &&
 			    $dstat !~ /^\.$Ident\s*=/ &&				# .foo =
 			    $dstat !~ /^do\s*$Constant\s*while\s*$Constant;?$/ &&	# do {...} while (...); // do {...} while (...)
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch

