From: akpm@linux-foundation.org
Subject: + checkpatch-fix-unnecessary_kern_level-false-positive.patch
 added to -mm tree
Date: Mon, 05 Jan 2015 16:14:51 -0800
Message-ID: <54ab28fb.WrKdwkR76qoRwJKk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbbAFAOw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2015 19:14:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbonzini@redhat.com, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix UNNECESSARY_KERN_LEVEL false positive
has been added to the -mm tree.  Its filename is
     checkpatch-fix-unnecessary_kern_level-false-positive.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-unnecessary_kern_level-false-positive.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-unnecessary_kern_level-false-positive.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: checkpatch: fix UNNECESSARY_KERN_LEVEL false positive

KERN_<LEVEL> is never redundant with printk_ratelimited or printk_once. 
(Except perhaps in the sense that you could use e.g.  pr_err_ratelimited
or pr_err_once, but that would apply to printk as well).

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andy Whitcroft <apw@canonical.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-unnecessary_kern_level-false-positive scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-unnecessary_kern_level-false-positive
+++ a/scripts/checkpatch.pl
@@ -4545,7 +4545,7 @@ sub process {
 		}
 
 # check for logging functions with KERN_<LEVEL>
-		if ($line !~ /printk\s*\(/ &&
+		if ($line !~ /printk(?:_ratelimited|_once)?\s*\(/ &&
 		    $line =~ /\b$logFunctions\s*\(.*\b(KERN_[A-Z]+)\b/) {
 			my $level = $1;
 			if (WARN("UNNECESSARY_KERN_LEVEL",
_

Patches currently in -mm which might be from pbonzini@redhat.com are

origin.patch
checkpatch-fix-unnecessary_kern_level-false-positive.patch

