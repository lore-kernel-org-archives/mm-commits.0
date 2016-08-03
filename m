From: akpm@linux-foundation.org
Subject: [merged] mm-refuse-wrapped-vm_brk-requests.patch removed from -mm tree
Date: Wed, 03 Aug 2016 11:12:53 -0700
Message-ID: <57a23425.DPjLIp8F7veAgMGd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378AbcHCSNo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, aarcange@redhat.com, aryabinin@virtuozzo.com, gang.chen.5i5j@gmail.com, hecmargi@upv.es, iripoll@upv.es, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mhocko@suse.com, oleg@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: refuse wrapped vm_brk requests
has been removed from the -mm tree.  Its filename was
     mm-refuse-wrapped-vm_brk-requests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mm: refuse wrapped vm_brk requests

The vm_brk() alignment calculations should refuse to overflow. The ELF
loader depending on this, but it has been fixed now. No other unsafe
callers have been found.

Link: http://lkml.kernel.org/r/1468014494-25291-3-git-send-email-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Hector Marco-Gisbert <hecmargi@upv.es>
Cc: Ismael Ripoll Ripoll <iripoll@upv.es>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/mmap.c~mm-refuse-wrapped-vm_brk-requests mm/mmap.c
--- a/mm/mmap.c~mm-refuse-wrapped-vm_brk-requests
+++ a/mm/mmap.c
@@ -2653,16 +2653,18 @@ static inline void verify_mm_writelocked
  *  anonymous maps.  eventually we may be able to do some
  *  brk-specific accounting here.
  */
-static int do_brk(unsigned long addr, unsigned long len)
+static int do_brk(unsigned long addr, unsigned long request)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev;
-	unsigned long flags;
+	unsigned long flags, len;
 	struct rb_node **rb_link, *rb_parent;
 	pgoff_t pgoff = addr >> PAGE_SHIFT;
 	int error;
 
-	len = PAGE_ALIGN(len);
+	len = PAGE_ALIGN(request);
+	if (len < request)
+		return -ENOMEM;
 	if (!len)
 		return 0;
 
_

Patches currently in -mm which might be from keescook@chromium.org are


