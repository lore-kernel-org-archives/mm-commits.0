From: akpm@linux-foundation.org
Subject: + omap-clockdomain-if-no-autodeps-exist-dont-try-to-add-or-remove-them.patch added to -mm tree
Date: Wed, 24 Feb 2010 13:54:15 -0800
Message-ID: <201002242154.o1OLsFmD022570@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758271Ab0BXVyd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 16:54:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paul@pwsan.com, linux@arm.linux.org.uk, roel.kluin@gmail.com, tony@atomide.com


The patch titled
     OMAP clockdomain: if no autodeps exist, don't try to add or remove them
has been added to the -mm tree.  Its filename is
     omap-clockdomain-if-no-autodeps-exist-dont-try-to-add-or-remove-them.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
omap-clockdomain-if-no-autodeps-exist-dont-try-to-add-or-remove-them.patch

