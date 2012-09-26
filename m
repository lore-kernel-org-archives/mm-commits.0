From: akpm@linux-foundation.org
Subject: [merged] c-r-prctl-fix-build-error-for-no-mmu-case.patch removed from -mm tree
Date: Wed, 26 Sep 2012 12:35:37 -0700
Message-ID: <20120926193538.28DA45C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:53719 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758340Ab2IZTfk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Sep 2012 15:35:40 -0400
Received: by eaaq10 with SMTP id q10so33789eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Sep 2012 12:35:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: msalter@redhat.com, gorcunov@openvz.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: c/r: prctl: fix build error for no-MMU case
has been removed from the -mm tree.  Its filename was
     c-r-prctl-fix-build-error-for-no-mmu-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mark Salter <msalter@redhat.com>
Subject: c/r: prctl: fix build error for no-MMU case

Commit 1ad75b9e1 ("c/r: prctl: add minimal address test to PR_SET_MM")
added some address checking to prctl_set_mm() used by checkpoint-restore. 
This causes a build error for no-MMU systems:

   kernel/sys.c: In function 'prctl_set_mm':
   kernel/sys.c:1868:34: error: 'mmap_min_addr' undeclared (first use in this function)

The test for mmap_min_addr doesn't make a lot of sense for no-MMU code as
noted in commit 6e1415467.  This patch defines mmap_min_addr as 0UL in the
no-MMU case so that the compiler will optimize away tests for "addr <
mmap_min_addr".

Signed-off-by: Mark Salter <msalter@redhat.com>
Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: <stable@vger.kernel.org>	[3.6.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/security.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/security.h~c-r-prctl-fix-build-error-for-no-mmu-case include/linux/security.h
--- a/include/linux/security.h~c-r-prctl-fix-build-error-for-no-mmu-case
+++ a/include/linux/security.h
@@ -118,6 +118,7 @@ void reset_security_ops(void);
 extern unsigned long mmap_min_addr;
 extern unsigned long dac_mmap_min_addr;
 #else
+#define mmap_min_addr		0UL
 #define dac_mmap_min_addr	0UL
 #endif
 
_

Patches currently in -mm which might be from msalter@redhat.com are

origin.patch
linux-next.patch
prctl-use-access_ok-instead-of-task_size-in-prctl_set_mm.patch
cross-arch-dont-corrupt-personality-flags-upon-exec.patch

