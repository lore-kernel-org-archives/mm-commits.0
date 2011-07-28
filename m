From: akpm@linux-foundation.org
Subject: [folded] arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver-fix.patch removed from -mm tree
Date: Thu, 28 Jul 2011 13:48:55 -0700
Message-ID: <201107282048.p6SKmtv8007600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755329Ab1G1UtQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jul 2011 16:49:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Sebastien.Hinderer@ens-lyon.org, lenb@kernel.org, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     arch-x86-platform-iris-irisc-register-a-platform-device-and-a-plat=
form-driver-fix
has been removed from the -mm tree.  Its filename was
     arch-x86-platform-iris-irisc-register-a-platform-device-and-a-plat=
form-driver-fix.patch

This patch was dropped because it was folded into arch-x86-platform-iri=
s-irisc-register-a-platform-device-and-a-platform-driver.patch

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

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigne=
d-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-=
driver.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch
pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-=
re-scanning-pci-fix.patch
drivers-cdrom-cdromc-relax-check-on-dvd-manufacturer-value.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-corre=
ct-error.patch
drivers-staging-dt3155v4l-dt3155v4lc-needs-slabh.patch
drivers-staging-solo6x10-corec-needs-slabh.patch
drivers-staging-solo6x10-p2mc-needs-slabh.patch
staging-more-missing-slabh-inclusions.patch
slab-use-numa_no_node.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
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
