From: akpm@linux-foundation.org
Subject: + ksm-add-ksm-kernel-shared-memory-driver-use-another-miscdevice-minor-number.patch added to -mm tree
Date: Tue, 05 May 2009 13:15:18 -0700
Message-ID: <200905052015.n45KFIUJ004945@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753230AbZEEUWv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 16:22:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ieidus@redhat.com, aarcange@redhat.com, avi@redhat.com, chrisw@redhat.com, device@lanana.org, hugh@veritas.com, nickpiggin@yahoo.com.au


The patch titled
     ksm: use another miscdevice minor number.
has been added to the -mm tree.  Its filename is
     ksm-add-ksm-kernel-shared-memory-driver-use-another-miscdevice-minor-number.patch

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
Subject: ksm: use another miscdevice minor number.
From: Izik Eidus <ieidus@redhat.com>

The old number was registered already by another project.
The new number is #234.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
Signed-off-by: Alan Cox <device@lanana.org>
Cc: Chris Wright <chrisw@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devices.txt  |    1 +
 include/linux/miscdevice.h |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN Documentation/devices.txt~ksm-add-ksm-kernel-shared-memory-driver-use-another-miscdevice-minor-number Documentation/devices.txt
--- a/Documentation/devices.txt~ksm-add-ksm-kernel-shared-memory-driver-use-another-miscdevice-minor-number
+++ a/Documentation/devices.txt
@@ -443,6 +443,7 @@ Your cooperation is appreciated.
 		231 = /dev/snapshot	System memory snapshot device
 		232 = /dev/kvm		Kernel-based virtual machine (hardware virtualization extensions)
 		233 = /dev/kmview	View-OS A process with a view
+		234 = /dev/ksm		Dynamic page sharing
 		240-254			Reserved for local use
 		255			Reserved for MISC_DYNAMIC_MINOR
 
diff -puN include/linux/miscdevice.h~ksm-add-ksm-kernel-shared-memory-driver-use-another-miscdevice-minor-number include/linux/miscdevice.h
--- a/include/linux/miscdevice.h~ksm-add-ksm-kernel-shared-memory-driver-use-another-miscdevice-minor-number
+++ a/include/linux/miscdevice.h
@@ -30,7 +30,7 @@
 #define HPET_MINOR		228
 #define FUSE_MINOR		229
 #define KVM_MINOR		232
-#define KSM_MINOR		233
+#define KSM_MINOR		234
 #define MISC_DYNAMIC_MINOR	255
 
 struct device;
_

Patches currently in -mm which might be from ieidus@redhat.com are

linux-next.patch
ksm-mmu_notifiers-add-set_pte_at_notify.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-page_wrprotect-write-protecting-page.patch
ksm-add-replace_page-change-the-page-pte-is-pointing-to.patch
ksm-add-ksm-kernel-shared-memory-driver.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
ksm-add-ksm-kernel-shared-memory-driver-fix-unsafe-pte-fetching.patch
ksm-add-ksm-kernel-shared-memory-driver-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-limiting-the-num-of-mem-regions-user-can-register-per-fd.patch
ksm-add-ksm-kernel-shared-memory-driver-dont-allow-overlap-memory-addresses-registrations.patch
ksm-add-ksm-kernel-shared-memory-driver-change-the-ksm_remove_memory_region-ioctl.patch
ksm-add-ksm-kernel-shared-memory-driver-change-the-prot-handling-to-use-the-generic-helper-functions.patch
ksm-add-ksm-kernel-shared-memory-driver-use-another-miscdevice-minor-number.patch

