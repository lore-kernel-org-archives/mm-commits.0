From: akpm@linux-foundation.org
Subject: +
 powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch added
 to -mm tree
Date: Fri, 16 Sep 2016 16:35:10 -0700
Message-ID: <57dc81ae.7zNSINxdtbMmGMaH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59851 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756389AbcIPXfL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2016 19:35:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, benh@kernel.crashing.org, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, hpa@zytor.com, mingo@redhat.com, mpe@ellerman.id.au, paulus@samba.org, sam@mendozajonas.com, stewart@linux.vnet.ibm.com, tglx@linutronix.de, vgoyal@redhat.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: enable CONFIG_KEXEC_FILE in powerpc server defconfigs
has been added to the -mm tree.  Its filename is
     powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: powerpc: enable CONFIG_KEXEC_FILE in powerpc server defconfigs

Enable CONFIG_KEXEC_FILE in powernv_defconfig, ppc64_defconfig and
pseries_defconfig.

It depends on CONFIG_CRYPTO_SHA256=y, so add that as well.

Link: http://lkml.kernel.org/r/1472579041-26033-14-git-send-email-bauerman@linux.vnet.ibm.com
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Samuel Mendoza-Jonas <sam@mendozajonas.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/configs/powernv_defconfig |    2 ++
 arch/powerpc/configs/ppc64_defconfig   |    2 ++
 arch/powerpc/configs/pseries_defconfig |    2 ++
 3 files changed, 6 insertions(+)

diff -puN arch/powerpc/configs/powernv_defconfig~powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs arch/powerpc/configs/powernv_defconfig
--- a/arch/powerpc/configs/powernv_defconfig~powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs
+++ a/arch/powerpc/configs/powernv_defconfig
@@ -47,6 +47,7 @@ CONFIG_BINFMT_MISC=m
 CONFIG_PPC_TRANSACTIONAL_MEM=y
 CONFIG_HOTPLUG_CPU=y
 CONFIG_KEXEC=y
+CONFIG_KEXEC_FILE=y
 CONFIG_IRQ_ALL_CPUS=y
 CONFIG_NUMA=y
 CONFIG_MEMORY_HOTPLUG=y
@@ -298,6 +299,7 @@ CONFIG_CRYPTO_CCM=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_MICHAEL_MIC=m
+CONFIG_CRYPTO_SHA256=y
 CONFIG_CRYPTO_TGR192=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
diff -puN arch/powerpc/configs/ppc64_defconfig~powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs arch/powerpc/configs/ppc64_defconfig
--- a/arch/powerpc/configs/ppc64_defconfig~powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs
+++ a/arch/powerpc/configs/ppc64_defconfig
@@ -44,6 +44,7 @@ CONFIG_HZ_100=y
 CONFIG_BINFMT_MISC=m
 CONFIG_PPC_TRANSACTIONAL_MEM=y
 CONFIG_KEXEC=y
+CONFIG_KEXEC_FILE=y
 CONFIG_CRASH_DUMP=y
 CONFIG_IRQ_ALL_CPUS=y
 CONFIG_MEMORY_HOTREMOVE=y
@@ -333,6 +334,7 @@ CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_MICHAEL_MIC=m
+CONFIG_CRYPTO_SHA256=y
 CONFIG_CRYPTO_TGR192=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
diff -puN arch/powerpc/configs/pseries_defconfig~powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs arch/powerpc/configs/pseries_defconfig
--- a/arch/powerpc/configs/pseries_defconfig~powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs
+++ a/arch/powerpc/configs/pseries_defconfig
@@ -50,6 +50,7 @@ CONFIG_HZ_100=y
 CONFIG_BINFMT_MISC=m
 CONFIG_PPC_TRANSACTIONAL_MEM=y
 CONFIG_KEXEC=y
+CONFIG_KEXEC_FILE=y
 CONFIG_IRQ_ALL_CPUS=y
 CONFIG_MEMORY_HOTPLUG=y
 CONFIG_MEMORY_HOTREMOVE=y
@@ -300,6 +301,7 @@ CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_MICHAEL_MIC=m
+CONFIG_CRYPTO_SHA256=y
 CONFIG_CRYPTO_TGR192=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
_

Patches currently in -mm which might be from bauerman@linux.vnet.ibm.com are

kexec_file-allow-arch-specific-memory-walking-for-kexec_add_buffer.patch
kexec_file-change-kexec_add_buffer-to-take-kexec_buf-as-argument.patch
kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer.patch
powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead.patch
powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c.patch
powerpc-generalize-elf64_apply_relocate_add.patch
powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load.patch
powerpc-add-functions-to-read-elf-files-of-any-endianness.patch
powerpc-implement-kexec_file_load.patch
powerpc-add-code-to-work-with-device-trees-in-kexec_file_load.patch
powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load.patch
powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load-fix.patch
powerpc-add-purgatory-for-kexec_file_load-implementation.patch
powerpc-add-purgatory-for-kexec_file_load-implementation-fix.patch
powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch
kexec_file-include-the-purgatory-segment-in-the-kexec-image-checksum.patch
kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
powerpc-kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
kexec_file-add-mechanism-to-update-kexec-segments.patch
ima-on-soft-reboot-save-the-measurement-list.patch

