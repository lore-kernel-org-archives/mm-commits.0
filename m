Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272754848A5
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866001; cv=none; b=KN1NPnPSS5vVMV0ZIUGaUfeCDWlyCGQR5gwYNnVNoU12Yz90pLKmXpQFAS0BCLCaxX/2Lq4Z+wLdecsKrI3T9/MYJbKdZr9UXcIVAxHe+84IGT80l8QiKhOHJ5WQggpHLAOs7gUekW9V4Ms6wa32hxQRUMpVfY8DhudoLbPQ7VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866001; c=relaxed/simple;
	bh=WC5sYuaMxsRHVqqvJOZo/b4imSOegW/tuKk43hT8Zug=;
	h=Date:To:From:Subject:Message-Id; b=BIwitNl+pJpL2EhHO419VfCfT1hD9GDTi95MM4gFhTVr/daUh54yB4sxQxU38iFyoAB/b3jCm7AYtabgqdypXQiRq8RBciIna1Qe8xeQSgPtVQxHJkWMDtecojXEOC5mVtB1pp3PqzOivvyTXRzzFiq8PWT7YBQyrdMg0Gs4Gaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UNrQRVla; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UNrQRVla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B551A1F00893;
	Tue, 13 Oct 2026 04:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865998;
	bh=t+bO6AEiISDHRV0dLA2M6RWSIq6Z69yQ6rxBcpZ8Czk=;
	h=Date:To:From:Subject;
	b=UNrQRVla4nk2Te+0CpF1s8W2QP84sQATuZ98y3WtnBEC0CQrNjwkTuqjGfDpoMtD0
	 xq2W+4I+Y4DeTm/mt62NYInV1delbfM0bE+pkX5obhpdixrmzGCUdaFrgoJksI9nA3
	 Gp10GGr+ja7Yu9GeCDcidkH1CD0aJKSPC3sWO2UU=
Date: Mon, 12 Oct 2026 21:33:18 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,usama.arif@linux.dev,pfalcato@suse.de,paulmck@kernel.org,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-proc-add-proc-pid-smaps_rollup-tearing-tests.patch removed from -mm tree
Message-Id: <20261013043318.B551A1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/proc: add /proc/pid/smaps_rollup tearing tests
has been removed from the -mm tree.  Its filename was
     selftests-proc-add-proc-pid-smaps_rollup-tearing-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: selftests/proc: add /proc/pid/smaps_rollup tearing tests
Date: Fri, 18 Sep 2026 08:33:18 -0700

During tearing tests, smaps_rollup Pss* metrics should stay constant. 
Extend /proc/pid/smaps tearing tests to also check for smaps_rollup
consistency.

Link: https://lore.kernel.org/20260918153318.758387-8-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 tools/testing/selftests/proc/proc-maps-race.c |  186 +++++++++++++++-
 1 file changed, 181 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/proc/proc-maps-race.c~selftests-proc-add-proc-pid-smaps_rollup-tearing-tests
+++ a/tools/testing/selftests/proc/proc-maps-race.c
@@ -80,6 +80,61 @@ enum maps_file {
 
 struct vma_modifier_info;
 
+enum smaps_rollup_stat {
+	Rss,
+	Pss,
+	Pss_Dirty,
+	Pss_Anon,
+	Pss_File,
+	Pss_Shmem,
+	Shared_Clean,
+	Shared_Dirty,
+	Private_Clean,
+	Private_Dirty,
+	Referenced,
+	Anonymous,
+	KSM,
+	LazyFree,
+	AnonHugePages,
+	ShmemPmdMapped,
+	FilePmdMapped,
+	Shared_Hugetlb,
+	Private_Hugetlb,
+	Swap,
+	SwapPss,
+	Locked,
+	RollupFieldCount
+};
+
+static const char *smaps_rollup_stat_names[RollupFieldCount] = {
+	"Rss",
+	"Pss",
+	"Pss_Dirty",
+	"Pss_Anon",
+	"Pss_File",
+	"Pss_Shmem",
+	"Shared_Clean",
+	"Shared_Dirty",
+	"Private_Clean",
+	"Private_Dirty",
+	"Referenced",
+	"Anonymous",
+	"KSM",
+	"LazyFree",
+	"AnonHugePages",
+	"ShmemPmdMapped",
+	"FilePmdMapped",
+	"Shared_Hugetlb",
+	"Private_Hugetlb",
+	"Swap",
+	"SwapPss",
+	"Locked",
+};
+
+struct smaps_rollup_stats {
+	unsigned long values[RollupFieldCount];
+};
+
 FIXTURE(proc_maps_race)
 {
 	struct vma_modifier_info *mod_info;
@@ -91,6 +146,7 @@ FIXTURE(proc_maps_race)
 	enum maps_file maps_file;
 	int shared_mem_size;
 	int skip_pages;
+	int rollup_fd;
 	int page_size;
 	int vma_count;
 	bool verbose;
@@ -132,12 +188,12 @@ struct vma_modifier_info {
 	void *child_mapped_addr[];
 };
 
-static bool read_page(FIXTURE_DATA(proc_maps_race) *self,
+static bool read_page(FIXTURE_DATA(proc_maps_race) *self, int fd,
 		      struct page_content *page)
 {
 	ssize_t  bytes_read;
 
-	bytes_read = read(self->maps_fd, page->data, self->page_size);
+	bytes_read = read(fd, page->data, self->page_size);
 	if (bytes_read <= 0)
 		return false;
 
@@ -175,7 +231,7 @@ static int locate_containing_page(FIXTUR
 		char *curr_pos;
 		char *end_pos;
 
-		if (!read_page(self, &self->page1))
+		if (!read_page(self, self->maps_fd, &self->page1))
 			return -1;
 
 		curr_pos = self->page1.data;
@@ -205,10 +261,11 @@ static bool read_two_pages(FIXTURE_DATA(
 		return false;
 
 	for (int i = 0; i < self->skip_pages; i++)
-		if (!read_page(self, &self->page1))
+		if (!read_page(self, self->maps_fd, &self->page1))
 			return false;
 
-	return read_page(self, &self->page1) && read_page(self, &self->page2);
+	return read_page(self, self->maps_fd, &self->page1) &&
+	       read_page(self, self->maps_fd, &self->page2);
 }
 
 static void copy_line(const char *line_start, const char *line_end,
@@ -317,6 +374,61 @@ static bool read_boundary_lines(FIXTURE_
 		      &first_line->end_addr) == 2;
 }
 
+static bool parse_smaps_rollup(FIXTURE_DATA(proc_maps_race) *self,
+		struct smaps_rollup_stats *stats)
+{
+	unsigned int dev_maj, dev_min, inode;
+	unsigned long start, end, offs;
+	unsigned long value;
+	char name[32], perm[5];
+	char *curr_pos;
+	char *end_pos;
+	char *line_end;
+
+	if (lseek(self->rollup_fd, 0, SEEK_SET) < 0)
+		return false;
+
+	if (!read_page(self, self->rollup_fd, &self->page1))
+		return false;
+
+	curr_pos = self->page1.data;
+	end_pos = self->page1.data + self->page1.size;
+
+	line_end = strchr(curr_pos, '\n');
+	if (!line_end)
+		return false;
+
+	if (sscanf(curr_pos, "%lx-%lx %4s %lx %u:%u %u %31s",
+		&start, &end, perm, &offs, &dev_maj, &dev_min, &inode, name) != 8)
+		return false;
+
+	if (strcmp(name, "[rollup]"))
+		return false;
+
+	for (int stat = 0; stat < ARRAY_SIZE(smaps_rollup_stat_names); stat++) {
+		int len;
+
+		curr_pos = line_end + 1;
+		if (curr_pos >= end_pos)
+			return false;
+
+		line_end = strchr(curr_pos, '\n');
+		if (!line_end)
+			return false;
+
+		if (sscanf(curr_pos, "%31s %lu kB", name, &value) != 2)
+			return false;
+
+		len = strlen(name);
+		if (name[len - 1] != ':' || strncmp(name, smaps_rollup_stat_names[stat], len - 1))
+			return false;
+
+		stats->values[stat] = value;
+	}
+
+	return true;
+}
+
 /* Thread synchronization routines */
 static void wait_for_state(struct vma_modifier_info *mod_info, enum test_state state)
 {
@@ -397,6 +509,40 @@ static bool print_boundaries_on(bool con
 	return condition;
 }
 
+static void print_smaps_rollup_stats(const char *title, FIXTURE_DATA(proc_maps_race) *self,
+		struct smaps_rollup_stats *stats)
+{
+	printf("%s", title);
+	for (int stat = 0; stat < ARRAY_SIZE(smaps_rollup_stat_names); stat++)
+		printf("%64s %lu kB\n", smaps_rollup_stat_names[stat], stats->values[stat]);
+}
+
+static bool cmp_smaps_rollup_stat(struct smaps_rollup_stats *s1,
+		struct smaps_rollup_stats *s2, enum smaps_rollup_stat stat)
+{
+	return s1->values[stat] == s2->values[stat];
+}
+
+static bool compare_smaps_rollup(FIXTURE_DATA(proc_maps_race) *self,
+		struct smaps_rollup_stats *expected,
+		struct smaps_rollup_stats *actual)
+{
+	/*
+	 * Clean/dirty metrics might change but Pss-related ones
+	 * should stay constant.
+	 */
+	if (cmp_smaps_rollup_stat(expected, actual, Pss) &&
+	    cmp_smaps_rollup_stat(expected, actual, Pss_Anon) &&
+	    cmp_smaps_rollup_stat(expected, actual, Pss_File) &&
+	    cmp_smaps_rollup_stat(expected, actual, Pss_Shmem))
+		return true;
+
+	print_smaps_rollup_stats("Expected stats:", self, expected);
+	print_smaps_rollup_stats("Actual stats:", self, actual);
+
+	return false;
+}
+
 static void report_test_start(const char *name, bool verbose)
 {
 	if (verbose)
@@ -572,6 +718,7 @@ FIXTURE_SETUP(proc_maps_race)
 	unsigned long first_map_addr;
 	unsigned long last_map_addr;
 	unsigned long duration_sec;
+	char rollup_fname[32];
 	char fname[32];
 
 	self->page_size = (unsigned long)sysconf(_SC_PAGESIZE);
@@ -649,6 +796,9 @@ FIXTURE_SETUP(proc_maps_race)
 		break;
 	case SMAPS:
 		sprintf(fname, "/proc/%d/smaps", self->pid);
+		sprintf(rollup_fname, "/proc/%d/smaps_rollup", self->pid);
+		self->rollup_fd = open(rollup_fname, O_RDONLY);
+		ASSERT_NE(self->rollup_fd, -1);
 		break;
 	default:
 		ksft_exit_fail();
@@ -711,6 +861,8 @@ FIXTURE_TEARDOWN(proc_maps_race)
 	for (int i = 0; i < self->vma_count; i++)
 		munmap(self->mod_info->child_mapped_addr[i], self->page_size);
 	close(self->maps_fd);
+	if (self->maps_file == SMAPS)
+		close(self->rollup_fd);
 	waitpid(self->pid, &status, 0);
 	munmap(self->mod_info, self->shared_mem_size);
 }
@@ -723,6 +875,7 @@ TEST_F(proc_maps_race, test_maps_tearing
 	struct line_content split_first_line;
 	struct line_content restored_last_line;
 	struct line_content restored_first_line;
+	struct smaps_rollup_stats orig_stats;
 
 	wait_for_state(mod_info, SETUP_READY);
 
@@ -736,6 +889,8 @@ TEST_F(proc_maps_race, test_maps_tearing
 	report_test_start("Tearing from split", self->verbose);
 	ASSERT_TRUE(capture_mod_pattern(self, &split_last_line, &split_first_line,
 					&restored_last_line, &restored_first_line));
+	if (self->maps_file == SMAPS)
+		ASSERT_TRUE(parse_smaps_rollup(self, &orig_stats));
 
 	/* Now start concurrent modifications for self->duration_sec */
 	signal_state(mod_info, TEST_READY);
@@ -799,6 +954,11 @@ TEST_F(proc_maps_race, test_maps_tearing
 				     vma_end == self->last_line.end_addr) ||
 				    (vma_start == split_first_line.start_addr &&
 				     vma_end == split_first_line.end_addr));
+		} else {
+			struct smaps_rollup_stats stats;
+
+			ASSERT_TRUE(parse_smaps_rollup(self, &stats));
+			ASSERT_TRUE(compare_smaps_rollup(self, &orig_stats, &stats));
 		}
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
 		end_test_iteration(&end_ts, self->verbose);
@@ -817,6 +977,7 @@ TEST_F(proc_maps_race, test_maps_tearing
 	struct line_content shrunk_first_line;
 	struct line_content restored_last_line;
 	struct line_content restored_first_line;
+	struct smaps_rollup_stats orig_stats;
 
 	wait_for_state(mod_info, SETUP_READY);
 
@@ -830,6 +991,8 @@ TEST_F(proc_maps_race, test_maps_tearing
 	report_test_start("Tearing from resize", self->verbose);
 	ASSERT_TRUE(capture_mod_pattern(self, &shrunk_last_line, &shrunk_first_line,
 					&restored_last_line, &restored_first_line));
+	if (self->maps_file == SMAPS)
+		ASSERT_TRUE(parse_smaps_rollup(self, &orig_stats));
 
 	/* Now start concurrent modifications for self->duration_sec */
 	signal_state(mod_info, TEST_READY);
@@ -880,6 +1043,11 @@ TEST_F(proc_maps_race, test_maps_tearing
 			ASSERT_TRUE(vma_start == self->last_line.start_addr &&
 				    (vma_end - vma_start == self->page_size * 3 ||
 				     vma_end - vma_start == self->page_size));
+		} else {
+			struct smaps_rollup_stats stats;
+
+			ASSERT_TRUE(parse_smaps_rollup(self, &stats));
+			ASSERT_TRUE(compare_smaps_rollup(self, &orig_stats, &stats));
 		}
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
 		end_test_iteration(&end_ts, self->verbose);
@@ -898,6 +1066,7 @@ TEST_F(proc_maps_race, test_maps_tearing
 	struct line_content remapped_first_line;
 	struct line_content restored_last_line;
 	struct line_content restored_first_line;
+	struct smaps_rollup_stats orig_stats;
 
 	wait_for_state(mod_info, SETUP_READY);
 
@@ -911,6 +1080,8 @@ TEST_F(proc_maps_race, test_maps_tearing
 	report_test_start("Tearing from remap", self->verbose);
 	ASSERT_TRUE(capture_mod_pattern(self, &remapped_last_line, &remapped_first_line,
 					&restored_last_line, &restored_first_line));
+	if (self->maps_file == SMAPS)
+		ASSERT_TRUE(parse_smaps_rollup(self, &orig_stats));
 
 	/* Now start concurrent modifications for self->duration_sec */
 	signal_state(mod_info, TEST_READY);
@@ -963,6 +1134,11 @@ TEST_F(proc_maps_race, test_maps_tearing
 				     vma_end - vma_start == self->page_size * 3) ||
 				    (vma_start == self->last_line.start_addr + self->page_size &&
 				     vma_end - vma_start == self->page_size));
+		} else {
+			struct smaps_rollup_stats stats;
+
+			ASSERT_TRUE(parse_smaps_rollup(self, &stats));
+			ASSERT_TRUE(compare_smaps_rollup(self, &orig_stats, &stats));
 		}
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
 		end_test_iteration(&end_ts, self->verbose);
_

Patches currently in -mm which might be from surenb@google.com are


