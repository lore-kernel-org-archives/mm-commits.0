From: akpm@linux-foundation.org
Subject: +
 checkpatch-dont-try-to-get-maintained-status-when-no-tree-is-given.patch
 added to -mm tree
Date: Mon, 17 Oct 2016 16:04:46 -0700
Message-ID: <5805590e.4DYpiHz5Xmg2J9mx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58307 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752159AbcJQXEr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2016 19:04:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jerome.forissier@linaro.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: don't try to get maintained status when --no-tree is given
has been added to the -mm tree.  Its filename is
     checkpatch-dont-try-to-get-maintained-status-when-no-tree-is-given.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-dont-try-to-get-maintained-status-when-no-tree-is-given.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-dont-try-to-get-maintained-status-when-no-tree-is-given.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jerome Forissier <jerome.forissier@linaro.org>
Subject: checkpatch: don't try to get maintained status when --no-tree is given

Fixes the following warning:
Use of uninitialized value $root in concatenation (.) or string at /path/to/checkpatch.pl line 764.

Link: http://lkml.kernel.org/r/1476719709-16668-1-git-send-email-jerome.forissier@linaro.org
Signed-off-by: Jerome Forissier <jerome.forissier@linaro.org>
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

checkpatch-dont-try-to-get-maintained-status-when-no-tree-is-given.patch

