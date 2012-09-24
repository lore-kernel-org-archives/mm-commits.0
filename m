From: akpm@linux-foundation.org
Subject: + c-r-prctl-fix-build-error-for-no-mmu-case.patch added to -mm tree
Date: Mon, 24 Sep 2012 15:05:54 -0700
Message-ID: <20120924220555.264C25C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:47797 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab2IXWF5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Sep 2012 18:05:57 -0400
Received: by eekb57 with SMTP id b57so145762eek.1
        for <mm-commits@vger.kernel.org>; Mon, 24 Sep 2012 15:05:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: msalter@redhat.com, gorcunov@openvz.org, stable@vger.kernel.org


The patch titled
     Subject: c/r: prctl: fix build error for no-MMU case
has been added to the -mm tree.  Its filename is
     c-r-prctl-fix-build-error-for-no-mmu-case.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

c-r-prctl-fix-build-error-for-no-mmu-case.patch
linux-next.patch
cross-arch-dont-corrupt-personality-flags-upon-exec.patch

