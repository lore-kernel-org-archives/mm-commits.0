Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93613390C88
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 01:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774489373; cv=none; b=JZy0W+ba6ACG5fd1KbgRCiq0ZLGrzvozxPSbfbBtB3gVlftbUUCcTL1k6IuZMENupPl6PAfCU2WWynXZ8mFHKS87J+Oji2THhCqBtej3+WbidyuD9RwpgwsTSVJcYlsqq3cQYVhuc6QYiNZFz3Hgk8vr2bFu307Q0W3bIWe3zD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774489373; c=relaxed/simple;
	bh=ZUEGCHJdzPJWZDQQRf/DTterFQzsKT1rxU8H0mLBeDU=;
	h=Date:To:From:Subject:Message-Id; b=AWvU1U7z/11Qc9SGF3fCP8Rw+0TPoST+Xp8KiA/E4CtTdWh0JA/naqEfmrj7tAVa6H+B4L6pluOdiDLpQ0jNPimPb92AVItFe16ZEjBIoEIFaw9jMRkTmsRf1a3AzOUTSXyyNFKQzZaficL08sdAHvw2RWQYQIOE39M96NKNSEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TF4du34C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TF4du34C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F51DC4CEF7;
	Thu, 26 Mar 2026 01:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774489373;
	bh=ZUEGCHJdzPJWZDQQRf/DTterFQzsKT1rxU8H0mLBeDU=;
	h=Date:To:From:Subject:From;
	b=TF4du34CIKF86WHn+cPOLAewtonKDaWtPoxfGfhZrWMLia/A7AGwLMikVd1UfQzwz
	 216xLiUhp2WeGCsNRZcG9UxvQRzdw0Lfh9IR9dzgB8DOiglHCNIuy+BGjMHNlIA1Qf
	 ZZYUoWGzD4ehPbDarL/xy+VIzmnDfu+HaqNZRapM=
Date: Wed, 25 Mar 2026 18:42:52 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam.howlett@oracle.com,lance.yang@linux.dev,hughd@google.com,dev.jain@arm.com,david@kernel.org,bas@dfinity.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,adam.bratschikaye@dfinity.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-add-folio_split-and-filemap_get_entry-race-test-v4.patch removed from -mm tree
Message-Id: <20260326014253.0F51DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-mm-add-folio_split-and-filemap_get_entry-race-test-v4
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-folio_split-and-filemap_get_entry-race-test-v4.patch

This patch was dropped because it was folded into selftests-mm-add-folio_split-and-filemap_get_entry-race-test.patch

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: selftests-mm-add-folio_split-and-filemap_get_entry-race-test-v4
Date: Fri, 20 Mar 2026 10:22:19 -0400

1. fix loop stepping issue
2. use PRIu64 instead of %zu for uint64_t

Link: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLumWJdiWXv+C9Yct0w@mail.gmail.com/ [1]
Link: https://github.com/dfinity/thp-madv-remove-test [2]
Link: https://lkml.kernel.org/r/20260320142219.375118-1-ziy@nvidia.com
Signed-off-by: Bas van Dijk <bas@dfinity.org>
Signed-off-by: Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/folio_split_race_test.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/folio_split_race_test.c~selftests-mm-add-folio_split-and-filemap_get_entry-race-test-v4
+++ a/tools/testing/selftests/mm/folio_split_race_test.c
@@ -11,6 +11,7 @@
 
 #define _GNU_SOURCE
 #include <errno.h>
+#include <inttypes.h>
 #include <linux/mman.h>
 #include <pthread.h>
 #include <stdatomic.h>
@@ -189,7 +190,7 @@ static size_t run_iteration(void)
 				i, errno);
 		}
 
-		i += PUNCH_SIZE_FACTOR;
+		i += PUNCH_SIZE_FACTOR - 1;
 	}
 
 	atomic_store_explicit(&ctl.stop, 1, memory_order_release);
@@ -261,8 +262,8 @@ int main(void)
 
 	ksft_print_msg("folio split race test\n");
 	ksft_print_msg("===================================================\n");
-	ksft_print_msg("Shmem size:       %zu MiB\n", FILE_SIZE / 1024 / 1024);
-	ksft_print_msg("Total pages:     %zu\n", TOTAL_PAGES);
+	ksft_print_msg("Shmem size:       %" PRIu64 " MiB\n", FILE_SIZE / 1024 / 1024);
+	ksft_print_msg("Total pages:     %" PRIu64 "\n", TOTAL_PAGES);
 	ksft_print_msg("Child readers:   %d\n", NUM_READER_THREADS);
 	ksft_print_msg("Punching every %dth to %dth page\n", PUNCH_INTERVAL,
 		       PUNCH_INTERVAL + PUNCH_SIZE_FACTOR);
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-add-folio_split-and-filemap_get_entry-race-test.patch
selftests-mm-add-folio_split-and-filemap_get_entry-race-test-fix.patch
selftests-mm-add-folio_split-and-filemap_get_entry-race-test-fix-2.patch

