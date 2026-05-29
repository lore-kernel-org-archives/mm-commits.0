Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E38136F418
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027605; cv=none; b=fJib78lpIqdV3o/VQE6lcvQY1hiapWCGqG/bdKTQQzCyCWTrp/111HNbl5gwpt1Ac9B/5zmlbsXJ+wN18k9iWeWlB/TGWLjZKLW7YhR2P6r96zC9NjidoyU5Cuc4dP2UGXvOAAA5ivl250TGDW23tuaoI0/N2St1BL9cgG6Qd7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027605; c=relaxed/simple;
	bh=dBGuFSVHzZJ+W/iyk1hr5JxSBXksudiNe56dA+9N6g8=;
	h=Date:To:From:Subject:Message-Id; b=u7XBbL7qYWVxmQy197hSq885H3iTatR2txNBUdTMilkJErEwKrOzA5lBlV6kkNDJ3pA5gb/4pg4CT8Q0CwrHMV4UwxUFlVl2QcVP00U3JBmHZSqQ+saWOOkaepyPqex8rPpPELQEQR1KbhJKrpPKdws+YzEYIBZQymS+/3++y8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dRTrZane; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dRTrZane"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202801F00893;
	Fri, 29 May 2026 04:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027603;
	bh=wrXdsre2+GyVwIo98mG4o6OGEiMs+WozZDCMJ7/Uwv4=;
	h=Date:To:From:Subject;
	b=dRTrZaneYegvF2TZ7Rh56ysK4KFcolB1J2ZejQfDxcPCMgJLcJZEDMHNPMFVkiU8B
	 Qkmhy1lRubAeQUnTstOa5ubYSnmbg80P9IEVqtGANEwa97wC2taa7Fe193p0Svgvwh
	 ncEVm/tsSSoBF5I/1/FPsUT+f6LSszSDUGURFCcg=
Date: Thu, 28 May 2026 21:06:42 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jason@zx2c4.com,jannh@google.com,david@kernel.org,broonie@kernel.org,anthony.yznaga@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-verify-droppable-mappings-cannot-be-locked.patch removed from -mm tree
Message-Id: <20260529040643.202801F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: verify droppable mappings cannot be locked
has been removed from the -mm tree.  Its filename was
     selftests-mm-verify-droppable-mappings-cannot-be-locked.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anthony Yznaga <anthony.yznaga@oracle.com>
Subject: selftests/mm: verify droppable mappings cannot be locked
Date: Wed, 15 Apr 2026 20:39:38 -0700

For configs that support MAP_DROPPABLE verify that a mapping created with
MAP_DROPPABLE cannot be locked via mlock(), and that it will not be locked
if it's created after mlockall(MCL_FUTURE).

Link: https://lore.kernel.org/20260416033939.49981-3-anthony.yznaga@oracle.com
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mlock2-tests.c |   84 +++++++++++++++++---
 1 file changed, 75 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/mm/mlock2-tests.c~selftests-mm-verify-droppable-mappings-cannot-be-locked
+++ a/tools/testing/selftests/mm/mlock2-tests.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #define _GNU_SOURCE
 #include <sys/mman.h>
+#include <linux/mman.h>
 #include <stdint.h>
 #include <unistd.h>
 #include <string.h>
@@ -163,14 +164,17 @@ static int lock_check(unsigned long addr
 	return (vma_rss == vma_size);
 }
 
-static int unlock_lock_check(char *map)
+static int unlock_lock_check(char *map, bool mlock_supported)
 {
-	if (is_vmflag_set((unsigned long)map, LOCKED)) {
+	if (!is_vmflag_set((unsigned long)map, LOCKED))
+		return 0;
+
+	if (mlock_supported)
 		ksft_print_msg("VMA flag %s is present on page 1 after unlock\n", LOCKED);
-		return 1;
-	}
+	else
+		ksft_print_msg("VMA flag %s is present on an unsupported VMA\n", LOCKED);
 
-	return 0;
+	return 1;
 }
 
 static void test_mlock_lock(void)
@@ -196,7 +200,7 @@ static void test_mlock_lock(void)
 		ksft_exit_fail_msg("munlock(): %s\n", strerror(errno));
 	}
 
-	ksft_test_result(!unlock_lock_check(map), "%s: Unlocked\n", __func__);
+	ksft_test_result(!unlock_lock_check(map, true), "%s: Unlocked\n", __func__);
 	munmap(map, 2 * page_size);
 }
 
@@ -296,7 +300,7 @@ static void test_munlockall0(void)
 		ksft_exit_fail_msg("munlockall(): %s\n", strerror(errno));
 	}
 
-	ksft_test_result(!unlock_lock_check(map), "%s: No locked memory\n", __func__);
+	ksft_test_result(!unlock_lock_check(map, true), "%s: No locked memory\n", __func__);
 	munmap(map, 2 * page_size);
 }
 
@@ -336,7 +340,67 @@ static void test_munlockall1(void)
 		ksft_exit_fail_msg("munlockall() %s\n", strerror(errno));
 	}
 
-	ksft_test_result(!unlock_lock_check(map), "%s: No locked memory\n", __func__);
+	ksft_test_result(!unlock_lock_check(map, true), "%s: No locked memory\n", __func__);
+	munmap(map, 2 * page_size);
+}
+
+/* Droppable memory should not be lockable.  */
+static void test_mlock_droppable(void)
+{
+	char *map;
+	unsigned long page_size = getpagesize();
+
+	/* Ensure MCL_FUTURE is not set. */
+	if (munlockall()) {
+		ksft_test_result_fail("munlockall() %s\n", strerror(errno));
+		return;
+	}
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
+	if (map == MAP_FAILED) {
+		if ((errno == EOPNOTSUPP) || (errno == EINVAL))
+			ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n", __func__);
+		else
+			ksft_test_result_fail("mmap error: %s\n", strerror(errno));
+		return;
+	}
+
+	if (mlock2_(map, 2 * page_size, 0))
+		ksft_test_result_fail("mlock2(0): %s\n", strerror(errno));
+	else
+		ksft_test_result(!unlock_lock_check(map, false),
+				"%s: droppable memory not locked\n", __func__);
+
+	munmap(map, 2 * page_size);
+}
+
+static void test_mlockall_future_droppable(void)
+{
+	char *map;
+	unsigned long page_size = getpagesize();
+
+	if (mlockall(MCL_CURRENT | MCL_FUTURE)) {
+		ksft_test_result_fail("mlockall(MCL_CURRENT | MCL_FUTURE): %s\n", strerror(errno));
+		return;
+	}
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
+
+	if (map == MAP_FAILED) {
+		if ((errno == EOPNOTSUPP) || (errno == EINVAL))
+			ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n", __func__);
+		else
+			ksft_test_result_fail("mmap error: %s\n", strerror(errno));
+		munlockall();
+		return;
+	}
+
+	ksft_test_result(!unlock_lock_check(map, false), "%s: droppable memory not locked\n",
+			__func__);
+
+	munlockall();
 	munmap(map, 2 * page_size);
 }
 
@@ -442,7 +506,7 @@ int main(int argc, char **argv)
 
 	munmap(map, size);
 
-	ksft_set_plan(13);
+	ksft_set_plan(15);
 
 	test_mlock_lock();
 	test_mlock_onfault();
@@ -451,6 +515,8 @@ int main(int argc, char **argv)
 	test_lock_onfault_of_present();
 	test_vma_management(true);
 	test_mlockall();
+	test_mlock_droppable();
+	test_mlockall_future_droppable();
 
 	ksft_finished();
 }
_

Patches currently in -mm which might be from anthony.yznaga@oracle.com are


