Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F4DF9DF
	for <mm-commits@vger.kernel.org>; Mon,  1 Apr 2024 18:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711997984; cv=none; b=D45K7juIFyWq+MwqhCMbOapp+H5ly0lKMKk9qviz1UU/ea30vQmfXcSRILqtm71iXXMCg6Xzj01uZq0+dy6ypmtLjUFm3i08S28q1ZRMjg/BzyMV9nE/K7O77V8h7aVes6ntPsLlr+kynIwmydMipZkXeoI99y3v15aTetnCeJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711997984; c=relaxed/simple;
	bh=wRcNGWIize3knxZcY+c69BcIsb9o/M3ulkK6HONNiMc=;
	h=Date:To:From:Subject:Message-Id; b=aUpL4Ai4EnimtLnWa5LPdgTiqS53I4hWzWVrcdX7Rb/rZI8XrCgMHEbQDecnSGkOVt2s8OOsnawnANBrmZ3PnQ4db4uEaLEKPF7dF55WkQF0sx08g4g61mZnoQx59sKvsdO0Cn0A6gOmx1rt9gbMkSGw/bRWCNgksO1bS6ncSKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TB0JtfXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TB0JtfXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B699DC433F1;
	Mon,  1 Apr 2024 18:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711997983;
	bh=wRcNGWIize3knxZcY+c69BcIsb9o/M3ulkK6HONNiMc=;
	h=Date:To:From:Subject:From;
	b=TB0JtfXRy3aHTNfSIdrMZvTM8oMay0xiGpCpNBCjPMNlZoRoES+1fjUGyA1e4Ulki
	 IQ3jUImVkaD6sLscD2bxFsN2iX/bzNOcBoT0kBj1UeYIhmzPFTXqIf8eZzxSltbiFO
	 9fVrP5514sBgOT/vbAYndLkYaD7dR28YMLVO7K0g=
Date: Mon, 01 Apr 2024 11:59:43 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,kaleshsingh@google.com,jhubbard@nvidia.com,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-mremap_test-use-sscanf-to-parse-proc-self-maps.patch added to mm-unstable branch
Message-Id: <20240401185943.B699DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: mremap_test: use sscanf to parse /proc/self/maps
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-mremap_test-use-sscanf-to-parse-proc-self-maps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-mremap_test-use-sscanf-to-parse-proc-self-maps.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: selftests/mm: mremap_test: use sscanf to parse /proc/self/maps
Date: Sat, 30 Mar 2024 23:05:57 +0530

Enforce consistency across files by avoiding two separate functions to
parse /proc/self/maps, replacing them with a simple sscanf().

Link: https://lkml.kernel.org/r/20240330173557.2697684-4-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_test.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/mremap_test.c~selftests-mm-mremap_test-use-sscanf-to-parse-proc-self-maps
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -148,19 +148,21 @@ static unsigned long long get_mmap_min_a
  * Using /proc/self/maps, assert that the specified address range is contained
  * within a single mapping.
  */
-static bool is_range_mapped(FILE *maps_fp, void *start, void *end)
+static bool is_range_mapped(FILE *maps_fp, unsigned long start,
+			    unsigned long end)
 {
 	char *line = NULL;
 	size_t len = 0;
 	bool success = false;
+	unsigned long first_val, second_val;
 
 	rewind(maps_fp);
 
 	while (getline(&line, &len, maps_fp) != -1) {
-		char *first = strtok(line, "- ");
-		void *first_val = (void *)strtol(first, NULL, 16);
-		char *second = strtok(NULL, "- ");
-		void *second_val = (void *) strtol(second, NULL, 16);
+		if (sscanf(line, "%lx-%lx", &first_val, &second_val) != 2) {
+			ksft_exit_fail_msg("cannot parse /proc/self/maps\n");
+			break;
+		}
 
 		if (first_val <= start && second_val >= end) {
 			success = true;
@@ -255,7 +257,8 @@ static void mremap_expand_merge(FILE *ma
 		goto out;
 	}
 
-	success = is_range_mapped(maps_fp, start, start + 3 * page_size);
+	success = is_range_mapped(maps_fp, (unsigned long)start,
+				  (unsigned long)(start + 3 * page_size));
 	munmap(start, 3 * page_size);
 
 out:
@@ -294,7 +297,8 @@ static void mremap_expand_merge_offset(F
 		goto out;
 	}
 
-	success = is_range_mapped(maps_fp, start, start + 3 * page_size);
+	success = is_range_mapped(maps_fp, (unsigned long)start,
+				  (unsigned long)(start + 3 * page_size));
 	munmap(start, 3 * page_size);
 
 out:
_

Patches currently in -mm which might be from dev.jain@arm.com are

selftests-mm-virtual_address_range-switch-to-ksft_exit_fail_msg.patch
selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap.patch
selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap-v2.patch
selftests-mm-parse-vma-range-in-one-go.patch
selftests-mm-mremap_test-optimize-using-pre-filled-random-array-and-memcpy.patch
selftests-mm-mremap_test-optimize-execution-time-from-minutes-to-seconds-using-chunkwise-memcmp.patch
selftests-mm-mremap_test-use-sscanf-to-parse-proc-self-maps.patch

