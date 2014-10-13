From: akpm@linux-foundation.org
Subject: [merged] introduce-vm_bug_on_vma.patch removed from -mm tree
Date: Mon, 13 Oct 2014 11:20:27 -0700
Message-ID: <543c17eb.9hpzhP4mFuEzw5/Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60596 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbaJMSU1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:20:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, hughd@google.com, khlebnikov@openvz.org, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, vbabka@suse.cz, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce VM_BUG_ON_VMA
has been removed from the -mm tree.  Its filename was
     introduce-vm_bug_on_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
kernel-add-support-for-gcc-5.patch
kernel-add-support-for-gcc-5-checkpatch-fixes.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch

