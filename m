From: akpm@linux-foundation.org
Subject: [merged] kexec-fix-oops-in-crash_kernel_shrink.patch removed from -mm tree
Date: Wed, 12 May 2010 10:58:23 -0400
Message-ID: <201005121759.o4CHxpXn011535@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752148Ab0ELSAV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 14:00:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: v.mayatskih@gmail.com, amwang@redhat.com, nhorman@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     kexec: fix OOPS in crash_kernel_shrink
has been removed from the -mm tree.  Its filename was
     kexec-fix-oops-in-crash_kernel_shrink.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec: fix OOPS in crash_kernel_shrink
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>

Two "echo 0 > /sys/kernel/kexec_crash_size" OOPSes kernel.  Also content
of this file is invalid after first shrink to zero: it shows 1 instead of
0.

This scenario is unlikely to happen often (root privs, valid crashkernel=
in cmdline, dump-capture kernel not loaded), I hit it only by chance.

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

origin.patch

