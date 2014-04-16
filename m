From: akpm@linux-foundation.org
Subject: + mm-pass-vm_bug_on-reason-to-dump_page.patch added to -mm tree
Date: Wed, 16 Apr 2014 16:07:49 -0700
Message-ID: <534f0d45.ezx4FVvUcEYrIrLX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46974 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161013AbaDPXHu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 19:07:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com, davidlohr@hp.com, dave.hansen@linux.intel.com

Subject: + mm-pass-vm_bug_on-reason-to-dump_page.patch added to -mm tree
To: dave.hansen@linux.intel.com,davidlohr@hp.com,kirill.shutemov@linux.intel.com
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 16:07:49 -0700


The patch titled
     Subject: mm: pass VM_BUG_ON() reason to dump_page()
has been added to the -mm tree.  Its filename is
     mm-pass-vm_bug_on-reason-to-dump_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-pass-vm_bug_on-reason-to-dump_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-pass-vm_bug_on-reason-to-dump_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm: pass VM_BUG_ON() reason to dump_page()

I recently added a patch to let folks pass a "reason" string dump_page()
which gets dumped out along with the page's data.  This essentially saves
the bug-reader a trip in to the source to figure out why we BUG_ON()'d.

The new VM_BUG_ON_PAGE() passes in NULL for "reason".  It seems like we
might as well pass the BUG_ON() condition if we have it.  This will bloat
kernels a bit with ~160 new strings, but this is all under a debugging
option anyway.

	page:ffffea0008560280 count:1 mapcount:0 mapping:(null) index:0x0
	page flags: 0xbfffc0000000001(locked)
	page dumped because: VM_BUG_ON_PAGE(PageLocked(page))
	------------[ cut here ]------------
	kernel BUG at /home/davehans/linux.git/mm/filemap.c:464!
	invalid opcode: 0000 [#1] SMP
	CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0+ #251
	Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
	...

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN include/linux/mmdebug.h~mm-pass-vm_bug_on-reason-to-dump_page include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~mm-pass-vm_bug_on-reason-to-dump_page
+++ a/include/linux/mmdebug.h
@@ -9,8 +9,13 @@ extern void dump_page_badflags(struct pa
 
 #ifdef CONFIG_DEBUG_VM
 #define VM_BUG_ON(cond) BUG_ON(cond)
-#define VM_BUG_ON_PAGE(cond, page) \
-	do { if (unlikely(cond)) { dump_page(page, NULL); BUG(); } } while (0)
+#define VM_BUG_ON_PAGE(cond, page)					\
+	do {								\
+		if (unlikely(cond)) {					\
+			dump_page(page, "VM_BUG_ON_PAGE(" __stringify(cond)")");\
+			BUG();						\
+		}							\
+	} while (0)
 #define VM_WARN_ON(cond) WARN_ON(cond)
 #define VM_WARN_ON_ONCE(cond) WARN_ON_ONCE(cond)
 #else
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

