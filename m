Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C4E3F106D
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525383; cv=none; b=DXao5CYGayokp8vBXbh8NLSsjVZfQqZZLkndfLA/I5/DziGyJ6moIEhChrOYx/4Nm7EQ+CFzSp2Zt3Q3F3nHFX63YVkRxo41XtNAW4oIOa4NNz1NdxlKBgTePxpCjOt8u6Xe15mN+JZnanXW04qfV8ZGuwxylDwyoeD2OxNr3gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525383; c=relaxed/simple;
	bh=ipT+x7kyHfjXPYMhVm5Yg3ABF+cAERqY+srd/C+X9ic=;
	h=Date:To:From:Subject:Message-Id; b=nHGiIHl2rm524xRZOuGCv1LIdJ3r1IgxwkMp5oposrWU71iQeUtLZptV2CafgNDdmW0O7JHvqM4LFSX4q7Wlr5O8dY2nkBTe3JvYF4KzvTU4jQgpcvvDaREMEO8sjBiDE2bsFAosR9cwojPWmDrRDliyuLVT7Aw+HZrqQnB+Ocw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YBAoi6hU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YBAoi6hU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0EE51F00893;
	Fri,  9 Oct 2026 05:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525382;
	bh=gdL7+Ljk5r1Ap+8QD4vzav7uVKdeiNDvplWSMUt6jgE=;
	h=Date:To:From:Subject;
	b=YBAoi6hUeUOxspOBPJ4uL5Nkat5KEkq6V8PsKVU0h+T06qNKdYDBcTBm1IFLyyf+k
	 9ZJaTwlPZZ+GxgJfhGHFjv0lHjR3DBQdu17nI3phCDTKPDW7U1KBH0Br363hx0dFYI
	 JTbs2JIh79m4g66rUDg0HreuSWrDgLT+SWC1/Rnk=
Date: Thu, 08 Oct 2026 22:56:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-remove-unreachable-returns-after-ksft-exit-helpers.patch removed from -mm tree
Message-Id: <20261009055621.E0EE51F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: remove unreachable returns after ksft exit helpers
has been removed from the -mm tree.  Its filename was
     selftests-mm-remove-unreachable-returns-after-ksft-exit-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: selftests/mm: remove unreachable returns after ksft exit helpers
Date: Thu, 3 Sep 2026 21:52:51 +0800

The ksft_exit*() helpers such as ksft_exit_fail_msg() are declared
__noreturn, and the ksft_exit() and ksft_finished() macros expand to calls
of them, always terminating the process via exit().  Any return statements
following such calls are unreachable, both at the end of main() and on
error paths of helper functions.

Remove all of them.  No functional change.

Link: https://lore.kernel.org/20260903135251.39593-1-zenghui.yu@linux.dev
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Assisted-by: GLM-5.3 OpenCode
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 tools/testing/selftests/mm/folio_split_race_test.c |    2 --
 tools/testing/selftests/mm/mlock-random-test.c     |    1 -
 tools/testing/selftests/mm/pkey_sighandler_tests.c |    1 -
 tools/testing/selftests/mm/split_huge_page_test.c  |    4 ----
 4 files changed, 8 deletions(-)

--- a/tools/testing/selftests/mm/folio_split_race_test.c~selftests-mm-remove-unreachable-returns-after-ksft-exit-helpers
+++ a/tools/testing/selftests/mm/folio_split_race_test.c
@@ -269,6 +269,4 @@ int main(void)
 				      NUM_ITERATIONS);
 
 	ksft_exit(iter == NUM_ITERATIONS);
-
-	return 0;
 }
--- a/tools/testing/selftests/mm/mlock-random-test.c~selftests-mm-remove-unreachable-returns-after-ksft-exit-helpers
+++ a/tools/testing/selftests/mm/mlock-random-test.c
@@ -71,7 +71,6 @@ int get_proc_locked_vm_size(void)
 
 	fclose(f);
 	ksft_exit_fail_msg("cannot parse VmLck in /proc/self/status: %s\n", strerror(errno));
-	return -1;
 }
 
 /*
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-remove-unreachable-returns-after-ksft-exit-helpers
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -556,5 +556,4 @@ int main(int argc, char *argv[])
 	}
 
 	ksft_finished();
-	return 0;
 }
--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-remove-unreachable-returns-after-ksft-exit-helpers
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -101,7 +101,6 @@ static bool is_backed_by_folio(char *vad
 	return (pfn_flags & folio_tail_flags) != folio_tail_flags;
 fail:
 	ksft_exit_fail_msg("Failed to get folio info\n");
-	return false;
 }
 
 static int check_after_split_folio_orders(char *vaddr_start, size_t len,
@@ -548,7 +547,6 @@ err_out_close:
 err_out_unlink:
 	unlink(testfile);
 	ksft_exit_fail_msg("Failed to create large pagecache folios\n");
-	return -1;
 }
 
 static void split_thp_in_pagecache_to_order_at(size_t fd_size,
@@ -711,6 +709,4 @@ int main(int argc, char **argv)
 	free(expected_orders);
 
 	ksft_finished();
-
-	return 0;
 }
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

selftests-damon-stop-kdamond-on-error-exits-of-no-op-commit-test.patch
selftests-damon-ignore-test-generated-damon_dump_output.patch
mm-damon-api-remove-unused-nr_damos_-enumerators.patch

