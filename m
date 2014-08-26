From: akpm@linux-foundation.org
Subject: + prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4-fix.patch
 added to -mm tree
Date: Tue, 26 Aug 2014 14:48:00 -0700
Message-ID: <53fd0090.6ivxwV0JFpYt2Pwz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:63255 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291AbaHZVsC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 17:48:02 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so1825179qap.0
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 14:48:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, gorcunov@openvz.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: headers: prctl.h -- Add missing linux/types.h
has been added to the -mm tree.  Its filename is
     prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

x86mm-fix-pte_special-versus-pte_numa.patch
mm-remove-misleading-arch_uses_numa_prot_none.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4-fix.patch

