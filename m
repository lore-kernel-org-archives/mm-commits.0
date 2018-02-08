From: akpm@linux-foundation.org
Subject: + mm-always-print-rlimit_data-warning.patch added to -mm tree
Date: Thu, 08 Feb 2018 14:30:16 -0800
Message-ID: <5a7ccf78.8cNOKS0xZ1zr6q0t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54600 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbeBHWaS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Feb 2018 17:30:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwmw@amazon.co.uk, gorcunov@gmail.com, koct9i@gmail.com, vdavydov@virtuozzo.com, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: always print RLIMIT_DATA warning
has been added to the -mm tree.  Its filename is
     mm-always-print-rlimit_data-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-always-print-rlimit_data-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-always-print-rlimit_data-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Woodhouse <dwmw@amazon.co.uk>
Subject: mm: always print RLIMIT_DATA warning

The documentation for ignore_rlimit_data says that it will print a warning
at first misuse.  Yet it doesn't seem to do that.  Fix the code to print
the warning even when we allow the process to continue.

Link: http://lkml.kernel.org/r/1517935505-9321-1-git-send-email-dwmw@amazon.co.uk
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Acked-by: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN mm/mmap.c~mm-always-print-rlimit_data-warning mm/mmap.c
--- a/mm/mmap.c~mm-always-print-rlimit_data-warning
+++ a/mm/mmap.c
@@ -3184,13 +3184,15 @@ bool may_expand_vm(struct mm_struct *mm,
 		if (rlimit(RLIMIT_DATA) == 0 &&
 		    mm->data_vm + npages <= rlimit_max(RLIMIT_DATA) >> PAGE_SHIFT)
 			return true;
-		if (!ignore_rlimit_data) {
-			pr_warn_once("%s (%d): VmData %lu exceed data ulimit %lu. Update limits or use boot option ignore_rlimit_data.\n",
-				     current->comm, current->pid,
-				     (mm->data_vm + npages) << PAGE_SHIFT,
-				     rlimit(RLIMIT_DATA));
+
+		pr_warn_once("%s (%d): VmData %lu exceed data ulimit %lu. Update limits%s.\n",
+			     current->comm, current->pid,
+			     (mm->data_vm + npages) << PAGE_SHIFT,
+			     rlimit(RLIMIT_DATA),
+			     ignore_rlimit_data ? "" : " or use boot option ignore_rlimit_data");
+
+		if (!ignore_rlimit_data)
 			return false;
-		}
 	}
 
 	return true;
_

Patches currently in -mm which might be from dwmw@amazon.co.uk are

mm-always-print-rlimit_data-warning.patch

