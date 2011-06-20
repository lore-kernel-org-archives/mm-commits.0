From: akpm@linux-foundation.org
Subject: + ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch added to -mm tree
Date: Mon, 20 Jun 2011 12:55:17 -0700
Message-ID: <201106201955.p5KJtHqH014982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750829Ab1FTTzZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 15:55:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, joe@perches.com, kyungmin.park@samsung.com, marco.stornelli@gmail.com, stevie.trujillo@gmail.com, xiyou.wangcong@gmail.com


The patch titled
     ramoops-use-module-parameters-instead-of-platform-data-if-not-avai=
lable-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     ramoops-use-module-parameters-instead-of-platform-data-if-not-avai=
lable-checkpatch-fixes.patch

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
Subject: ramoops-use-module-parameters-instead-of-platform-data-if-not-=
available-checkpatch-fixes
=46rom: Andrew Morton <akpm@linux-foundation.org>

ERROR: Invalid UTF-8, patch and commit message should be encoded in UTF=
-8
#10:=20
Cc: Am=E9rico Wang <xiyou.wangcong@gmail.com>
      ^

ERROR: that open brace { should be on the previous line
#81: FILE: drivers/char/ramoops.c:182:
+	if (ret =3D=3D -ENODEV)
+	{

ERROR: trailing whitespace
#83: FILE: drivers/char/ramoops.c:184:
+^I^I/* $

ERROR: trailing whitespace
#97: FILE: drivers/char/ramoops.c:198:
+^I^Iif (IS_ERR(dummy)) $

ERROR: trailing whitespace
#102: FILE: drivers/char/ramoops.c:203:
+^I$

total: 5 errors, 0 warnings, 87 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatc=
h or
      scripts/cleanfile

=2E/patches/ramoops-use-module-parameters-instead-of-platform-data-if-n=
ot-available.patch has style problems, please review.  If any of these =
errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Am=E9rico Wang <xiyou.wangcong@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Stevie Trujillo <stevie.trujillo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ramoops.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/char/ramoops.c~ramoops-use-module-parameters-instead-=
of-platform-data-if-not-available-checkpatch-fixes drivers/char/ramoops=
=2Ec
--- a/drivers/char/ramoops.c~ramoops-use-module-parameters-instead-of-p=
latform-data-if-not-available-checkpatch-fixes
+++ a/drivers/char/ramoops.c
@@ -179,10 +179,9 @@ static int __init ramoops_init(void)
 {
 	int ret;
 	ret =3D platform_driver_probe(&ramoops_driver, ramoops_probe);
-	if (ret =3D=3D -ENODEV)
-	{
-		/*=20
-		 * if we didn't find a platform device, we use module parameters
+	if (ret =3D=3D -ENODEV) {
+		/*
+		 * If we didn't find a platform device, we use module parameters
 		 * building platform data on the fly.
 		 */
 		dummy_data =3D kzalloc(sizeof(struct ramoops_platform_data),
@@ -195,12 +194,12 @@ static int __init ramoops_init(void)
 			NULL, 0, dummy_data,
 			sizeof(struct ramoops_platform_data));
=20
-		if (IS_ERR(dummy))=20
+		if (IS_ERR(dummy))
 			ret =3D PTR_ERR(dummy);
 		else
 			ret =3D 0;
 	}
-=09
+
 	return ret;
 }
=20
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
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
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-calibratec-calibrate_delay-tidy-up-the-pr_info-messages.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-ini=
tialize-spread-rotor-lazily-fix.patch
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
