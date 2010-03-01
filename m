From: akpm@linux-foundation.org
Subject: [merged] omap-clockdomain-if-no-autodeps-exist-dont-try-to-add-or-remove-them.patch removed from -mm tree
Date: Mon, 01 Mar 2010 11:46:27 -0800
Message-ID: <201003011946.o21JkRgn028678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318Ab0CATrE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Mar 2010 14:47:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paul@pwsan.com, linux@arm.linux.org.uk, roel.kluin@gmail.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     OMAP clockdomain: if no autodeps exist, don't try to add or remove them
has been removed from the -mm tree.  Its filename was
     omap-clockdomain-if-no-autodeps-exist-dont-try-to-add-or-remove-them.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: OMAP clockdomain: if no autodeps exist, don't try to add or remove them
From: Paul Walmsley <paul@pwsan.com>

_clkdm_add_autodeps() and _clkdm_del_autodeps() will attempt to
dereference a NULL pointer if no autodeps were supplied to clkdm_init().

Based on a patch from Roel Kluin <roel.kluin@gmail.com> - thanks Roel.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Reported-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap2/clockdomain.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN arch/arm/mach-omap2/clockdomain.c~omap-clockdomain-if-no-autodeps-exist-dont-try-to-add-or-remove-them arch/arm/mach-omap2/clockdomain.c
--- a/arch/arm/mach-omap2/clockdomain.c~omap-clockdomain-if-no-autodeps-exist-dont-try-to-add-or-remove-them
+++ a/arch/arm/mach-omap2/clockdomain.c
@@ -173,6 +173,9 @@ static void _clkdm_add_autodeps(struct c
 {
 	struct clkdm_autodep *autodep;
 
+	if (!autodeps)
+		return;
+
 	for (autodep = autodeps; autodep->clkdm.ptr; autodep++) {
 		if (IS_ERR(autodep->clkdm.ptr))
 			continue;
@@ -201,6 +204,9 @@ static void _clkdm_del_autodeps(struct c
 {
 	struct clkdm_autodep *autodep;
 
+	if (!autodeps)
+		return;
+
 	for (autodep = autodeps; autodep->clkdm.ptr; autodep++) {
 		if (IS_ERR(autodep->clkdm.ptr))
 			continue;
_

Patches currently in -mm which might be from paul@pwsan.com are

linux-next.patch

