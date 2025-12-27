Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A741A9F83;
	Thu,  1 Jan 2026 02:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767234613; cv=none; b=vFxoT3sUDYPceOf+awY6H50j53yMw4pkAhuZMh6HH08LKJGXm0DDXi2PPwCYwB6AfHss2XsLPBCbJ60xr4AFbDRjdLH2/SY68zCRVheKBD6Le+Wp5Hze9f7ezWQrw8Ar6r368eGiBbQnEQkycVfkDnjJgdSDrEREgyjzp7Xpdpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767234613; c=relaxed/simple;
	bh=oSt2XV2wFTQQykOA1KDDTOAzuHJ1cHjhZGK0S33zcY4=;
	h=Date:To:From:Subject:Message-Id; b=YlC2KsVx2mi/PkCme+lTHzuQdkowdBdfUmI6NqlE3jUpq3YHfmf+s1z34tHNpyOCZ51tAGl1a9Lhh3j3/ZuSCo/j7x3o2VmjVhtYsV5W20jmFMzP9yzeCQtElDkJspF0ga6swMLYaq3HYF8ro5iU+hfqYaIW2taBccD+CiosYzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yHa0VJdU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yHa0VJdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310DEC113D0;
	Thu,  1 Jan 2026 02:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767234612;
	bh=oSt2XV2wFTQQykOA1KDDTOAzuHJ1cHjhZGK0S33zcY4=;
	h=Date:To:From:Subject:From;
	b=yHa0VJdUf0ims0lZGO920GYyJeXhgpkY7Kmj4q1GSOuxDtd4MUBZ8YksvTD1xN7pZ
	 MRHQ2G5BmqFR24XOg3yDwkhOW/NZkNigePFXsMse1y/EfrMfu2saGHd7WxwWvQHHpR
	 xmH4wyEHi368VACo3RNlW3DZJroVne8fI/EmlpAU=
Date: Wed, 31 Dec 2025 18:30:11 +9900
To: mm-commits@vger.kernel.org,zohar@linux.ibm.com,yifei.l.liu@oracle.com,tglx@linutronix.de,stable@vger.kernel.org,sourabhjain@linux.ibm.com,sohil.mehta@intel.com,rppt@kernel.org,paul.x.webb@oracle.com,noodles@fb.com,mingo@redhat.com,joel.granados@kernel.org,jbohac@suse.cz,hpa@zytor.com,henry.willard@oracle.com,guoweikang.kernel@gmail.com,graf@amazon.com,bp@alien8.de,bhe@redhat.com,ardb@kernel.org,harshit.m.mogalapalli@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ima-verify-the-previous-kernels-ima-buffer-lies-in-addressable-ram.patch added to mm-nonmm-unstable branch
Message-Id: <20260101023012.310DEC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ima: verify the previous kernel's IMA buffer lies in addressable RAM
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ima-verify-the-previous-kernels-ima-buffer-lies-in-addressable-ram.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ima-verify-the-previous-kernels-ima-buffer-lies-in-addressable-ram.patch

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
Subject: ima: verify the previous kernel's IMA buffer lies in addressable RAM
Date: Tue, 30 Dec 2025 22:16:07 -0800

Patch series "Address page fault in ima_restore_measurement_list()", v3.

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

Link: https://lkml.kernel.org/r/20251231061609.907170-1-harshit.m.mogalapalli@oracle.com
Link: https://lkml.kernel.org/r/20251231061609.907170-2-harshit.m.mogalapalli@oracle.com
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
Cc: Baoquan He <bhe@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ima.h                |    1 
 security/integrity/ima/ima_kexec.c |   35 +++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

--- a/include/linux/ima.h~ima-verify-the-previous-kernels-ima-buffer-lies-in-addressable-ram
+++ a/include/linux/ima.h
@@ -69,6 +69,7 @@ static inline int ima_measure_critical_d
 #ifdef CONFIG_HAVE_IMA_KEXEC
 int __init ima_free_kexec_buffer(void);
 int __init ima_get_kexec_buffer(void **addr, size_t *size);
+int ima_validate_range(phys_addr_t phys, size_t size);
 #endif
 
 #ifdef CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT
--- a/security/integrity/ima/ima_kexec.c~ima-verify-the-previous-kernels-ima-buffer-lies-in-addressable-ram
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

ima-verify-the-previous-kernels-ima-buffer-lies-in-addressable-ram.patch
of-kexec-refactor-ima_get_kexec_buffer-to-use-ima_validate_range.patch
x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer.patch

