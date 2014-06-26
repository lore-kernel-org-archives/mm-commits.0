From: akpm@linux-foundation.org
Subject: +
 kernel-build-bin2c-based-on-config-option-config_build_bin2c.patch added to -mm tree
Date: Thu, 26 Jun 2014 14:08:42 -0700
Message-ID: <53ac8bda.JH5iWWoDyLXZ+Xco%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60917 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaFZVIn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jun 2014 17:08:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, bhe@redhat.com, bp@suse.de, chaowang@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, greg@kroah.com, hpa@zytor.com, luto@amacapital.net, mjg59@srcf.ucam.org, mtk.manpages@gmail.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: build bin2c based on config option CONFIG_BUILD_BIN2C
has been added to the -mm tree.  Its filename is
     kernel-build-bin2c-based-on-config-option-config_build_bin2c.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-build-bin2c-based-on-config-option-config_build_bin2c.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-build-bin2c-based-on-config-option-config_build_bin2c.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1576,6 +1576,7 @@ source kernel/Kconfig.hz
 
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
bin2c-move-bin2c-in-scripts-basic.patch
kernel-build-bin2c-based-on-config-option-config_build_bin2c.patch
kexec-rename-unusebale_pages-to-unusable_pages.patch
kexec-move-segment-verification-code-in-a-separate-function.patch
kexec-use-common-function-for-kimage_normal_alloc-and-kimage_crash_alloc.patch
resource-provide-new-functions-to-walk-through-resources.patch
kexec-make-kexec_segment-user-buffer-pointer-a-union.patch
kexec-new-syscall-kexec_file_load-declaration.patch
kexec-implementation-of-new-syscall-kexec_file_load.patch
purgatory-sha256-provide-implementation-of-sha256-in-purgaotory-context.patch
purgatory-core-purgatory-functionality.patch
kexec-load-and-relocate-purgatory-at-kernel-load-time.patch
kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry.patch
kexec-support-for-kexec-on-panic-using-new-system-call.patch
kexec-support-kexec-kdump-on-efi-systems.patch
linux-next.patch

