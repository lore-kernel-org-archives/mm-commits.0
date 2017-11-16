From: akpm@linux-foundation.org
Subject: [folded-merged] mm-simplify-nodemask-printing-fix.patch removed
 from -mm tree
Date: Wed, 15 Nov 2017 17:12:15 -0800
Message-ID: <5a0ce5ef.sJmNjcCzUQPmMKEh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36624 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932838AbdKPBMR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:12:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, joe@perches.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-simplify-nodemask-printing-fix
has been removed from the -mm tree.  Its filename was
     mm-simplify-nodemask-printing-fix.patch

This patch was dropped because it was folded into mm-simplify-nodemask-printing.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-simplify-nodemask-printing-fix

fix tile warning, per Arnd

Cc: Joe Perches <joe@perches.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/nodemask.h~mm-simplify-nodemask-printing-fix include/linux/nodemask.h
--- a/include/linux/nodemask.h~mm-simplify-nodemask-printing-fix
+++ a/include/linux/nodemask.h
@@ -104,7 +104,9 @@ extern nodemask_t _unused_nodemask_arg_;
  *
  * Can be used to provide arguments for '%*pb[l]' when printing a nodemask.
  */
-#define nodemask_pr_args(maskp)	(maskp) ? MAX_NUMNODES : 0, (maskp) ? (maskp)->bits : NULL
+#define nodemask_pr_args(maskp)				\
+	((maskp) != NULL) ? MAX_NUMNODES : 0,		\
+	((maskp) != NULL) ? (maskp)->bits : NULL
 
 /*
  * The inline keyword gives the compiler room to decide to inline, or
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-simplify-nodemask-printing.patch
mm-make-alloc_node_mem_map-a-voidcall-if-we-dont-have-config_flat_node_mem_map-fix.patch

