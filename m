From: akpm@linux-foundation.org
Subject: + mm-adjust-address_space_operationsmigratepage-return-code-fix.patch added to -mm tree
Date: Wed, 07 Nov 2012 13:56:41 -0800
Message-ID: <20121107215642.13538100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:49354 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab2KGV4n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Nov 2012 16:56:43 -0500
Received: by mail-qa0-f74.google.com with SMTP id a16so252206qae.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Nov 2012 13:56:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aquini@redhat.com


The patch titled
     Subject: mm-adjust-address_space_operationsmigratepage-return-code-fix
has been added to the -mm tree.  Its filename is
     mm-adjust-address_space_operationsmigratepage-return-code-fix.patch

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
Subject: mm-adjust-address_space_operationsmigratepage-return-code-fix

Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN mm/migrate.c~mm-adjust-address_space_operationsmigratepage-return-code-fix mm/migrate.c
--- a/mm/migrate.c~mm-adjust-address_space_operationsmigratepage-return-code-fix
+++ a/mm/migrate.c
@@ -996,15 +996,12 @@ int migrate_pages(struct list_head *from
 			}
 		}
 	}
-	rc = 0;
+	rc = nr_failed + retry;
 out:
 	if (!swapwrite)
 		current->flags &= ~PF_SWAPWRITE;
 
-	if (rc != MIGRATEPAGE_SUCCESS)
-		return rc;
-
-	return nr_failed + retry;
+	return rc;
 }
 
 int migrate_huge_page(struct page *hpage, new_page_t get_new_page,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-tools-testing-selftests-epoll-test_epollc-fix-build.patch
revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
irq-tsk-comm-is-an-array-fix.patch
mm.patch
mm-introduce-mm_find_pmd-fix.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty-fix.patch
slub-slub-specific-propagation-changes-fix.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix.patch
mm-check-rb_subtree_gap-correctness-fix.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes.patch
mm-vm_unmapped_area-lookup-function-checkpatch-fixes.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
mm-adjust-address_space_operationsmigratepage-return-code-fix.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility-fix.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
drivers-tty-serial-serial_corec-fix-uart_get_attr_port-shift.patch

