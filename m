From: akpm@osdl.org
Subject: - char-stallion-mark-functions-as-init.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:08:10 -0800
Message-ID: <200612082008.kB8K8Au3002585@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58160 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946126AbWLHUIQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:08:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: stallion, mark functions as init
has been removed from the -mm tree.  Its filename was
     char-stallion-mark-functions-as-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: stallion, mark functions as init
From: Jiri Slaby <jirislaby@gmail.com>

Use __init macro for functions, that may be freed after initialization.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/stallion.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/char/stallion.c~char-stallion-mark-functions-as-init drivers/char/stallion.c
--- a/drivers/char/stallion.c~char-stallion-mark-functions-as-init
+++ a/drivers/char/stallion.c
@@ -700,7 +700,7 @@ static struct class *stallion_class;
  *	Check for any arguments passed in on the module load command line.
  */
 
-static void stl_argbrds(void)
+static void __init stl_argbrds(void)
 {
 	struct stlconf	conf;
 	struct stlbrd	*brdp;
@@ -767,7 +767,7 @@ static unsigned long stl_atol(char *str)
  *	Parse the supplied argument string, into the board conf struct.
  */
 
-static int stl_parsebrd(struct stlconf *confp, char **argp)
+static int __init stl_parsebrd(struct stlconf *confp, char **argp)
 {
 	char	*sp;
 	int	i;
@@ -2014,7 +2014,7 @@ static int __init stl_initports(struct s
  *	Try to find and initialize an EasyIO board.
  */
 
-static int stl_initeio(struct stlbrd *brdp)
+static int __init stl_initeio(struct stlbrd *brdp)
 {
 	struct stlpanel	*panelp;
 	unsigned int	status;
@@ -2155,7 +2155,7 @@ static int stl_initeio(struct stlbrd *br
  *	dealing with all types of ECH board.
  */
 
-static int stl_initech(struct stlbrd *brdp)
+static int __init stl_initech(struct stlbrd *brdp)
 {
 	struct stlpanel	*panelp;
 	unsigned int	status, nxtid, ioaddr, conflict;
@@ -2414,7 +2414,7 @@ static int __init stl_brdinit(struct stl
  *	Find the next available board number that is free.
  */
 
-static int stl_getbrdnr(void)
+static int __init stl_getbrdnr(void)
 {
 	int	i;
 
@@ -2438,7 +2438,7 @@ static int stl_getbrdnr(void)
  *	configuration space.
  */
 
-static int stl_initpcibrd(int brdtype, struct pci_dev *devp)
+static int __init stl_initpcibrd(int brdtype, struct pci_dev *devp)
 {
 	struct stlbrd	*brdp;
 
@@ -2500,7 +2500,7 @@ static int stl_initpcibrd(int brdtype, s
  */
 
 
-static int stl_findpcibrds(void)
+static int __init stl_findpcibrds(void)
 {
 	struct pci_dev	*dev = NULL;
 	int		i, rc;
@@ -2536,7 +2536,7 @@ static int stl_findpcibrds(void)
  *	since the initial search and setup is too different.
  */
 
-static int stl_initbrds(void)
+static int __init stl_initbrds(void)
 {
 	struct stlbrd	*brdp;
 	struct stlconf	*confp;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

