Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB532D8382;
	Tue, 30 Dec 2025 20:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767127353; cv=none; b=Cf2XbkBkNRVlxfbUAMYpXf5LjucGzsQ6kYmbZIF/ApMWKe4FyHrLF2OdYt0ObGpbvmk20vSu8bj9uNJrMVgTysBYfLoJKMeloPYugJJ83bMK5NEbQvi7tsQJ5p7DFTJBuCr5tJs5hMgKxvSFRBu6q0fcePA/UApfiLaPAAXpmIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767127353; c=relaxed/simple;
	bh=P5/7atsr6bO2FNbUlf6MPowwiI+SF9ETEEmsCIuVhYs=;
	h=Date:To:From:Subject:Message-Id; b=X1melZojRCCFIcr8HwGAxV3wClRh0wh979ln+hIwL5oCqH120T6ZNFYzmoem+qzzq4KQ0EYPYTmksXW/19g3bfu0iQVpnuQzMYdKyJF18uavxQrACQByOVYLw5gzj52eJ6Fe2D/uZ0qpdh8pYW9/ACEX15rtbp39qygMsMfFjbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J+MWHrke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J+MWHrke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99937C4CEFB;
	Tue, 30 Dec 2025 20:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767127352;
	bh=P5/7atsr6bO2FNbUlf6MPowwiI+SF9ETEEmsCIuVhYs=;
	h=Date:To:From:Subject:From;
	b=J+MWHrkeM82c+nG011/arSi9K9/9Gny1PvC022pQyYFoB7WsOuBKH4vbtwQlQ2jNa
	 8sGC3KQtm/hcgcZjHdULv72sjUGxsBDcCRe2TLKdyTQR20N+Zg3fqKUbPSzOw/bpko
	 vBRmRcvfbByo+tmj038CNLEBEp3QNRVCni/Zfi4s=
Date: Tue, 30 Dec 2025 12:42:31 -0800
To: mm-commits@vger.kernel.org,zohar@linux.ibm.com,yifei.l.liu@oracle.com,tglx@linutronix.de,stable@vger.kernel.org,sourabhjain@linux.ibm.com,sohil.mehta@intel.com,rppt@kernel.org,paul.x.webb@oracle.com,noodles@fb.com,mingo@redhat.com,joel.granados@kernel.org,jbohac@suse.cz,hpa@zytor.com,henry.willard@oracle.com,guoweikang.kernel@gmail.com,graf@amazon.com,bp@alien8.de,ardb@kernel.org,harshit.m.mogalapalli@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ima-add-ima_validate_range-for-previous-kernel-ima-buffer.patch added to mm-nonmm-unstable branch
Message-Id: <20251230204232.99937C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ima: add ima_validate_range() for previous kernel IMA buffer
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ima-add-ima_validate_range-for-previous-kernel-ima-buffer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ima-add-ima_validate_range-for-previous-kernel-ima-buffer.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: ima: add ima_validate_range() for previous kernel IMA buffer
Date: Mon, 29 Dec 2025 00:15:21 -0800

Patch series "Address page fault in ima_restore_measurement_list()", v2.

When the second-stage kernel is booted via kexec with a limiting command
line such as "mem=<size>" we observe a pafe fault that happens.

    BUG: unable to handle page fault for address: ffff97793ff47000
    RIP: ima_restore_measurement_list+0xdc/0x45a
    #PF: error_code(0x0000)  not-present page

This happens on x86_64 only, as this is already fixed in aarch64 in
commit: cbf9c4b9617b ("of: check previous kernel's ima-kexec-buffer
against memory bounds")


This patch (of 3):

When the second-stage kernel is booted with a limiting command line (e.g. 
"mem=<size>"), the IMA measurement buffer handed over from the previous
kernel may fall outside the addressable RAM of the new kernel.  Accessing
such a buffer can fault during early restore.

Introduce a small generic helper, ima_validate_range(), which verifies
that a physical [start, end] range for the previous-kernel IMA buffer lies
within addressable memory:
	- On x86, use pfn_range_is_mapped().
	- On OF based architectures, use page_is_ram().

Link: https://lkml.kernel.org/r/20251229081523.622515-1-harshit.m.mogalapalli@oracle.com
Link: https://lkml.kernel.org/r/20251229081523.622515-2-harshit.m.mogalapalli@oracle.com
Fixes: b69a2afd5afc ("x86/kexec: Carry forward IMA measurement log on kexec")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: guoweikang <guoweikang.kernel@gmail.com>
Cc: Henry Willard <henry.willard@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Jonathan McDowell <noodles@fb.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Paul Webb <paul.x.webb@oracle.com>
Cc: Sohil Mehta <sohil.mehta@intel.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Yifei Liu <yifei.l.liu@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ima.h                |    1 
 security/integrity/ima/ima_kexec.c |   35 +++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

--- a/include/linux/ima.h~ima-add-ima_validate_range-for-previous-kernel-ima-buffer
+++ a/include/linux/ima.h
@@ -69,6 +69,7 @@ static inline int ima_measure_critical_d
 #ifdef CONFIG_HAVE_IMA_KEXEC
 int __init ima_free_kexec_buffer(void);
 int __init ima_get_kexec_buffer(void **addr, size_t *size);
+int ima_validate_range(phys_addr_t phys, size_t size);
 #endif
 
 #ifdef CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT
--- a/security/integrity/ima/ima_kexec.c~ima-add-ima_validate_range-for-previous-kernel-ima-buffer
+++ a/security/integrity/ima/ima_kexec.c
@@ -12,6 +12,8 @@
 #include <linux/kexec.h>
 #include <linux/of.h>
 #include <linux/ima.h>
+#include <linux/mm.h>
+#include <linux/overflow.h>
 #include <linux/reboot.h>
 #include <asm/page.h>
 #include "ima.h"
@@ -294,3 +296,36 @@ void __init ima_load_kexec_buffer(void)
 		pr_debug("Error restoring the measurement list: %d\n", rc);
 	}
 }
+
+/*
+ * ima_validate_range - verify a physical buffer lies in addressable RAM
+ * @phys: physical start address of the buffer from previous kernel
+ * @size: size of the buffer
+ *
+ * On success return 0. On failure returns -EINVAL so callers can skip
+ * restoring.
+ */
+int ima_validate_range(phys_addr_t phys, size_t size)
+{
+	unsigned long start_pfn, end_pfn;
+	phys_addr_t end_phys;
+
+	if (check_add_overflow(phys, (phys_addr_t)size - 1, &end_phys))
+		return -EINVAL;
+
+	start_pfn = PHYS_PFN(phys);
+	end_pfn = PHYS_PFN(end_phys);
+
+#ifdef CONFIG_X86
+	if (!pfn_range_is_mapped(start_pfn, end_pfn))
+#else
+	if (!page_is_ram(start_pfn) || !page_is_ram(end_pfn))
+#endif
+	{
+		pr_warn("IMA: previous kernel measurement buffer %pa (size 0x%zx) lies outside available memory\n",
+			&phys, size);
+		return -EINVAL;
+	}
+
+	return 0;
+}
_

Patches currently in -mm which might be from harshit.m.mogalapalli@oracle.com are

ima-add-ima_validate_range-for-previous-kernel-ima-buffer.patch
of-kexec-refactor-ima_get_kexec_buffer-to-use-ima_validate_range.patch
x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer.patch

