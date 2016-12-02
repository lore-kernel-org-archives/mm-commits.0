From: akpm@linux-foundation.org
Subject: [merged]
 powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch removed from -mm tree
Date: Fri, 02 Dec 2016 15:45:49 -0800
Message-ID: <584207ad.agrLFMuqW7yDO5X7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59076 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753364AbcLBXpe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2016 18:45:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, benh@kernel.crashing.org, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, hpa@zytor.com, mingo@redhat.com, mpe@ellerman.id.au, paulus@samba.org, sfr@canb.auug.org.au, sklar@linux.vnet.ibm.com, stewart@linux.vnet.ibm.com, tglx@linutronix.de, vgoyal@redhat.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: enable CONFIG_KEXEC_FILE in powerpc server defconfigs
has been removed from the -mm tree.  Its filename was
     powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: powerpc: enable CONFIG_KEXEC_FILE in powerpc server defconfigs

Enable CONFIG_KEXEC_FILE in powernv_defconfig, ppc64_defconfig and
pseries_defconfig.

It depends on CONFIG_CRYPTO_SHA256=y, so add that as well.

Link: http://lkml.kernel.org/r/1480423554-6411-9-git-send-email-mpe@ellerman.id.au
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Josh Sklar <sklar@linux.vnet.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
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
@@ -299,6 +300,7 @@ CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPT_CRC32C_VPMSUM=m
 CONFIG_CRYPTO_MD5_PPC=m
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
@@ -335,6 +336,7 @@ CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPT_CRC32C_VPMSUM=m
 CONFIG_CRYPTO_MD5_PPC=m
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
@@ -298,6 +299,7 @@ CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPT_CRC32C_VPMSUM=m
 CONFIG_CRYPTO_MD5_PPC=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
+CONFIG_CRYPTO_SHA256=y
 CONFIG_CRYPTO_TGR192=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
_

Patches currently in -mm which might be from bauerman@linux.vnet.ibm.com are

powerpc-ima-get-the-kexec-buffer-passed-by-the-previous-kernel.patch
powerpc-ima-send-the-kexec-buffer-to-the-next-kernel.patch

