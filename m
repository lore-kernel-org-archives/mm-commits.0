Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133126CDB0
	for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2024 18:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711133068; cv=none; b=hSV4G+F/Lj60Wal7E+0t6IdmfT0pXRlQiegnRbRZh4SiPzsBT+UajO/o9D/sXDOreIa0veaiFQJ2zXg3Vs1Lk4MaOUi5aBGkIhujhvBvy6ZHPhm7rKmqBCoLBeU078yAxFb20txgp/0BGDr3HFNbI/DOrqKm64f5ebh5teoZiEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711133068; c=relaxed/simple;
	bh=VKpUy+df7ecaOnCwQBgknVH/SvfhwpFq/HRIuCfBnco=;
	h=Date:To:From:Subject:Message-Id; b=H0/pwzQzyDf7rBbOX46baGUh0SS8/y/Ds1e2LWroFIZXH3niUJQ7zg4QNCRCM5K5EIOS7bVJWkq6PRjs32pyfIdJCekyPDBVXLolKtw4KDXsWNS5y1d9XshGpfT0e8ys1HeYWySdeHUfbxE7Lp0dMo47DF0bFl42W+73Xhy6Pnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jWDamPCp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jWDamPCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA29C433C7;
	Fri, 22 Mar 2024 18:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711133067;
	bh=VKpUy+df7ecaOnCwQBgknVH/SvfhwpFq/HRIuCfBnco=;
	h=Date:To:From:Subject:From;
	b=jWDamPCp4CDQgVw5EBPlS9g9RXXogTr+G7oL0uAIcZljiWLxBz4n8DGKQfpOl0Bwd
	 l4j1RRc31sY+nzM+oMdNsm5fdzSj47afY9Wf3Bq/cy2GEoLQbsPyg+/G20XTdONnFn
	 YcVWtTdKOZ92y5/jn1aVMxcbyjq3B+ZydTiI2Ufc=
Date: Fri, 22 Mar 2024 11:44:27 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-parse-vma-range-in-one-go.patch added to mm-unstable branch
Message-Id: <20240322184427.BBA29C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: parse VMA range in one go
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-parse-vma-range-in-one-go.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-parse-vma-range-in-one-go.patch

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
Subject: selftests/mm: parse VMA range in one go
Date: Fri, 22 Mar 2024 17:35:51 +0530

Use sscanf() to directly parse the VMA range. No functional change is intended.

Link: https://lkml.kernel.org/r/20240322120551.818764-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mlock2-tests.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

--- a/tools/testing/selftests/mm/mlock2-tests.c~selftests-mm-parse-vma-range-in-one-go
+++ a/tools/testing/selftests/mm/mlock2-tests.c
@@ -20,8 +20,6 @@ static int get_vm_area(unsigned long add
 	FILE *file;
 	int ret = 1;
 	char line[1024] = {0};
-	char *end_addr;
-	char *stop;
 	unsigned long start;
 	unsigned long end;
 
@@ -37,21 +35,10 @@ static int get_vm_area(unsigned long add
 	memset(area, 0, sizeof(struct vm_boundaries));
 
 	while(fgets(line, 1024, file)) {
-		end_addr = strchr(line, '-');
-		if (!end_addr) {
+		if (sscanf(line, "%lx-%lx", &start, &end) != 2) {
 			ksft_print_msg("cannot parse /proc/self/maps\n");
 			goto out;
 		}
-		*end_addr = '\0';
-		end_addr++;
-		stop = strchr(end_addr, ' ');
-		if (!stop) {
-			ksft_print_msg("cannot parse /proc/self/maps\n");
-			goto out;
-		}
-
-		sscanf(line, "%lx", &start);
-		sscanf(end_addr, "%lx", &end);
 
 		if (start <= addr && end > addr) {
 			area->start = start;
_

Patches currently in -mm which might be from dev.jain@arm.com are

selftests-mm-virtual_address_range-switch-to-ksft_exit_fail_msg.patch
selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap.patch
selftests-mm-parse-vma-range-in-one-go.patch

