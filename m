From: akpm@linux-foundation.org
Subject: [patch 027/162] mm: enable RLIMIT_DATA by default with workaround for valgrind
Date: Fri, 20 May 2016 16:57:45 -0700
Message-ID: <573fa479.t0dMsezmWB8cu3tZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbcETX5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:57:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, koct9i@gmail.com, borntraeger@de.ibm.com, gorcunov@openvz.org

From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: mm: enable RLIMIT_DATA by default with workaround for valgrind

Since commit 84638335900f ("mm: rework virtual memory accounting")
RLIMIT_DATA limits both brk() and private mmap() but this's disabled by
default because of incompatibility with older versions of valgrind.

Valgrind always set limit to zero and fails if RLIMIT_DATA is enabled. 
Fortunately it changes only rlim_cur and keeps rlim_max for reverting
limit back when needed.

This patch checks current usage also against rlim_max if rlim_cur is zero.
This is safe because task anyway can increase rlim_cur up to rlim_max. 
Size of brk is still checked against rlim_cur, so this part is completely
compatible - zero rlim_cur forbids brk() but allows private mmap().

Link: http://lkml.kernel.org/r/56A28613.5070104@de.ibm.com
Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN mm/mmap.c~mm-enable-rlimit_data-by-default-with-workaround-for-valgrind mm/mmap.c
--- a/mm/mmap.c~mm-enable-rlimit_data-by-default-with-workaround-for-valgrind
+++ a/mm/mmap.c
@@ -66,7 +66,7 @@ const int mmap_rnd_compat_bits_max = CON
 int mmap_rnd_compat_bits __read_mostly = CONFIG_ARCH_MMAP_RND_COMPAT_BITS;
 #endif
 
-static bool ignore_rlimit_data = true;
+static bool ignore_rlimit_data;
 core_param(ignore_rlimit_data, ignore_rlimit_data, bool, 0644);
 
 static void unmap_region(struct mm_struct *mm,
@@ -2886,13 +2886,17 @@ bool may_expand_vm(struct mm_struct *mm,
 
 	if (is_data_mapping(flags) &&
 	    mm->data_vm + npages > rlimit(RLIMIT_DATA) >> PAGE_SHIFT) {
-		if (ignore_rlimit_data)
-			pr_warn_once("%s (%d): VmData %lu exceed data ulimit %lu. Will be forbidden soon.\n",
+		/* Workaround for Valgrind */
+		if (rlimit(RLIMIT_DATA) == 0 &&
+		    mm->data_vm + npages <= rlimit_max(RLIMIT_DATA) >> PAGE_SHIFT)
+			return true;
+		if (!ignore_rlimit_data) {
+			pr_warn_once("%s (%d): VmData %lu exceed data ulimit %lu. Update limits or use boot option ignore_rlimit_data.\n",
 				     current->comm, current->pid,
 				     (mm->data_vm + npages) << PAGE_SHIFT,
 				     rlimit(RLIMIT_DATA));
-		else
 			return false;
+		}
 	}
 
 	return true;
_
