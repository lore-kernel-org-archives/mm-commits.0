From: akpm@linux-foundation.org
Subject: [folded] asiliantfb-fix-cmap-memory-leaks-fix.patch removed from -mm tree
Date: Tue, 31 Mar 2009 15:11:39 -0700
Message-ID: <200903312211.n2VMBdUl018769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764AbZCaWOM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 18:14:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, dilinger@debian.org, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     asiliantfb: fix ISO declaration/code warning
has been removed from the -mm tree.  Its filename was
     asiliantfb-fix-cmap-memory-leaks-fix.patch

This patch was dropped because it was folded into asiliantfb-fix-cmap-memory-leaks.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asiliantfb: fix ISO declaration/code warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Move data declaration before any code:

drivers/video/asiliantfb.c:515: warning: ISO C90 forbids mixed declarations and code

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Andres Salomon <dilinger@debian.org>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/asiliantfb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/asiliantfb.c~asiliantfb-fix-cmap-memory-leaks-fix drivers/video/asiliantfb.c
--- a/drivers/video/asiliantfb.c~asiliantfb-fix-cmap-memory-leaks-fix
+++ a/drivers/video/asiliantfb.c
@@ -507,12 +507,13 @@ static struct fb_var_screeninfo asiliant
 
 static int __devinit init_asiliant(struct fb_info *p, unsigned long addr)
 {
+	int err;
+
 	p->fix			= asiliantfb_fix;
 	p->fix.smem_start	= addr;
 	p->var			= asiliantfb_var;
 	p->fbops		= &asiliantfb_ops;
 	p->flags		= FBINFO_DEFAULT;
-	int err;
 
 	err = fb_alloc_cmap(&p->cmap, 256, 0);
 	if (err) {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
alpha-convert-u64-to-unsigned-long-long.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
atyfb-fix-header-file-trailing-whitespace.patch
asiliantfb-fix-cmap-memory-leaks.patch
asiliantfb-fix-cmap-memory-leaks-fix.patch
linux-next.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
esp-fix-section-mismatch-warning.patch
qla2x-fix-printk-format-warnings.patch
max3100-spi-uart-driver.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix.patch
documentation-ignore-byproducts-from-latex.patch
cpusets-replace-zone-allowed-functions-with-node-allowed.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch
auditsc-fix-kernel-doc-notation.patch
reiser4-export-remove_from_page_cache-fix.patch

