From: akpm@linux-foundation.org
Subject: + checkpatch-fix-jiffies-comparison-and-others.patch added to -mm tree
Date: Tue, 18 Feb 2014 14:50:07 -0800
Message-ID: <5303e39f.cjA84czn9bbvq3ra%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51322 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbaBRWuI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 17:50:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-fix-jiffies-comparison-and-others.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 14:50:07 -0800


The patch titled
     Subject: checkpatch: fix jiffies comparison and others
has been added to the -mm tree.  Its filename is
     checkpatch-fix-jiffies-comparison-and-others.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-jiffies-comparison-and-others.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-jiffies-comparison-and-others.patch

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

drivers-iommu-omap-iommu-debugc-fix-decimal-permissions.patch
drivers-fmc-fmc-write-eepromc-fix-decimal-permissions.patch
lib-random32c-minor-cleanups-and-kdoc-fix.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-test-for-long-udelay.patch
checkpatch-dont-warn-on-some-function-pointer-return-styles.patch
checkpatch-add-checks-for-constant-non-octal-permissions.patch
checkpatch-warn-on-uses-of-__constant_foo-functions.patch
checkpatch-update-octal-permissions-warning.patch
checkpatch-avoid-sscanf-test-duplicated-messages.patch
checkpatch-fix-jiffies-comparison-and-others.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

