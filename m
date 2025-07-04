Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61835A2D
	for <mm-commits@vger.kernel.org>; Fri,  4 Jul 2025 21:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751664205; cv=none; b=QZqgafobPGVQwPRXw/WlLBdUpfhri7XgYUdkYs6HqfHl4MT4iuXDEVEFBp27aOlcqbcoDMD6TfY4jRy2sqfTDPzibiTR5gR68dzlwJdYjiFOxdBxqOLzfpvqMMElUWaHYks7mR0raBFA/s00dZwknwXdzBpSqmOmYnj/EUqF+tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751664205; c=relaxed/simple;
	bh=fzc5aGYe7voaTqnLTli71gblLx2vhW+88yoT9Ee5jzM=;
	h=Date:To:From:Subject:Message-Id; b=CsrKFQnzoxTa9jkDDEGbSSTAu8B8Q4sp5yyyJaCiuNrVP5hm6dGb+rtQdKzuxxlfh9ru0AR/K4mP2QBWt1/Znj2ri/VztQTw9TMxMtOXxqV0w72cghJ7ioCQdeBBbdizp2shpkET1+w9Hv4GNWfEHXG/A0x5i8uLdZQ63HBin6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZhCBhirE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZhCBhirE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC8FC4CEE3;
	Fri,  4 Jul 2025 21:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751664205;
	bh=fzc5aGYe7voaTqnLTli71gblLx2vhW+88yoT9Ee5jzM=;
	h=Date:To:From:Subject:From;
	b=ZhCBhirEf8qlzQCWB0FU3Gq1tUVlVURNBE/uI6T5Dm6WDsWL7T/K3Qj3wZCXQypgq
	 tQt3HPOv8opd4y9FBMuylt/mS/KCKqs4KBh+W0TUj7tm6c2WZnw/O5axPP/iAMWWF1
	 OaFAK2DVpSrNNrPZay2khhZjLVG+RzTcFFtPlfxw=
Date: Fri, 04 Jul 2025 14:23:24 -0700
To: mm-commits@vger.kernel.org,yebin10@huawei.com,willy@infradead.org,vbabka@suse.cz,tjmercier@google.com,shuah@kernel.org,ryan.roberts@arm.com,peterx@redhat.com,paulmck@kernel.org,osalvador@suse.de,mhocko@kernel.org,lorenzo.stoakes@oracle.com,linux@weissschuh.net,liam.howlett@oracle.com,kaleshsingh@google.com,josef@toxicpanda.com,jannh@google.com,hannes@cmpxchg.org,david@redhat.com,christophe.leroy@csgroup.eu,brauner@kernel.org,andrii@kernel.org,aha310510@gmail.com,adobriyan@gmail.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-proc-test-procmap_query-ioctl-while-vma-is-concurrently-modified.patch added to mm-new branch
Message-Id: <20250704212325.2CC8FC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/proc: test PROCMAP_QUERY ioctl while vma is concurrently modified
has been added to the -mm mm-new branch.  Its filename is
     selftests-proc-test-procmap_query-ioctl-while-vma-is-concurrently-modified.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-proc-test-procmap_query-ioctl-while-vma-is-concurrently-modified.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: selftests/proc: test PROCMAP_QUERY ioctl while vma is concurrently modified
Date: Thu, 3 Jul 2025 23:07:22 -0700

Extend /proc/pid/maps tearing test to verify PROCMAP_QUERY ioctl operation
correctness while the vma is being concurrently modified.

Link: https://lkml.kernel.org/r/20250704060727.724817-5-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeongjun Park <aha310510@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Cc: T.J. Mercier <tjmercier@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Ye Bin <yebin10@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/proc-maps-race.c |   62 ++++++++++++++++
 1 file changed, 62 insertions(+)

--- a/tools/testing/selftests/proc/proc-maps-race.c~selftests-proc-test-procmap_query-ioctl-while-vma-is-concurrently-modified
+++ a/tools/testing/selftests/proc/proc-maps-race.c
@@ -30,6 +30,8 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include <linux/fs.h>
+#include <sys/ioctl.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/types.h>
@@ -239,6 +241,21 @@ static void capture_mod_pattern(int maps
 	assert(strcmp(restored_first_line->text, first_line->text) == 0);
 }
 
+static void query_addr_at(int maps_fd, void *addr,
+			  unsigned long *vma_start, unsigned long *vma_end)
+{
+	struct procmap_query q;
+
+	memset(&q, 0, sizeof(q));
+	q.size = sizeof(q);
+	/* Find the VMA at the split address */
+	q.query_addr = (unsigned long long)addr;
+	q.query_flags = 0;
+	assert(!ioctl(maps_fd, PROCMAP_QUERY, &q));
+	*vma_start = q.vma_start;
+	*vma_end = q.vma_end;
+}
+
 static inline void split_vma(const struct vma_modifier_info *mod_info)
 {
 	assert(mmap(mod_info->addr, page_size, mod_info->prot | PROT_EXEC,
@@ -299,6 +316,8 @@ static void test_maps_tearing_from_split
 	do {
 		bool last_line_changed;
 		bool first_line_changed;
+		unsigned long vma_start;
+		unsigned long vma_end;
 
 		read_boundary_lines(maps_fd, page1, page2, &new_last_line, &new_first_line);
 
@@ -329,6 +348,19 @@ static void test_maps_tearing_from_split
 		first_line_changed = strcmp(new_first_line.text, first_line->text) != 0;
 		assert(last_line_changed == first_line_changed);
 
+		/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
+		query_addr_at(maps_fd, mod_info->addr + page_size,
+			      &vma_start, &vma_end);
+		/*
+		 * The vma at the split address can be either the same as
+		 * original one (if read before the split) or the same as the
+		 * first line in the second page (if read after the split).
+		 */
+		assert((vma_start == last_line->start_addr &&
+			vma_end == last_line->end_addr) ||
+		       (vma_start == split_first_line.start_addr &&
+			vma_end == split_first_line.end_addr));
+
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
 	} while (end_ts.tv_sec - start_ts.tv_sec < test_duration_sec);
 
@@ -390,6 +422,9 @@ static void test_maps_tearing_from_resiz
 
 	clock_gettime(CLOCK_MONOTONIC_COARSE, &start_ts);
 	do {
+		unsigned long vma_start;
+		unsigned long vma_end;
+
 		read_boundary_lines(maps_fd, page1, page2, &new_last_line, &new_first_line);
 
 		/* Check if we read vmas after shrinking it */
@@ -409,6 +444,17 @@ static void test_maps_tearing_from_resiz
 			assert(!strcmp(new_last_line.text, restored_last_line.text) &&
 			       !strcmp(new_first_line.text, restored_first_line.text));
 		}
+
+		/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
+		query_addr_at(maps_fd, mod_info->addr, &vma_start, &vma_end);
+		/*
+		 * The vma should stay at the same address and have either the
+		 * original size of 3 pages or 1 page if read after shrinking.
+		 */
+		assert(vma_start == last_line->start_addr &&
+		       (vma_end - vma_start == page_size * 3 ||
+			vma_end - vma_start == page_size));
+
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
 	} while (end_ts.tv_sec - start_ts.tv_sec < test_duration_sec);
 
@@ -479,6 +525,9 @@ static void test_maps_tearing_from_remap
 
 	clock_gettime(CLOCK_MONOTONIC_COARSE, &start_ts);
 	do {
+		unsigned long vma_start;
+		unsigned long vma_end;
+
 		read_boundary_lines(maps_fd, page1, page2, &new_last_line, &new_first_line);
 
 		/* Check if we read vmas after remapping it */
@@ -498,6 +547,19 @@ static void test_maps_tearing_from_remap
 			assert(!strcmp(new_last_line.text, restored_last_line.text) &&
 			       !strcmp(new_first_line.text, restored_first_line.text));
 		}
+
+		/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
+		query_addr_at(maps_fd, mod_info->addr + page_size, &vma_start, &vma_end);
+		/*
+		 * The vma should either stay at the same address and have the
+		 * original size of 3 pages or we should find the remapped vma
+		 * at the remap destination address with size of 1 page.
+		 */
+		assert((vma_start == last_line->start_addr &&
+			vma_end - vma_start == page_size * 3) ||
+		       (vma_start == last_line->start_addr + page_size &&
+			vma_end - vma_start == page_size));
+
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
 	} while (end_ts.tv_sec - start_ts.tv_sec < test_duration_sec);
 
_

Patches currently in -mm which might be from surenb@google.com are

selftests-proc-add-proc-pid-maps-tearing-from-vma-split-test.patch
selftests-proc-extend-proc-pid-maps-tearing-test-to-include-vma-resizing.patch
selftests-proc-extend-proc-pid-maps-tearing-test-to-include-vma-remapping.patch
selftests-proc-test-procmap_query-ioctl-while-vma-is-concurrently-modified.patch
selftests-proc-add-verbose-more-for-tests-to-facilitate-debugging.patch
fs-proc-task_mmu-remove-conversion-of-seq_file-position-to-unsigned.patch
fs-proc-task_mmu-read-proc-pid-maps-under-per-vma-lock.patch
fs-proc-task_mmu-execute-procmap_query-ioctl-under-per-vma-locks.patch

