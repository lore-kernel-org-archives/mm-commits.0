From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 maccess-unexport-probe_kernel_write-and-probe_user_write-fix.patch added to
 -mm tree
Date: Tue, 02 Jun 2020 14:34:30 -0700
Message-ID: <20200602213430.Gn-9S-cS2%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgFBVeb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:34:31 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, mm-commits@vger.kernel.org, sfr@canb.auug.org.au


The patch titled
     Subject: turns out that probe_user_write is used in modular code
has been added to the -mm tree.  Its filename is
     maccess-unexport-probe_kernel_write-and-probe_user_write-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maccess-unexport-probe_kernel_write-and-probe_user_write-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maccess-unexport-probe_kernel_write-and-probe_user_write-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kernel-better-document-the-use_mm-unuse_mm-api-contract-v2-fix.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-fix-2.patch
maccess-unexport-probe_kernel_write-and-probe_user_write-fix.patch
