From: akpm@linux-foundation.org
Subject: [folded-merged]
 prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4-fix.patch removed from -mm tree
Date: Thu, 09 Oct 2014 13:37:47 -0700
Message-ID: <5436f21b.4MeIUuH8W9dYqMfD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35522 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaJIUhr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:37:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, gorcunov@openvz.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: headers: prctl.h -- Add missing linux/types.h
has been removed from the -mm tree.  Its filename was
     prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4-fix.patch

This patch was dropped because it was folded into prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3.patch

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: headers: prctl.h -- Add missing linux/types.h

Stephen reported:

 | After merging the akpm-current tree, today's linux-next build (x86_64
 | allmodconfig) failed like this:
 |
 | ./usr/include/linux/prctl.h:132: found __[us]{8,16,32,64} type without #include <linux/types.h>
 | In file included from /usr/include/x86_64-linux-gnu/sys/prctl.h:23:0,
 |                 from Documentation/prctl/disable-tsc-test.c:14:
 | ./usr/include/linux/prctl.h:132:2: error: unknown type name '__u64'
 |

Include the header needed.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/prctl.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/uapi/linux/prctl.h~prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4-fix include/uapi/linux/prctl.h
--- a/include/uapi/linux/prctl.h~prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4-fix
+++ a/include/uapi/linux/prctl.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_PRCTL_H
 #define _LINUX_PRCTL_H
 
+#include <linux/types.h>
+
 /* Values to pass as first argument to prctl() */
 
 #define PR_SET_PDEATHSIG  1  /* Second arg is a signal */
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
mm-remove-misleading-arch_uses_numa_prot_none.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4-fix-2.patch

