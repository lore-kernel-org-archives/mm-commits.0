From: akpm@linux-foundation.org
Subject: [patch 056/127] mm: mlock: check against vma for actual mlock()
 size
Date: Fri, 07 Oct 2016 16:59:36 -0700
Message-ID: <57f836e8.pbCTSznzKvi/u+cJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39169 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756002AbcJHAAO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:00:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, wei.guo.simon@gmail.com, emunson@akamai.com, geert@linux-m68k.org, kirill.shutemov@linux.intel.com, klimov.linux@gmail.com, mgorman@techsingularity.net, mhocko@suse.com, rientjes@google.com, shuah@kernel.org, treding@nvidia.com, vbabka@suse.cz

From: Simon Guo <wei.guo.simon@gmail.com>
Subject: mm: mlock: check against vma for actual mlock() size

In do_mlock(), the check against locked memory limitation has a hole which
will fail following cases at step 3):

1) User has a memory chunk from addressA with 50k, and user
mem lock rlimit is 64k.
2) mlock(addressA, 30k)
3) mlock(addressA, 40k)

The 3rd step should have been allowed since the 40k request is intersected
with the previous 30k at step 2), and the 3rd step is actually for mlock
on the extra 10k memory.

This patch checks vma to caculate the actual "new" mlock size, if
necessary, and ajust the logic to fix this issue.

[akpm@linux-foundation.org: clean up comment layout]
[wei.guo.simon@gmail.com: correct a typo in count_mm_mlocked_page_nr()]
 Link: http://lkml.kernel.org/r/1473325970-11393-2-git-send-email-wei.guo.simon@gmail.com
Link: http://lkml.kernel.org/r/1472554781-9835-2-git-send-email-wei.guo.simon@gmail.com
Signed-off-by: Simon Guo <wei.guo.simon@gmail.com>
Cc: Alexey Klimov <klimov.linux@gmail.com>
Cc: Eric B Munson <emunson@akamai.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Simon Guo <wei.guo.simon@gmail.com>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff -puN mm/mlock.c~mm-mlock-check-against-vma-for-actual-mlock-size mm/mlock.c
--- a/mm/mlock.c~mm-mlock-check-against-vma-for-actual-mlock-size
+++ a/mm/mlock.c
@@ -617,6 +617,45 @@ static int apply_vma_lock_flags(unsigned
 	return error;
 }
 
+/*
+ * Go through vma areas and sum size of mlocked
+ * vma pages, as return value.
+ * Note deferred memory locking case(mlock2(,,MLOCK_ONFAULT)
+ * is also counted.
+ * Return value: previously mlocked page counts
+ */
+static int count_mm_mlocked_page_nr(struct mm_struct *mm,
+		unsigned long start, size_t len)
+{
+	struct vm_area_struct *vma;
+	int count = 0;
+
+	if (mm == NULL)
+		mm = current->mm;
+
+	vma = find_vma(mm, start);
+	if (vma == NULL)
+		vma = mm->mmap;
+
+	for (; vma ; vma = vma->vm_next) {
+		if (start >= vma->vm_end)
+			continue;
+		if (start + len <=  vma->vm_start)
+			break;
+		if (vma->vm_flags & VM_LOCKED) {
+			if (start > vma->vm_start)
+				count -= (start - vma->vm_start);
+			if (start + len < vma->vm_end) {
+				count += start + len - vma->vm_start;
+				break;
+			}
+			count += vma->vm_end - vma->vm_start;
+		}
+	}
+
+	return count >> PAGE_SHIFT;
+}
+
 static __must_check int do_mlock(unsigned long start, size_t len, vm_flags_t flags)
 {
 	unsigned long locked;
@@ -639,6 +678,16 @@ static __must_check int do_mlock(unsigne
 		return -EINTR;
 
 	locked += current->mm->locked_vm;
+	if ((locked > lock_limit) && (!capable(CAP_IPC_LOCK))) {
+		/*
+		 * It is possible that the regions requested intersect with
+		 * previously mlocked areas, that part area in "mm->locked_vm"
+		 * should not be counted to new mlock increment count. So check
+		 * and adjust locked count if necessary.
+		 */
+		locked -= count_mm_mlocked_page_nr(current->mm,
+				start, len);
+	}
 
 	/* check against resource limits */
 	if ((locked <= lock_limit) || capable(CAP_IPC_LOCK))
_
