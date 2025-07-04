Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DCFA2D
	for <mm-commits@vger.kernel.org>; Fri,  4 Jul 2025 21:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751664201; cv=none; b=UZPRRsY39d17lYuGpNPbSqnX9WxMuBX5XfK2v1Mh9/KQ5dvhAe2+g7pd3ZRQoW+LcwQXILWu2O8WyROj4Biwo/7Oo9JVzc4iHJJSm2fLzPNcMFdGTYC7fULsz+0NnZ8Od1dfcjvu0FTFLtJCTNMjIG9iSO66Vr/ZPMhNux9BrQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751664201; c=relaxed/simple;
	bh=X6T04y+F211FTmlAtobF41KNkKixH7yG+LljZWmI+fg=;
	h=Date:To:From:Subject:Message-Id; b=FWCrA25EQT/njL/bL2C6pHHd4fN56xKxuEe926dCF5pWYb0GEdvvkx16moiWDyIMmYQ1yrBAnhPYsG4TNhJJPdxPGqMiE1SVOKZAXYevCLhsXw971GapUWDB7I3bDhnrofAMAozV27g+3z9wJU9ktxl7kkab2aHPqJj1i2DruF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QLSlo2OQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QLSlo2OQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA33C4CEE3;
	Fri,  4 Jul 2025 21:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751664200;
	bh=X6T04y+F211FTmlAtobF41KNkKixH7yG+LljZWmI+fg=;
	h=Date:To:From:Subject:From;
	b=QLSlo2OQpMPgvMZGX6qLs/7rkeXLp53YZGx17yY0AWSTDM1C0rQ53X5YCPiZiSonu
	 jnlVHuqILlO7kivFXcXKvKG0n3jrIsbdJ90SNL+/flb1zfTKeKQZD1iTpXAxbEpb+K
	 Ke32oo7mylQJ2yTSCEbafUEfEqp9HBgFit6j6HF4=
Date: Fri, 04 Jul 2025 14:23:20 -0700
To: mm-commits@vger.kernel.org,yebin10@huawei.com,willy@infradead.org,vbabka@suse.cz,tjmercier@google.com,shuah@kernel.org,ryan.roberts@arm.com,peterx@redhat.com,paulmck@kernel.org,osalvador@suse.de,mhocko@kernel.org,lorenzo.stoakes@oracle.com,linux@weissschuh.net,liam.howlett@oracle.com,kaleshsingh@google.com,josef@toxicpanda.com,jannh@google.com,hannes@cmpxchg.org,david@redhat.com,christophe.leroy@csgroup.eu,brauner@kernel.org,andrii@kernel.org,aha310510@gmail.com,adobriyan@gmail.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-proc-extend-proc-pid-maps-tearing-test-to-include-vma-resizing.patch added to mm-new branch
Message-Id: <20250704212320.8FA33C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/proc: extend /proc/pid/maps tearing test to include vma resizing
has been added to the -mm mm-new branch.  Its filename is
     selftests-proc-extend-proc-pid-maps-tearing-test-to-include-vma-resizing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-proc-extend-proc-pid-maps-tearing-test-to-include-vma-resizing.patch

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
Subject: selftests/proc: extend /proc/pid/maps tearing test to include vma resizing
Date: Thu, 3 Jul 2025 23:07:20 -0700

Test that /proc/pid/maps does not report unexpected holes in the address
space when a vma at the edge of the page is being concurrently remapped. 
This remapping results in the vma shrinking and expanding from under the
reader.  We should always see either shrunk or expanded (original) version
of the vma.

Link: https://lkml.kernel.org/r/20250704060727.724817-3-surenb@google.com
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

 tools/testing/selftests/proc/proc-maps-race.c |   83 ++++++++++++++++
 1 file changed, 83 insertions(+)

--- a/tools/testing/selftests/proc/proc-maps-race.c~selftests-proc-extend-proc-pid-maps-tearing-test-to-include-vma-resizing
+++ a/tools/testing/selftests/proc/proc-maps-race.c
@@ -336,6 +336,86 @@ static void test_maps_tearing_from_split
 	signal_state(mod_info, TEST_DONE);
 }
 
+static inline void shrink_vma(const struct vma_modifier_info *mod_info)
+{
+	assert(mremap(mod_info->addr, page_size * 3, page_size, 0) != MAP_FAILED);
+}
+
+static inline void expand_vma(const struct vma_modifier_info *mod_info)
+{
+	assert(mremap(mod_info->addr, page_size, page_size * 3, 0) != MAP_FAILED);
+}
+
+static inline void check_shrink_result(struct line_content *mod_last_line,
+				       struct line_content *mod_first_line,
+				       struct line_content *restored_last_line,
+				       struct line_content *restored_first_line)
+{
+	/* Make sure only the last vma of the first page is changing */
+	assert(strcmp(mod_last_line->text, restored_last_line->text) != 0);
+	assert(strcmp(mod_first_line->text, restored_first_line->text) == 0);
+}
+
+static void test_maps_tearing_from_resize(int maps_fd,
+					  struct vma_modifier_info *mod_info,
+					  struct page_content *page1,
+					  struct page_content *page2,
+					  struct line_content *last_line,
+					  struct line_content *first_line)
+{
+	struct line_content shrunk_last_line;
+	struct line_content shrunk_first_line;
+	struct line_content restored_last_line;
+	struct line_content restored_first_line;
+
+	wait_for_state(mod_info, SETUP_READY);
+
+	/* re-read the file to avoid using stale data from previous test */
+	read_boundary_lines(maps_fd, page1, page2, last_line, first_line);
+
+	mod_info->vma_modify = shrink_vma;
+	mod_info->vma_restore = expand_vma;
+	mod_info->vma_mod_check = check_shrink_result;
+
+	capture_mod_pattern(maps_fd, mod_info, page1, page2, last_line, first_line,
+			    &shrunk_last_line, &shrunk_first_line,
+			    &restored_last_line, &restored_first_line);
+
+	/* Now start concurrent modifications for test_duration_sec */
+	signal_state(mod_info, TEST_READY);
+
+	struct line_content new_last_line;
+	struct line_content new_first_line;
+	struct timespec start_ts, end_ts;
+
+	clock_gettime(CLOCK_MONOTONIC_COARSE, &start_ts);
+	do {
+		read_boundary_lines(maps_fd, page1, page2, &new_last_line, &new_first_line);
+
+		/* Check if we read vmas after shrinking it */
+		if (!strcmp(new_last_line.text, shrunk_last_line.text)) {
+			/*
+			 * The vmas should be consistent with shrunk results,
+			 * however if the vma was concurrently restored, it
+			 * can be reported twice (first as shrunk one, then
+			 * as restored one) because we found it as the next vma
+			 * again. In that case new first line will be the same
+			 * as the last restored line.
+			 */
+			assert(!strcmp(new_first_line.text, shrunk_first_line.text) ||
+			       !strcmp(new_first_line.text, restored_last_line.text));
+		} else {
+			/* The vmas should be consistent with the original/resored state */
+			assert(!strcmp(new_last_line.text, restored_last_line.text) &&
+			       !strcmp(new_first_line.text, restored_first_line.text));
+		}
+		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
+	} while (end_ts.tv_sec - start_ts.tv_sec < test_duration_sec);
+
+	/* Signal the modifyer thread to stop and wait until it exits */
+	signal_state(mod_info, TEST_DONE);
+}
+
 int usage(void)
 {
 	fprintf(stderr, "Userland /proc/pid/{s}maps race test cases\n");
@@ -444,6 +524,9 @@ int main(int argc, char **argv)
 	test_maps_tearing_from_split(maps_fd, mod_info, &page1, &page2,
 				     &last_line, &first_line);
 
+	test_maps_tearing_from_resize(maps_fd, mod_info, &page1, &page2,
+				      &last_line, &first_line);
+
 	stop_vma_modifier(mod_info);
 
 	free(page2.data);
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

