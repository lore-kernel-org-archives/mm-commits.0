From: akpm@linux-foundation.org
Subject: [merged] kexec-export-kernel_image_size-to-vmcoreinfo.patch
 removed from -mm tree
Date: Fri, 11 Sep 2015 11:13:28 -0700
Message-ID: <55f319c8.bPX1M1GwRlX9kALS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54039 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbbIKSN2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:13:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, keescook@chromium.org, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: export KERNEL_IMAGE_SIZE to vmcoreinfo
has been removed from the -mm tree.  Its filename was
     kexec-export-kernel_image_size-to-vmcoreinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: kexec: export KERNEL_IMAGE_SIZE to vmcoreinfo

In x86_64, since v2.6.26 the KERNEL_IMAGE_SIZE is changed to 512M, and
accordingly the MODULES_VADDR is changed to 0xffffffffa0000000.  However,
in v3.12 Kees Cook introduced kaslr to randomise the location of kernel. 
And the kernel text mapping addr space is enlarged from 512M to 1G.  That
means now KERNEL_IMAGE_SIZE is variable, its value is 512M when kaslr
support is not compiled in and 1G when kaslr support is compiled in. 
Accordingly the MODULES_VADDR is changed too to be:

    #define MODULES_VADDR    (__START_KERNEL_map + KERNEL_IMAGE_SIZE)

So when kaslr is compiled in and enabled, the kernel text mapping addr
space and modules vaddr space need be adjusted.  Otherwise makedumpfile
will collapse since the addr for some symbols is not correct.

Hence KERNEL_IMAGE_SIZE need be exported to vmcoreinfo and got in
makedumpfile to help calculate MODULES_VADDR.

Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/kexec_core.c~kexec-export-kernel_image_size-to-vmcoreinfo kernel/kexec_core.c
--- a/kernel/kexec_core.c~kexec-export-kernel_image_size-to-vmcoreinfo
+++ a/kernel/kexec_core.c
@@ -1417,6 +1417,9 @@ static int __init crash_save_vmcoreinfo_
 #endif
 	VMCOREINFO_NUMBER(PG_head_mask);
 	VMCOREINFO_NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE);
+#ifdef CONFIG_X86
+	VMCOREINFO_NUMBER(KERNEL_IMAGE_SIZE);
+#endif
 #ifdef CONFIG_HUGETLBFS
 	VMCOREINFO_SYMBOL(free_huge_page);
 #endif
_

Patches currently in -mm which might be from bhe@redhat.com are


