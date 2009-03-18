From: akpm@linux-foundation.org
Subject: [merged] wimax-fix-i2400m-printk-formats.patch removed from -mm tree
Date: Wed, 18 Mar 2009 15:48:13 -0700
Message-ID: <200903182248.n2IMmDWP020289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754209AbZCRWum (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Mar 2009 18:50:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, inaky@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     wimax: fix i2400m printk formats
has been removed from the -mm tree.  Its filename was
     wimax-fix-i2400m-printk-formats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wimax: fix i2400m printk formats
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings:

drivers/net/wimax/i2400m/netdev.c:523: warning: format '%zu' expects type 'size_t', but argument 7 has type 'unsigned int'
drivers/net/wimax/i2400m/netdev.c:548: warning: format '%zu' expects type 'size_t', but argument 7 has type 'unsigned int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wimax/i2400m/netdev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/wimax/i2400m/netdev.c~wimax-fix-i2400m-printk-formats drivers/net/wimax/i2400m/netdev.c
--- a/drivers/net/wimax/i2400m/netdev.c~wimax-fix-i2400m-printk-formats
+++ a/drivers/net/wimax/i2400m/netdev.c
@@ -520,7 +520,7 @@ void i2400m_net_erx(struct i2400m *i2400
 	struct device *dev = i2400m_dev(i2400m);
 	int protocol;
 
-	d_fnstart(2, dev, "(i2400m %p skb %p [%zu] cs %d)\n",
+	d_fnstart(2, dev, "(i2400m %p skb %p [%u] cs %d)\n",
 		  i2400m, skb, skb->len, cs);
 	switch(cs) {
 	case I2400M_CS_IPV4_0:
@@ -545,7 +545,7 @@ void i2400m_net_erx(struct i2400m *i2400
 	d_dump(4, dev, skb->data, skb->len);
 	netif_rx_ni(skb);	/* see notes in function header */
 error:
-	d_fnend(2, dev, "(i2400m %p skb %p [%zu] cs %d) = void\n",
+	d_fnend(2, dev, "(i2400m %p skb %p [%u] cs %d) = void\n",
 		i2400m, skb, skb->len, cs);
 }
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
git-acpi-vs-git-cpufreq.patch
auditsc-fix-kernel-doc-notation.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
esp-fix-section-mismatch-warning.patch
qla2x-fix-printk-format-warnings.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
max3100-spi-uart-driver.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
alpha-convert-u64-to-unsigned-long-long.patch
alpha-convert-u64-to-unsigned-long-long-fix.patch
alpha-convert-u64-to-unsigned-long-long-fix-2.patch
alpha-convert-u64-to-unsigned-long-long-fix-3.patch
alpha-convert-u64-to-unsigned-long-long-fix-3-checkpatch-fixes.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-99.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix.patch
atyfb-fix-header-file-trailing-whitespace.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-fix.patch
asiliantfb-fix-cmap-memory-leaks-fix.patch
documentation-ignore-byproducts-from-latex.patch
cpusets-replace-zone-allowed-functions-with-node-allowed.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch
reiser4-export-remove_from_page_cache-fix.patch

