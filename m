From: akpm@linux-foundation.org
Subject: [merged]
 h8300-normalize-global-variables-exported-by-vmlinuxlds.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:26:40 -0700
Message-ID: <51db1270.lOxTAkZDal+3JBJX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab3GHT0k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:26:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ysato@users.sourceforge.jp, jiang.liu@huawei.com, liuj97@gmail.com

Subject: [merged] h8300-normalize-global-variables-exported-by-vmlinuxlds.patch removed from -mm tree
To: liuj97@gmail.com,jiang.liu@huawei.com,ysato@users.sourceforge.jp,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:26:40 -0700


The patch titled
     Subject: h8300: normalize global variables exported by vmlinux.lds
has been removed from the -mm tree.  Its filename was
     h8300-normalize-global-variables-exported-by-vmlinuxlds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: h8300: normalize global variables exported by vmlinux.lds

Generate mandatory global variables __bss_start/__bss_stop in
file vmlinux.lds.

Also remove one unused declaration of _text.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/boot/compressed/misc.c |    1 -
 arch/h8300/kernel/vmlinux.lds.S   |    2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/h8300/boot/compressed/misc.c~h8300-normalize-global-variables-exported-by-vmlinuxlds arch/h8300/boot/compressed/misc.c
--- a/arch/h8300/boot/compressed/misc.c~h8300-normalize-global-variables-exported-by-vmlinuxlds
+++ a/arch/h8300/boot/compressed/misc.c
@@ -79,7 +79,6 @@ static void error(char *m);
 
 int puts(const char *);
 
-extern int _text;		/* Defined in vmlinux.lds.S */
 extern int _end;
 static unsigned long free_mem_ptr;
 static unsigned long free_mem_end_ptr;
diff -puN arch/h8300/kernel/vmlinux.lds.S~h8300-normalize-global-variables-exported-by-vmlinuxlds arch/h8300/kernel/vmlinux.lds.S
--- a/arch/h8300/kernel/vmlinux.lds.S~h8300-normalize-global-variables-exported-by-vmlinuxlds
+++ a/arch/h8300/kernel/vmlinux.lds.S
@@ -132,10 +132,12 @@ SECTIONS
         {
 	. = ALIGN(0x4) ;
 	__sbss = . ;
+	___bss_start = . ;
 		*(.bss*)
 	. = ALIGN(0x4) ;
 		*(COMMON)
 	. = ALIGN(0x4) ;
+	___bss_stop = . ;
 	__ebss = . ;
 	__end = . ;
 	__ramstart = .;
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
linux-next.patch

