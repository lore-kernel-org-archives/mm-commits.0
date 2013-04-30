From: akpm@linux-foundation.org
Subject: [folded-merged] xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch removed from -mm tree
Date: Tue, 30 Apr 2013 15:13:29 -0700
Message-ID: <20130430221329.B0A4531C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:40508 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab3D3WNb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 18:13:31 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so113584yen.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 15:13:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andor.daam@googlemail.com, dan.magenheimer@oracle.com, fschmaus@gmail.com, ilendir@googlemail.com, konrad.wilk@oracle.com, liwanp@linux.vnet.ibm.com, lliubbo@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix
has been removed from the -mm tree.  Its filename was
     xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch

This patch was dropped because it was folded into xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix

fix build (disable_frontswap_selfshrinking undeclared)

Cc: Andor Daam <andor.daam@googlemail.com>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Florian Schmaus <fschmaus@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Stefan Hengelein <ilendir@googlemail.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/xen/tmem.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/xen/tmem.c~xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix drivers/xen/tmem.c
--- a/drivers/xen/tmem.c~xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix
+++ a/drivers/xen/tmem.c
@@ -382,6 +382,8 @@ static struct frontswap_ops tmem_frontsw
 	.invalidate_area = tmem_frontswap_flush_area,
 	.init = tmem_frontswap_init
 };
+#else	/* CONFIG_FRONTSWAP */
+#define disable_frontswap_selfshrinking 1
 #endif
 
 static int xen_tmem_init(void)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-usb-storage-realtek_crc-fix-build.patch
inotify-invalid-mask-should-return-a-error-number-but-not-set-it.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module-fix.patch
selftest-add-simple-test-for-soft-dirty-bit.patch
kernel-smpc-cleanups.patch
lib-string_helpers-introduce-generic-string_unescape-fix.patch
lib-string_helpers-introduce-generic-string_unescape-fix-fix.patch
kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption-fix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch

