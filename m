Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9440B3D300A
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 17:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775237578; cv=none; b=QZ9rmr7pFhanrRufe9dHS28LfQakNPyY0mv6PakUX3U5vNfVYyGdgDRuBpPa12ekYVbtIXsjx2m/LKyrZD2UGyDbVK4E3PU+1xDYOzeagMZOncPsR8B+5ry388m7AFsFNebcSv37XfbBQdS9kmlUx9skUgXBRsyoENLLjELVeRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775237578; c=relaxed/simple;
	bh=ZnEWScJIDBX5Pvrli0QzgAGLrGySUjfIHMdpV3Q/V5Y=;
	h=Date:To:From:Subject:Message-Id; b=YOUvJtdSIBSJGMfp4NW8h+M13rWoaS+Tf4esuiOPdFXA0ClauO1U8qOHy4/9c6VxoYE4MPmETK/CfUevA2R2AK32o94+drGe+zVAbiI4hQLxvb0IFt3Hy1rHU97fdBi0xj3QOKmQZczxTrdWVUQ7GK+C8UkgSJXmeOx9RJzs6AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TDv7Y+jy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TDv7Y+jy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34EE0C4CEF7;
	Fri,  3 Apr 2026 17:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775237578;
	bh=ZnEWScJIDBX5Pvrli0QzgAGLrGySUjfIHMdpV3Q/V5Y=;
	h=Date:To:From:Subject:From;
	b=TDv7Y+jyF3YwtKGYezU1M14O3XQaSn8KwhyeaUD2dsU9OHSN12AX7UMpkVJ5m28kD
	 tEI8AoHOZ9Gs3CHuxdrsEPmIwQcktXGhU6LL1AITb3px0IS01kKG5at0MGc/hDa1X2
	 +cCOkjAuVtjnPfeD4Yn0CiWFBoQuJQZCo2AZ92CI=
Date: Fri, 03 Apr 2026 10:32:57 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,jason@zx2c4.com,jannh@google.com,david@kernel.org,anthony.yznaga@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-verify-droppable-mappings-cannot-be-locked.patch removed from -mm tree
Message-Id: <20260403173258.34EE0C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: verify droppable mappings cannot be locked
has been removed from the -mm tree.  Its filename was
     selftests-mm-verify-droppable-mappings-cannot-be-locked.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Anthony Yznaga <anthony.yznaga@oracle.com>
Subject: selftests/mm: verify droppable mappings cannot be locked
Date: Wed, 1 Apr 2026 17:34:17 -0700

For configs that support MAP_DROPPABLE verify that a mapping created with
MAP_DROPPABLE cannot be locked via mlock(), and that it will not be locked
if it's created after mlockall(MCL_FUTURE).

Link: https://lkml.kernel.org/r/20260402003417.438037-3-anthony.yznaga@oracle.com
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mlock2-tests.c |   91 ++++++++++++++++++--
 1 file changed, 82 insertions(+), 9 deletions(-)

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
 
@@ -336,7 +340,74 @@ static void test_munlockall1(void)
 		ksft_exit_fail_msg("munlockall() %s\n", strerror(errno));
 	}
 
-	ksft_test_result(!unlock_lock_check(map), "%s: No locked memory\n", __func__);
+	ksft_test_result(!unlock_lock_check(map, true), "%s: No locked memory\n", __func__);
+	munmap(map, 2 * page_size);
+}
+
+/*
+ * Droppable memory should not be lockable.
+ */
+static void test_mlock_droppable(void)
+{
+	char *map;
+	unsigned long page_size = getpagesize();
+
+	/*
+	 * Ensure MCL_FUTURE is not set.
+	 */
+	if (mlockall(MCL_CURRENT))
+		ksft_exit_fail_msg("mlockall(MCL_CURRENT): %s\n", strerror(errno));
+	if (munlockall())
+		ksft_exit_fail_msg("munlockall() %s\n", strerror(errno));
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
+	if (map == MAP_FAILED) {
+		if (errno == EOPNOTSUPP) {
+			ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n", __func__);
+			return;
+		}
+		ksft_exit_fail_msg("mmap error: %s\n", strerror(errno));
+	}
+
+	if (mlock2_(map, 2 * page_size, 0)) {
+		munmap(map, 2 * page_size);
+		ksft_exit_fail_msg("mlock2(0): %s\n", strerror(errno));
+	}
+
+	ksft_test_result(!unlock_lock_check(map, false), "%s: droppable memory not locked\n",
+			__func__);
+
+	munmap(map, 2 * page_size);
+}
+
+static void test_mlockall_future_droppable(void)
+{
+	char *map;
+	unsigned long page_size = getpagesize();
+
+	if (mlockall(MCL_CURRENT | MCL_FUTURE))
+		ksft_exit_fail_msg("mlockall(MCL_CURRENT | MCL_FUTURE): %s\n", strerror(errno));
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
+
+	if (map == MAP_FAILED) {
+		if (errno == EOPNOTSUPP) {
+			ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n", __func__);
+			return;
+		}
+		ksft_exit_fail_msg("mmap error: %s\n", strerror(errno));
+	}
+
+	ksft_test_result(!unlock_lock_check(map, false), "%s: droppable memory not locked\n",
+			__func__);
+
+	if (munlockall()) {
+		munmap(map, 2 * page_size);
+		ksft_exit_fail_msg("munlockall() %s\n", strerror(errno));
+	}
+
 	munmap(map, 2 * page_size);
 }
 
@@ -442,7 +513,7 @@ int main(int argc, char **argv)
 
 	munmap(map, size);
 
-	ksft_set_plan(13);
+	ksft_set_plan(15);
 
 	test_mlock_lock();
 	test_mlock_onfault();
@@ -451,6 +522,8 @@ int main(int argc, char **argv)
 	test_lock_onfault_of_present();
 	test_vma_management(true);
 	test_mlockall();
+	test_mlock_droppable();
+	test_mlockall_future_droppable();
 
 	ksft_finished();
 }
_

Patches currently in -mm which might be from anthony.yznaga@oracle.com are

mm-fix-mmap-errno-value-when-map_droppable-is-not-supported.patch

