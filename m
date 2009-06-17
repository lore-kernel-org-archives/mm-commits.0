From: akpm@linux-foundation.org
Subject: [folded] gcov-add-gcov-profiling-infrastructure-use-vmalloc-for-duplicating-counter-data.patch removed from -mm tree
Date: Wed, 17 Jun 2009 15:56:15 -0700
Message-ID: <200906172256.n5HMuFB8015781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757087AbZFQW4P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 18:56:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oberpar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     gcov: use vmalloc for duplicating counter data
has been removed from the -mm tree.  Its filename was
     gcov-add-gcov-profiling-infrastructure-use-vmalloc-for-duplicating-counter-data.patch

This patch was dropped because it was folded into gcov-add-gcov-profiling-infrastructure.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gcov: use vmalloc for duplicating counter data
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

Coverage data is duplicated during each open() of a data file and when
modules are unloaded.  The contained data areas can get large (>50 kb)
so that kmalloc()-based allocations may fail due to memory
fragmentation, especially when a system has run for a long time.  As we
only need virtually contiguous memory for the duplicate, the use of
vmalloc() can help prevent this problem.

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/gcc_3_4.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/gcov/gcc_3_4.c~gcov-add-gcov-profiling-infrastructure-use-vmalloc-for-duplicating-counter-data kernel/gcov/gcc_3_4.c
--- a/kernel/gcov/gcc_3_4.c~gcov-add-gcov-profiling-infrastructure-use-vmalloc-for-duplicating-counter-data
+++ a/kernel/gcov/gcc_3_4.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/seq_file.h>
+#include <linux/vmalloc.h>
 #include "gcov.h"
 
 /* Symbolic links to be created for each profiling data file. */
@@ -152,9 +153,10 @@ struct gcov_info *gcov_info_dup(struct g
 
 		dup->counts[i].num = ctr->num;
 		dup->counts[i].merge = ctr->merge;
-		dup->counts[i].values = kmemdup(ctr->values, size, GFP_KERNEL);
+		dup->counts[i].values = vmalloc(size);
 		if (!dup->counts[i].values)
 			goto err_free;
+		memcpy(dup->counts[i].values, ctr->values, size);
 	}
 	return dup;
 
@@ -173,7 +175,7 @@ void gcov_info_free(struct gcov_info *in
 	unsigned int i;
 
 	for (i = 0; i < active ; i++)
-		kfree(info->counts[i].values);
+		vfree(info->counts[i].values);
 	kfree(info->functions);
 	kfree(info->filename);
 	kfree(info);
_

Patches currently in -mm which might be from oberpar@linux.vnet.ibm.com are

kernel-constructor-support.patch
seq_file-add-function-to-write-binary-data.patch
gcov-add-gcov-profiling-infrastructure.patch
gcov-add-gcov-profiling-infrastructure-use-vmalloc-for-duplicating-counter-data.patch
gcov-enable-gcov_profile_all-for-x86_64.patch

