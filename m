From: akpm@linux-foundation.org
Subject: + bootgraph-fix-for-use-with-dot-symbols.patch added to -mm tree
Date: Tue, 10 Feb 2009 11:40:52 -0800
Message-ID: <200902101940.n1AJeqRR025883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42569 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754522AbZBJTlf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Feb 2009 14:41:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikey@neuling.org, arjan@linux.intel.com, sam@ravnborg.org


The patch titled
     bootgraph: fix for use with dot symbols
has been added to the -mm tree.  Its filename is
     bootgraph-fix-for-use-with-dot-symbols.patch

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
Subject: bootgraph: fix for use with dot symbols
From: Michael Neuling <mikey@neuling.org>

powerpc has dot symbols, so the dmesg output looks like:

<4>[    0.327310] calling  .migration_init+0x0/0x9c @ 1
<4>[    0.327595] initcall .migration_init+0x0/0x9c returned 1 after 0 usecs

The below fixes bootgraph.pl so it handles this correctly.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bootgraph.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/bootgraph.pl~bootgraph-fix-for-use-with-dot-symbols scripts/bootgraph.pl
--- a/scripts/bootgraph.pl~bootgraph-fix-for-use-with-dot-symbols
+++ a/scripts/bootgraph.pl
@@ -51,7 +51,7 @@ my %pidctr;
 
 while (<>) {
 	my $line = $_;
-	if ($line =~ /([0-9\.]+)\] calling  ([a-zA-Z0-9\_]+)\+/) {
+	if ($line =~ /([0-9\.]+)\] calling  ([a-zA-Z0-9\_\.]+)\+/) {
 		my $func = $2;
 		if ($done == 0) {
 			$start{$func} = $1;
@@ -87,7 +87,7 @@ while (<>) {
 		$count = $count + 1;
 	}
 
-	if ($line =~ /([0-9\.]+)\] initcall ([a-zA-Z0-9\_]+)\+.*returned/) {
+	if ($line =~ /([0-9\.]+)\] initcall ([a-zA-Z0-9\_\.]+)\+.*returned/) {
 		if ($done == 0) {
 			$end{$2} = $1;
 			$maxtime = $1;
_

Patches currently in -mm which might be from mikey@neuling.org are

bootgraph-fix-for-use-with-dot-symbols.patch

