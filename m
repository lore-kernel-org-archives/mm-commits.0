From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-emit-note-types-message-only-once-after-multiple-files.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:49:01 -0700
Message-ID: <5591af3d.OILs/xmVj49XlnuQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50996 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbbF2UtC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:49:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: emit "NOTE: <types>" message only once after multiple files
has been removed from the -mm tree.  Its filename was
     checkpatch-emit-note-types-message-only-once-after-multiple-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: emit "NOTE: <types>" message only once after multiple files

Make this message similar to the "false positives" message and emit it
only once when scanning multiple files instead of after each file scanned.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-emit-note-types-message-only-once-after-multiple-files scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-emit-note-types-message-only-once-after-multiple-files
+++ a/scripts/checkpatch.pl
@@ -203,7 +203,7 @@ sub hash_save_array_words {
 sub hash_show_words {
 	my ($hashRef, $prefix) = @_;
 
-	if ($quiet == 0 && keys %$hashRef) {
+	if (keys %$hashRef) {
 		print "\nNOTE: $prefix message types:";
 		foreach my $word (sort keys %$hashRef) {
 			print " $word";
@@ -770,6 +770,9 @@ for my $filename (@ARGV) {
 }
 
 if (!$quiet) {
+	hash_show_words(\%use_type, "Used");
+	hash_show_words(\%ignore_type, "Ignored");
+
 	if ($^V lt 5.10.0) {
 		print << "EOM"
 
@@ -5707,9 +5710,6 @@ EOM
 		}
 	}
 
-	hash_show_words(\%use_type, "Used");
-	hash_show_words(\%ignore_type, "Ignored");
