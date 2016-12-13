From: akpm@linux-foundation.org
Subject: [patch 116/123] checkpatch: don't try to get maintained status
 when --no-tree is given
Date: Mon, 12 Dec 2016 16:46:23 -0800
Message-ID: <584f44df.Tavi11ohC79WMaEL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42048 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932599AbcLMAqY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:46:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jerome.forissier@linaro.org, computersforpeace@gmail.com, joe@perches.com

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
