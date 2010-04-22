From: akpm@linux-foundation.org
Subject: + kexec-fix-oops-in-crash_kernel_shrink.patch added to -mm tree
Date: Wed, 21 Apr 2010 17:47:08 -0700
Message-ID: <201004220047.o3M0l8gr019685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754602Ab0DVArv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Apr 2010 20:47:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: v.mayatskih@gmail.com, amwang@redhat.com, nhorman@tuxdriver.com


The patch titled
     kexec: fix OOPS in crash_kernel_shrink
has been added to the -mm tree.  Its filename is
     kexec-fix-oops-in-crash_kernel_shrink.patch

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
Subject: kexec: fix OOPS in crash_kernel_shrink
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>

Two "echo 0 > /sys/kernel/kexec_crash_size" OOPSes kernel.  Also content
of this file is invalid after first shrink to zero: it shows 1 instead of
0.

This patch fixes it.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Cong Wang <amwang@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/kexec.c~kexec-fix-oops-in-crash_kernel_shrink kernel/kexec.c
--- a/kernel/kexec.c~kexec-fix-oops-in-crash_kernel_shrink
+++ a/kernel/kexec.c
@@ -1134,11 +1134,9 @@ int crash_shrink_memory(unsigned long ne
 
 	free_reserved_phys_range(end, crashk_res.end);
 
-	if (start == end) {
-		crashk_res.end = end;
+	if (start == end)
 		release_resource(&crashk_res);
-	} else
-		crashk_res.end = end - 1;
+	crashk_res.end = end - 1;
 
 unlock:
 	mutex_unlock(&kexec_mutex);
_

Patches currently in -mm which might be from v.mayatskih@gmail.com are

kexec-fix-oops-in-crash_kernel_shrink.patch

