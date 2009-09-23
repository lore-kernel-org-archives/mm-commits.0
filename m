From: akpm@linux-foundation.org
Subject: [merged] checkincludespl-provide-usage-helper.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:04:26 -0700
Message-ID: <200909232004.n8NK4QQ5021275@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753942AbZIWUE4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:04:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lrodriguez@Atheros.comlrodriguez@Atheros.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     checkincludes.pl: provide usage helper
has been removed from the -mm tree.  Its filename was
     checkincludespl-provide-usage-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

