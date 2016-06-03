From: akpm@linux-foundation.org
Subject: + kexec-ensure-user-memory-sizes-do-not-wrap.patch added to -mm
 tree
Date: Fri, 03 Jun 2016 14:15:57 -0700
Message-ID: <5751f38d.M8idOlS3sLJUObuq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbcFCVP7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2016 17:15:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rmk+kernel@arm.linux.org.uk, bhe@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, horms@verge.net.au, j-keerthy@ti.com, panand@redhat.com, vgoyal@redhat.com, vitalya@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: ensure user memory sizes do not wrap
has been added to the -mm tree.  Its filename is
     kexec-ensure-user-memory-sizes-do-not-wrap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-ensure-user-memory-sizes-do-not-wrap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-ensure-user-memory-sizes-do-not-wrap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: kexec: ensure user memory sizes do not wrap

Ensure that user memory sizes do not wrap around when validating the user
input, which can lead to the following input validation working
incorrectly.

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
+			return result;
 		if ((mstart & ~PAGE_MASK) || (mend & ~PAGE_MASK))
 			return -EADDRNOTAVAIL;
 		if (mend >= KEXEC_DESTINATION_MEMORY_LIMIT)
_

Patches currently in -mm which might be from rmk+kernel@arm.linux.org.uk are

arm-kdump-advertise-boot-aliased-crash-kernel-resource.patch
arm-kexec-advertise-location-of-bootable-ram.patch
kexec-dont-invoke-oom-killer-for-control-page-allocation.patch
kexec-ensure-user-memory-sizes-do-not-wrap.patch
kdump-arrange-for-paddr_vmcoreinfo_note-to-return-phys_addr_t.patch
kexec-allow-architectures-to-override-boot-mapping.patch
arm-kexec-fix-kexec-for-keystone-2.patch

