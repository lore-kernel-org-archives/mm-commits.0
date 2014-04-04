From: akpm@linux-foundation.org
Subject: [merged] checkpatch-fix-jiffies-comparison-and-others.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:34:02 -0700
Message-ID: <533f092a.QdYQD+n+xe5p4zlL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43332 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbaDDTeD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:34:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] checkpatch-fix-jiffies-comparison-and-others.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:34:02 -0700


The patch titled
     Subject: checkpatch: fix jiffies comparison and others
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-jiffies-comparison-and-others.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: fix jiffies comparison and others

checkpatch could not distinguish between a variable in a struct named
jiffies and the normal jiffies.

	foo->jiffies

would emit a "Comparing jiffies" arning.

Update the $Compare variable to do a negative look-behind for "-" when
finding a ">" so that a pointer dereference like -> isn't a comparison.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-jiffies-comparison-and-others scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-jiffies-comparison-and-others
+++ a/scripts/checkpatch.pl
@@ -296,7 +296,7 @@ our $Float_int	= qr{(?i)[0-9]+e-?[0-9]+[
 our $Float	= qr{$Float_hex|$Float_dec|$Float_int};
 our $Constant	= qr{$Float|$Binary|$Octal|$Hex|$Int};
 our $Assignment	= qr{\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=};
-our $Compare    = qr{<=|>=|==|!=|<|>};
+our $Compare    = qr{<=|>=|==|!=|<|(?<!-)>};
 our $Arithmetic = qr{\+|-|\*|\/|%};
 our $Operators	= qr{
 			<=|>=|==|!=|
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

