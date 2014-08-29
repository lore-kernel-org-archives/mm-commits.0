From: akpm@linux-foundation.org
Subject: + introduce-vm_bug_on_vma.patch added to -mm tree
Date: Fri, 29 Aug 2014 12:32:02 -0700
Message-ID: <5400d532.I9E+Cgp+0UF9OdDk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45690 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbaH2TcD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Aug 2014 15:32:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, hughd@google.com, khlebnikov@openvz.org, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, vbabka@suse.cz, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce VM_BUG_ON_VMA
has been added to the -mm tree.  Its filename is
     introduce-vm_bug_on_vma.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/introduce-vm_bug_on_vma.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/introduce-vm_bug_on_vma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: mm: introduce VM_BUG_ON_VMA

Very similar to VM_BUG_ON_PAGE but dumps VMA information instead.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michel Lespinasse <walken@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN include/linux/mmdebug.h~introduce-vm_bug_on_vma include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~introduce-vm_bug_on_vma
+++ a/include/linux/mmdebug.h
@@ -20,12 +20,20 @@ void dump_vma(const struct vm_area_struc
 			BUG();						\
 		}							\
 	} while (0)
+#define VM_BUG_ON_VMA(cond, vma)					\
+	do {								\
+		if (unlikely(cond)) {					\
+			dump_vma(vma);					\
+			BUG();						\
+		}							\
+	} while (0)
 #define VM_WARN_ON(cond) WARN_ON(cond)
 #define VM_WARN_ON_ONCE(cond) WARN_ON_ONCE(cond)
 #define VM_WARN_ONCE(cond, format...) WARN_ONCE(cond, format)
 #else
 #define VM_BUG_ON(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_BUG_ON_PAGE(cond, page) VM_BUG_ON(cond)
+#define VM_BUG_ON_VMA(cond, vma) VM_BUG_ON(cond)
 #define VM_WARN_ON(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ONCE(cond, format...) BUILD_BUG_ON_INVALID(cond)
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

x86mm-fix-pte_special-versus-pte_numa.patch
mm-balloon_compaction-ignore-anonymous-pages.patch
introduce-dump_vma.patch
introduce-vm_bug_on_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
vmstat-on-demand-vmstat-workers-v8-fix-2.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch

