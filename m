Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C54C3D7D6C
	for <mm-commits@vger.kernel.org>; Fri, 20 Mar 2026 17:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774028692; cv=none; b=gHAFtEmi2hKw1B0o2/xGzAhbQ0dZEU9z6o/UCZxNjhh3qoClBeZGE3yeF0yoYmzJcinCLfZMcFPT1UGystyWEjJ3MdE1cJuCSMUjA2Kgp5mJV0lDts4qPTkJc27caRaFcgNPbDH37vJjGQlB2OydNy2T3lCWYMbcUC7bXNifc34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774028692; c=relaxed/simple;
	bh=iLiLP2IbCLJDWs03UjWcpdTn2GL8ZtLQ+ws5XK2rNp8=;
	h=Date:To:From:Subject:Message-Id; b=mlOj/fvdIHpfQe5857CigQ7rpEe2kRsccZUrP7UWxT5vS3GMJxMPcPj7Fln+SCLLhW69EtsKVtNdz84BpVnz1BxQhiBTzP5Vgf8ipv1OKNfLD6GaU2saWFKMMBVYjcWP6s6dNsPV1oD74zSEvfuPkMBz9NBtTkOCynyX+54WtpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N1QQMNh/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N1QQMNh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B52C4CEF7;
	Fri, 20 Mar 2026 17:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774028692;
	bh=iLiLP2IbCLJDWs03UjWcpdTn2GL8ZtLQ+ws5XK2rNp8=;
	h=Date:To:From:Subject:From;
	b=N1QQMNh/NCkFr4GMFVexOBlQH55ilJNNri268YuWxN4tOpFb61pWKm7E7SohLNjSD
	 +b/1aKMVHkZX5nWEcrz8FVpnqCCYGYrcguM1FCxdu8rsa4tw6OHUfvI+6FOurKR5Hu
	 5kchTgX274UF3pETYl3+uANyCHj/BCpcznhmhHTk=
Date: Fri, 20 Mar 2026 10:44:51 -0700
To: mm-commits@vger.kernel.org,bas@dfinity.org,adam.bratschikaye@dfinity.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-folio_split-and-filemap_get_entry-race-test-v4.patch added to mm-new branch
Message-Id: <20260320174451.E0B52C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-add-folio_split-and-filemap_get_entry-race-test-v4
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-add-folio_split-and-filemap_get_entry-race-test-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-folio_split-and-filemap_get_entry-race-test-v4.patch

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
selftests-mm-add-folio_split-and-filemap_get_entry-race-test-v4.patch

