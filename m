From: akpm@linux-foundation.org
Subject: + mmfsdax-mark-dax_iomap_pmd_fault-as-const.patch added to -mm
 tree
Date: Mon, 27 Feb 2017 12:47:32 -0800
Message-ID: <58b49064.WTF4TVpljEivH/SX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34720 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752041AbdB0U5A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:57:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,fs,dax: mark dax_iomap_pmd_fault as const
has been added to the -mm tree.  Its filename is
     mmfsdax-mark-dax_iomap_pmd_fault-as-const.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmfsdax-mark-dax_iomap_pmd_fault-as-const.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmfsdax-mark-dax_iomap_pmd_fault-as-const.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm,fs,dax: mark dax_iomap_pmd_fault as const

The two alternative implementations of dax_iomap_fault have different
prototypes, and one of them is obviously wrong as seen from this build
warning:

fs/dax.c: In function 'dax_iomap_fault':
fs/dax.c:1462:35: error: passing argument 2 of 'dax_iomap_pmd_fault' discards 'const' qualifier from pointer target type [-Werror=discarded-qualifiers]

This marks the argument 'const' as in all the related functions.

Fixes: a2d581675d48 ("mm,fs,dax: change ->pmd_fault to ->huge_fault")
Link: http://lkml.kernel.org/r/20170227203349.3318733-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/dax.c~mmfsdax-mark-dax_iomap_pmd_fault-as-const fs/dax.c
--- a/fs/dax.c~mmfsdax-mark-dax_iomap_pmd_fault-as-const
+++ a/fs/dax.c
@@ -1436,7 +1436,8 @@ out:
 	return result;
 }
 #else
-static int dax_iomap_pmd_fault(struct vm_fault *vmf, struct iomap_ops *ops)
+static int dax_iomap_pmd_fault(struct vm_fault *vmf,
+			       const struct iomap_ops *ops)
 {
 	return VM_FAULT_FALLBACK;
 }
_

Patches currently in -mm which might be from arnd@arndb.de are

mmfsdax-mark-dax_iomap_pmd_fault-as-const.patch

