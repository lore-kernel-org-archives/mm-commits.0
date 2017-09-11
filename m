From: akpm@linux-foundation.org
Subject: [merged]
 extract-early-boot-entropy-from-the-passed-cmdline.patch removed from -mm
 tree
Date: Mon, 11 Sep 2017 12:43:01 -0700
Message-ID: <20170911194301.-XWB8jlYB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50378 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751110AbdIKTnC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:43:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: danielmicay@gmail.com, keescook@chromium.org, labbott@redhat.com, lauraa@codeaurora.org, mm-commits@vger.kernel.org, nnk@google.com, tytso@mit.edu


The patch titled
     Subject: init/main.c: extract early boot entropy from the passed cmdline
has been removed from the -mm tree.  Its filename was
     extract-early-boot-entropy-from-the-passed-cmdline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Micay <danielmicay@gmail.com>
Subject: init/main.c: extract early boot entropy from the passed cmdline

Feed the boot command-line as to the /dev/random entropy pool

Existing Android bootloaders usually pass data which may not be known by
an external attacker on the kernel command-line.  It may also be the case
on other embedded systems.  Sample command-line from a Google Pixel
running CopperheadOS....

    console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0
    androidboot.hardware=sailfish user_debug=31 ehci-hcd.park=3
    lpm_levels.sleep_disabled=1 cma=32M@0-0xffffffff buildvariant=user
    veritykeyid=id:dfcb9db0089e5b3b4090a592415c28e1cb4545ab
    androidboot.bootdevice=624000.ufshc androidboot.verifiedbootstate=yellow
    androidboot.veritymode=enforcing androidboot.keymaster=1
    androidboot.serialno=FA6CE0305299 androidboot.baseband=msm
    mdss_mdp.panel=1:dsi:0:qcom,mdss_dsi_samsung_ea8064tg_1080p_cmd:1:none:cfg:single_dsi
    androidboot.slot_suffix=_b fpsimd.fpsimd_settings=0
    app_setting.use_app_setting=0 kernelflag=0x00000000 debugflag=0x00000000
    androidboot.hardware.revision=PVT radioflag=0x00000000
    radioflagex1=0x00000000 radioflagex2=0x00000000 cpumask=0x00000000
    androidboot.hardware.ddr=4096MB,Hynix,LPDDR4 androidboot.ddrinfo=00000006
    androidboot.ddrsize=4GB androidboot.hardware.color=GRA00
    androidboot.hardware.ufs=32GB,Samsung androidboot.msm.hw_ver_id=268824801
    androidboot.qf.st=2 androidboot.cid=11111111 androidboot.mid=G-2PW4100
    androidboot.bootloader=8996-012001-1704121145
    androidboot.oem_unlock_support=1 androidboot.fp_src=1
    androidboot.htc.hrdump=detected androidboot.ramdump.opt=mem@2g:2g,mem@4g:2g
    androidboot.bootreason=reboot androidboot.ramdump_enable=0 ro
    root=/dev/dm-0 dm="system none ro,0 1 android-verity /dev/sda34"
    rootwait skip_initramfs init=/init androidboot.wificountrycode=US
    androidboot.boottime=1BLL:85,1BLE:669,2BLL:0,2BLE:1777,SW:6,KL:8136

Among other things, it contains a value unique to the device
(androidboot.serialno=FA6CE0305299), unique to the OS builds for the
device variant (veritykeyid=id:dfcb9db0089e5b3b4090a592415c28e1cb4545ab)
and timings from the bootloader stages in milliseconds
(androidboot.boottime=1BLL:85,1BLE:669,2BLL:0,2BLE:1777,SW:6,KL:8136).

[tytso@mit.edu: changelog tweak]
[labbott@redhat.com: line-wrapped command line]
Link: http://lkml.kernel.org/r/20170816231458.2299-3-labbott@redhat.com
Signed-off-by: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Nick Kralevich <nnk@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN init/main.c~extract-early-boot-entropy-from-the-passed-cmdline init/main.c
--- a/init/main.c~extract-early-boot-entropy-from-the-passed-cmdline
+++ a/init/main.c
@@ -530,8 +530,10 @@ asmlinkage __visible void __init start_k
 	setup_arch(&command_line);
 	/*
 	 * Set up the the initial canary and entropy after arch
+	 * and after adding latent and command line entropy.
 	 */
 	add_latent_entropy();
+	add_device_randomness(command_line, strlen(command_line));
 	boot_init_stack_canary();
 	mm_init_cpumask(&init_mm);
 	setup_command_line(command_line);
_

Patches currently in -mm which might be from danielmicay@gmail.com are


