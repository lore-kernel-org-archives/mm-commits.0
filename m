Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB431EB3D
	for <mm-commits@vger.kernel.org>; Sat, 15 Jun 2024 17:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718473441; cv=none; b=A6urZmFUU2G1JyQLGtjJ/oC0cSr6xh3p0nSk8q1QnGmSMU7NDYgRvsHkcNDhJhLopqapDNbC7k/3q5YNITH4UJbl1WggZkR2FNVFCVUXKZ6gFGnJ/IoYlyK6lYNpDqqH+Bqd8tY/jWkzKiK8d0rvu8PZ8WWf/ujoefU5Jxb4Qe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718473441; c=relaxed/simple;
	bh=hnreDgPcluc2t4z4QLu1VDD7E0cAo56O1SAS0In1DLM=;
	h=Date:To:From:Subject:Message-Id; b=pTlSwiQl7AkJrHYAj9+yd2YgPk0bU/3uvTJqc3IFk7PQyu5Dbo34Z+0BrfVoXzkmT2TmVysjoQyYFpX32y0dSPG/pHkd2JZkdn88zlwDIgghR1Rk2zrePKYp0+1bYG6XuFYsb9AzoXmRGJsl24ulF82sjTGhczg2C9kbvqiz8KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ff4RAgZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ff4RAgZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CB4C116B1;
	Sat, 15 Jun 2024 17:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718473441;
	bh=hnreDgPcluc2t4z4QLu1VDD7E0cAo56O1SAS0In1DLM=;
	h=Date:To:From:Subject:From;
	b=Ff4RAgZEEMpCzXWib0AdVLUZk3tXb/saawrQxMEwnL0SXgmI1NCwDDEKFXHYzmiIZ
	 TaaW5dbng/VdHFwIM/MOOVMDB4Puo86LOxIqB0fcz8AG9EEpb0uFX0v4Housx6zxw8
	 drPHGUc21+Gpmch+dYSyWe7A9rP3ylXWw/3HU5K8=
Date: Sat, 15 Jun 2024 10:44:01 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,ryan.roberts@arm.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-make-map_fixed_noreplace-test-names-stable.patch removed from -mm tree
Message-Id: <20240615174401.91CB4C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: mm: make map_fixed_noreplace test names stable
has been removed from the -mm tree.  Its filename was
     selftests-mm-make-map_fixed_noreplace-test-names-stable.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


