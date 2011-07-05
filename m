From: akpm@linux-foundation.org
Subject: + arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver-fix.patch added to -mm tree
Date: Tue, 05 Jul 2011 13:42:53 -0700
Message-ID: <201107052042.p65Kgrb0022808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751542Ab1GEUnK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jul 2011 16:43:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Sebastien.Hinderer@ens-lyon.org, lenb@kernel.org, mjg@redhat.com


The patch titled
     arch-x86-platform-iris-irisc-register-a-platform-device-and-a-plat=
form-driver-fix
has been added to the -mm tree.  Its filename is
     arch-x86-platform-iris-irisc-register-a-platform-device-and-a-plat=
form-driver-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: arch-x86-platform-iris-irisc-register-a-platform-device-and-a-=
platform-driver-fix
=46rom: Andrew Morton <akpm@linux-foundation.org>

- remove commented-out code
- add missing space to printk
- clean up code layout

Cc: Len Brown <lenb@kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Sh=E9rab <Sebastien.Hinderer@ens-lyon.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/iris/iris.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff -puN arch/x86/platform/iris/iris.c~arch-x86-platform-iris-irisc-re=
gister-a-platform-device-and-a-platform-driver-fix arch/x86/platform/ir=
is/iris.c
--- a/arch/x86/platform/iris/iris.c~arch-x86-platform-iris-irisc-regist=
er-a-platform-device-and-a-platform-driver-fix
+++ a/arch/x86/platform/iris/iris.c
@@ -65,14 +65,6 @@ static void iris_power_off(void)
  */
 static int iris_probe(struct platform_device *pdev)
 {
-/*
-	unsigned char status =3D inb(IRIS_GIO_INPUT);
-	if (status =3D=3D IRIS_GIO_NODEV) {
-		printk(KERN_ERR "This machine does not seem to be an Iris. "
-			"Power off handler not installed.\n");
-		return -ENODEV;
-	}
-*/
 	old_pm_power_off =3D pm_power_off;
 	pm_power_off =3D &iris_power_off;
 	printk(KERN_INFO "Iris power_off handler installed.\n");
@@ -111,17 +103,17 @@ static int iris_init(void)
 	int ret;
 	if (force !=3D 1) {
 		printk(KERN_ERR "The force parameter has not been set to 1."
-			"The Iris poweroff handler will not be installed.\n");
+			" The Iris poweroff handler will not be installed.\n");
 		return -ENODEV;
 	}
 	ret =3D platform_driver_register(&iris_driver);
 	if (ret < 0) {
-		printk(KERN_ERR "Failed to register iris platform driver: "
-			"%d\n", ret);
+		printk(KERN_ERR "Failed to register iris platform driver: %d\n",
+			ret);
 		return ret;
 	}
-	iris_device =3D platform_device_register_simple(
-		"iris", (-1), iris_resources, ARRAY_SIZE(iris_resources));
+	iris_device =3D platform_device_register_simple("iris", (-1),
+				iris_resources, ARRAY_SIZE(iris_resources));
 	if (IS_ERR(iris_device)) {
 		printk(KERN_ERR "Failed to register iris platform device\n");
 		platform_driver_unregister(&iris_driver);
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

memcg-fix-reclaimable-lru-check-in-memcg-checkpatch-fixes.patch
memcg-fix-reclaimable-lru-check-in-memcg-fix.patch
memcg-fix-numa-scan-information-update-to-be-triggered-by-memory-event-=
fix.patch
mm-preallocate-page-before-lock_page-at-filemap-cow-fix.patch
linux-next.patch
drivers-staging-makefile-cs5535_gpio-went-away.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
drivers-net-wireless-rtlwifi-rtl8192de-phyc-fix-udelay-usage.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-=
driver-fix.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-=
re-scanning-pci-fix.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-corre=
ct-error.patch
drivers-staging-gma500-psb_intel_displayc-fix-build.patch
drivers-staging-dt3155v4l-dt3155v4lc-needs-slabh.patch
drivers-staging-solo6x10-corec-needs-slabh.patch
drivers-staging-solo6x10-p2mc-needs-slabh.patch
staging-more-missing-slabh-inclusions.patch
slab-use-numa_no_node.patch
mm.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machine=
s-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
mm-memoryc-remove-zap_block_size.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
drivers-misc-add-support-the-fsa9480-usb-switch-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-a-prefer-__aligned-check.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-skip-calibration-delay-if-previously-done-4.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-ini=
tialize-spread-rotor-lazily-fix.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch
proc-pid-fdinfo-add-cloexec-information-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-cleanup.patch
ipc-introduce-shm_rmid_forced-sysctl-comments-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available=
-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
