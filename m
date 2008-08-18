From: akpm@linux-foundation.org
Subject: - kexec-fix-compilation-warning-on-xchgkexec_lock-0-in-kernel_kexec.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:39:21 -0700
Message-ID: <200808181939.m7IJdLEV008288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762662AbYHRTjX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:39:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     kexec: fix compilation warning on xchg(&kexec_lock, 0) in kernel_kexec()
has been removed from the -mm tree.  Its filename was
     kexec-fix-compilation-warning-on-xchgkexec_lock-0-in-kernel_kexec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec: fix compilation warning on xchg(&kexec_lock, 0) in kernel_kexec()
From: Huang Ying <ying.huang@intel.com>

kernel/kexec.c: In function 'kernel_kexec':
kernel/kexec.c:1506: warning: value computed is not used

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/kexec.c~kexec-fix-compilation-warning-on-xchgkexec_lock-0-in-kernel_kexec kernel/kexec.c
--- a/kernel/kexec.c~kexec-fix-compilation-warning-on-xchgkexec_lock-0-in-kernel_kexec
+++ a/kernel/kexec.c
@@ -1503,7 +1503,8 @@ int kernel_kexec(void)
 	}
 
  Unlock:
-	xchg(&kexec_lock, 0);
+	if (!xchg(&kexec_lock, 0))
+		BUG();
 
 	return error;
 }
_

Patches currently in -mm which might be from ying.huang@intel.com are

origin.patch

