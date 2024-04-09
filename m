Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5624D1386C0;
	Tue,  9 Apr 2024 19:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712690404; cv=none; b=l/W0zOvqLtS3jN25H4m4CITe8/2aDpZFxuYwKFEjLazmoTElibArZAQn5qvTUcy4obgmnI3PekeaE+Krq19d1VCR0GLJcpNkyabcoN7pUUrRGqSaHhaXCtLY/GSPOGY/LNTM8n+8YdfoZurCGfTdD9p5YhDzuN/5scimD6mRsV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712690404; c=relaxed/simple;
	bh=HTt+Pl8E3LeGv1J+tQ5NYlwq11WIQ4kjxMdnjuZFQzs=;
	h=Date:To:From:Subject:Message-Id; b=UwaVRK29P+NRfTDqNj64qcYxLKWytuRPY1zxATKCXJ7KlTwp5BTAg9oLUfF54nvVW16c1rz+npT2TpJy4fB27Zokgn4hfu8Ol4DfQ5ZFeX1zYtn/r2R6FMnCnRKKjnYG7RAmX6/Mn8a5XptBs2D0auV0L/Y5RV3R6Ryf7rLHj+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g8dvfkM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g8dvfkM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6DDC433C7;
	Tue,  9 Apr 2024 19:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712690403;
	bh=HTt+Pl8E3LeGv1J+tQ5NYlwq11WIQ4kjxMdnjuZFQzs=;
	h=Date:To:From:Subject:From;
	b=g8dvfkM5EXdCBKJGDtjcZT36peLWPjYiHCTfspfQgVxRUpYfZLZsIxyiidwEnfXbJ
	 zSlif9zy7cUtxtj/R4zNBVSqMMH6wiaXv/J+TvgFqz7YWj9kq2ZAzhxownmfLXHXpd
	 07vP/7hjRv11G6QFSlPlbyKX6eJ4jBN8QvPxqhyo=
Date: Tue, 09 Apr 2024 12:20:03 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,jirislaby@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-fix-the-unexpected-kexec_dprintk-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20240409192003.BF6DDC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec: fix the unexpected kexec_dprintk() macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-fix-the-unexpected-kexec_dprintk-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-fix-the-unexpected-kexec_dprintk-macro.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: kexec: fix the unexpected kexec_dprintk() macro
Date: Tue, 9 Apr 2024 12:22:38 +0800

Jiri reported that the current kexec_dprintk() always prints out debugging
message whenever kexec/kdmmp loading is triggered.  That is not wanted. 
The debugging message is supposed to be printed out when 'kexec -s -d' is
specified for kexec/kdump loading.

After investigating, the reason is the current kexec_dprintk() takes
printk(KERN_INFO) or printk(KERN_DEBUG) depending on whether '-d' is
specified.  However, distros usually have defaulg log level like below:

 [~]# cat /proc/sys/kernel/printk
 7       4      1       7

So, even though '-d' is not specified, printk(KERN_DEBUG) also always
prints out.  I thought printk(KERN_DEBUG) is equal to pr_debug(), it's
not.

Fix it by changing to use pr_info() instead which are expected to work.

Link: https://lkml.kernel.org/r/20240409042238.1240462-1-bhe@redhat.com
Fixes: cbc2fe9d9cb2 ("kexec_file: add kexec_file flag to control debug printing")
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Closes: https://lore.kernel.org/all/4c775fca-5def-4a2d-8437-7130b02722a2@kernel.org
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/include/linux/kexec.h~kexec-fix-the-unexpected-kexec_dprintk-macro
+++ a/include/linux/kexec.h
@@ -461,10 +461,8 @@ static inline void arch_kexec_pre_free_p
 
 extern bool kexec_file_dbg_print;
 
-#define kexec_dprintk(fmt, ...)					\
-	printk("%s" fmt,					\
-	       kexec_file_dbg_print ? KERN_INFO : KERN_DEBUG,	\
-	       ##__VA_ARGS__)
+#define kexec_dprintk(fmt, arg...) \
+        do { if (kexec_file_dbg_print) pr_info(fmt, ##arg); } while (0)
 
 #else /* !CONFIG_KEXEC_CORE */
 struct pt_regs;
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmallocc-optimize-to-reduce-arguments-of-alloc_vmap_area.patch
x86-remove-unneeded-memblock_find_dma_reserve.patch
mm-mm_initc-remove-the-useless-dma_reserve.patch
mm-mm_initc-add-new-function-calc_nr_all_pages.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core-v3.patch
mm-mm_initc-remove-unneeded-calc_memmap_size.patch
mm-mm_initc-remove-arch_reserved_kernel_pages.patch
mm-move-array-mem_section-init-code-out-of-memory_present.patch
mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node.patch
mm-make-__absent_pages_in_range-as-static.patch
mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists.patch
mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-v2.patch
mm-mm_initc-remove-the-outdated-code-comment-above-deferred_grow_zone.patch
mm-page_allocc-dont-show-protection-in-zones-lowmem_reserve-for-empty-zone.patch
mm-page_allocc-change-the-array-length-to-migrate_pcptypes.patch
arch-loongarch-clean-up-the-left-code-and-kconfig-item-related-to-crash_core.patch
documentation-kdump-clean-up-the-outdated-description.patch
kexec-fix-the-unexpected-kexec_dprintk-macro.patch

