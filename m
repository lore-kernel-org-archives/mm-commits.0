From: akpm@linux-foundation.org
Subject: [folded-merged]
 selftest-add-mremap_dontunmap-selftest-v7.patch removed from -mm tree
Date: Wed, 01 Apr 2020 20:31:43 -0700
Message-ID: <20200402033143.o8g_Hhnzy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732667AbgDBDbq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 1 Apr 2020 23:31:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bgeffon@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftest: add MREMAP_DONTUNMAP selftest
has been removed from the -mm tree.  Its filename was
     selftest-add-mremap_dontunmap-selftest-v7.patch

This patch was dropped because it was folded into selftest-add-mremap_dontunmap-selftest.patch

------------------------------------------------------
From: Brian Geffon <bgeffon@google.com>
Subject: selftest: add MREMAP_DONTUNMAP selftest

Add a few simple self tests for the new flag MREMAP_DONTUNMAP,
they are simple smoke tests which also demonstrate the behavior.

Link: http://lkml.kernel.org/r/20200221174248.244748-2-bgeffon@google.com
Signed-off-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mremap_dontunmap.c |   91 ++++++----------
 1 file changed, 39 insertions(+), 52 deletions(-)

--- a/tools/testing/selftests/vm/mremap_dontunmap.c~selftest-add-mremap_dontunmap-selftest-v7
+++ a/tools/testing/selftests/vm/mremap_dontunmap.c
@@ -36,7 +36,7 @@ static void dump_maps(void)
 		if (condition) {					      \
 			fprintf(stderr, "[FAIL]\t%s():%d\t%s:%s\n", __func__, \
 				__LINE__, (description), strerror(errno));    \
-			dump_maps();					      \
+			dump_maps();					  \
 			exit(1);					      \
 		} 							      \
 	} while (0)
@@ -224,73 +224,60 @@ static void mremap_dontunmap_partial_map
 	       "unable to unmap source mapping");
 }
 
-// This test validates that we can shrink an existing mapping via the normal
-// mremap behavior along with the MREMAP_DONTUNMAP flag.
-static void mremap_dontunmap_shrink_mapping()
+// This test validates that we can remap over only a portion of a mapping.
+static void mremap_dontunmap_partial_mapping_overwrite()
 {
 	/*
-	 * We shrink the source by 5 pages while remapping.
 	 *  source mapping:
-	 *  --------------
-	 *  | aaaaaaaaaa |
-	 *  --------------
-	 *  to become:
 	 *  ---------
-	 *  | 00000 |
+	 *  |aaaaa|
 	 *  ---------
-	 *  With the destination mapping containing 5 pages of As followed by
-	 *  the original pages of Xs.
-	 *  --------------
-	 *  | aaaaaXXXXX |
-	 *  --------------
+	 *  dest mapping initially:
+	 *  -----------
+	 *  |XXXXXXXXXX|
+	 *  ------------
+	 *  Source to become:
+	 *  ---------
+	 *  |00000|
+	 *  ---------
+	 *  With the destination mapping containing 5 pages of As.
+	 *  ------------
+	 *  |aaaaaXXXXX|
+	 *  ------------
 	 */
+	void *source_mapping =
+	    mmap(NULL, 5 * page_size, PROT_READ | PROT_WRITE,
+		 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	BUG_ON(source_mapping == MAP_FAILED, "mmap");
+	memset(source_mapping, 'a', 5 * page_size);
 
-	unsigned long num_pages = 10;
-
-	// We use MREMAP_FIXED because we don't want the mremap to place the
-	// remapped mapping behind the source, if it did
-	// we wouldn't be able to validate that the mapping was in fact
-	// adjusted.
 	void *dest_mapping =
-	    mmap(NULL, num_pages * page_size, PROT_READ | PROT_WRITE,
+	    mmap(NULL, 10 * page_size, PROT_READ | PROT_WRITE,
 		 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	BUG_ON(dest_mapping == MAP_FAILED, "mmap");
-	memset(dest_mapping, 'X', num_pages * page_size);
+	memset(dest_mapping, 'X', 10 * page_size);
 
-	void *source_mapping =
-	    mmap(NULL, num_pages * page_size, PROT_READ | PROT_WRITE,
-		 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-	BUG_ON(source_mapping == MAP_FAILED, "mmap");
-	memset(source_mapping, 'a', num_pages * page_size);
-
-	// We are shrinking the mapping while also using MREMAP_DONTUNMAP
+	// We will grab the last 5 pages of the source and move them.
 	void *remapped_mapping =
-	    mremap(source_mapping, num_pages * page_size, 5 * page_size,
-		   MREMAP_FIXED | MREMAP_DONTUNMAP | MREMAP_MAYMOVE,
-		   dest_mapping);
-	BUG_ON(remapped_mapping == MAP_FAILED, "mremap");
-	BUG_ON(remapped_mapping != dest_mapping,
-	       "expected mremap to place mapping at dest");
-
-	// The last 5 pages of source should have become unmapped while the
-	// first 5 remain.
-	unsigned char buf[5];
-	int ret = mincore(source_mapping + (5 * page_size), 5 * page_size, buf);
-	BUG_ON((ret != -1 || (ret == -1 && errno != ENOMEM)),
-	       "we expect -ENOMEM from mincore.");
+	    mremap(source_mapping, 5 * page_size,
+		   5 * page_size,
+		   MREMAP_DONTUNMAP | MREMAP_MAYMOVE | MREMAP_FIXED, dest_mapping);
+	BUG_ON(dest_mapping == MAP_FAILED, "mremap");
+	BUG_ON(dest_mapping != remapped_mapping, "expected to remap to dest_mapping");
 
 	BUG_ON(check_region_contains_byte(source_mapping, 5 * page_size, 0) !=
-	       0, "source should have no ptes");
-	BUG_ON(check_region_contains_byte(dest_mapping, 5 * page_size, 'a') !=
-	       0, "dest mapping should contain ptes from the source");
+	       0, "first 5 pages of source should have no ptes");
+
+	// Finally we expect the destination to have 5 pages worth of a's.
+	BUG_ON(check_region_contains_byte(dest_mapping, 5 * page_size, 'a') != 0,
+			"dest mapping should contain ptes from the source");
 
-	// And the second half of the destination should be unchanged.
+	// Finally the last 5 pages shouldn't have been touched.
 	BUG_ON(check_region_contains_byte(dest_mapping + (5 * page_size),
-					  5 * page_size, 'X') != 0,
-	       "second half of dest shouldn't be touched");
+				5 * page_size, 'X') != 0,
+			"dest mapping should have retained the last 5 pages");
 
-	// Cleanup
-	BUG_ON(munmap(dest_mapping, num_pages * page_size) == -1,
+	BUG_ON(munmap(dest_mapping, 10 * page_size) == -1,
 	       "unable to unmap destination mapping");
 	BUG_ON(munmap(source_mapping, 5 * page_size) == -1,
 	       "unable to unmap source mapping");
@@ -316,7 +303,7 @@ int main(void)
 	mremap_dontunmap_simple();
 	mremap_dontunmap_simple_fixed();
 	mremap_dontunmap_partial_mapping();
-	mremap_dontunmap_shrink_mapping();
+	mremap_dontunmap_partial_mapping_overwrite();
 
 	BUG_ON(munmap(page_buffer, page_size) == -1,
 	       "unable to unmap page buffer");
_

Patches currently in -mm which might be from bgeffon@google.com are

mm-add-mremap_dontunmap-to-mremap.patch
selftest-add-mremap_dontunmap-selftest.patch
