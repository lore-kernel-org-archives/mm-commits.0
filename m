Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CEEC21ABD7
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409709; cv=none; b=pGVXyQJpL55iri2yhrhfHH+BWKG7mKSdXJeoN51A7NznetYMeI8Dl5iy392VYEeVeHg9Aq2rsXbkEj748PUp3y6BpkqbfxQE6fujHMFFackdOuqTIoPsxm8W83m0dqzwgBajMcObJ+5X0Db2RiJho8rsC3YCRRGTz30RSf5F/Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409709; c=relaxed/simple;
	bh=VjlUje3NJYGM4oKUqk3meM//TNGpQz1itDn98exZ7Zg=;
	h=Date:To:From:Subject:Message-Id; b=ePSzrXHKEYcIDUgkXna8Mjgix0BC0H5BweQbHmBoO5g7zWcQfm7VZyCCjW2NX3arCaN3WFUlbDs46boC9oy8DDP/NJtHO6f8+yHgM8S2TubINXBArLCBiCatPM5tnvRTVpphEOIouryMXE5aROJWQsJQyEhB5//PqA3LWf3qwaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jChPkllu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jChPkllu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72075C4CEED;
	Fri, 25 Jul 2025 02:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409709;
	bh=VjlUje3NJYGM4oKUqk3meM//TNGpQz1itDn98exZ7Zg=;
	h=Date:To:From:Subject:From;
	b=jChPklluUMuwPlw/pnt16aRySwwUXS05c2aLeITc+SegAEmtXxbFfKkeRZXGKVjXl
	 CARnx06QnBoTwTnwUzcJoaBkX1EOiIAnagpQj1GMPum+dKaG6Beog6q0M6eIW5jc/J
	 nSU6pUdxcOS7PBoJ4kB1QvmMX3izaZ0wWRMb0oCk=
Date: Thu, 24 Jul 2025 19:15:08 -0700
To: mm-commits@vger.kernel.org,yebin10@huawei.com,willy@infradead.org,vbabka@suse.cz,tjmercier@google.com,shuah@kernel.org,ryan.roberts@arm.com,peterx@redhat.com,paulmck@kernel.org,osalvador@suse.de,mhocko@kernel.org,lorenzo.stoakes@oracle.com,linux@weissschuh.net,liam.howlett@oracle.com,kaleshsingh@google.com,josef@toxicpanda.com,jannh@google.com,hannes@cmpxchg.org,david@redhat.com,christophe.leroy@csgroup.eu,brauner@kernel.org,andrii@kernel.org,aha310510@gmail.com,adobriyan@gmail.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-proc-extend-proc-pid-maps-tearing-test-to-include-vma-resizing.patch removed from -mm tree
Message-Id: <20250725021509.72075C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/proc: extend /proc/pid/maps tearing test to include vma resizing
has been removed from the -mm tree.  Its filename was
     selftests-proc-extend-proc-pid-maps-tearing-test-to-include-vma-resizing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: selftests/proc: extend /proc/pid/maps tearing test to include vma resizing
Date: Sat, 19 Jul 2025 11:28:50 -0700

Test that /proc/pid/maps does not report unexpected holes in the address
space when a vma at the edge of the page is being concurrently remapped. 
This remapping results in the vma shrinking and expanding from under the
reader.  We should always see either shrunk or expanded (original) version
of the vma.

Link: https://lkml.kernel.org/r/20250719182854.3166724-3-surenb@google.com
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

 tools/testing/selftests/proc/proc-maps-race.c |   79 ++++++++++++++++
 1 file changed, 79 insertions(+)

--- a/tools/testing/selftests/proc/proc-maps-race.c~selftests-proc-extend-proc-pid-maps-tearing-test-to-include-vma-resizing
+++ a/tools/testing/selftests/proc/proc-maps-race.c
@@ -242,6 +242,28 @@ static inline bool check_split_result(st
 	       strcmp(mod_first_line->text, restored_first_line->text) != 0;
 }
 
+static inline bool shrink_vma(FIXTURE_DATA(proc_maps_race) *self)
+{
+	return mremap(self->mod_info->addr, self->page_size * 3,
+		      self->page_size, 0) != MAP_FAILED;
+}
+
+static inline bool expand_vma(FIXTURE_DATA(proc_maps_race) *self)
+{
+	return mremap(self->mod_info->addr, self->page_size,
+		      self->page_size * 3, 0) != MAP_FAILED;
+}
+
+static inline bool check_shrink_result(struct line_content *mod_last_line,
+				       struct line_content *mod_first_line,
+				       struct line_content *restored_last_line,
+				       struct line_content *restored_first_line)
+{
+	/* Make sure only the last vma of the first page is changing */
+	return strcmp(mod_last_line->text, restored_last_line->text) != 0 &&
+	       strcmp(mod_first_line->text, restored_first_line->text) == 0;
+}
+
 FIXTURE_SETUP(proc_maps_race)
 {
 	const char *duration = getenv("DURATION");
@@ -439,6 +461,63 @@ TEST_F(proc_maps_race, test_maps_tearing
 
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
 	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
+
+	/* Signal the modifyer thread to stop and wait until it exits */
+	signal_state(mod_info, TEST_DONE);
+}
+
+TEST_F(proc_maps_race, test_maps_tearing_from_resize)
+{
+	struct vma_modifier_info *mod_info = self->mod_info;
+
+	struct line_content shrunk_last_line;
+	struct line_content shrunk_first_line;
+	struct line_content restored_last_line;
+	struct line_content restored_first_line;
+
+	wait_for_state(mod_info, SETUP_READY);
+
+	/* re-read the file to avoid using stale data from previous test */
+	ASSERT_TRUE(read_boundary_lines(self, &self->last_line, &self->first_line));
+
+	mod_info->vma_modify = shrink_vma;
+	mod_info->vma_restore = expand_vma;
+	mod_info->vma_mod_check = check_shrink_result;
+
+	ASSERT_TRUE(capture_mod_pattern(self, &shrunk_last_line, &shrunk_first_line,
+					&restored_last_line, &restored_first_line));
+
+	/* Now start concurrent modifications for self->duration_sec */
+	signal_state(mod_info, TEST_READY);
+
+	struct line_content new_last_line;
+	struct line_content new_first_line;
+	struct timespec start_ts, end_ts;
+
+	clock_gettime(CLOCK_MONOTONIC_COARSE, &start_ts);
+	do {
+		ASSERT_TRUE(read_boundary_lines(self, &new_last_line, &new_first_line));
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
+			ASSERT_FALSE(strcmp(new_first_line.text, shrunk_first_line.text) &&
+				     strcmp(new_first_line.text, restored_last_line.text));
+		} else {
+			/* The vmas should be consistent with the original/resored state */
+			ASSERT_FALSE(strcmp(new_last_line.text, restored_last_line.text));
+			ASSERT_FALSE(strcmp(new_first_line.text, restored_first_line.text));
+		}
+
+		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
+	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
 
 	/* Signal the modifyer thread to stop and wait until it exits */
 	signal_state(mod_info, TEST_DONE);
_

Patches currently in -mm which might be from surenb@google.com are


