From: akpm@osdl.org
Subject: - char-stallion-correct-__init-macros.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:09:42 -0800
Message-ID: <200612082009.kB8K9g27002735@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58662 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946262AbWLHUJr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:09:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: stallion, correct __init macros
has been removed from the -mm tree.  Its filename was
     char-stallion-correct-__init-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: stallion, correct __init macros
From: Jiri Slaby <jirislaby@gmail.com>

Some functions are now called from pci probing functiuon which is __devinit,
not __init, correct this to not free functions after init if hotplug enabled.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/stallion.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/char/stallion.c~char-stallion-correct-__init-macros drivers/char/stallion.c
--- a/drivers/char/stallion.c~char-stallion-correct-__init-macros
+++ a/drivers/char/stallion.c
@@ -1923,7 +1923,7 @@ static void stl_offintr(struct work_stru
  *	Initialize all the ports on a panel.
  */
 
-static int __init stl_initports(struct stlbrd *brdp, struct stlpanel *panelp)
+static int __devinit stl_initports(struct stlbrd *brdp, struct stlpanel *panelp)
 {
 	struct stlport	*portp;
 	int		chipmask, i;
@@ -1995,7 +1995,7 @@ static void stl_cleanup_panels(struct st
  *	Try to find and initialize an EasyIO board.
  */
 
-static int __init stl_initeio(struct stlbrd *brdp)
+static int __devinit stl_initeio(struct stlbrd *brdp)
 {
 	struct stlpanel	*panelp;
 	unsigned int	status;
@@ -2148,7 +2148,7 @@ err:
  *	dealing with all types of ECH board.
  */
 
-static int __init stl_initech(struct stlbrd *brdp)
+static int __devinit stl_initech(struct stlbrd *brdp)
 {
 	struct stlpanel	*panelp;
 	unsigned int	status, nxtid, ioaddr, conflict;
@@ -2372,7 +2372,7 @@ err:
  *	since the initial search and setup is very different.
  */
 
-static int __init stl_brdinit(struct stlbrd *brdp)
+static int __devinit stl_brdinit(struct stlbrd *brdp)
 {
 	int i, retval;
 
@@ -2438,7 +2438,7 @@ err:
  *	Find the next available board number that is free.
  */
 
-static int __init stl_getbrdnr(void)
+static int __devinit stl_getbrdnr(void)
 {
 	int	i;
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-stallion-correct-__init-macros.patch
char-stallion-functions-cleanup.patch
char-stallion-fix-fail-paths.patch
char-stallion-brd-struct-locking.patch
char-stallion-remove-syntactic-sugar.patch
char-stallion-variables-cleanup.patch
char-stallion-use-dynamic-dev.patch
char-istallion-convert-to-pci-probing.patch
char-istallion-remove-the-mess.patch
char-istallion-eliminate-typedefs.patch
char-istallion-variables-cleanup.patch
char-istallion-ifdef-eisa-code.patch
char-istallion-brdnr-locking.patch
char-istallion-free-only-isa.patch
char-istallion-correct-fail-paths.patch
char-istallion-fix-enabling.patch
char-istallion-move-init-and-exit-code.patch
char-istallion-change-init-sequence.patch
char-istallion-dynamic-tty-device.patch
char-istallion-use-mod_timer.patch
char-cyclades-save-indent-levels.patch
char-cyclades-lindent-the-code.patch
char-cyclades-cleanup.patch
char-cyclades-fix-warnings.patch

