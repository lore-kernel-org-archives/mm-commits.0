Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0237E219312
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409713; cv=none; b=GMgAKysmjdQON/xVcCGadUAaeJnvMqocbz82vHQyA+6O1zpSwpT7uChQQe/tI81AIm4lTujM2+apQdaJeg+TMK/KaAlrV9wH2BiRiuCOBgv3sVVInnRyIx/YRQcFYosaaG6HEysXdfTM3BS6We9pOrNi/0dSTTM1hHGp/D6sVtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409713; c=relaxed/simple;
	bh=jYHc9npdhAd69dGom/E9IRHIcS9r+HxOV9d4UCfrM8M=;
	h=Date:To:From:Subject:Message-Id; b=Y0sW1IUNtpAn9wXWSU4QFBQZn+qyaaq2a1DTdEYeKVLYNGyZzJWaBqlOyjkQxqW5UPZkfCOpyouMtSEViZ6PKzkJvbO9oFxGzzTUi1cM+ecYtUiuxYHbZcvttJeeO2dzeOmhDNii4A+m6uiUi2xoXtEeDqPLEApEa/eD94osgA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G2IXbe1p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G2IXbe1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA64EC4CEED;
	Fri, 25 Jul 2025 02:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409712;
	bh=jYHc9npdhAd69dGom/E9IRHIcS9r+HxOV9d4UCfrM8M=;
	h=Date:To:From:Subject:From;
	b=G2IXbe1pZmEVCMM9NHX7EL4Kt0QiMP5EGXB9glltH5BmPtzo0HjC8lOFkKAdSD4F0
	 DkaXVRcmp+q5+KHllKU3wV5BxTCMFBoWEqU4C80ztVsdjkr4X39rQJhGaZ3ZCLZnVL
	 8E7HSGc6747yTACpZVTwQlkx2+fvaFius/Gq36cM=
Date: Thu, 24 Jul 2025 19:15:12 -0700
To: mm-commits@vger.kernel.org,yebin10@huawei.com,willy@infradead.org,vbabka@suse.cz,tjmercier@google.com,shuah@kernel.org,ryan.roberts@arm.com,peterx@redhat.com,paulmck@kernel.org,osalvador@suse.de,mhocko@kernel.org,lorenzo.stoakes@oracle.com,linux@weissschuh.net,liam.howlett@oracle.com,kaleshsingh@google.com,josef@toxicpanda.com,jannh@google.com,hannes@cmpxchg.org,david@redhat.com,christophe.leroy@csgroup.eu,brauner@kernel.org,andrii@kernel.org,aha310510@gmail.com,adobriyan@gmail.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-proc-add-verbose-mode-for-proc-pid-maps-tearing-tests.patch removed from -mm tree
Message-Id: <20250725021512.CA64EC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/proc: add verbose mode for /proc/pid/maps tearing tests
has been removed from the -mm tree.  Its filename was
     selftests-proc-add-verbose-mode-for-proc-pid-maps-tearing-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: selftests/proc: add verbose mode for /proc/pid/maps tearing tests
Date: Sat, 19 Jul 2025 11:28:52 -0700

Add verbose mode to the /proc/pid/maps tearing tests to print debugging
information.  VERBOSE environment variable is used to enable it.

Usage example: VERBOSE=1 ./proc-maps-race

Link: https://lkml.kernel.org/r/20250719182854.3166724-5-surenb@google.com
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

 tools/testing/selftests/proc/proc-maps-race.c |  153 ++++++++++++++--
 1 file changed, 141 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/proc/proc-maps-race.c~selftests-proc-add-verbose-mode-for-proc-pid-maps-tearing-tests
+++ a/tools/testing/selftests/proc/proc-maps-race.c
@@ -77,6 +77,7 @@ FIXTURE(proc_maps_race)
 	int shared_mem_size;
 	int page_size;
 	int vma_count;
+	bool verbose;
 	int maps_fd;
 	pid_t pid;
 };
@@ -188,12 +189,104 @@ static void stop_vma_modifier(struct vma
 	signal_state(mod_info, SETUP_MODIFY_MAPS);
 }
 
+static void print_first_lines(char *text, int nr)
+{
+	const char *end = text;
+
+	while (nr && (end = strchr(end, '\n')) != NULL) {
+		nr--;
+		end++;
+	}
+
+	if (end) {
+		int offs = end - text;
+
+		text[offs] = '\0';
+		printf(text);
+		text[offs] = '\n';
+		printf("\n");
+	} else {
+		printf(text);
+	}
+}
+
+static void print_last_lines(char *text, int nr)
+{
+	const char *start = text + strlen(text);
+
+	nr++; /* to ignore the last newline */
+	while (nr) {
+		while (start > text && *start != '\n')
+			start--;
+		nr--;
+		start--;
+	}
+	printf(start);
+}
+
+static void print_boundaries(const char *title, FIXTURE_DATA(proc_maps_race) *self)
+{
+	if (!self->verbose)
+		return;
+
+	printf("%s", title);
+	/* Print 3 boundary lines from each page */
+	print_last_lines(self->page1.data, 3);
+	printf("-----------------page boundary-----------------\n");
+	print_first_lines(self->page2.data, 3);
+}
+
+static bool print_boundaries_on(bool condition, const char *title,
+				FIXTURE_DATA(proc_maps_race) *self)
+{
+	if (self->verbose && condition)
+		print_boundaries(title, self);
+
+	return condition;
+}
+
+static void report_test_start(const char *name, bool verbose)
+{
+	if (verbose)
+		printf("==== %s ====\n", name);
+}
+
+static struct timespec print_ts;
+
+static void start_test_loop(struct timespec *ts, bool verbose)
+{
+	if (verbose)
+		print_ts.tv_sec = ts->tv_sec;
+}
+
+static void end_test_iteration(struct timespec *ts, bool verbose)
+{
+	if (!verbose)
+		return;
+
+	/* Update every second */
+	if (print_ts.tv_sec == ts->tv_sec)
+		return;
+
+	printf(".");
+	fflush(stdout);
+	print_ts.tv_sec = ts->tv_sec;
+}
+
+static void end_test_loop(bool verbose)
+{
+	if (verbose)
+		printf("\n");
+}
+
 static bool capture_mod_pattern(FIXTURE_DATA(proc_maps_race) *self,
 				struct line_content *mod_last_line,
 				struct line_content *mod_first_line,
 				struct line_content *restored_last_line,
 				struct line_content *restored_first_line)
 {
+	print_boundaries("Before modification", self);
+
 	signal_state(self->mod_info, SETUP_MODIFY_MAPS);
 	wait_for_state(self->mod_info, SETUP_MAPS_MODIFIED);
 
@@ -201,6 +294,8 @@ static bool capture_mod_pattern(FIXTURE_
 	if (!read_boundary_lines(self, mod_last_line, mod_first_line))
 		return false;
 
+	print_boundaries("After modification", self);
+
 	signal_state(self->mod_info, SETUP_RESTORE_MAPS);
 	wait_for_state(self->mod_info, SETUP_MAPS_RESTORED);
 
@@ -208,6 +303,8 @@ static bool capture_mod_pattern(FIXTURE_
 	if (!read_boundary_lines(self, restored_last_line, restored_first_line))
 		return false;
 
+	print_boundaries("After restore", self);
+
 	if (!self->mod_info->vma_mod_check(mod_last_line, mod_first_line,
 					   restored_last_line, restored_first_line))
 		return false;
@@ -295,6 +392,7 @@ static inline bool check_remap_result(st
 
 FIXTURE_SETUP(proc_maps_race)
 {
+	const char *verbose = getenv("VERBOSE");
 	const char *duration = getenv("DURATION");
 	struct vma_modifier_info *mod_info;
 	pthread_mutexattr_t mutex_attr;
@@ -303,6 +401,7 @@ FIXTURE_SETUP(proc_maps_race)
 	char fname[32];
 
 	self->page_size = (unsigned long)sysconf(_SC_PAGESIZE);
+	self->verbose = verbose && !strncmp(verbose, "1", 1);
 	duration_sec = duration ? atol(duration) : 0;
 	self->duration_sec = duration_sec ? duration_sec : 5UL;
 
@@ -444,6 +543,7 @@ TEST_F(proc_maps_race, test_maps_tearing
 	mod_info->vma_restore = merge_vma;
 	mod_info->vma_mod_check = check_split_result;
 
+	report_test_start("Tearing from split", self->verbose);
 	ASSERT_TRUE(capture_mod_pattern(self, &split_last_line, &split_first_line,
 					&restored_last_line, &restored_first_line));
 
@@ -455,6 +555,7 @@ TEST_F(proc_maps_race, test_maps_tearing
 	struct timespec start_ts, end_ts;
 
 	clock_gettime(CLOCK_MONOTONIC_COARSE, &start_ts);
+	start_test_loop(&start_ts, self->verbose);
 	do {
 		bool last_line_changed;
 		bool first_line_changed;
@@ -472,12 +573,18 @@ TEST_F(proc_maps_race, test_maps_tearing
 			 * In that case new first line will be the same as the
 			 * last restored line.
 			 */
-			ASSERT_FALSE(strcmp(new_first_line.text, split_first_line.text) &&
-				     strcmp(new_first_line.text, restored_last_line.text));
+			ASSERT_FALSE(print_boundaries_on(
+					strcmp(new_first_line.text, split_first_line.text) &&
+					strcmp(new_first_line.text, restored_last_line.text),
+					"Split result invalid", self));
 		} else {
 			/* The vmas should be consistent with merge results */
-			ASSERT_FALSE(strcmp(new_last_line.text, restored_last_line.text));
-			ASSERT_FALSE(strcmp(new_first_line.text, restored_first_line.text));
+			ASSERT_FALSE(print_boundaries_on(
+					strcmp(new_last_line.text, restored_last_line.text),
+					"Merge result invalid", self));
+			ASSERT_FALSE(print_boundaries_on(
+					strcmp(new_first_line.text, restored_first_line.text),
+					"Merge result invalid", self));
 		}
 		/*
 		 * First and last lines should change in unison. If the last
@@ -489,7 +596,9 @@ TEST_F(proc_maps_race, test_maps_tearing
 		ASSERT_EQ(last_line_changed, first_line_changed);
 
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
+		end_test_iteration(&end_ts, self->verbose);
 	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
+	end_test_loop(self->verbose);
 
 	/* Signal the modifyer thread to stop and wait until it exits */
 	signal_state(mod_info, TEST_DONE);
@@ -513,6 +622,7 @@ TEST_F(proc_maps_race, test_maps_tearing
 	mod_info->vma_restore = expand_vma;
 	mod_info->vma_mod_check = check_shrink_result;
 
+	report_test_start("Tearing from resize", self->verbose);
 	ASSERT_TRUE(capture_mod_pattern(self, &shrunk_last_line, &shrunk_first_line,
 					&restored_last_line, &restored_first_line));
 
@@ -524,6 +634,7 @@ TEST_F(proc_maps_race, test_maps_tearing
 	struct timespec start_ts, end_ts;
 
 	clock_gettime(CLOCK_MONOTONIC_COARSE, &start_ts);
+	start_test_loop(&start_ts, self->verbose);
 	do {
 		ASSERT_TRUE(read_boundary_lines(self, &new_last_line, &new_first_line));
 
@@ -537,16 +648,24 @@ TEST_F(proc_maps_race, test_maps_tearing
 			 * again. In that case new first line will be the same
 			 * as the last restored line.
 			 */
-			ASSERT_FALSE(strcmp(new_first_line.text, shrunk_first_line.text) &&
-				     strcmp(new_first_line.text, restored_last_line.text));
+			ASSERT_FALSE(print_boundaries_on(
+					strcmp(new_first_line.text, shrunk_first_line.text) &&
+					strcmp(new_first_line.text, restored_last_line.text),
+					"Shrink result invalid", self));
 		} else {
 			/* The vmas should be consistent with the original/resored state */
-			ASSERT_FALSE(strcmp(new_last_line.text, restored_last_line.text));
-			ASSERT_FALSE(strcmp(new_first_line.text, restored_first_line.text));
+			ASSERT_FALSE(print_boundaries_on(
+					strcmp(new_last_line.text, restored_last_line.text),
+					"Expand result invalid", self));
+			ASSERT_FALSE(print_boundaries_on(
+					strcmp(new_first_line.text, restored_first_line.text),
+					"Expand result invalid", self));
 		}
 
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
+		end_test_iteration(&end_ts, self->verbose);
 	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
+	end_test_loop(self->verbose);
 
 	/* Signal the modifyer thread to stop and wait until it exits */
 	signal_state(mod_info, TEST_DONE);
@@ -570,6 +689,7 @@ TEST_F(proc_maps_race, test_maps_tearing
 	mod_info->vma_restore = patch_vma;
 	mod_info->vma_mod_check = check_remap_result;
 
+	report_test_start("Tearing from remap", self->verbose);
 	ASSERT_TRUE(capture_mod_pattern(self, &remapped_last_line, &remapped_first_line,
 					&restored_last_line, &restored_first_line));
 
@@ -581,6 +701,7 @@ TEST_F(proc_maps_race, test_maps_tearing
 	struct timespec start_ts, end_ts;
 
 	clock_gettime(CLOCK_MONOTONIC_COARSE, &start_ts);
+	start_test_loop(&start_ts, self->verbose);
 	do {
 		ASSERT_TRUE(read_boundary_lines(self, &new_last_line, &new_first_line));
 
@@ -594,16 +715,24 @@ TEST_F(proc_maps_race, test_maps_tearing
 			 * again. In that case new first line will be the same
 			 * as the last restored line.
 			 */
-			ASSERT_FALSE(strcmp(new_first_line.text, remapped_first_line.text) &&
-				     strcmp(new_first_line.text, restored_last_line.text));
+			ASSERT_FALSE(print_boundaries_on(
+					strcmp(new_first_line.text, remapped_first_line.text) &&
+					strcmp(new_first_line.text, restored_last_line.text),
+					"Remap result invalid", self));
 		} else {
 			/* The vmas should be consistent with the original/resored state */
-			ASSERT_FALSE(strcmp(new_last_line.text, restored_last_line.text));
-			ASSERT_FALSE(strcmp(new_first_line.text, restored_first_line.text));
+			ASSERT_FALSE(print_boundaries_on(
+					strcmp(new_last_line.text, restored_last_line.text),
+					"Remap restore result invalid", self));
+			ASSERT_FALSE(print_boundaries_on(
+					strcmp(new_first_line.text, restored_first_line.text),
+					"Remap restore result invalid", self));
 		}
 
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
+		end_test_iteration(&end_ts, self->verbose);
 	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
+	end_test_loop(self->verbose);
 
 	/* Signal the modifyer thread to stop and wait until it exits */
 	signal_state(mod_info, TEST_DONE);
_

Patches currently in -mm which might be from surenb@google.com are


