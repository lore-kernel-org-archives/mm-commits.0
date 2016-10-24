From: akpm@linux-foundation.org
Subject: +
 powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch added
 to -mm tree
Date: Mon, 24 Oct 2016 12:42:44 -0700
Message-ID: <580e6434.Kuz+boYw836gDxlS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56718 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941071AbcJXTmp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2016 15:42:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, andreas.steffen@strongswan.org, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, mpe@ellerman.id.au, sklar@linux.vnet.ibm.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


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

Link: http://lkml.kernel.org/r/1477017617-8540-11-git-send-email-bauerman@linux.vnet.ibm.com
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andreas Steffen <andreas.steffen@strongswan.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Josh Sklar <sklar@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/configs/powernv_defconfig |    2 ++
 arch/powerpc/configs/ppc64_defconfig   |    2 ++
 arch/powerpc/configs/pseries_defconfig |    2 ++
 3 files changed, 6 insertions(+)

diff -puN arch/powerpc/configs/powernv_defconfig~powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs arch/powerpc/configs/powernv_defconfig
--- a/arch/powerpc/configs/powernv_defconfig~powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs
+++ a/arch/powerpc/configs/powernv_defconfig
@@ -49,6 +49,7 @@ CONFIG_BINFMT_MISC=m
 CONFIG_PPC_TRANSACTIONAL_MEM=y
 CONFIG_HOTPLUG_CPU=y
 CONFIG_KEXEC=y
+CONFIG_KEXEC_FILE=y
 CONFIG_IRQ_ALL_CPUS=y
 CONFIG_NUMA=y
 CONFIG_MEMORY_HOTPLUG=y
@@ -301,6 +302,7 @@ CONFIG_CRYPTO_CCM=m
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
@@ -46,6 +46,7 @@ CONFIG_HZ_100=y
 CONFIG_BINFMT_MISC=m
 CONFIG_PPC_TRANSACTIONAL_MEM=y
 CONFIG_KEXEC=y
+CONFIG_KEXEC_FILE=y
 CONFIG_CRASH_DUMP=y
 CONFIG_IRQ_ALL_CPUS=y
 CONFIG_MEMORY_HOTREMOVE=y
@@ -336,6 +337,7 @@ CONFIG_CRYPTO_TEST=m
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
@@ -52,6 +52,7 @@ CONFIG_HZ_100=y
 CONFIG_BINFMT_MISC=m
 CONFIG_PPC_TRANSACTIONAL_MEM=y
 CONFIG_KEXEC=y
+CONFIG_KEXEC_FILE=y
 CONFIG_IRQ_ALL_CPUS=y
 CONFIG_MEMORY_HOTPLUG=y
 CONFIG_MEMORY_HOTREMOVE=y
@@ -303,6 +304,7 @@ CONFIG_CRYPTO_TEST=m
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
powerpc-factor-out-relocation-code-in-module_64c.patch
powerpc-implement-kexec_file_load.patch
powerpc-add-functions-to-read-elf-files-of-any-endianness.patch
powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load.patch
powerpc-add-purgatory-for-kexec_file_load-implementation.patch
powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch
powerpc-ima-get-the-kexec-buffer-passed-by-the-previous-kernel.patch
powerpc-ima-send-the-kexec-buffer-to-the-next-kernel.patch

