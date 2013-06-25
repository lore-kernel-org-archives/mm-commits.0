From: akpm@linux-foundation.org
Subject: + fs-proc-kcorec-using-strlcpy-instead-of-strncpy.patch added to
 -mm tree
Date: Tue, 25 Jun 2013 16:47:59 -0700
Message-ID: <51ca2c2f.mK0ND2Ku2VSB1GAc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44020 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab3FYXsA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 19:48:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhaohongjiang@huawei.com

Subject: + fs-proc-kcorec-using-strlcpy-instead-of-strncpy.patch added to -mm tree
To: zhaohongjiang@huawei.com
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 16:47:59 -0700


The patch titled
     Subject: fs/proc/kcore.c: using strlcpy() instead of strncpy()
has been added to the -mm tree.  Its filename is
     fs-proc-kcorec-using-strlcpy-instead-of-strncpy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
drivers-infiniband-core-cmc-convert-to-using-idr_alloc_cyclic.patch
fs-proc-kcorec-using-strlcpy-instead-of-strncpy.patch

