From: akpm@linux-foundation.org
Subject: + checkpatch-allow-longer-logging-function-names.patch added to
 -mm tree
Date: Wed, 26 Jun 2013 15:37:06 -0700
Message-ID: <51cb6d12.qnk5COtxyyJNlwHz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3FZWhH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jun 2013 18:37:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, jeffrey.t.kirsher@intel.com, aaron.f.brown@intel.com, jacob.e.keller@intel.com

Subject: + checkpatch-allow-longer-logging-function-names.patch added to -mm tree
To: jacob.e.keller@intel.com,aaron.f.brown@intel.com,jeffrey.t.kirsher@intel.com,joe@perches.com
From: akpm@linux-foundation.org
Date: Wed, 26 Jun 2013 15:37:06 -0700


The patch titled
     Subject: checkpatch: allow longer logging function names
has been added to the -mm tree.  Its filename is
     checkpatch-allow-longer-logging-function-names.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jacob Keller <jacob.e.keller@intel.com>
Subject: checkpatch: allow longer logging function names

The current $logFunction regular expression allows names like dev_warn,
e_dbg, netdev_info, etc, but some log functions are now written like
e_dev_warn, so allow 1 or 2 word blocks with an underscore before the
logging level.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-allow-longer-logging-function-names scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-allow-longer-logging-function-names
+++ a/scripts/checkpatch.pl
@@ -281,7 +281,7 @@ our $typeTypedefs = qr{(?x:
 
 our $logFunctions = qr{(?x:
 	printk(?:_ratelimited|_once|)|
-	[a-z0-9]+_(?:printk|emerg|alert|crit|err|warning|warn|notice|info|debug|dbg|vdbg|devel|cont|WARN)(?:_ratelimited|_once|)|
+	(?:[a-z0-9]+_){1,2}(?:printk|emerg|alert|crit|err|warning|warn|notice|info|debug|dbg|vdbg|devel|cont|WARN)(?:_ratelimited|_once|)|
 	WARN(?:_RATELIMIT|_ONCE|)|
 	panic|
 	MODULE_[A-Z_]+
_

Patches currently in -mm which might be from jacob.e.keller@intel.com are

linux-next.patch
checkpatch-allow-longer-logging-function-names.patch

