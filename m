From: akpm@linux-foundation.org
Subject: + drivers-edac-i3000-document-type-promotion.patch added to -mm tree
Date: Thu, 31 Jan 2008 15:55:58 -0800
Message-ID: <200801312355.m0VNtwG7017852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41231 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756758AbYAaX4E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 18:56:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: juhlenko@akamai.com, dougthompson@xmission.com


The patch titled
     drivers/edac/i3000: document type promotion
has been added to the -mm tree.  Its filename is
     drivers-edac-i3000-document-type-promotion.patch

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

drivers-edac-i3000-code-tidying.patch
drivers-edac-i3000-replace-macros-with-functions.patch
drivers-edac-i3000-64bit-build.patch
drivers-edac-i3000-missing-init-code.patch
drivers-edac-i3000-document-type-promotion.patch
