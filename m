From: akpm@linux-foundation.org
Subject: [merged] kexec-ensure-user-memory-sizes-do-not-wrap.patch removed from -mm tree
Date: Wed, 03 Aug 2016 11:13:43 -0700
Message-ID: <57a23457.FqrxwkWXMzS9bGhR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33525 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758012AbcHCSNy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rmk+kernel@arm.linux.org.uk, bhe@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, horms@verge.net.au, j-keerthy@ti.com, panand@redhat.com, vgoyal@redhat.com, vitalya@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: ensure user memory sizes do not wrap
has been removed from the -mm tree.  Its filename was
     kexec-ensure-user-memory-sizes-do-not-wrap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: kexec: ensure user memory sizes do not wrap

Ensure that user memory sizes do not wrap around when validating the user
input, which can lead to the following input validation working
incorrectly.

[akpm@linux-foundation.org: fix it for kexec-return-error-number-directly.patch]
Link: http://lkml.kernel.org/r/E1b8koF-0004HM-5x@rmk-PC.armlinux.org.uk
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Reviewed-by: Pratyush Anand <panand@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Keerthy <j-keerthy@ti.com>
Cc: Vitaly Andrianov <vitalya@ti.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/kexec_core.c~kexec-ensure-user-memory-sizes-do-not-wrap kernel/kexec_core.c
--- a/kernel/kexec_core.c~kexec-ensure-user-memory-sizes-do-not-wrap
+++ a/kernel/kexec_core.c
@@ -168,6 +168,8 @@ int sanity_check_segment_list(struct kim
 
 		mstart = image->segment[i].mem;
 		mend   = mstart + image->segment[i].memsz;
+		if (mstart > mend)
+			return -EADDRNOTAVAIL;
 		if ((mstart & ~PAGE_MASK) || (mend & ~PAGE_MASK))
 			return -EADDRNOTAVAIL;
 		if (mend >= KEXEC_DESTINATION_MEMORY_LIMIT)
_

Patches currently in -mm which might be from rmk+kernel@arm.linux.org.uk are


