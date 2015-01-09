From: akpm@linux-foundation.org
Subject: + mm-fix-cleancache-debugfs-directory-path.patch added to -mm
 tree
Date: Fri, 09 Jan 2015 15:48:14 -0800
Message-ID: <54b068be.srsCB4JMOonGmyDG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbbAIXsP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2015 18:48:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.jabrzyk@samsung.com, konrad.wilk@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix cleancache debugfs directory path
has been added to the -mm tree.  Its filename is
     mm-fix-cleancache-debugfs-directory-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-cleancache-debugfs-directory-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-cleancache-debugfs-directory-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marcin Jabrzyk <m.jabrzyk@samsung.com>
Subject: mm: fix cleancache debugfs directory path

Minor fixes for cleancache about wrong debugfs paths in documentation and
code comment.

Signed-off-by: Marcin Jabrzyk <m.jabrzyk@samsung.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/cleancache.txt |    2 +-
 mm/cleancache.c                 |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/vm/cleancache.txt~mm-fix-cleancache-debugfs-directory-path Documentation/vm/cleancache.txt
--- a/Documentation/vm/cleancache.txt~mm-fix-cleancache-debugfs-directory-path
+++ a/Documentation/vm/cleancache.txt
@@ -85,7 +85,7 @@ lock the page to ensure serial behavior.
 CLEANCACHE PERFORMANCE METRICS
 
 If properly configured, monitoring of cleancache is done via debugfs in
-the /sys/kernel/debug/mm/cleancache directory.  The effectiveness of cleancache
+the /sys/kernel/debug/cleancache directory.  The effectiveness of cleancache
 can be measured (across all filesystems) with:
 
 succ_gets	- number of gets that were successful
diff -puN mm/cleancache.c~mm-fix-cleancache-debugfs-directory-path mm/cleancache.c
--- a/mm/cleancache.c~mm-fix-cleancache-debugfs-directory-path
+++ a/mm/cleancache.c
@@ -25,7 +25,7 @@
 static struct cleancache_ops *cleancache_ops __read_mostly;
 
 /*
- * Counters available via /sys/kernel/debug/frontswap (if debugfs is
+ * Counters available via /sys/kernel/debug/cleancache (if debugfs is
  * properly configured.  These are for information only so are not protected
  * against increment races.
  */
_

Patches currently in -mm which might be from m.jabrzyk@samsung.com are

mm-fix-cleancache-debugfs-directory-path.patch

