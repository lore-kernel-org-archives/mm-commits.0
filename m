Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501C42E36FB
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409711; cv=none; b=X2DhyabjH6f4VNKN5GrbRVBvhqwFuCt+cgB9WsM/Kj6Ju8jydM1KslBF72UbVvUCHu4f3XCfFxO+blHpH8I1smNxYRxTP7fDZW5gVyqlxKBS8vlShXxU89wGrx9TVVJuD1O6FL32BZaq0PL9tr25pXOjXIvlxAFrH+K5z8cN9So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409711; c=relaxed/simple;
	bh=IYlKsPEzOsQzvnQ+KX97kZZN/W66qRACBzmb4+hHY/4=;
	h=Date:To:From:Subject:Message-Id; b=lYTYwoWsPtEydSdHZeOgdqVm3K0vP9Z+DXeuu2amOKL0h0cE551unVz0PY87E6zVnvoHxelQiZZdcRb3vkgdURuaVycxjijzi0SeDeESmLO78CKlrxGzNCsc4OfEypa9kfN10j/7vbUy9BQ/3cvyi0Rukad2fyTMYzsHyxoUBW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qx5EpKaL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qx5EpKaL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23640C4CEED;
	Fri, 25 Jul 2025 02:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409711;
	bh=IYlKsPEzOsQzvnQ+KX97kZZN/W66qRACBzmb4+hHY/4=;
	h=Date:To:From:Subject:From;
	b=Qx5EpKaLQeg4sL/Lh/rslzLFdki66AB+Okk99Uq4rJSXu9J37z711ky+uIOHRPYnm
	 rlZajGV1LH+hV+TGZkIWTU+3r0AhEMVbxcV7KYBKLzYgxHxmdnV2A9+QLBwAIgW/Ie
	 vJrIdHoaCBdJ+BGUDbVcCgyMXBzkJp5vFXnkQ6OM=
Date: Thu, 24 Jul 2025 19:15:10 -0700
To: mm-commits@vger.kernel.org,yebin10@huawei.com,willy@infradead.org,vbabka@suse.cz,tjmercier@google.com,shuah@kernel.org,ryan.roberts@arm.com,peterx@redhat.com,paulmck@kernel.org,osalvador@suse.de,mhocko@kernel.org,lorenzo.stoakes@oracle.com,linux@weissschuh.net,liam.howlett@oracle.com,kaleshsingh@google.com,josef@toxicpanda.com,jannh@google.com,hannes@cmpxchg.org,david@redhat.com,christophe.leroy@csgroup.eu,brauner@kernel.org,andrii@kernel.org,aha310510@gmail.com,adobriyan@gmail.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-proc-extend-proc-pid-maps-tearing-test-to-include-vma-remapping.patch removed from -mm tree
Message-Id: <20250725021511.23640C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/proc: extend /proc/pid/maps tearing test to include vma remapping
has been removed from the -mm tree.  Its filename was
     selftests-proc-extend-proc-pid-maps-tearing-test-to-include-vma-remapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: selftests/proc: extend /proc/pid/maps tearing test to include vma remapping
Date: Sat, 19 Jul 2025 11:28:51 -0700

Test that /proc/pid/maps does not report unexpected holes in the address
space when we concurrently remap a part of a vma into the middle of
another vma.  This remapping results in the destination vma being split
into three parts and the part in the middle being patched back from, all
done concurrently from under the reader.  We should always see either
original vma or the split one with no holes.

Link: https://lkml.kernel.org/r/20250719182854.3166724-4-surenb@google.com
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

 tools/testing/selftests/proc/proc-maps-race.c |   86 ++++++++++++++++
 1 file changed, 86 insertions(+)

--- a/tools/testing/selftests/proc/proc-maps-race.c~selftests-proc-extend-proc-pid-maps-tearing-test-to-include-vma-remapping
+++ a/tools/testing/selftests/proc/proc-maps-race.c
@@ -264,6 +264,35 @@ static inline bool check_shrink_result(s
 	       strcmp(mod_first_line->text, restored_first_line->text) == 0;
 }
 
+static inline bool remap_vma(FIXTURE_DATA(proc_maps_race) *self)
+{
+	/*
+	 * Remap the last page of the next vma into the middle of the vma.
+	 * This splits the current vma and the first and middle parts (the
+	 * parts at lower addresses) become the last vma objserved in the
+	 * first page and the first vma observed in the last page.
+	 */
+	return mremap(self->mod_info->next_addr + self->page_size * 2, self->page_size,
+		      self->page_size, MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
+		      self->mod_info->addr + self->page_size) != MAP_FAILED;
+}
+
+static inline bool patch_vma(FIXTURE_DATA(proc_maps_race) *self)
+{
+	return mprotect(self->mod_info->addr + self->page_size, self->page_size,
+			self->mod_info->prot) == 0;
+}
+
+static inline bool check_remap_result(struct line_content *mod_last_line,
+				      struct line_content *mod_first_line,
+				      struct line_content *restored_last_line,
+				      struct line_content *restored_first_line)
+{
+	/* Make sure vmas at the boundaries are changing */
+	return strcmp(mod_last_line->text, restored_last_line->text) != 0 &&
+	       strcmp(mod_first_line->text, restored_first_line->text) != 0;
+}
+
 FIXTURE_SETUP(proc_maps_race)
 {
 	const char *duration = getenv("DURATION");
@@ -512,6 +541,63 @@ TEST_F(proc_maps_race, test_maps_tearing
 				     strcmp(new_first_line.text, restored_last_line.text));
 		} else {
 			/* The vmas should be consistent with the original/resored state */
+			ASSERT_FALSE(strcmp(new_last_line.text, restored_last_line.text));
+			ASSERT_FALSE(strcmp(new_first_line.text, restored_first_line.text));
+		}
+
+		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
+	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
+
+	/* Signal the modifyer thread to stop and wait until it exits */
+	signal_state(mod_info, TEST_DONE);
+}
+
+TEST_F(proc_maps_race, test_maps_tearing_from_remap)
+{
+	struct vma_modifier_info *mod_info = self->mod_info;
+
+	struct line_content remapped_last_line;
+	struct line_content remapped_first_line;
+	struct line_content restored_last_line;
+	struct line_content restored_first_line;
+
+	wait_for_state(mod_info, SETUP_READY);
+
+	/* re-read the file to avoid using stale data from previous test */
+	ASSERT_TRUE(read_boundary_lines(self, &self->last_line, &self->first_line));
+
+	mod_info->vma_modify = remap_vma;
+	mod_info->vma_restore = patch_vma;
+	mod_info->vma_mod_check = check_remap_result;
+
+	ASSERT_TRUE(capture_mod_pattern(self, &remapped_last_line, &remapped_first_line,
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
+		/* Check if we read vmas after remapping it */
+		if (!strcmp(new_last_line.text, remapped_last_line.text)) {
+			/*
+			 * The vmas should be consistent with remap results,
+			 * however if the vma was concurrently restored, it
+			 * can be reported twice (first as split one, then
+			 * as restored one) because we found it as the next vma
+			 * again. In that case new first line will be the same
+			 * as the last restored line.
+			 */
+			ASSERT_FALSE(strcmp(new_first_line.text, remapped_first_line.text) &&
+				     strcmp(new_first_line.text, restored_last_line.text));
+		} else {
+			/* The vmas should be consistent with the original/resored state */
 			ASSERT_FALSE(strcmp(new_last_line.text, restored_last_line.text));
 			ASSERT_FALSE(strcmp(new_first_line.text, restored_first_line.text));
 		}
_

Patches currently in -mm which might be from surenb@google.com are


