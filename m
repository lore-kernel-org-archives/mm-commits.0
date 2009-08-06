From: akpm@linux-foundation.org
Subject: + checkincludespl-provide-usage-helper.patch added to -mm tree
Date: Wed, 05 Aug 2009 19:00:00 -0700
Message-ID: <200908060200.n76200Z5015183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753644AbZHFCAE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2009 22:00:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lrodriguez@Atheros.comlrodriguez@Atheros.com, sam@ravnborg.org


The patch titled
     checkincludes.pl: provide usage helper
has been added to the -mm tree.  Its filename is
     checkincludespl-provide-usage-helper.patch

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
Subject: checkincludes.pl: provide usage helper
From: "Luis R. Rodriguez" <lrodriguez@Atheros.com>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkincludes.pl |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN scripts/checkincludes.pl~checkincludespl-provide-usage-helper scripts/checkincludes.pl
--- a/scripts/checkincludes.pl~checkincludespl-provide-usage-helper
+++ a/scripts/checkincludes.pl
@@ -3,6 +3,15 @@
 # checkincludes: Find files included more than once in (other) files.
 # Copyright abandoned, 2000, Niels Kristian Bech Jensen <nkbj@image.dk>.
 
+sub usage {
+	print "Usage: checkincludes.pl <file list>\n";
+	exit 1;
+}
+
+if ($#ARGV < 0) {
+        usage();
+}
+
 foreach $file (@ARGV) {
 	open(FILE, $file) or die "Cannot open $file: $!.\n";
 
_

Patches currently in -mm which might be from lrodriguez@Atheros.com are

checkincludespl-close-file-as-soon-as-were-done-with-it.patch
checkincludespl-provide-usage-helper.patch
checkincludespl-add-option-to-remove-duplicates-in-place.patch
checkincludespl-add-option-to-remove-duplicates-in-place-fix.patch

