From: akpm@linux-foundation.org
Subject: + arch-kconfig-add-kernel-kconfigfreezer-to-arch-kconfig.patch
 added to -mm tree
Date: Tue, 30 Jul 2013 16:41:34 -0700
Message-ID: <51f84f2e.a+TGQwtSZ3YtLbWa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758328Ab3G3Xlf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jul 2013 19:41:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rkuo@codeaurora.org, liqin.chen@sunplusct.com, lennox.wu@gmail.com, jonas@southpole.se, gang.chen@asianux.com

Subject: + arch-kconfig-add-kernel-kconfigfreezer-to-arch-kconfig.patch added to -mm tree
To: gang.chen@asianux.com,jonas@southpole.se,lennox.wu@gmail.com,liqin.chen@sunplusct.com,rkuo@codeaurora.org
From: akpm@linux-foundation.org
Date: Tue, 30 Jul 2013 16:41:34 -0700


The patch titled
     Subject: arch: *: Kconfig: add "kernel/Kconfig.freezer" to "arch/*/Kconfig"
has been added to the -mm tree.  Its filename is
     arch-kconfig-add-kernel-kconfigfreezer-to-arch-kconfig.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-kconfig-add-kernel-kconfigfreezer-to-arch-kconfig.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-kconfig-add-kernel-kconfigfreezer-to-arch-kconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: arch: *: Kconfig: add "kernel/Kconfig.freezer" to "arch/*/Kconfig"

All architectures include "kernel/Kconfig.freezer" except three left, so
let them include it too, or 'allmodconfig' will report error.

The related errors: (with allmodconfig for openrisc):

    CC      kernel/cgroup_freezer.o
  kernel/cgroup_freezer.c: In function 'freezer_css_online':
  kernel/cgroup_freezer.c:133:15: error: 'system_freezing_cnt' undeclared (first use in this function)
  kernel/cgroup_freezer.c:133:15: note: each undeclared identifier is reported only once for each function it appears in
  kernel/cgroup_freezer.c: In function 'freezer_css_offline':
  kernel/cgroup_freezer.c:157:15: error: 'system_freezing_cnt' undeclared (first use in this function)
  kernel/cgroup_freezer.c: In function 'freezer_attach':
  kernel/cgroup_freezer.c:200:4: error: implicit declaration of function 'freeze_task'
  kernel/cgroup_freezer.c: In function 'freezer_apply_state':
  kernel/cgroup_freezer.c:371:16: error: 'system_freezing_cnt' undeclared (first use in this function)

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/Kconfig  |    1 +
 arch/openrisc/Kconfig |    1 +
 arch/score/Kconfig    |    2 ++
 3 files changed, 4 insertions(+)

diff -puN arch/hexagon/Kconfig~arch-kconfig-add-kernel-kconfigfreezer-to-arch-kconfig arch/hexagon/Kconfig
--- a/arch/hexagon/Kconfig~arch-kconfig-add-kernel-kconfigfreezer-to-arch-kconfig
+++ a/arch/hexagon/Kconfig
@@ -158,6 +158,7 @@ source "kernel/Kconfig.hz"
 endmenu
 
 source "init/Kconfig"
+source "kernel/Kconfig.freezer"
 source "drivers/Kconfig"
 source "fs/Kconfig"
 
diff -puN arch/openrisc/Kconfig~arch-kconfig-add-kernel-kconfigfreezer-to-arch-kconfig arch/openrisc/Kconfig
--- a/arch/openrisc/Kconfig~arch-kconfig-add-kernel-kconfigfreezer-to-arch-kconfig
+++ a/arch/openrisc/Kconfig
@@ -55,6 +55,7 @@ config GENERIC_CSUM
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
 
 menu "Processor type and features"
 
diff -puN arch/score/Kconfig~arch-kconfig-add-kernel-kconfigfreezer-to-arch-kconfig arch/score/Kconfig
--- a/arch/score/Kconfig~arch-kconfig-add-kernel-kconfigfreezer-to-arch-kconfig
+++ a/arch/score/Kconfig
@@ -87,6 +87,8 @@ config STACKTRACE_SUPPORT
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 config MMU
 	def_bool y
 
_

Patches currently in -mm which might be from gang.chen@asianux.com are

arch-kconfig-add-kernel-kconfigfreezer-to-arch-kconfig.patch
sh64-kernel-use-usp-instead-of-fn.patch
sh64-kernel-remove-useless-variable-regs.patch
include-linux-interrupth-add-dummy-irq_set_irq_wake-for-generic_hardirqs.patch
mm-page_allocc-use-__paginginit-instead-of-__init.patch
kernel-smpc-free-related-resources-when-failure-occurs-in-hotplug_cfd.patch
linux-next.patch

