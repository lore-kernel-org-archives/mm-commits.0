From: akpm@linux-foundation.org
Subject: [merged] mmfsdax-mark-dax_iomap_pmd_fault-as-const.patch removed
 from -mm tree
Date: Tue, 28 Feb 2017 12:49:27 -0800
Message-ID: <58b5e257.ssL8oJmqVdBQTZmT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55808 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751793AbdB1Vay (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 16:30:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,fs,dax: mark dax_iomap_pmd_fault as const
has been removed from the -mm tree.  Its filename was
     mmfsdax-mark-dax_iomap_pmd_fault-as-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


