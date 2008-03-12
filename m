From: akpm@linux-foundation.org
Subject: + 8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch added to -mm tree
Date: Tue, 11 Mar 2008 21:51:17 -0700
Message-ID: <200803120451.m2C4pHBb010751@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751970AbYCLEwJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Mar 2008 00:52:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, alan@lxorguk.ukuu.org.uk


The patch titled
     ne2: needs more 8390 support functions
has been added to the -mm tree.  Its filename is
     8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ne2: needs more 8390 support functions
From: Randy Dunlap <randy.dunlap@oracle.com>

ne2 (MCA) needs both 8390.o and 8390p.o functions:

drivers/built-in.o: In function `ne_close':
ne2.c:(.text+0x30544): undefined reference to `eip_close'
drivers/built-in.o: In function `ne_open':
ne2.c:(.text+0x30554): undefined reference to `eip_open'
drivers/built-in.o: In function `ne2_probe':
(.init.text+0x1bce): undefined reference to `__alloc_eip_netdev'
drivers/built-in.o: In function `ne2_probe':
(.init.text+0x1dd9): undefined reference to `eip_interrupt'
make[1]: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/Makefile~8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix drivers/net/Makefile
--- a/drivers/net/Makefile~8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix
+++ a/drivers/net/Makefile
@@ -108,7 +108,7 @@ obj-$(CONFIG_68360_ENET) += 68360enet.o
 obj-$(CONFIG_WD80x3) += wd.o 8390.o
 obj-$(CONFIG_EL2) += 3c503.o 8390p.o
 obj-$(CONFIG_NE2000) += ne.o 8390p.o
-obj-$(CONFIG_NE2_MCA) += ne2.o 8390.o
+obj-$(CONFIG_NE2_MCA) += ne2.o 8390.o 8390p.o
 obj-$(CONFIG_HPLAN) += hp.o 8390p.o
 obj-$(CONFIG_HPLAN_PLUS) += hp-plus.o 8390p.o
 obj-$(CONFIG_ULTRA) += smc-ultra.o 8390.o
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
kernel-doc-set-verbose-mode-via-environment.patch
x86-visws-fix-printk-format-warnings.patch
mempolicy-update-numa-memory-policy-documentation.patch
let-log_buf_shift-default-to-17.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
profile-likely-unlikely-macros.patch

