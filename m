Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A87718EAB
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 22:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718144642; cv=none; b=Rt1FDOrn8bnlxESWo9JkiDgyoWxUcjWnc8+bVvtE9meOcyL/GPf9KpS0OeR7oTV48/MUROJC/gZ0VYkJI4rxlCSN6cF/IUYPYKSdwIP9AjLOaAtflGdbpofPZJIBy6oDrYWs3TTJwQFO58rb5VE3UBi0ceuSwm/m3SkWIkCgfdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718144642; c=relaxed/simple;
	bh=9Yh0VcGhiAV26S1NLQeN6XrdIKkwVxVCYnICtDp1CcQ=;
	h=Date:To:From:Subject:Message-Id; b=ojI29AhB5iJEIFw6eQMLI4XnIT2lVdVFTSW++FAEuIFnDP8hlVGUOrPb+tmZVJE2bjHJ4ef0wGxzI8wnaGeVxryqDOdr4aznvKKaazjMOUarj9YPQ/F/eqGuBte/Bzbyxa2WGh0e0fW8H7EhpDdm+kBxeEn12jznMw+edt3hG7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2ubJJaLU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2ubJJaLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A978C2BD10;
	Tue, 11 Jun 2024 22:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718144641;
	bh=9Yh0VcGhiAV26S1NLQeN6XrdIKkwVxVCYnICtDp1CcQ=;
	h=Date:To:From:Subject:From;
	b=2ubJJaLUzQrbBS+kWyO2zFFhRecF+3DOyBolDu4Hd/YZzQyiOPINZRuuc7StOE4Js
	 q3OQMhr7nXhIj1j3A7CpXoOmJd1e5QRCccF+E6z9BQQLE39p1YENEp1M6QyX91HzlU
	 n/EixPsiX2q/7nsWcfe/AexJ7eOLZrwNs3uVW1O4=
Date: Tue, 11 Jun 2024 15:24:01 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,ryan.roberts@arm.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-make-map_fixed_noreplace-test-names-stable.patch added to mm-hotfixes-unstable branch
Message-Id: <20240611222401.8A978C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: mm: make map_fixed_noreplace test names stable
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-make-map_fixed_noreplace-test-names-stable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-make-map_fixed_noreplace-test-names-stable.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Mark Brown <broonie@kernel.org>
Subject: selftests: mm: make map_fixed_noreplace test names stable
Date: Wed, 05 Jun 2024 23:36:12 +0100

KTAP parsers interpret the output of ksft_test_result_*() as being the
name of the test.  The map_fixed_noreplace test uses a dynamically
allocated base address for the mmap()s that it tests and currently
includes this in the test names that it logs so the test names that are
logged are not stable between runs.  It also uses multiples of PAGE_SIZE
which mean that runs for kernels with different PAGE_SIZE configurations
can't be directly compared.  Both these factors cause issues for CI
systems when interpreting and displaying results.

Fix this by replacing the current test names with fixed strings describing
the intent of the mappings that are logged, the existing messages with the
actual addresses and sizes are retained as diagnostic prints to aid in
debugging.

Link: https://lkml.kernel.org/r/20240605-kselftest-mm-fixed-noreplace-v1-1-a235db8b9be9@kernel.org
Fixes: 4838cf70e539 ("selftests/mm: map_fixed_noreplace: conform test to TAP format output")
Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/map_fixed_noreplace.c |   24 ++++++++-----
 1 file changed, 16 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/map_fixed_noreplace.c~selftests-mm-make-map_fixed_noreplace-test-names-stable
+++ a/tools/testing/selftests/mm/map_fixed_noreplace.c
@@ -67,7 +67,8 @@ int main(void)
 		dump_maps();
 		ksft_exit_fail_msg("Error: munmap failed!?\n");
 	}
-	ksft_test_result_pass("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
+	ksft_print_msg("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
+	ksft_test_result_pass("mmap() 5*PAGE_SIZE at base\n");
 
 	addr = base_addr + page_size;
 	size = 3 * page_size;
@@ -76,7 +77,8 @@ int main(void)
 		dump_maps();
 		ksft_exit_fail_msg("Error: first mmap() failed unexpectedly\n");
 	}
-	ksft_test_result_pass("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
+	ksft_print_msg("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
+	ksft_test_result_pass("mmap() 3*PAGE_SIZE at base+PAGE_SIZE\n");
 
 	/*
 	 * Exact same mapping again:
@@ -93,7 +95,8 @@ int main(void)
 		dump_maps();
 		ksft_exit_fail_msg("Error:1: mmap() succeeded when it shouldn't have\n");
 	}
-	ksft_test_result_pass("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
+	ksft_print_msg("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
+	ksft_test_result_pass("mmap() 5*PAGE_SIZE at base\n");
 
 	/*
 	 * Second mapping contained within first:
@@ -111,7 +114,8 @@ int main(void)
 		dump_maps();
 		ksft_exit_fail_msg("Error:2: mmap() succeeded when it shouldn't have\n");
 	}
-	ksft_test_result_pass("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
+	ksft_print_msg("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
+	ksft_test_result_pass("mmap() 2*PAGE_SIZE at base+PAGE_SIZE\n");
 
 	/*
 	 * Overlap end of existing mapping:
@@ -128,7 +132,8 @@ int main(void)
 		dump_maps();
 		ksft_exit_fail_msg("Error:3: mmap() succeeded when it shouldn't have\n");
 	}
-	ksft_test_result_pass("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
+	ksft_print_msg("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
+	ksft_test_result_pass("mmap() 2*PAGE_SIZE  at base+(3*PAGE_SIZE)\n");
 
 	/*
 	 * Overlap start of existing mapping:
@@ -145,7 +150,8 @@ int main(void)
 		dump_maps();
 		ksft_exit_fail_msg("Error:4: mmap() succeeded when it shouldn't have\n");
 	}
-	ksft_test_result_pass("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
+	ksft_print_msg("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
+	ksft_test_result_pass("mmap() 2*PAGE_SIZE bytes at base\n");
 
 	/*
 	 * Adjacent to start of existing mapping:
@@ -162,7 +168,8 @@ int main(void)
 		dump_maps();
 		ksft_exit_fail_msg("Error:5: mmap() failed when it shouldn't have\n");
 	}
-	ksft_test_result_pass("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
+	ksft_print_msg("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
+	ksft_test_result_pass("mmap() PAGE_SIZE at base\n");
 
 	/*
 	 * Adjacent to end of existing mapping:
@@ -179,7 +186,8 @@ int main(void)
 		dump_maps();
 		ksft_exit_fail_msg("Error:6: mmap() failed when it shouldn't have\n");
 	}
-	ksft_test_result_pass("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
+	ksft_print_msg("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
+	ksft_test_result_pass("mmap() PAGE_SIZE at base+(4*PAGE_SIZE)\n");
 
 	addr = base_addr;
 	size = 5 * page_size;
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-mm-make-map_fixed_noreplace-test-names-stable.patch

