From: akpm@linux-foundation.org
Subject: + nommu-report-correct-errno-in-message.patch added to -mm tree
Date: Mon, 04 Jun 2007 13:05:19 -0700
Message-ID: <200706042005.l54K5JcI016085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40212 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760826AbXFDUGO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 16:06:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, dhowells@redhat.com, gerg@uclinux.org, phdm@macqel.be


The patch titled
     nommu: report correct errno in message
has been added to the -mm tree.  Its filename is
     nommu-report-correct-errno-in-message.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nommu: report correct errno in message
From: Greg Ungerer <gerg@snapgear.com>

Report the correct errno for out of memory debug output in binfmt_flat.c

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_flat.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/binfmt_flat.c~nommu-report-correct-errno-in-message fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~nommu-report-correct-errno-in-message
+++ a/fs/binfmt_flat.c
@@ -558,7 +558,7 @@ static int load_flat_file(struct linux_b
 			if (!realdatastart)
 				realdatastart = (unsigned long) -ENOMEM;
 			printk("Unable to allocate RAM for process data, errno %d\n",
-					(int)-datapos);
+					(int)-realdatastart);
 			do_munmap(current->mm, textpos, text_len);
 			ret = realdatastart;
 			goto err;
_

Patches currently in -mm which might be from gerg@snapgear.com are

drivers-mtd-maps-nettelc-possible-cleanups.patch
m68knommu-fix-coldfire-timer-off-by-1.patch
nommu-stub-expand_stack-for-nommu-case.patch
m68knommu-use-trhead_size-instead-of-hard-constant.patch
m68knommu-remove-cruft-from-setup-code.patch
m68knommu-remove-old-cache-management-cruft-from-mm-code.patch
nommu-report-correct-errno-in-message.patch
