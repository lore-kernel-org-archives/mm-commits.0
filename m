From: akpm@linux-foundation.org
Subject: + checkpatch-add-warning-for-uses-of-printk_ratelimit.patch added to -mm tree
Date: Wed, 01 Jun 2011 16:47:00 -0700
Message-ID: <201106012347.p51Nl08E016889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754785Ab1FAXrP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2011 19:47:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com, richard@nod.at


The patch titled
     checkpatch: add warning for uses of printk_ratelimit
has been added to the -mm tree.  Its filename is
     checkpatch-add-warning-for-uses-of-printk_ratelimit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: add warning for uses of printk_ratelimit
From: Joe Perches <joe@perches.com>

Warn about uses of printk_ratelimit() because it uses a global state and
can hide subsequent useful messages.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-warning-for-uses-of-printk_ratelimit scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-warning-for-uses-of-printk_ratelimit
+++ a/scripts/checkpatch.pl
@@ -1943,6 +1943,11 @@ sub process {
 			WARN("LINUX_VERSION_CODE should be avoided, code should be for the version to which it is merged\n" . $herecurr);
 		}
 
+# check for uses of printk_ratelimit
+		if ($line =~ /\bprintk_ratelimit\s*\(/) {
+			WARN("Prefer printk_ratelimited or pr_<level>_ratelimited to printk_ratelimit\n" . $herecurr);
+		}
+
 # printk should use KERN_* levels.  Note that follow on printk's on the
 # same line do not need a level, so we use the current block context
 # to try and find and validate the current printk.  In summary the current
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-add-warning-for-uses-of-printk_ratelimit.patch
linux-next.patch
drivers-use-kzalloc-kcalloc-instead-of-kmallocmemset-where-possible.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch

