From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-fix-fix-use-with-a-patch-of-multiple-files.patch removed from
 -mm tree
Date: Mon, 20 Apr 2015 12:17:22 -0700
Message-ID: <553550c2.95/t4Y1wXx3uw0ZY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40137 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbbDTTLB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:11:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix --fix use with a patch of multiple files
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-fix-use-with-a-patch-of-multiple-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: fix --fix use with a patch of multiple files

If a patch touches multiple files, the --fix and --fix-inplace option
doesn't keep the proper line count and makes the new patch file not able
to be applied via bad offset line numbers when lines are added or deleted
by the --fix option.

Dunno how that extra backslash snuck in there.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-fix-use-with-a-patch-of-multiple-files scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-fix-use-with-a-patch-of-multiple-files
+++ a/scripts/checkpatch.pl
@@ -1690,7 +1690,7 @@ sub fix_inserted_deleted_lines {
 	foreach my $old_line (@{$linesRef}) {
 		my $save_line = 1;
 		my $line = $old_line;	#don't modify the array
-		if ($line =~ /^(?:\+\+\+\|\-\-\-)\s+\S+/) {	#new filename
+		if ($line =~ /^(?:\+\+\+|\-\-\-)\s+\S+/) {	#new filename
 			$delta_offset = 0;
 		} elsif ($line =~ /^\@\@ -\d+,\d+ \+\d+,\d+ \@\@/) {	#new hunk
 			$range_last_linenr = $new_linenr;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

