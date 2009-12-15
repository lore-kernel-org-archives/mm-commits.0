From: akpm@linux-foundation.org
Subject: [merged] efih-use-%pul-to-print-uuids.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:58:14 -0800
Message-ID: <200912152158.nBFLwE4s015795@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933832AbZLOV74 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:59:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jgarzik@redhat.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     efi.h: use %pUl to print UUIDs
has been removed from the -mm tree.  Its filename was
     efih-use-%pul-to-print-uuids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: efi.h: use %pUl to print UUIDs
From: Joe Perches <joe@perches.com>

Shrinks vmlinux

without:
$ size vmlinux
   text    data     bss     dec     hex filename
6975863  679652 1359668 9015183  898f8f vmlinux

with:
$ size vmlinux
   text    data     bss     dec     hex filename
6975639 679652 1359668 9014959 898eaf vmlinux

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/efi.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN include/linux/efi.h~efih-use-%pul-to-print-uuids include/linux/efi.h
--- a/include/linux/efi.h~efih-use-%pul-to-print-uuids
+++ a/include/linux/efi.h
@@ -280,11 +280,7 @@ efi_guidcmp (efi_guid_t left, efi_guid_t
 static inline char *
 efi_guid_unparse(efi_guid_t *guid, char *out)
 {
-	sprintf(out, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x",
-		guid->b[3], guid->b[2], guid->b[1], guid->b[0],
-		guid->b[5], guid->b[4], guid->b[7], guid->b[6],
-		guid->b[8], guid->b[9], guid->b[10], guid->b[11],
-		guid->b[12], guid->b[13], guid->b[14], guid->b[15]);
+	sprintf(out, "%pUl", guid->b);
         return out;
 }
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
isicomc-use-pr_fmt-and-pr_level.patch
parport_pcc-use-correct-length-in-strncmp.patch

