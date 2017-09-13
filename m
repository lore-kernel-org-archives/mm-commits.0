From: akpm@linux-foundation.org
Subject: [folded-merged]
 treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
 removed from -mm tree
Date: Wed, 13 Sep 2017 16:24:54 -0700
Message-ID: <59b9be46.HleR5lus7hCSiTCZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56204 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbdIMXYz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2017 19:24:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch

This patch was dropped because it was folded into treewide-remove-gfp_temporary-allocation-flag.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 0123456789ab ("commit description")'
#4: 
GFP_TEMPORARY was been introduced by e12ba74d8ff3 ("Group short-lived and

ERROR: "(foo*)" should be "(foo *)"
#588: FILE: fs/proc/base.c:1632:
+	char *tmp = (char*)__get_free_page(GFP_KERNEL);

total: 2 errors, 0 warnings, 451 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/treewide-remove-gfp_temporary-allocation-flag.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/base.c~treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes fs/proc/base.c
--- a/fs/proc/base.c~treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes
+++ a/fs/proc/base.c
@@ -1630,7 +1630,7 @@ out:
 
 static int do_proc_readlink(struct path *path, char __user *buffer, int buflen)
 {
-	char *tmp = (char*)__get_free_page(GFP_KERNEL);
+	char *tmp = (char *)__get_free_page(GFP_KERNEL);
 	char *pathname;
 	int len;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-media-cec-cec-adapc-fix-build-with-gcc-444.patch
treewide-remove-gfp_temporary-allocation-flag.patch

