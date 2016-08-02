From: akpm@linux-foundation.org
Subject: [folded-merged]
 kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch removed from -mm tree
Date: Tue, 02 Aug 2016 13:45:10 -0700
Message-ID: <57a10656.bDuMuCjY087gS3wZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59546 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428AbcHBUpM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 16:45:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, horms@verge.net.au, j-keerthy@ti.com, panand@redhat.com, rmk+kernel@arm.linux.org.uk, vgoyal@redhat.com, vitalya@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-ensure-user-memory-sizes-do-not-wrap-fix
has been removed from the -mm tree.  Its filename was
     kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch

This patch was dropped because it was folded into kexec-ensure-user-memory-sizes-do-not-wrap.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kexec-ensure-user-memory-sizes-do-not-wrap-fix

fix it for kexec-return-error-number-directly.patch

Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Keerthy <j-keerthy@ti.com>
Cc: Pratyush Anand <panand@redhat.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Simon Horman <horms@verge.net.au>
Cc: Vitaly Andrianov <vitalya@ti.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kexec_core.c~kexec-ensure-user-memory-sizes-do-not-wrap-fix kernel/kexec_core.c
--- a/kernel/kexec_core.c~kexec-ensure-user-memory-sizes-do-not-wrap-fix
+++ a/kernel/kexec_core.c
@@ -169,7 +169,7 @@ int sanity_check_segment_list(struct kim
 		mstart = image->segment[i].mem;
 		mend   = mstart + image->segment[i].memsz;
 		if (mstart > mend)
-			return result;
+			return -EADDRNOTAVAIL;
 		if ((mstart & ~PAGE_MASK) || (mend & ~PAGE_MASK))
 			return -EADDRNOTAVAIL;
 		if (mend >= KEXEC_DESTINATION_MEMORY_LIMIT)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kexec-ensure-user-memory-sizes-do-not-wrap.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
allow-kdump-with-crash_kexec_post_notifiers-fix.patch
kexec-add-restriction-on-kexec_load-segment-sizes-fix.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix.patch

