From: akpm@linux-foundation.org
Subject: + kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch added to
 -mm tree
Date: Fri, 03 Jun 2016 15:18:08 -0700
Message-ID: <57520220.+eDzQMJf0qD3ZfRO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbcFCWSK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2016 18:18:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, horms@verge.net.au, j-keerthy@ti.com, panand@redhat.com, rmk+kernel@arm.linux.org.uk, vgoyal@redhat.com, vitalya@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-ensure-user-memory-sizes-do-not-wrap-fix
has been added to the -mm tree.  Its filename is
     kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kexec-ensure-user-memory-sizes-do-not-wrap-fix

fix it for kexec-return-error-number-directly.patch

Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Keerthy <j-keerthy@ti.com>
Cc: Pratyush Anand <panand@redhat.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Simon Horman <horms@verge.net.au>
Cc: Vitaly Andrianov <vitalya@ti.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kexec_core.c~kexec-ensure-user-memory-sizes-do-not-wrap-fix kernel/kexec_core.c
--- a/kernel/kexec_core.c~kexec-ensure-user-memory-sizes-do-not-wrap-fix
+++ a/kernel/kexec_core.c
@@ -169,7 +169,7 @@ int sanity_check_segment_list(struct kim
 		mstart = image->segment[i].mem;
 		mend   = mstart + image->segment[i].memsz;
 		if (mstart > mend)
-			return result;
+			return -EADDRNOTAVAIL;
 		if ((mstart & ~PAGE_MASK) || (mend & ~PAGE_MASK))
 			return -EADDRNOTAVAIL;
 		if (mend >= KEXEC_DESTINATION_MEMORY_LIMIT)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

