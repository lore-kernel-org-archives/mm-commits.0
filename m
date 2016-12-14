From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-dont-try-to-get-maintained-status-when-no-tree-is-given.patch
 removed from -mm tree
Date: Wed, 14 Dec 2016 11:27:48 -0800
Message-ID: <58519d34.I+80KH+m+PLrbH23%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45850 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756690AbcLNT2C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:28:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jerome.forissier@linaro.org, computersforpeace@gmail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: don't try to get maintained status when --no-tree is given
has been removed from the -mm tree.  Its filename was
     checkpatch-dont-try-to-get-maintained-status-when-no-tree-is-given.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jerome Forissier <jerome.forissier@linaro.org>
Subject: checkpatch: don't try to get maintained status when --no-tree is given

Fixes the following warning:
Use of uninitialized value $root in concatenation (.) or string at /path/to/checkpatch.pl line 764.

Link: http://lkml.kernel.org/r/1476719709-16668-1-git-send-email-jerome.forissier@linaro.org
Signed-off-by: Jerome Forissier <jerome.forissier@linaro.org>
Reviewed-by: Brian Norris <computersforpeace@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-dont-try-to-get-maintained-status-when-no-tree-is-given scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-dont-try-to-get-maintained-status-when-no-tree-is-given
+++ a/scripts/checkpatch.pl
@@ -761,7 +761,7 @@ sub seed_camelcase_file {
 sub is_maintained_obsolete {
 	my ($filename) = @_;
 
-	return 0 if (!(-e "$root/scripts/get_maintainer.pl"));
+	return 0 if (!$tree || !(-e "$root/scripts/get_maintainer.pl"));
 
 	my $status = `perl $root/scripts/get_maintainer.pl --status --nom --nol --nogit --nogit-fallback -f $filename 2>&1`;
 
_

Patches currently in -mm which might be from jerome.forissier@linaro.org are


