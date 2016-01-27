From: akpm@linux-foundation.org
Subject: + mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs-v2.patch added to -mm tree
Date: Wed, 27 Jan 2016 11:58:48 -0800
Message-ID: <56a92178.Gu4UMAekWYVPfzTl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935833AbcA0T6t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 14:58:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kwapulinski.piotr@gmail.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs-v2
has been added to the -mm tree.  Its filename is
     mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Piotr Kwapulinski <kwapulinski.piotr@gmail.com>
Subject: mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs-v2

The difference between v1 is that the prot variable is reset to
 reqprot for each loop iteration (thanks to Konstantin Khlebnikov for
pointing this out).
rier means "(current->personality & [R]EAD_[I]MPLIES_[E]XEC) &&
(prot & PROT_[R]EAD)".

Signed-off-by: Piotr Kwapulinski <kwapulinski.piotr@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/mprotect.c~mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs-v2 mm/mprotect.c
--- a/mm/mprotect.c~mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs-v2
+++ a/mm/mprotect.c
@@ -442,6 +442,7 @@ SYSCALL_DEFINE3(mprotect, unsigned long,
 			error = -ENOMEM;
 			goto out;
 		}
+		prot = reqprot;
 	}
 out:
 	up_write(&current->mm->mmap_sem);
_

Patches currently in -mm which might be from kwapulinski.piotr@gmail.com are

mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs.patch
mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs-v2.patch

