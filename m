From: akpm@linux-foundation.org
Subject: [folded-merged]
 maccess-unexport-probe_kernel_write-and-probe_user_write-fix.patch removed
 from -mm tree
Date: Mon, 08 Jun 2020 20:19:27 -0700
Message-ID: <20200609031927.QlfXUCQXN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgFIDT2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 23:19:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, mm-commits@vger.kernel.org, sfr@canb.auug.org.au


The patch titled
     Subject: turns out that probe_user_write is used in modular code
has been removed from the -mm tree.  Its filename was
     maccess-unexport-probe_kernel_write-and-probe_user_write-fix.patch

This patch was dropped because it was folded into maccess-unexport-probe_kernel_write-and-probe_user_write.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: turns out that probe_user_write is used in modular code

Link: http://lkml.kernel.org/r/20200602195741.4faaa348@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/maccess.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/maccess.c~maccess-unexport-probe_kernel_write-and-probe_user_write-fix
+++ a/mm/maccess.c
@@ -244,6 +244,7 @@ long strncpy_from_unsafe_user(char *dst,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(probe_user_write);
 
 /**
  * strnlen_unsafe_user: - Get the size of a user string INCLUDING final NUL.
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

maccess-unexport-probe_kernel_write-and-probe_user_write.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-v2-fix.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-fix-2.patch
