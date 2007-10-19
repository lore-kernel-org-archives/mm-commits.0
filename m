From: akpm@linux-foundation.org
Subject: - mxser-fix-compiler-warning-when-building-withoug-config_pci.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:43:28 -0700
Message-ID: <200710190343.l9J3hStB013063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37638 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934254AbXJSDze (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mxser: fix compiler warning when building without CONFIG_PCI
has been removed from the -mm tree.  Its filename was
     mxser-fix-compiler-warning-when-building-withoug-config_pci.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mxser: fix compiler warning when building without CONFIG_PCI
From: Jesper Juhl <jesper.juhl@gmail.com>

drivers/char/mxser.c:386: warning: 'mxser_get_PCI_conf' declared 'static' but never defined

when building without CONFIG_PCI.

[jesper.juhl@gmail.com: Fix warning: 'CheckIsMoxaMust' defined but not used]
Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/mxser.c~mxser-fix-compiler-warning-when-building-withoug-config_pci drivers/char/mxser.c
--- a/drivers/char/mxser.c~mxser-fix-compiler-warning-when-building-withoug-config_pci
+++ a/drivers/char/mxser.c
@@ -383,7 +383,6 @@ static int mxser_init(void);
 
 /* static void   mxser_poll(unsigned long); */
 static int mxser_get_ISA_conf(int, struct mxser_hwconf *);
-static int mxser_get_PCI_conf(int, int, int, struct mxser_hwconf *);
 static void mxser_do_softint(struct work_struct *);
 static int mxser_open(struct tty_struct *, struct file *);
 static void mxser_close(struct tty_struct *, struct file *);
@@ -422,7 +421,7 @@ static void mxser_wait_until_sent(struct
 static void mxser_startrx(struct tty_struct *tty);
 static void mxser_stoprx(struct tty_struct *tty);
 
-
+#ifdef CONFIG_PCI
 static int CheckIsMoxaMust(int io)
 {
 	u8 oldmcr, hwid;
@@ -445,6 +444,7 @@ static int CheckIsMoxaMust(int io)
 	}
 	return MOXA_OTHER_UART;
 }
+#endif
 
 /* above is modified by Victor Yu. 08-15-2002 */
 
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-cifs.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-xfs.patch
