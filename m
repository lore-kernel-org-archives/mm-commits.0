From: akpm@linux-foundation.org
Subject: [merged] checkpatch-dont-warn-on-bitfield-spaces-around.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:34:32 -0700
Message-ID: <533f0948.9/cvYS2DifQyCDLc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43425 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbaDDTed (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:34:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dan.carpenter@oracle.com, joe@perches.com

Subject: [merged] checkpatch-dont-warn-on-bitfield-spaces-around.patch removed from -mm tree
To: joe@perches.com,dan.carpenter@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:34:32 -0700


The patch titled
     Subject: checkpatch: don't warn on bitfield spaces around :
has been removed from the -mm tree.  Its filename was
     checkpatch-dont-warn-on-bitfield-spaces-around.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: don't warn on bitfield spaces around :

This test prevents code from being aligned around the : for easy visual
counting of bitfield lengths.

ie:
	int foo		: 1,
	int bar		: 2,
	int foobar	:29;

should be acceptable so remove the test.

Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-dont-warn-on-bitfield-spaces-around scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-dont-warn-on-bitfield-spaces-around
+++ a/scripts/checkpatch.pl
@@ -3138,10 +3138,13 @@ sub process {
 				# // is a comment
 				} elsif ($op eq '//') {
 
+				#   :   when part of a bitfield
+				} elsif ($opv eq ':B') {
+					# skip the bitfield test for now
+
 				# No spaces for:
 				#   ->
-				#   :   when part of a bitfield
-				} elsif ($op eq '->' || $opv eq ':B') {
+				} elsif ($op eq '->') {
 					if ($ctx =~ /Wx.|.xW/) {
 						if (ERROR("SPACING",
 							  "spaces prohibited around that '$op' $at\n" . $hereptr)) {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ntfs-logging-clean-up.patch
mm-utilc-add-kstrimdup.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

