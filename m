Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E5913B284
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 00:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754958113; cv=none; b=D4iZH05EfwS6x7IEL7j2hZ1WUit1pIudIOdgSvKSTOVnERJQ73SjgYwqkqt4e5fqXTarLrN4tdermbMA2tIEqPvLLr7XGIg4oMbFZlKH2/9Mn1VHEyMSmkcbKCH8U0iV4EsAYDZ4VbPatq3HW9DxA5utorHGBp3SnAFObPqc7Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754958113; c=relaxed/simple;
	bh=9zH7nMsrzbleYFP7Wq9V8Zcns3/3dTFLtO6yVyNgau8=;
	h=Date:To:From:Subject:Message-Id; b=i/ccvup3TSc6m+2DQqVCWVsRFyYDq7d3M73gNs5f+nQwuqGSNa1z2gTNAH/7Ouw72t0XrawxouAQ+mKi1vUhPhiqYx4qV2d+wPOD7IQpKibJ0E1WQr/hy1crTuFNr5UqPXKgky2CP8P3TxaUYkXjm/02MrxM1knRqn+dcX02YHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jmC9ADrd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jmC9ADrd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046D6C4CEED;
	Tue, 12 Aug 2025 00:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754958113;
	bh=9zH7nMsrzbleYFP7Wq9V8Zcns3/3dTFLtO6yVyNgau8=;
	h=Date:To:From:Subject:From;
	b=jmC9ADrdTLcWxrgqUoeeguWLyPOeVTH6tGdbYwnH6UPS7G8uN2vXLWy/kkFTPpfxR
	 qCrOxiX+vbrAfQyqk2AbHFb070/C9tJsbPpbPBDSN/BX5O5NEvh4M1favcxP6p66wQ
	 wIL5H2lzhVlA3TTQnYeNlUhR305MRwqpJrq6L5IQ=
Date: Mon, 11 Aug 2025 17:21:52 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-proc-test-procmap_query-ioctl-while-vma-is-concurrently-modified.patch added to mm-unstable branch
Message-Id: <20250812002153.046D6C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/proc: test PROCMAP_QUERY ioctl while vma is concurrently modified
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-proc-test-procmap_query-ioctl-while-vma-is-concurrently-modified.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-proc-test-procmap_query-ioctl-while-vma-is-concurrently-modified.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Date: Fri, 8 Aug 2025 08:28:47 -0700

Extend /proc/pid/maps tearing tests to verify PROCMAP_QUERY ioctl operation
correctness while the vma is being concurrently modified.

Link: https://lkml.kernel.org/r/20250808152850.2580887-2-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: SeongJae Park <sj@kernel.org>
Acked-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/proc-maps-race.c |   65 ++++++++++++++++
 1 file changed, 65 insertions(+)

--- a/tools/testing/selftests/proc/proc-maps-race.c~selftests-proc-test-procmap_query-ioctl-while-vma-is-concurrently-modified
+++ a/tools/testing/selftests/proc/proc-maps-race.c
@@ -32,6 +32,8 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include <linux/fs.h>
+#include <sys/ioctl.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/types.h>
@@ -317,6 +319,25 @@ static bool capture_mod_pattern(FIXTURE_
 	       strcmp(restored_first_line->text, self->first_line.text) == 0;
 }
 
+static bool query_addr_at(int maps_fd, void *addr,
+			  unsigned long *vma_start, unsigned long *vma_end)
+{
+	struct procmap_query q;
+
+	memset(&q, 0, sizeof(q));
+	q.size = sizeof(q);
+	/* Find the VMA at the split address */
+	q.query_addr = (unsigned long long)addr;
+	q.query_flags = 0;
+	if (ioctl(maps_fd, PROCMAP_QUERY, &q))
+		return false;
+
+	*vma_start = q.vma_start;
+	*vma_end = q.vma_end;
+
+	return true;
+}
+
 static inline bool split_vma(FIXTURE_DATA(proc_maps_race) *self)
 {
 	return mmap(self->mod_info->addr, self->page_size, self->mod_info->prot | PROT_EXEC,
@@ -559,6 +580,8 @@ TEST_F(proc_maps_race, test_maps_tearing
 	do {
 		bool last_line_changed;
 		bool first_line_changed;
+		unsigned long vma_start;
+		unsigned long vma_end;
 
 		ASSERT_TRUE(read_boundary_lines(self, &new_last_line, &new_first_line));
 
@@ -595,6 +618,19 @@ TEST_F(proc_maps_race, test_maps_tearing
 		first_line_changed = strcmp(new_first_line.text, self->first_line.text) != 0;
 		ASSERT_EQ(last_line_changed, first_line_changed);
 
+		/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
+		ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr + self->page_size,
+					  &vma_start, &vma_end));
+		/*
+		 * The vma at the split address can be either the same as
+		 * original one (if read before the split) or the same as the
+		 * first line in the second page (if read after the split).
+		 */
+		ASSERT_TRUE((vma_start == self->last_line.start_addr &&
+			     vma_end == self->last_line.end_addr) ||
+			    (vma_start == split_first_line.start_addr &&
+			     vma_end == split_first_line.end_addr));
+
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
 		end_test_iteration(&end_ts, self->verbose);
 	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
@@ -636,6 +672,9 @@ TEST_F(proc_maps_race, test_maps_tearing
 	clock_gettime(CLOCK_MONOTONIC_COARSE, &start_ts);
 	start_test_loop(&start_ts, self->verbose);
 	do {
+		unsigned long vma_start;
+		unsigned long vma_end;
+
 		ASSERT_TRUE(read_boundary_lines(self, &new_last_line, &new_first_line));
 
 		/* Check if we read vmas after shrinking it */
@@ -662,6 +701,16 @@ TEST_F(proc_maps_race, test_maps_tearing
 					"Expand result invalid", self));
 		}
 
+		/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
+		ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr, &vma_start, &vma_end));
+		/*
+		 * The vma should stay at the same address and have either the
+		 * original size of 3 pages or 1 page if read after shrinking.
+		 */
+		ASSERT_TRUE(vma_start == self->last_line.start_addr &&
+			    (vma_end - vma_start == self->page_size * 3 ||
+			     vma_end - vma_start == self->page_size));
+
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
 		end_test_iteration(&end_ts, self->verbose);
 	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
@@ -703,6 +752,9 @@ TEST_F(proc_maps_race, test_maps_tearing
 	clock_gettime(CLOCK_MONOTONIC_COARSE, &start_ts);
 	start_test_loop(&start_ts, self->verbose);
 	do {
+		unsigned long vma_start;
+		unsigned long vma_end;
+
 		ASSERT_TRUE(read_boundary_lines(self, &new_last_line, &new_first_line));
 
 		/* Check if we read vmas after remapping it */
@@ -729,6 +781,19 @@ TEST_F(proc_maps_race, test_maps_tearing
 					"Remap restore result invalid", self));
 		}
 
+		/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
+		ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr + self->page_size,
+					  &vma_start, &vma_end));
+		/*
+		 * The vma should either stay at the same address and have the
+		 * original size of 3 pages or we should find the remapped vma
+		 * at the remap destination address with size of 1 page.
+		 */
+		ASSERT_TRUE((vma_start == self->last_line.start_addr &&
+			     vma_end - vma_start == self->page_size * 3) ||
+			    (vma_start == self->last_line.start_addr + self->page_size &&
+			     vma_end - vma_start == self->page_size));
+
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
 		end_test_iteration(&end_ts, self->verbose);
 	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
_

Patches currently in -mm which might be from surenb@google.com are

userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry.patch
userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry-fix.patch
mm-limit-the-scope-of-vma_start_read.patch
mm-change-vma_start_read-to-drop-rcu-lock-on-failure.patch
selftests-proc-test-procmap_query-ioctl-while-vma-is-concurrently-modified.patch
fs-proc-task_mmu-factor-out-proc_maps_private-fields-used-by-procmap_query.patch
fs-proc-task_mmu-execute-procmap_query-ioctl-under-per-vma-locks.patch

