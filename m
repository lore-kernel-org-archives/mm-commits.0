Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CE516DED4
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 22:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724278738; cv=none; b=sFFHpjMcVydJCMBjastMfssoVxeUrl3fTkZN/rFhNudDIEEKqMhDL4iquU8dYpJ0lasNt5XDPvENZjCc9oVIZiBzP9st38jqpUb80CeoqHxD/lBgF45ELdMJGZrGFSghjBZxktLHy97igUCb1EXXwEXEbFyvEAjMcJ0cgnQLb8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724278738; c=relaxed/simple;
	bh=6h1GqtcNjRKPGETxQ5nuhZkCchvAlIV/dZmCf8Faevg=;
	h=Date:To:From:Subject:Message-Id; b=DrKYWex4JTtc8r0XFb39RNivrnG+ifDdf+i2DS5lmi23chmznLyzLSvlWycCOTbasufJGCkMVsheCtz0pH8dZCJSCIIF1hXeiP2OcJgS4xYYcvWWJG/GQbpRJj5WEQqeiFFIOd8zILDs8l+C3lP4Ju25ku5EVqhfb5t+5ewSkmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uDRxFeKW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uDRxFeKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B200C32781;
	Wed, 21 Aug 2024 22:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724278736;
	bh=6h1GqtcNjRKPGETxQ5nuhZkCchvAlIV/dZmCf8Faevg=;
	h=Date:To:From:Subject:From;
	b=uDRxFeKWyu84A6l7Pt2N2t1pwZ34SS/ZR60hfD78TFV9j7rH11NIFNheVLEyzOdU+
	 VP8RjBKYk6R0CeQkqSZgV5y9pS1/Iaic3Nr46UfXUvsNoVqhe5qtZNjvnSqaTnx6T8
	 eDhsV2rFLTZt4HKjbnsWRI8tArRn+wTWvP5yY7gs=
Date: Wed, 21 Aug 2024 15:18:55 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,11162571@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-check-mmap-based-on-return-values.patch added to mm-unstable branch
Message-Id: <20240821221856.9B200C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools:mm: check mmap based on return values
has been added to the -mm mm-unstable branch.  Its filename is
     tools-mm-check-mmap-based-on-return-values.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-check-mmap-based-on-return-values.patch

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
From: Yang Ruibin <11162571@vivo.com>
Subject: tools:mm: check mmap based on return values
Date: Tue, 20 Aug 2024 23:50:03 -0400

To correctly detect whether mmap is successful, must use if (map_ptr ==
MAP_FAILED)to avoid incorrectly handling a valid mapping.

Link: https://lkml.kernel.org/r/20240821035005.4423-1-11162571@vivo.com
Signed-off-by: Yang Ruibin <11162571@vivo.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_tests.c     |    2 +-
 tools/testing/selftests/mm/madv_populate.c |    2 +-
 tools/testing/selftests/mm/soft-dirty.c    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/ksm_tests.c~tools-mm-check-mmap-based-on-return-values
+++ a/tools/testing/selftests/mm/ksm_tests.c
@@ -201,7 +201,7 @@ static void  *allocate_memory(void *ptr,
 {
 	void *map_ptr = mmap(ptr, map_size, PROT_WRITE, mapping, -1, 0);
 
-	if (!map_ptr) {
+	if (map_ptr == MAP_FAILED) {
 		perror("mmap");
 		return NULL;
 	}
--- a/tools/testing/selftests/mm/madv_populate.c~tools-mm-check-mmap-based-on-return-values
+++ a/tools/testing/selftests/mm/madv_populate.c
@@ -34,7 +34,7 @@ static void sense_support(void)
 
 	addr = mmap(0, pagesize, PROT_READ | PROT_WRITE,
 		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
-	if (!addr)
+	if (addr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap failed\n");
 
 	ret = madvise(addr, pagesize, MADV_POPULATE_READ);
--- a/tools/testing/selftests/mm/soft-dirty.c~tools-mm-check-mmap-based-on-return-values
+++ a/tools/testing/selftests/mm/soft-dirty.c
@@ -134,7 +134,7 @@ static void test_mprotect(int pagemap_fd
 	if (anon) {
 		map = mmap(NULL, pagesize, PROT_READ|PROT_WRITE,
 			   MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
-		if (!map)
+		if (map == MAP_FAILED)
 			ksft_exit_fail_msg("anon mmap failed\n");
 	} else {
 		test_fd = open(fname, O_RDWR | O_CREAT, 0664);
_

Patches currently in -mm which might be from 11162571@vivo.com are

tools-mm-check-mmap-based-on-return-values.patch
lib-fix-the-null-vs-is_err-bug-for-debugfs_create_dir.patch

