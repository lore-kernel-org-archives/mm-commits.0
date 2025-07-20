Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B1FC120
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977349; cv=none; b=X9hM3syu/6mTDCzUhL+2wvSEWM3pnYmRlWZhDK72Gcn8e9imB8O1yj6qlebVBAnbaIpIAY/Et7B0jkkSf5QV4IQ32eJZfqIym/LI9SYGUUSWxFWi0Kr2Nxv8zav6TpA2Zm5qH89Uy1eCzeO2EU58Hc9FKc9lTq12qfoni0aH6cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977349; c=relaxed/simple;
	bh=QSRdxF+nU+ZQTE538+l7cXdPZgOKPKWJzz3BkE96V/I=;
	h=Date:To:From:Subject:Message-Id; b=i3JvY/G3+WGQYnDm92asjIJwN1r4gcCfP6RQrNNCCcrw3RFisOlI/WRWjzbToTjnSW72qWTsFzxLDfvzf/ppGntuKfNNrqzk09I/ISmDcWx4KvMwReSi5k5uCCPXgelZDyRyPyyBIOH2c++/Skt0aRmc0RyXk/JRynWwF+/hVSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sbhvt/Bv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sbhvt/Bv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731C5C4CEE3;
	Sun, 20 Jul 2025 02:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977348;
	bh=QSRdxF+nU+ZQTE538+l7cXdPZgOKPKWJzz3BkE96V/I=;
	h=Date:To:From:Subject:From;
	b=sbhvt/BvTPnw7/PffVNYqGib3r11G0h8iqpv4BgWN7HCuaI/kVuoa9CmRS2n2XsH1
	 0lnCFS5DDY81vCfg3LBTa+UXKpRBUsCoWtzO5i5eYci4ns+sKOE+KEzfLmSQzZ+cmi
	 LGO7VvPQuNOy0Y3SzYVAz8Rzs31RIQxxNwPbIy40=
Date: Sat, 19 Jul 2025 19:09:07 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,prudo@redhat.com,piliu@redhat.com,mhocko@suse.cz,ltao@redhat.com,dyoung@redhat.com,ddutile@redhat.com,david@redhat.com,bhe@redhat.com,jbohac@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kdump-wait-for-dma-to-finish-when-using-cma.patch removed from -mm tree
Message-Id: <20250720020908.731C5C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kdump: wait for DMA to finish when using CMA
has been removed from the -mm tree.  Its filename was
     kdump-wait-for-dma-to-finish-when-using-cma.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiri Bohac <jbohac@suse.cz>
Subject: kdump: wait for DMA to finish when using CMA
Date: Thu, 12 Jun 2025 12:18:40 +0200

When re-using the CMA area for kdump there is a risk of pending DMA into
pinned user pages in the CMA area.

Pages residing in CMA areas can usually not get long-term pinned and are
instead migrated away from the CMA area, so long-term pinning is typically
not a concern.  (BUGs in the kernel might still lead to long-term pinning
of such pages if everything goes wrong.)

Pages pinned without FOLL_LONGTERM remain in the CMA and may possibly be
the source or destination of a pending DMA transfer.

Although there is no clear specification how long a page may be pinned
without FOLL_LONGTERM, pinning without the flag shows an intent of the
caller to only use the memory for short-lived DMA transfers, not a
transfer initiated by a device asynchronously at a random time in the
future.

Add a delay of CMA_DMA_TIMEOUT_SEC seconds before starting the kdump
kernel, giving such short-lived DMA transfers time to finish before the
CMA memory is re-used by the kdump kernel.

Set CMA_DMA_TIMEOUT_SEC to 10 seconds - chosen arbitrarily as both a huge
margin for a DMA transfer, yet not increasing the kdump time too
significantly.

Link: https://lkml.kernel.org/r/aEqpgDIBndZ5LXSo@dwarf.suse.cz
Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Donald Dutile <ddutile@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Philipp Rudo <prudo@redhat.com>
Cc: Pingfan Liu <piliu@redhat.com>
Cc: Tao Liu <ltao@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/kernel/crash_core.c~kdump-wait-for-dma-to-finish-when-using-cma
+++ a/kernel/crash_core.c
@@ -21,6 +21,7 @@
 #include <linux/reboot.h>
 #include <linux/btf.h>
 #include <linux/objtool.h>
+#include <linux/delay.h>
 
 #include <asm/page.h>
 #include <asm/sections.h>
@@ -33,6 +34,11 @@
 /* Per cpu memory for storing cpu states in case of system crash. */
 note_buf_t __percpu *crash_notes;
 
+/* time to wait for possible DMA to finish before starting the kdump kernel
+ * when a CMA reservation is used
+ */
+#define CMA_DMA_TIMEOUT_SEC 10
+
 #ifdef CONFIG_CRASH_DUMP
 
 int kimage_crash_copy_vmcoreinfo(struct kimage *image)
@@ -97,6 +103,14 @@ int kexec_crash_loaded(void)
 }
 EXPORT_SYMBOL_GPL(kexec_crash_loaded);
 
+static void crash_cma_clear_pending_dma(void)
+{
+	if (!crashk_cma_cnt)
+		return;
+
+	mdelay(CMA_DMA_TIMEOUT_SEC * 1000);
+}
+
 /*
  * No panic_cpu check version of crash_kexec().  This function is called
  * only when panic_cpu holds the current CPU number; this is the only CPU
@@ -119,6 +133,7 @@ void __noclone __crash_kexec(struct pt_r
 			crash_setup_regs(&fixed_regs, regs);
 			crash_save_vmcoreinfo();
 			machine_crash_shutdown(&fixed_regs);
+			crash_cma_clear_pending_dma();
 			machine_kexec(kexec_crash_image);
 		}
 		kexec_unlock();
_

Patches currently in -mm which might be from jbohac@suse.cz are


