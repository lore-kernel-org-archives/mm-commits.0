From: akpm@linux-foundation.org
Subject: [merged] checkincludespl-close-file-as-soon-as-were-done-with-it.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:04:23 -0700
Message-ID: <200909232004.n8NK4Ni1021139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753939AbZIWUEz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:04:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lrodriguez@Atheros.comlrodriguez@Atheros.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     checkincludes.pl: close file as soon as we're done with it
has been removed from the -mm tree.  Its filename was
     checkincludespl-close-file-as-soon-as-were-done-with-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkincludes.pl: close file as soon as we're done with it
From: "Luis R. Rodriguez" <lrodriguez@Atheros.com>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkincludes.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkincludes.pl~checkincludespl-close-file-as-soon-as-were-done-with-it scripts/checkincludes.pl
--- a/scripts/checkincludes.pl~checkincludespl-close-file-as-soon-as-were-done-with-it
+++ a/scripts/checkincludes.pl
@@ -13,12 +13,12 @@ foreach $file (@ARGV) {
 			++$includedfiles{$1};
 		}
 	}
+
+	close(FILE);
 	
 	foreach $filename (keys %includedfiles) {
 		if ($includedfiles{$filename} > 1) {
 			print "$file: $filename is included more than once.\n";
 		}
 	}
