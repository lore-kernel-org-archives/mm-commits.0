From: akpm@linux-foundation.org
Subject: - s390-strlcpy-is-smart-enough.patch removed from -mm tree
Date: Wed, 07 Mar 2007 15:58:46 -0800
Message-ID: <200703072358.l27Nwkxx013656@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39744 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992772AbXCGX70 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 18:59:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390: strlcpy is smart enough
has been removed from the -mm tree.  Its filename was
     s390-strlcpy-is-smart-enough.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: s390: strlcpy is smart enough
From: Jean Delvare <khali@linux-fr.org>

strlcpy already accounts for the trailing zero in its length
computation, so there is no need to substract one to the buffer size.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/debug.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/s390/kernel/debug.c~s390-strlcpy-is-smart-enough arch/s390/kernel/debug.c
--- a/arch/s390/kernel/debug.c~s390-strlcpy-is-smart-enough
+++ a/arch/s390/kernel/debug.c
@@ -268,7 +268,7 @@ debug_info_alloc(char *name, int pages_p
 	rc->level          = level;
 	rc->buf_size       = buf_size;
 	rc->entry_size     = sizeof(debug_entry_t) + buf_size;
-	strlcpy(rc->name, name, sizeof(rc->name)-1);
+	strlcpy(rc->name, name, sizeof(rc->name));
 	memset(rc->views, 0, DEBUG_MAX_VIEWS * sizeof(struct debug_view *));
 	memset(rc->debugfs_entries, 0 ,DEBUG_MAX_VIEWS *
 		sizeof(struct dentry*));
_

Patches currently in -mm which might be from khali@linux-fr.org are

sound-strlcpy-is-smart-enough.patch
git-dvb.patch
ehea-strlcpy-is-smart-enough.patch
scatterlisth-needs-typesh.patch
cleanup-the-includes-of-linux-pcih.patch
git-s390.patch
blackfin-blackfin-i2c-driver-update-2.patch
xtensa-strlcpy-is-smart-enough.patch
oss-strlcpy-is-smart-enough.patch
