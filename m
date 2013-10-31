From: akpm@linux-foundation.org
Subject: + drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
 added to -mm tree
Date: Thu, 31 Oct 2013 14:42:48 -0700
Message-ID: <5272ced8.CbdR6G6VG7Tf0Bd3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33940 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab3JaVmt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Oct 2013 17:42:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, scameron@beardog.cce.hp.com, axboe@kernel.dk, akpm@linux-foundation.org

Subject: + drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch added to -mm tree
To: akpm@linux-foundation.org,axboe@kernel.dk,scameron@beardog.cce.hp.com
From: akpm@linux-foundation.org
Date: Thu, 31 Oct 2013 14:42:48 -0700


The patch titled
     Subject: drivers/block/cciss.c:cciss_init_one(): use proper errnos
has been added to the -mm tree.  Its filename is
     drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch

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
Subject: drivers/block/cciss.c:cciss_init_one(): use proper errnos

pci_driver.probe should return a meaningful errno, not -1.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/cciss.c~drivers-block-ccissc-cciss_init_one-use-proper-errnos drivers/block/cciss.c
--- a/drivers/block/cciss.c~drivers-block-ccissc-cciss_init_one-use-proper-errnos
+++ a/drivers/block/cciss.c
@@ -5004,7 +5004,7 @@ reinit_after_soft_reset:
 
 	i = alloc_cciss_hba(pdev);
 	if (i < 0)
-		return -1;
+		return -ENOMEM;
 
 	h = hba[i];
 	h->pdev = pdev;
@@ -5205,7 +5205,7 @@ clean_no_release_regions:
 	 */
 	pci_set_drvdata(pdev, NULL);
 	free_hba(h);
-	return -1;
+	return -ENODEV;
 }
 
 static void cciss_shutdown(struct pci_dev *pdev)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix-fix.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
linux-next-rejects.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up-next-fix.patch
net-netfilter-ipset-ip_set_hash_netnetc-fix-build-with-older-gcc.patch
net-netfilter-ipset-ip_set_hash_netportnetc-fix-build-with-older-gccs.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix.patch
tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

