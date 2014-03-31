From: akpm@linux-foundation.org
Subject: + checkpatch-dont-warn-on-bitfield-spaces-around.patch added to
 -mm tree
Date: Mon, 31 Mar 2014 15:07:08 -0700
Message-ID: <5339e70c.xMfWRR7ahyLNw25x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50227 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaCaWHJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Mar 2014 18:07:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dan.carpenter@oracle.com, joe@perches.com

Subject: + checkpatch-dont-warn-on-bitfield-spaces-around.patch added to -mm tree
To: joe@perches.com,dan.carpenter@oracle.com
From: akpm@linux-foundation.org
Date: Mon, 31 Mar 2014 15:07:08 -0700


The patch titled
     Subject: checkpatch: don't warn on bitfield spaces around :
has been added to the -mm tree.  Its filename is
     checkpatch-dont-warn-on-bitfield-spaces-around.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-dont-warn-on-bitfield-spaces-around.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-dont-warn-on-bitfield-spaces-around.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3130,10 +3130,13 @@ sub process {
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

ntfs-logging-clean-up.patch
errh-use-bool-for-is_err-and-is_err_or_null.patch
maintainers-wimax-linuxwimaxorg-is-subscribers-only.patch
maintainers-addition-of-dialog-semiconductor-files.patch
maintainers-remove-venkatesh-from-hpet-move-to-credits.patch
lib-random32c-minor-cleanups-and-kdoc-fix.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-test-for-long-udelay.patch
checkpatch-dont-warn-on-some-function-pointer-return-styles.patch
checkpatch-add-checks-for-constant-non-octal-permissions.patch
checkpatch-warn-on-uses-of-__constant_foo-functions.patch
checkpatch-update-octal-permissions-warning.patch
checkpatch-avoid-sscanf-test-duplicated-messages.patch
checkpatch-fix-jiffies-comparison-and-others.patch
checkpatch-add-test-for-char-arrays-that-could-be-static-const.patch
checkpatch-use-a-more-consistent-function-argument-style.patch
checkpatch-ignore-networking-block-comment-style-first-lines-in-file.patch
checkpatch-make-return-is-not-a-function-test-quieter.patch
checkpatchpl-modify-warning-message-for-printk-usage.patch
checkpatch-improve-octal-permissions-test-speed.patch
checkpatch-check-vendor-compatible-with-dashes.patch
checkpatch-fix-spurious-vendor-compatible-warnings.patch
checkpatch-check-compatible-strings-in-c-and-h-too.patch
checkpatch-improve-the-compatible-vendor-match.patch
checkpatch-net-and-drivers-net-warn-on-missing-blank-line-after-variable-declaration.patch
scripts-checkpatchpl-__gfp_nofail-isnt-going-away.patch
checkpatch-dont-warn-on-bitfield-spaces-around.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch
checkpatchpl-add-check-for-change-id.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
befs-logging-clean-up.patch
befs-logging-clean-up-fix.patch
linux-next.patch

