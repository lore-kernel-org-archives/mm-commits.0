From: akpm@linux-foundation.org
Subject: [merged] vsprintf-correctly-handle-width-when-flag-used-in-%p-format.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:33:05 -0700
Message-ID: <20120601193305.62ADEA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:36653 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406Ab2FATdG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:06 -0400
Received: by mail-ee0-f74.google.com with SMTP id t10so140668eei.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:33:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: grant.likely@secretlab.ca, mm-commits@vger.kernel.org


The patch titled
     Subject: vsprintf: correctly handle width when '#' flag used in %#p format
has been removed from the -mm tree.  Its filename was
     vsprintf-correctly-handle-width-when-flag-used-in-%p-format.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Grant Likely <grant.likely@secretlab.ca>
Subject: vsprintf: correctly handle width when '#' flag used in %#p format

The '%p' output of the kernel's vsprintf() uses spec.field_width to
determine how many digits to output based on 2 * sizeof(void*) so that all
digits of a pointer are shown.  ie.  a pointer will be output as
"001A2B3C" instead of "1A2B3C".  However, if the '#' flag is used in the
format (%#p), then the code doesn't take into account the width of the
'0x' prefix and will end up outputing "0x1A2B3C" instead of "0x001A2B3C".

This patch reworks the "pointer()" format hook to include 2 characters for
the '0x' prefix if the '#' flag is included.

[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN lib/vsprintf.c~vsprintf-correctly-handle-width-when-flag-used-in-%p-format lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-correctly-handle-width-when-flag-used-in-%p-format
+++ a/lib/vsprintf.c
@@ -870,13 +870,15 @@ static noinline_for_stack
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	      struct printf_spec spec)
 {
+	int default_width = 2 * sizeof(void *) + (spec.flags & SPECIAL ? 2 : 0);
+
 	if (!ptr && *fmt != 'K') {
 		/*
 		 * Print (null) with the same width as a pointer so it makes
 		 * tabular output look nice.
 		 */
 		if (spec.field_width == -1)
-			spec.field_width = 2 * sizeof(void *);
+			spec.field_width = default_width;
 		return string(buf, end, "(null)", spec);
 	}
 
@@ -931,7 +933,7 @@ char *pointer(const char *fmt, char *buf
 		 */
 		if (in_irq() || in_serving_softirq() || in_nmi()) {
 			if (spec.field_width == -1)
-				spec.field_width = 2 * sizeof(void *);
+				spec.field_width = default_width;
 			return string(buf, end, "pK-error", spec);
 		}
 		if (!((kptr_restrict == 0) ||
@@ -948,7 +950,7 @@ char *pointer(const char *fmt, char *buf
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
-		spec.field_width = 2 * sizeof(void *);
+		spec.field_width = default_width;
 		spec.flags |= ZEROPAD;
 	}
 	spec.base = 16;
_

Patches currently in -mm which might be from grant.likely@secretlab.ca are

origin.patch
linux-next.patch

