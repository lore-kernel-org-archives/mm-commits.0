From: akpm@linux-foundation.org
Subject: [merged] checkpatch-if-no-filenames-then-read-stdin.patch removed from -mm tree
Date: Wed, 03 Aug 2016 11:12:48 -0700
Message-ID: <57a23420.g/AbM9nz17POVpTZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33522 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365AbcHCSNj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: allenbh@gmail.com, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: if no filenames then read stdin
has been removed from the -mm tree.  Its filename was
     checkpatch-if-no-filenames-then-read-stdin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Allen Hubbe <allenbh@gmail.com>
Subject: checkpatch: if no filenames then read stdin

If no filenames are given, then read the patch from stdin.

Link: http://lkml.kernel.org/r/a8784f291ccb5067361992bf5d41ff6cfb0ce5cb.1469830917.git.allenbh@gmail.com
Signed-off-by: Allen Hubbe <allenbh@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-if-no-filenames-then-read-stdin scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-if-no-filenames-then-read-stdin
+++ a/scripts/checkpatch.pl
@@ -228,9 +228,9 @@ if ($^V && $^V lt $minimum_perl_version)
 	}
 }
 
+#if no filenames are given, push '-' to read patch from stdin
 if ($#ARGV < 0) {
-	print "$P: no input files\n";
-	exit(1);
+	push(@ARGV, '-');
 }
 
 sub hash_save_array_words {
_

Patches currently in -mm which might be from allenbh@gmail.com are


