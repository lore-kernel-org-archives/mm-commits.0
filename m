Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96483D412B
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 17:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775237860; cv=none; b=Aw8vKrE9rQzNrjT+aUACbNwpsNYtQ891GqUU6bBaG1YEFbn7oKmm+q5CAbdc5R+reF1wCzmEPExLUAJnfNf/8Palm8voTkGS0MsT1bjlL6wc8lcf+AFF38xscILjXDgmcvbzpBU1CgdRLS/p/QNsdYD6UyWjafmRWRXYuqDvdSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775237860; c=relaxed/simple;
	bh=AEhDn2fQBL9NS0xKfaQBAo9P2BYwdQz+6hjShWwT/fw=;
	h=Date:To:From:Subject:Message-Id; b=kaj6C9KPZF1nYNhZ2lIxBwTD3KQshzBNCcE2mWHACIFk17/KxuciypdxsP41TYEF9cOg6xwCzfRl9k8gtIQ9Q9LoI5dkCsasiyjb8YxSKqy6SWUdxOwMG2iM6B1X/VHKybUMVf9loNL2raH4q3efT29TTwbcsfaCxT2ARh0CQVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bBZvt+aV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bBZvt+aV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5426CC19421;
	Fri,  3 Apr 2026 17:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775237860;
	bh=AEhDn2fQBL9NS0xKfaQBAo9P2BYwdQz+6hjShWwT/fw=;
	h=Date:To:From:Subject:From;
	b=bBZvt+aVTtOs1T1DiX/2S6HqelhltpvZt96aKZHvhfDymc0j6bcCEZQccf/AhklEk
	 XEXqWi4XmPpfNZHRN03vQxxFRZIK6TGG4OHrX7JXi7/Ny4M54koEakGGB26G5fgKRR
	 vTHNG4FvU35OyOgIlBsSTxQoY13QWA6werpAxib0=
Date: Fri, 03 Apr 2026 10:37:39 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,jason@zx2c4.com,jannh@google.com,david@kernel.org,broonie@kernel.org,anthony.yznaga@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-verify-droppable-mappings-cannot-be-locked.patch added to mm-unstable branch
Message-Id: <20260403173740.5426CC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: verify droppable mappings cannot be locked
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-verify-droppable-mappings-cannot-be-locked.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-verify-droppable-mappings-cannot-be-locked.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Anthony Yznaga <anthony.yznaga@oracle.com>
Subject: selftests/mm: verify droppable mappings cannot be locked
Date: Thu, 2 Apr 2026 16:59:33 -0700

For configs that support MAP_DROPPABLE verify that a mapping created
with MAP_DROPPABLE cannot be locked via mlock(), and that it will not
be locked if it's created after mlockall(MCL_FUTURE).

Link: https://lkml.kernel.org/r/20260402235933.10588-3-anthony.yznaga@oracle.com
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mlock2-tests.c |   87 +++++++++++++++++---
 1 file changed, 78 insertions(+), 9 deletions(-)

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
 
@@ -336,7 +340,70 @@ static void test_munlockall1(void)
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
+	if (munlockall()) {
+		ksft_test_result_fail("munlockall() %s\n", strerror(errno));
+		return;
+	}
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
+	if (map == MAP_FAILED) {
+		if (errno == EOPNOTSUPP)
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
+		if (errno == EOPNOTSUPP)
+			ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n", __func__);
+		else
+			ksft_test_result_fail("mmap error: %s\n", strerror(errno));
+		return;
+	}
+
+	ksft_test_result(!unlock_lock_check(map, false), "%s: droppable memory not locked\n",
+			__func__);
+
+	munlockall();
 	munmap(map, 2 * page_size);
 }
 
@@ -442,7 +509,7 @@ int main(int argc, char **argv)
 
 	munmap(map, size);
 
-	ksft_set_plan(13);
+	ksft_set_plan(15);
 
 	test_mlock_lock();
 	test_mlock_onfault();
@@ -451,6 +518,8 @@ int main(int argc, char **argv)
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
selftests-mm-verify-droppable-mappings-cannot-be-locked.patch

