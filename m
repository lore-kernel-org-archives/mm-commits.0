Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A53444361
	for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2024 19:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711396467; cv=none; b=pk+p4/6LAZokCu6I384xSs2XjDq6rqir6t0/9iDuffFhEKCcDezXXuPNrdu0XVwMVr+WMoN2qxidiYWUBFE6cqErvYh9dm5F1zcv4B3YGHUAHF+ZPLbe0a9V+83CeBrIvIasBzid2+6xDM9hA2k5yH1/GJtPoexD85BhCzwwT/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711396467; c=relaxed/simple;
	bh=tFzb1q1y8AJ+/EEkc4pIf3IMgjDbLD5PZAc/BFwzU0c=;
	h=Date:To:From:Subject:Message-Id; b=ZenhpWHZd7hO1X1rw0k4TAbWIaGDmjKh16vi440HTteeC+dStS1NOjPP0M7PLjCH8wuKuJ9c+HXtSZ+2uFwtVu/p+6bEER6I/VKSs2cRdnEm+cTLT7kKz/ks5Zf7Bhr77gDVRymsYbPMxpeVcGQESthaU/Z2fs9r2XA8mYlLOqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xdLcTdMC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xdLcTdMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A5DC433F1;
	Mon, 25 Mar 2024 19:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711396466;
	bh=tFzb1q1y8AJ+/EEkc4pIf3IMgjDbLD5PZAc/BFwzU0c=;
	h=Date:To:From:Subject:From;
	b=xdLcTdMCqI5nTpJhZK+AkNQGVu0dsSlh+e/PPVW9QW7dk6MsPr6A4N+Ru5U1F6KF/
	 j/pM8v11+qvy6tBZvURyjXQyZCeKquhTLIRWfJe4eh54II+v7iYiLW2NS3hircotMH
	 rFAbCEp9WSl15EM2rU6KnER5AxOS6sk/b16KBWMw=
Date: Mon, 25 Mar 2024 12:54:25 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap-v2.patch added to mm-unstable branch
Message-Id: <20240325195426.69A5DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap-v2
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap-v2.patch

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
Subject: selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap-v2
Date: Mon, 25 Mar 2024 09:56:53 +0530

replace SZ_1GB with MAP_CHUNK_SIZE, tidy-up

Link: https://lkml.kernel.org/r/20240325042653.867055-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/virtual_address_range.c |   15 ++++-------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/mm/virtual_address_range.c~selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap-v2
+++ a/tools/testing/selftests/mm/virtual_address_range.c
@@ -117,19 +117,17 @@ static int validate_complete_va_space(vo
 	prev_end_addr = 0;
 	while (fgets(line, sizeof(line), file)) {
 		unsigned long hop;
-		int ret;
 
-		ret = sscanf(line, "%lx-%lx %s[rwxp-]",
-			     &start_addr, &end_addr, prot);
-		if (ret != 3)
-			ksft_exit_fail_msg("sscanf failed, cannot parse\n");
+		if (sscanf(line, "%lx-%lx %s[rwxp-]",
+			   &start_addr, &end_addr, prot) != 3)
+			ksft_exit_fail_msg("cannot parse /proc/self/maps\n");
 
 		/* end of userspace mappings; ignore vsyscall mapping */
 		if (start_addr & (1UL << 63))
 			return 0;
 
-		/* /proc/self/maps must have gaps less than 1GB only */
-		if (start_addr - prev_end_addr >= SZ_1GB)
+		/* /proc/self/maps must have gaps less than MAP_CHUNK_SIZE */
+		if (start_addr - prev_end_addr >= MAP_CHUNK_SIZE)
 			return 1;
 
 		prev_end_addr = end_addr;
@@ -149,8 +147,7 @@ static int validate_complete_va_space(vo
 		while (start_addr + hop < end_addr) {
 			if (write(fd, (void *)(start_addr + hop), 1) != 1)
 				return 1;
-			else
-				lseek(fd, 0, SEEK_SET);
+			lseek(fd, 0, SEEK_SET);
 
 			hop += MAP_CHUNK_SIZE;
 		}
_

Patches currently in -mm which might be from dev.jain@arm.com are

selftests-mm-virtual_address_range-switch-to-ksft_exit_fail_msg.patch
selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap.patch
selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap-v2.patch
selftests-mm-parse-vma-range-in-one-go.patch

