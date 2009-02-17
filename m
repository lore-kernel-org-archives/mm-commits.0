From: akpm@linux-foundation.org
Subject: [merged] bootgraph-fix-for-use-with-dot-symbols.patch removed from -mm tree
Date: Tue, 17 Feb 2009 12:09:02 -0800
Message-ID: <200902172009.n1HK92BC001434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753303AbZBQUPQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 15:15:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikey@neuling.org, arjan@linux.intel.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     bootgraph: fix for use with dot symbols
has been removed from the -mm tree.  Its filename was
     bootgraph-fix-for-use-with-dot-symbols.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

