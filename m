From: akpm@linux-foundation.org
Subject: [merged]
 kernel-build-bin2c-based-on-config-option-config_build_bin2c.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:43:43 -0700
Message-ID: <53ea6e6f.AbnkLiKyyZE5fSnd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:46399 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067AbaHLTno (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:44 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so2671878pab.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:43:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, bhe@redhat.com, bp@suse.de, chaowang@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, greg@kroah.com, hpa@zytor.com, luto@amacapital.net, mjg59@srcf.ucam.org, mtk.manpages@gmail.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: build bin2c based on config option CONFIG_BUILD_BIN2C
has been removed from the -mm tree.  Its filename was
     kernel-build-bin2c-based-on-config-option-config_build_bin2c.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vivek Goyal <vgoyal@redhat.com>
Subject: kernel: build bin2c based on config option CONFIG_BUILD_BIN2C

currently bin2c builds only if CONFIG_IKCONFIG=y. But bin2c will now be
used by kexec too.  So make it compilation dependent on CONFIG_BUILD_BIN2C
and this config option can be selected by CONFIG_KEXEC and CONFIG_IKCONFIG.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: WANG Chao <chaowang@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig       |    1 +
 init/Kconfig           |    5 +++++
 scripts/basic/Makefile |    2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/x86/Kconfig~kernel-build-bin2c-based-on-config-option-config_build_bin2c arch/x86/Kconfig
--- a/arch/x86/Kconfig~kernel-build-bin2c-based-on-config-option-config_build_bin2c
+++ a/arch/x86/Kconfig
@@ -1582,6 +1582,7 @@ source kernel/Kconfig.hz
 
 config KEXEC
 	bool "kexec system call"
+	select BUILD_BIN2C
 	---help---
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff -puN init/Kconfig~kernel-build-bin2c-based-on-config-option-config_build_bin2c init/Kconfig
--- a/init/Kconfig~kernel-build-bin2c-based-on-config-option-config_build_bin2c
+++ a/init/Kconfig
@@ -783,8 +783,13 @@ endchoice
 
 endmenu # "RCU Subsystem"
 
+config BUILD_BIN2C
+	bool
+	default n
+
 config IKCONFIG
 	tristate "Kernel .config support"
+	select BUILD_BIN2C
 	---help---
 	  This option enables the complete Linux kernel ".config" file
 	  contents to be saved in the kernel. It provides documentation
diff -puN scripts/basic/Makefile~kernel-build-bin2c-based-on-config-option-config_build_bin2c scripts/basic/Makefile
--- a/scripts/basic/Makefile~kernel-build-bin2c-based-on-config-option-config_build_bin2c
+++ a/scripts/basic/Makefile
@@ -9,7 +9,7 @@
 # fixdep: 	 Used to generate dependency information during build process
 
 hostprogs-y	:= fixdep
-hostprogs-$(CONFIG_IKCONFIG)     += bin2c
+hostprogs-$(CONFIG_BUILD_BIN2C)     += bin2c
 always		:= $(hostprogs-y)
 
 # fixdep is needed to compile other host programs
_

Patches currently in -mm which might be from vgoyal@redhat.com are

origin.patch

