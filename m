From: akpm@linux-foundation.org
Subject: + drivers-tty-serial-serial_corec-fix-uart_get_attr_port-shift.patch added to -mm tree
Date: Wed, 07 Nov 2012 13:28:58 -0800
Message-ID: <20121107212858.CA5FA100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:65320 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab2KGV3A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Nov 2012 16:29:00 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so239951qcq.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Nov 2012 13:28:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, greg@kroah.com


The patch titled
     Subject: drivers/tty/serial/serial_core.c: fix uart_get_attr_port() shift
has been added to the -mm tree.  Its filename is
     drivers-tty-serial-serial_corec-fix-uart_get_attr_port-shift.patch

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
Subject: drivers/tty/serial/serial_core.c: fix uart_get_attr_port() shift

drivers/tty/serial/serial_core.c: In function 'uart_get_attr_port':
drivers/tty/serial/serial_core.c:2412: warning: left shift count >= width of type

Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/serial/serial_core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/tty/serial/serial_core.c~drivers-tty-serial-serial_corec-fix-uart_get_attr_port-shift drivers/tty/serial/serial_core.c
--- a/drivers/tty/serial/serial_core.c~drivers-tty-serial-serial_corec-fix-uart_get_attr_port-shift
+++ a/drivers/tty/serial/serial_core.c
@@ -2407,9 +2407,13 @@ static ssize_t uart_get_attr_port(struct
 {
 	struct serial_struct tmp;
 	struct tty_port *port = dev_get_drvdata(dev);
+	unsigned long ioaddr;
 
 	uart_get_info(port, &tmp);
-	return snprintf(buf, PAGE_SIZE, "0x%lX\n", (unsigned long)(tmp.port | (tmp.port_high << HIGH_BITS_OFFSET)));
+	ioaddr = tmp.port;
+	if (HIGH_BITS_OFFSET)
+		ioaddr |= (unsigned long)tmp.port_high << HIGH_BITS_OFFSET;
+	return snprintf(buf, PAGE_SIZE, "0x%lX\n", ioaddr);
 }
 
 static ssize_t uart_get_attr_irq(struct device *dev,
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

