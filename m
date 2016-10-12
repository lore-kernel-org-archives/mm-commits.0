From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-speed-up-checking-for-filenames-in-sections-marked-obsolete.patch removed from -mm tree
Date: Wed, 12 Oct 2016 12:23:16 -0700
Message-ID: <57fe8da4.22PojYr+daamks5r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33186 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755921AbcJLTYb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:24:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: speed up checking for filenames in sections marked obsolete
has been removed from the -mm tree.  Its filename was
     checkpatch-speed-up-checking-for-filenames-in-sections-marked-obsolete.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from joe@perches.com are


