From: akpm@linux-foundation.org
Subject: [patch 021/102] checkpatch: speed up checking for filenames in
 sections marked obsolete
Date: Tue, 11 Oct 2016 13:52:02 -0700
Message-ID: <57fd50f2.HszPrpPbu+C8kRT+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37919 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752795AbcJKUxE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:53:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com

From: Joe Perches <joe@perches.com>
Subject: checkpatch: speed up checking for filenames in sections marked obsolete

Adding -f to the get_maintainer.pl invocation means git isn't invoked
by get_maintainer.pl for known filenames.

This reduces the overall time to run checkpatch.

Link: http://lkml.kernel.org/r/22991e3a295aeb399b43af0478b6e5809106ccee.1472684066.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-speed-up-checking-for-filenames-in-sections-marked-obsolete scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-speed-up-checking-for-filenames-in-sections-marked-obsolete
+++ a/scripts/checkpatch.pl
@@ -759,7 +759,7 @@ sub is_maintained_obsolete {
 
 	return 0 if (!(-e "$root/scripts/get_maintainer.pl"));
 
-	my $status = `perl $root/scripts/get_maintainer.pl --status --nom --nol --nogit --nogit-fallback $filename 2>&1`;
+	my $status = `perl $root/scripts/get_maintainer.pl --status --nom --nol --nogit --nogit-fallback -f $filename 2>&1`;
 
 	return $status =~ /obsolete/i;
 }
_
