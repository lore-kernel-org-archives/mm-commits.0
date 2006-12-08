From: akpm@osdl.org
Subject: - char-stallion-uninline-functions.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:08:07 -0800
Message-ID: <200612082008.kB8K87pc002573@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58144 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946078AbWLHUIM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:08:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: stallion, uninline functions
has been removed from the -mm tree.  Its filename was
     char-stallion-uninline-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: stallion, uninline functions
From: Jiri Slaby <jirislaby@gmail.com>

- Do not inline such long functions, it won't speed up anything.
- Remove prototypes of these functions.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/stallion.c |   28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff -puN drivers/char/stallion.c~char-stallion-uninline-functions drivers/char/stallion.c
--- a/drivers/char/stallion.c~char-stallion-uninline-functions
+++ a/drivers/char/stallion.c
@@ -496,16 +496,6 @@ static void	stl_offintr(struct work_stru
 static struct stlbrd *stl_allocbrd(void);
 static struct stlport *stl_getport(int brdnr, int panelnr, int portnr);
 
-static inline int	stl_initbrds(void);
-static inline int	stl_initeio(struct stlbrd *brdp);
-static inline int	stl_initech(struct stlbrd *brdp);
-static inline int	stl_getbrdnr(void);
-
-#ifdef	CONFIG_PCI
-static inline int	stl_findpcibrds(void);
-static inline int	stl_initpcibrd(int brdtype, struct pci_dev *devp);
-#endif
-
 /*
  *	CD1400 uart specific handling functions.
  */
@@ -2024,7 +2014,7 @@ static int __init stl_initports(struct s
  *	Try to find and initialize an EasyIO board.
  */
 
-static inline int stl_initeio(struct stlbrd *brdp)
+static int stl_initeio(struct stlbrd *brdp)
 {
 	struct stlpanel	*panelp;
 	unsigned int	status;
@@ -2165,7 +2155,7 @@ static inline int stl_initeio(struct stl
  *	dealing with all types of ECH board.
  */
 
-static inline int stl_initech(struct stlbrd *brdp)
+static int stl_initech(struct stlbrd *brdp)
 {
 	struct stlpanel	*panelp;
 	unsigned int	status, nxtid, ioaddr, conflict;
@@ -2424,7 +2414,7 @@ static int __init stl_brdinit(struct stl
  *	Find the next available board number that is free.
  */
 
-static inline int stl_getbrdnr(void)
+static int stl_getbrdnr(void)
 {
 	int	i;
 
@@ -2448,7 +2438,7 @@ static inline int stl_getbrdnr(void)
  *	configuration space.
  */
 
-static inline int stl_initpcibrd(int brdtype, struct pci_dev *devp)
+static int stl_initpcibrd(int brdtype, struct pci_dev *devp)
 {
 	struct stlbrd	*brdp;
 
@@ -2510,7 +2500,7 @@ static inline int stl_initpcibrd(int brd
  */
 
 
-static inline int stl_findpcibrds(void)
+static int stl_findpcibrds(void)
 {
 	struct pci_dev	*dev = NULL;
 	int		i, rc;
@@ -2546,7 +2536,7 @@ static inline int stl_findpcibrds(void)
  *	since the initial search and setup is too different.
  */
 
-static inline int stl_initbrds(void)
+static int stl_initbrds(void)
 {
 	struct stlbrd	*brdp;
 	struct stlconf	*confp;
@@ -3596,7 +3586,7 @@ static void stl_cd1400echintr(struct stl
  *	this is the only way to generate them on the cd1400.
  */
 
-static inline int stl_cd1400breakisr(struct stlport *portp, int ioaddr)
+static int stl_cd1400breakisr(struct stlport *portp, int ioaddr)
 {
 	if (portp->brklen == 1) {
 		outb((COR2 + portp->uartaddr), ioaddr);
@@ -4520,7 +4510,7 @@ static void stl_sc26198wait(struct stlpo
  *	automatic flow control modes of the sc26198.
  */
 
-static inline void stl_sc26198txunflow(struct stlport *portp, struct tty_struct *tty)
+static void stl_sc26198txunflow(struct stlport *portp, struct tty_struct *tty)
 {
 	unsigned char	mr0;
 
@@ -4691,7 +4681,7 @@ static void stl_sc26198rxisr(struct stlp
  *	Process an RX bad character.
  */
 
-static inline void stl_sc26198rxbadch(struct stlport *portp, unsigned char status, char ch)
+static void stl_sc26198rxbadch(struct stlport *portp, unsigned char status, char ch)
 {
 	struct tty_struct	*tty;
 	unsigned int		ioaddr;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-stallion-uninline-functions.patch
char-stallion-mark-functions-as-init.patch
char-stallion-remove-many-prototypes.patch
char-isicom-expand-function.patch
char-isicom-rename-init-function.patch
char-isicom-remove-isa-code.patch
char-isicom-remove-unneeded-memset.patch
char-isicom-move-to-tty_register_device.patch
char-isicom-use-pci_request_region.patch
char-isicom-check-kmalloc-retval.patch
char-isicom-use-completion.patch
char-isicom-simplify-timer.patch
char-isicom-remove-cvs-stuff.patch
char-isicom-fix-tty-index-check.patch
char-sx-convert-to-pci-probing.patch
char-sx-use-kcalloc.patch
char-sx-mark-functions-as-devinit.patch
char-sx-use-eisa-probing.patch
char-sx-ifdef-isa-code.patch
char-sx-lock-boards-struct.patch
char-sx-remove-duplicite-code.patch
char-sx-whitespace-cleanup.patch
char-sx-simplify-timer-logic.patch
char-sx-fix-return-in-module-init.patch
char-sx-use-pci_iomap.patch
char-sx-request-regions.patch
char-stallion-convert-to-pci-probing.patch
char-stallion-prints-cleanup.patch
char-stallion-implement-fail-paths.patch
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

