From: akpm@linux-foundation.org
Subject: + fix-ldm-fix-for-windows-vista-dynamic-disks.patch added to -mm tree
Date: Mon, 21 May 2007 14:58:42 -0700
Message-ID: <200705212158.l4LLwgjn020994@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47795 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756249AbXEUWBr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 18:01:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aia21@cam.ac.uk, aia21@cantab.net, ldm@flatcap.org


The patch titled
     Fix "LDM: Fix for Windows Vista dynamic disks"
has been added to the -mm tree.  Its filename is
     fix-ldm-fix-for-windows-vista-dynamic-disks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix "LDM: Fix for Windows Vista dynamic disks"
From: Anton Altaparmakov <aia21@cam.ac.uk>

Fix the finger trouble that caused the previous LDM patch to break
compilation...

CC: Richard Russon <ldm@flatcap.org>
Signed-off-by: Anton Altaparmakov <aia21@cantab.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/ldm.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/partitions/ldm.c~fix-ldm-fix-for-windows-vista-dynamic-disks fs/partitions/ldm.c
--- a/fs/partitions/ldm.c~fix-ldm-fix-for-windows-vista-dynamic-disks
+++ a/fs/partitions/ldm.c
@@ -158,7 +158,7 @@ static bool ldm_parse_privhead(const u8 
 		/* Warn the user and continue, carefully. */
 		ldm_info("Database is normally %u bytes, it claims to "
 			"be %llu bytes.", LDM_DB_SIZE,
-			udunsigned long long)ph->config_size);
+			(unsigned long long)ph->config_size);
 	}
 	if ((ph->logical_disk_size == 0) || (ph->logical_disk_start +
 			ph->logical_disk_size > ph->config_start)) {
_

Patches currently in -mm which might be from aia21@cam.ac.uk are

fix-ldm-fix-for-windows-vista-dynamic-disks.patch
