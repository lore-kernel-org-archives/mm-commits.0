From: akpm@linux-foundation.org
Subject: [merged] fs-proc-kcorec-using-strlcpy-instead-of-strncpy.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:36:03 -0700
Message-ID: <51db14a3.voij954gSgChJKLS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab3GHTgD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:36:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhaohongjiang@huawei.com

Subject: [merged] fs-proc-kcorec-using-strlcpy-instead-of-strncpy.patch removed from -mm tree
To: zhaohongjiang@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:36:03 -0700


The patch titled
     Subject: fs/proc/kcore.c: using strlcpy() instead of strncpy()
has been removed from the -mm tree.  Its filename was
     fs-proc-kcorec-using-strlcpy-instead-of-strncpy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: fs/proc/kcore.c: using strlcpy() instead of strncpy()

For NUL terminated string, set '\0' at the end.

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/kcore.c~fs-proc-kcorec-using-strlcpy-instead-of-strncpy fs/proc/kcore.c
--- a/fs/proc/kcore.c~fs-proc-kcorec-using-strlcpy-instead-of-strncpy
+++ a/fs/proc/kcore.c
@@ -408,7 +408,7 @@ static void elf_kcore_store_hdr(char *bu
 	prpsinfo.pr_zomb	= 0;
 
 	strcpy(prpsinfo.pr_fname, "vmlinux");
-	strncpy(prpsinfo.pr_psargs, saved_command_line, ELF_PRARGSZ);
+	strlcpy(prpsinfo.pr_psargs, saved_command_line, sizeof(prpsinfo.pr_psargs));
 
 	nhdr->p_filesz	+= notesize(&notes[1]);
 	bufp = storenote(&notes[1], bufp);
_

Patches currently in -mm which might be from zhaohongjiang@huawei.com are

origin.patch
linux-next.patch
drivers-infiniband-core-cmc-convert-to-using-idr_alloc_cyclic.patch

