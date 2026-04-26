Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429C835F5EF
	for <mm-commits@vger.kernel.org>; Sun, 26 Apr 2026 20:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777233639; cv=none; b=W8T/xnExkqf059rF9HIpwH9VXiqfh8Rzi2e2M3GW+TRx090hQTrdDrsTRwKs2ybyIHaI7ctE38/y0+ibUaw7AN8jKWetnXNTQhUSQNEiCEinbuBB721nAhq6L9Sq3J5paTJYsoyOnoABRzW7WNh/Nlxm7c4SZgEXskf0qPjHqOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777233639; c=relaxed/simple;
	bh=6SNz94CtBiXMaiaGqjSdsVy6J3OeYd80zT0iDRETh0U=;
	h=Date:To:From:Subject:Message-Id; b=CdxMSdjeqqPGMRbpd4yd6ShEsZFissX+yAm3DVmPcvW4OJXDeW0f4MH3RJll9qBVAFvmNq+c3SZ3nf4dEbRnCgDET9dbMLNYzH3P1zfq42mcyfWWJp8hTj0BkNLQtsMQyM9/D5fZhu6TfSVgWeT4s1C//apLXngKP8SzspxTn5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ScRdsOxp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ScRdsOxp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FC9C2BCAF;
	Sun, 26 Apr 2026 20:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777233638;
	bh=6SNz94CtBiXMaiaGqjSdsVy6J3OeYd80zT0iDRETh0U=;
	h=Date:To:From:Subject:From;
	b=ScRdsOxpHOLwbg3j3TSOcX2uPzwJOf2281/FknV6OOUnclMWWkxSE+Zt3EJWeUHoO
	 PHMuVEZqx/+6bKafv8jEM1K/0MrhDKa+iOdjQVSOQhxmgF6aCydg1kQpI68iAokh0l
	 M4iirZrlQ28MB7tklpwY+6Y+uifqPAjcEi2pZhJY=
Date: Sun, 26 Apr 2026 13:00:38 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shuah@kernel.org,richard.weiyang@gmail.com,pfalcato@suse.de,paulmck@kernel.org,ljs@kernel.org,liam@infradead.org,jannh@google.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-proc-add-proc-pid-smaps-tearing-tests.patch added to mm-new branch
Message-Id: <20260426200038.D9FC9C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/proc: add /proc/pid/smaps tearing tests
has been added to the -mm mm-new branch.  Its filename is
     selftests-proc-add-proc-pid-smaps-tearing-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-proc-add-proc-pid-smaps-tearing-tests.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: selftests/proc: add /proc/pid/smaps tearing tests
Date: Sat, 25 Apr 2026 23:27:18 -0700

Add tearing tests for /proc/pid/smaps file.  New tests reuse the same
logic as with maps file but skipping all the data except for the VMA
addresses, which are the only part relevant for the tearing tests.  Skip
PROCMAP_QUERY parts of the tests because smaps does not implement that
ioctl.

Link: https://lore.kernel.org/20260426062718.1238437-4-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett <liam@infradead.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/proc-maps-race.c |  178 +++++++++++-----
 1 file changed, 133 insertions(+), 45 deletions(-)

--- a/tools/testing/selftests/proc/proc-maps-race.c~selftests-proc-add-proc-pid-smaps-tearing-tests
+++ a/tools/testing/selftests/proc/proc-maps-race.c
@@ -17,8 +17,8 @@
  */
 /*
  * Fork a child that concurrently modifies address space while the main
- * process is reading /proc/$PID/maps and verifying the results. Address
- * space modifications include:
+ * process is reading /proc/$PID/maps and /proc/$PID/smaps, verifying the
+ * results. Address space modifications include:
  *     VMA splitting and merging
  *
  */
@@ -73,6 +73,11 @@ enum test_state {
 	TEST_DONE,
 };
 
+enum maps_file {
+	MAPS,
+	SMAPS,
+};
+
 struct vma_modifier_info;
 
 FIXTURE(proc_maps_race)
@@ -83,6 +88,7 @@ FIXTURE(proc_maps_race)
 	struct line_content last_line;
 	struct line_content first_line;
 	unsigned long duration_sec;
+	enum maps_file maps_file;
 	int shared_mem_size;
 	int skip_pages;
 	int page_size;
@@ -92,6 +98,19 @@ FIXTURE(proc_maps_race)
 	pid_t pid;
 };
 
+FIXTURE_VARIANT(proc_maps_race)
+{
+	const enum maps_file maps_file;
+};
+
+FIXTURE_VARIANT_ADD(proc_maps_race, maps) {
+	.maps_file = MAPS,
+};
+
+FIXTURE_VARIANT_ADD(proc_maps_race, smaps) {
+	.maps_file = SMAPS,
+};
+
 typedef bool (*vma_modifier_op)(FIXTURE_DATA(proc_maps_race) *self);
 typedef bool (*vma_mod_result_check_op)(struct line_content *mod_last_line,
 					struct line_content *mod_first_line,
@@ -222,6 +241,57 @@ static void copy_last_line(struct page_c
 	copy_line(pos, end, last_line, line_size);
 }
 
+static bool copy_first_entry(struct page_content *page, char *first_line,
+			     size_t line_size)
+{
+	char *start_pos = page->data;
+
+	while (start_pos < page->data + page->size) {
+		unsigned long start_addr;
+		unsigned long end_addr;
+		char *end_pos;
+
+		end_pos = strchr(start_pos, '\n');
+		if (!end_pos)
+			break;
+
+		if (parse_vma_line(start_pos, end_pos, &start_addr, &end_addr)) {
+			copy_line(start_pos, end_pos, first_line, line_size);
+			return true;
+		}
+
+		start_pos = end_pos + 1;
+	}
+
+	return false;
+}
+
+static bool copy_last_entry(struct page_content *page, char *last_line,
+			    size_t line_size)
+{
+	char *end_pos = page->data + page->size - 1;
+	char *start_pos;
+
+	while (end_pos > page->data) {
+		unsigned long start_addr;
+		unsigned long end_addr;
+
+		/* skip last newline */
+		start_pos = end_pos - 1;
+		/* search previous newline */
+		while (start_pos > page->data && start_pos[-1] != '\n')
+			start_pos--;
+		if (parse_vma_line(start_pos, end_pos, &start_addr, &end_addr)) {
+			copy_line(start_pos, end_pos, last_line, line_size);
+			return true;
+		}
+
+		end_pos = start_pos - 1;
+	}
+
+	return false;
+}
+
 /* Read the last line of the first page and the first line of the second page */
 static bool read_boundary_lines(FIXTURE_DATA(proc_maps_race) *self,
 				struct line_content *last_line,
@@ -230,8 +300,16 @@ static bool read_boundary_lines(FIXTURE_
 	if (!read_two_pages(self))
 		return false;
 
-	copy_last_line(&self->page1, last_line->text, LINE_MAX_SIZE);
-	copy_first_line(&self->page2, first_line->text, LINE_MAX_SIZE);
+	if (self->maps_file == MAPS) {
+		copy_last_line(&self->page1, last_line->text, LINE_MAX_SIZE);
+		copy_first_line(&self->page2, first_line->text, LINE_MAX_SIZE);
+	} else if (self->maps_file == SMAPS) {
+		if (!copy_last_entry(&self->page1, last_line->text, LINE_MAX_SIZE) ||
+		    !copy_first_entry(&self->page2, first_line->text, LINE_MAX_SIZE))
+			return false;
+	} else {
+		return false;
+	}
 
 	return sscanf(last_line->text, "%lx-%lx", &last_line->start_addr,
 		      &last_line->end_addr) == 2 &&
@@ -497,6 +575,7 @@ FIXTURE_SETUP(proc_maps_race)
 
 	self->page_size = (unsigned long)sysconf(_SC_PAGESIZE);
 	self->verbose = verbose && !strncmp(verbose, "1", 1);
+	self->maps_file = variant->maps_file;
 	duration_sec = duration ? atol(duration) : 0;
 	self->duration_sec = duration_sec ? duration_sec : 5UL;
 
@@ -563,7 +642,16 @@ FIXTURE_SETUP(proc_maps_race)
 		exit(0);
 	}
 
-	sprintf(fname, "/proc/%d/maps", self->pid);
+	switch (self->maps_file) {
+	case MAPS:
+		sprintf(fname, "/proc/%d/maps", self->pid);
+		break;
+	case SMAPS:
+		sprintf(fname, "/proc/%d/smaps", self->pid);
+		break;
+	default:
+		ksft_exit_fail();
+	}
 	self->maps_fd = open(fname, O_RDONLY);
 	ASSERT_NE(self->maps_fd, -1);
 
@@ -608,7 +696,6 @@ FIXTURE_SETUP(proc_maps_race)
 	ASSERT_TRUE(mod_info->addr && mod_info->next_addr);
 
 	signal_state(mod_info, PARENT_READY);
-
 }
 
 FIXTURE_TEARDOWN(proc_maps_race)
@@ -698,20 +785,20 @@ TEST_F(proc_maps_race, test_maps_tearing
 		last_line_changed = strcmp(new_last_line.text, self->last_line.text) != 0;
 		first_line_changed = strcmp(new_first_line.text, self->first_line.text) != 0;
 		ASSERT_EQ(last_line_changed, first_line_changed);
-
-		/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
-		ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr + self->page_size,
-					  &vma_start, &vma_end));
-		/*
-		 * The vma at the split address can be either the same as
-		 * original one (if read before the split) or the same as the
-		 * first line in the second page (if read after the split).
-		 */
-		ASSERT_TRUE((vma_start == self->last_line.start_addr &&
-			     vma_end == self->last_line.end_addr) ||
-			    (vma_start == split_first_line.start_addr &&
-			     vma_end == split_first_line.end_addr));
-
+		if (self->maps_file == MAPS) {
+			/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
+			ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr + self->page_size,
+						  &vma_start, &vma_end));
+			/*
+			 * The vma at the split address can be either the same as
+			 * original one (if read before the split) or the same as the
+			 * first line in the second page (if read after the split).
+			 */
+			ASSERT_TRUE((vma_start == self->last_line.start_addr &&
+				     vma_end == self->last_line.end_addr) ||
+				    (vma_start == split_first_line.start_addr &&
+				     vma_end == split_first_line.end_addr));
+		}
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
 		end_test_iteration(&end_ts, self->verbose);
 	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
@@ -781,17 +868,18 @@ TEST_F(proc_maps_race, test_maps_tearing
 					strcmp(new_first_line.text, restored_first_line.text),
 					"Expand result invalid", self));
 		}
-
-		/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
-		ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr, &vma_start, &vma_end));
-		/*
-		 * The vma should stay at the same address and have either the
-		 * original size of 3 pages or 1 page if read after shrinking.
-		 */
-		ASSERT_TRUE(vma_start == self->last_line.start_addr &&
-			    (vma_end - vma_start == self->page_size * 3 ||
-			     vma_end - vma_start == self->page_size));
-
+		if (self->maps_file == MAPS) {
+			/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
+			ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr,
+						  &vma_start, &vma_end));
+			/*
+			 * The vma should stay at the same address and have either the
+			 * original size of 3 pages or 1 page if read after shrinking.
+			 */
+			ASSERT_TRUE(vma_start == self->last_line.start_addr &&
+				    (vma_end - vma_start == self->page_size * 3 ||
+				     vma_end - vma_start == self->page_size));
+		}
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
 		end_test_iteration(&end_ts, self->verbose);
 	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
@@ -861,20 +949,20 @@ TEST_F(proc_maps_race, test_maps_tearing
 					strcmp(new_first_line.text, restored_first_line.text),
 					"Remap restore result invalid", self));
 		}
-
-		/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
-		ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr + self->page_size,
-					  &vma_start, &vma_end));
-		/*
-		 * The vma should either stay at the same address and have the
-		 * original size of 3 pages or we should find the remapped vma
-		 * at the remap destination address with size of 1 page.
-		 */
-		ASSERT_TRUE((vma_start == self->last_line.start_addr &&
-			     vma_end - vma_start == self->page_size * 3) ||
-			    (vma_start == self->last_line.start_addr + self->page_size &&
-			     vma_end - vma_start == self->page_size));
-
+		if (self->maps_file == MAPS) {
+			/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
+			ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr + self->page_size,
+						  &vma_start, &vma_end));
+			/*
+			 * The vma should either stay at the same address and have the
+			 * original size of 3 pages or we should find the remapped vma
+			 * at the remap destination address with size of 1 page.
+			 */
+			ASSERT_TRUE((vma_start == self->last_line.start_addr &&
+				     vma_end - vma_start == self->page_size * 3) ||
+				    (vma_start == self->last_line.start_addr + self->page_size &&
+				     vma_end - vma_start == self->page_size));
+		}
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
 		end_test_iteration(&end_ts, self->verbose);
 	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
_

Patches currently in -mm which might be from surenb@google.com are

fs-proc-task_mmu-read-proc-pid-smapsnuma_maps-under-per-vma-lock.patch
selftests-proc-ensure-the-test-is-performed-at-the-right-page-boundary.patch
selftests-proc-add-proc-pid-smaps-tearing-tests.patch

