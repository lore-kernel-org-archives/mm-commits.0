From: akpm@linux-foundation.org
Subject: - drivers-edac-i3000-document-type-promotion.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:06:10 -0800
Message-ID: <200802080805.m1885p1Q014378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57087 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760503AbYBHIT3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: juhlenko@akamai.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac/i3000: document type promotion
has been removed from the -mm tree.  Its filename was
     drivers-edac-i3000-document-type-promotion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/edac/i3000: document type promotion
From: Jason Uhlenkott <juhlenko@akamai.com>

By popular request, add a comment documenting the implicit type promotion
here.

Signed-off-by: Jason Uhlenkott <juhlenko@akamai.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i3000_edac.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/edac/i3000_edac.c~drivers-edac-i3000-document-type-promotion drivers/edac/i3000_edac.c
--- a/drivers/edac/i3000_edac.c~drivers-edac-i3000-document-type-promotion
+++ a/drivers/edac/i3000_edac.c
@@ -44,6 +44,13 @@
 				 */
 #define I3000_DEAP_GRAIN 		(1 << 7)
 
+/*
+ * Helper functions to decode the DEAP/EDEAP hardware registers.
+ *
+ * The type promotion here is deliberate; we're deriving an
+ * unsigned long pfn and offset from hardware regs which are u8/u32.
+ */
+
 static inline unsigned long deap_pfn(u8 edeap, u32 deap)
 {
 	deap >>= PAGE_SHIFT;
_

Patches currently in -mm which might be from juhlenko@akamai.com are

origin.patch
