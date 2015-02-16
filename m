From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-fix-unnecessary_kern_level-false-positive.patch removed from -mm tree
Date: Mon, 16 Feb 2015 12:17:07 -0800
Message-ID: <54e25043.1FFw/YRBvZt8wSDm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbbBPURn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:17:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbonzini@redhat.com, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix UNNECESSARY_KERN_LEVEL false positive
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-unnecessary_kern_level-false-positive.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -4547,7 +4547,7 @@ sub process {
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
linux-next.patch

