From: akpm@linux-foundation.org
Subject: + nvme-dont-allocate-unused-nvme_major-fix.patch added to -mm
 tree
Date: Fri, 03 Jun 2016 15:32:45 -0700
Message-ID: <5752058d.o6TiwR+Pf9cr+Y68%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52795 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbcFCWcr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2016 18:32:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@fb.com, gregkh@linuxfoundation.org, keith.busch@intel.com, maximlevitsky@gmail.com, neilb@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nvme-dont-allocate-unused-nvme_major-fix
has been added to the -mm tree.  Its filename is
     nvme-dont-allocate-unused-nvme_major-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nvme-dont-allocate-unused-nvme_major-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nvme-dont-allocate-unused-nvme_major-fix.patch

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
Subject: nvme-dont-allocate-unused-nvme_major-fix

one unregister_blkdev() was missed

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jens Axboe <axboe@fb.com>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: NeilBrown <neilb@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nvme/host/core.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/nvme/host/core.c~nvme-dont-allocate-unused-nvme_major-fix drivers/nvme/host/core.c
--- a/drivers/nvme/host/core.c~nvme-dont-allocate-unused-nvme_major-fix
+++ a/drivers/nvme/host/core.c
@@ -1867,7 +1867,6 @@ void nvme_core_exit(void)
 {
 	class_destroy(nvme_class);
 	__unregister_chrdev(nvme_char_major, 0, NVME_MINORS, "nvme");
-	unregister_blkdev(nvme_major, "nvme");
 }
 
 MODULE_LICENSE("GPL");
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
nvme-dont-allocate-unused-nvme_major-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

