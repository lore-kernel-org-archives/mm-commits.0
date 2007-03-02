From: akpm@linux-foundation.org
Subject: + fb-sm501fb-off-by-1-sysfs-store.patch added to -mm tree
Date: Thu, 01 Mar 2007 18:35:00 -0800
Message-ID: <200703020235.l222Z0G5030168@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35947 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422643AbXCBCf2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 21:35:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, adaplas@pol.net, ben-linux@fluff.org


The patch titled
     fb: sm501fb off-by-1 sysfs store
has been added to the -mm tree.  Its filename is
     fb-sm501fb-off-by-1-sysfs-store.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fb: sm501fb off-by-1 sysfs store
From: Paul Mundt <lethal@linux-sh.org>

Currently sm501fb_crtsrc_store() won't allow the routing to be changed via
echos from userspace in to the sysfs file.  The reason for this is that the
strnicmp() for both heads uses a sizeof() for the string length, which ends
up being strlen() + 1 (\0 in the normal case, but the echo gives a newline,
which is where the issue occurs), this then causes a mismatch and
subsequently bails with the -EINVAL.

In addition to this, the hardcoded lengths were then used for the store
length that was returned, which ended up being erroneous and resulting in a
write error.  There's also no point in returning anything but the full
length since it will -EINVAL out on a mismatch well before then anyways.

sizeof("string") is great for making sure you have space in your buffer,
but rather less so for string comparisons :-)

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Ben Dooks <ben-linux@fluff.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/sm501fb.c~fb-sm501fb-off-by-1-sysfs-store drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~fb-sm501fb-off-by-1-sysfs-store
+++ a/drivers/video/sm501fb.c
@@ -1074,9 +1074,9 @@ static ssize_t sm501fb_crtsrc_store(stru
 	if (len < 1)
 		return -EINVAL;
 
-	if (strnicmp(buf, "crt", sizeof("crt")) == 0)
+	if (strnicmp(buf, "crt", 3) == 0)
 		head = HEAD_CRT;
-	else if (strnicmp(buf, "panel", sizeof("panel")) == 0)
+	else if (strnicmp(buf, "panel", 5) == 0)
 		head = HEAD_PANEL;
 	else
 		return -EINVAL;
@@ -1098,7 +1098,7 @@ static ssize_t sm501fb_crtsrc_store(stru
 	writel(ctrl, info->regs + SM501_DC_CRT_CONTROL);
 	sm501fb_sync_regs(info);
 
-	return (head == HEAD_CRT) ? 3 : 5;
+	return len;
 }
 
 /* Prepare the device_attr for registration with sysfs later */
_

Patches currently in -mm which might be from lethal@linux-sh.org are

fb-sm501fb-off-by-1-sysfs-store.patch
make-aout-executables-work-again.patch
git-sh.patch
fully-honor-vdso_enabled.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
simplify-the-stacktrace-code.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
