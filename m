From: akpm@linux-foundation.org
Subject: + kexec-fix-compilation-warning-on-xchgkexec_lock-0-in-kernel_kexec.patch added to -mm tree
Date: Wed, 13 Aug 2008 02:27:29 -0700
Message-ID: <200808130927.m7D9RTnr009773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752578AbYHMJ1c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 05:27:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, ebiederm@xmission.com


The patch titled
     kexec: fix compilation warning on xchg(&kexec_lock, 0) in kernel_kexec()
has been added to the -mm tree.  Its filename is
     kexec-fix-compilation-warning-on-xchgkexec_lock-0-in-kernel_kexec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

kexec-fix-compilation-warning-on-xchgkexec_lock-0-in-kernel_kexec.patch
kexec-jump-clean-up-ifdef-and-comments.patch
kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size.patch
kexec-jump-check-code-size-in-control-page.patch
kexec-jump-check-code-size-in-control-page-fix-2.patch
kexec-jump-remove-duplication-of-kexec_restart_prepare.patch
kexec-jump-in-sync-with-hibernation-implementation.patch
kexec-jump-__ftrace_enabled_save-restore.patch
kexec-jump-fix-for-ftrace.patch

