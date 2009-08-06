From: akpm@linux-foundation.org
Subject: + checkincludespl-close-file-as-soon-as-were-done-with-it.patch added to -mm tree
Date: Wed, 05 Aug 2009 18:59:58 -0700
Message-ID: <200908060159.n761xwiK015110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753640AbZHFCAE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2009 22:00:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lrodriguez@Atheros.comlrodriguez@Atheros.com, sam@ravnborg.org


The patch titled
     checkincludes.pl: close file as soon as we're done with it
has been added to the -mm tree.  Its filename is
     checkincludespl-close-file-as-soon-as-were-done-with-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
