From: akpm@linux-foundation.org
Subject: + drivers-input-joystick-kconfig-zhenhuac-needs-bitreverse.patch
 added to -mm tree
Date: Wed, 23 Sep 2015 12:59:11 -0700
Message-ID: <5603048f.a0JEM3BWfG7RnJcc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbbIWT7M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Sep 2015 15:59:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dmitry.torokhov@gmail.com, fengguang.wu@gmail.com, yalin.wang2010@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/input/joystick/Kconfig: zhenhua.c needs BITREVERSE
has been added to the -mm tree.  Its filename is
     drivers-input-joystick-kconfig-zhenhuac-needs-bitreverse.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-input-joystick-kconfig-zhenhuac-needs-bitreverse.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-input-joystick-kconfig-zhenhuac-needs-bitreverse.patch

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
Subject: drivers/input/joystick/Kconfig: zhenhua.c needs BITREVERSE

It uses bitrev8(), so it must ensure that lib/bitrev.o gets included in
vmlinux.

Cc: Fengguang Wu <fengguang.wu@gmail.com>
Cc: yalin wang <yalin.wang2010@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/joystick/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/input/joystick/Kconfig~drivers-input-joystick-kconfig-zhenhuac-needs-bitreverse drivers/input/joystick/Kconfig
--- a/drivers/input/joystick/Kconfig~drivers-input-joystick-kconfig-zhenhuac-needs-bitreverse
+++ a/drivers/input/joystick/Kconfig
@@ -196,6 +196,7 @@ config JOYSTICK_TWIDJOY
 config JOYSTICK_ZHENHUA
 	tristate "5-byte Zhenhua RC transmitter"
 	select SERIO
+	select BITREVERSE
 	help
 	  Say Y here if you have a Zhen Hua PPM-4CH transmitter which is
 	  supplied with a ready to fly micro electric indoor helicopters
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
memcg-make-mem_cgroup_read_stat-unsigned-fix.patch
drivers-input-joystick-kconfig-zhenhuac-needs-bitreverse.patch
mm.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

