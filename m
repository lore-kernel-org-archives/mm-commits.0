Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB59EC5
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 01:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736818113; cv=none; b=Ihzj4PbbZsMAJZU5EsK6kCs6aHyJkkz91lgThgkCBlo096O1Iw1erbwZW1VQ4NhPyhO5/M9YodcGSWJEqVsOV4peq9Uy1vo9u8QwY52Hf3aM5vsFCr4G0likZhkUWgM133RfLPJXWkz4ez/G8N3NnfV1pmfrX5qrnnMikQNH07o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736818113; c=relaxed/simple;
	bh=pKwmLSXm/m/zleRE8W5/rFPoJ81J0ouspM0SFeCYopM=;
	h=Date:To:From:Subject:Message-Id; b=LOBMHeqpGUrBtLlpvlqmmqGfShnC8MF434G9VfH5aHhm+nm4wQIQn8d4209/BvgsfWuLh3e2vukF6/N2bCp38DD2J6e0MbmKm/oZ4XTA5IX15v5TraF46Qe6GGE1ClaWKSan6EpJMw+0+Qon9QQpFSBClmvpjjRePa5rFAhtm2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rqMNsroA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rqMNsroA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80AB9C4CED6;
	Tue, 14 Jan 2025 01:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736818112;
	bh=pKwmLSXm/m/zleRE8W5/rFPoJ81J0ouspM0SFeCYopM=;
	h=Date:To:From:Subject:From;
	b=rqMNsroAh55OGUVzQkxyajDAzEhULUJgIhF+eF5XWvHf4FfjqIGh33ngQQyGInBa8
	 hXYsh9vUvsDqMdPTaSSlHeT5lyNgz7EHYRDMV2/zbAfk4WavgR33TserIILR+3Nf3B
	 Z2AwiNq21KM216ekFgaFpUI/TCWj1HSy1kpgPtL0=
Date: Mon, 13 Jan 2025 17:28:31 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,shuah@kernel.org,oliver.sang@intel.com,dev.jain@arm.com,david@redhat.com,thomas.weissschuh@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-virtual_address_range-unmap-chunks-after-validation.patch added to mm-unstable branch
Message-Id: <20250114012832.80AB9C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: virtual_address_range: unmap chunks after validation
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-virtual_address_range-unmap-chunks-after-validation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-virtual_address_range-unmap-chunks-after-validation.patch

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
From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Subject: selftests/mm: virtual_address_range: unmap chunks after validation
Date: Mon, 13 Jan 2025 14:15:36 +0100

For each accessed chunk a PTE is created.  More than 1GiB of PTEs is used
in this way.  Remove each PTE after validating a chunk to reduce peak
memory usage.

It is important to only unmap memory that previously mmap()ed, as
unmapping other mappings like the stack, heap or executable mappings will
crash the process.

The mappings read from /proc/self/maps and the return values from mmap()
don't allow a simple correlation due to merging and no guaranteed order. 
To correlate the pointers and mappings use prctl(PR_SET_VMA_ANON_NAME). 
While it introduces a test dependency, other alternatives would introduce
runtime or development overhead.

Link: https://lkml.kernel.org/r/20250113-virtual_address_range-tests-v3-2-f4a8e6b7feed@linutronix.de
Fixes: 010409649885 ("selftests/mm: confirm VA exhaustion without reliance on correctness of mmap()")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/config                  |    1 
 tools/testing/selftests/mm/virtual_address_range.c |   33 ++++++++++-
 2 files changed, 32 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/config~selftests-mm-virtual_address_range-unmap-chunks-after-validation
+++ a/tools/testing/selftests/mm/config
@@ -7,3 +7,4 @@ CONFIG_TEST_HMM=m
 CONFIG_GUP_TEST=y
 CONFIG_TRANSPARENT_HUGEPAGE=y
 CONFIG_MEM_SOFT_DIRTY=y
+CONFIG_ANON_VMA_NAME=y
--- a/tools/testing/selftests/mm/virtual_address_range.c~selftests-mm-virtual_address_range-unmap-chunks-after-validation
+++ a/tools/testing/selftests/mm/virtual_address_range.c
@@ -10,6 +10,7 @@
 #include <string.h>
 #include <unistd.h>
 #include <errno.h>
+#include <sys/prctl.h>
 #include <sys/mman.h>
 #include <sys/time.h>
 #include <fcntl.h>
@@ -82,6 +83,24 @@ static void validate_addr(char *ptr, int
 		ksft_exit_fail_msg("Bad address %lx\n", addr);
 }
 
+static void mark_range(char *ptr, size_t size)
+{
+	if (prctl(PR_SET_VMA, PR_SET_VMA_ANON_NAME, ptr, size, "virtual_address_range") == -1) {
+		if (errno == EINVAL) {
+			/* Depends on CONFIG_ANON_VMA_NAME */
+			ksft_test_result_skip("prctl(PR_SET_VMA_ANON_NAME) not supported\n");
+			ksft_finished();
+		} else {
+			ksft_exit_fail_perror("prctl(PR_SET_VMA_ANON_NAME) failed\n");
+		}
+	}
+}
+
+static int is_marked_vma(const char *vma_name)
+{
+	return vma_name && !strcmp(vma_name, "[anon:virtual_address_range]\n");
+}
+
 static int validate_lower_address_hint(void)
 {
 	char *ptr;
@@ -116,12 +135,17 @@ static int validate_complete_va_space(vo
 
 	prev_end_addr = 0;
 	while (fgets(line, sizeof(line), file)) {
+		const char *vma_name = NULL;
+		int vma_name_start = 0;
 		unsigned long hop;
 
-		if (sscanf(line, "%lx-%lx %s[rwxp-]",
-			   &start_addr, &end_addr, prot) != 3)
+		if (sscanf(line, "%lx-%lx %4s %*s %*s %*s %n",
+			   &start_addr, &end_addr, prot, &vma_name_start) != 3)
 			ksft_exit_fail_msg("cannot parse /proc/self/maps\n");
 
+		if (vma_name_start)
+			vma_name = line + vma_name_start;
+
 		/* end of userspace mappings; ignore vsyscall mapping */
 		if (start_addr & (1UL << 63))
 			return 0;
@@ -149,6 +173,9 @@ static int validate_complete_va_space(vo
 				return 1;
 			lseek(fd, 0, SEEK_SET);
 
+			if (is_marked_vma(vma_name))
+				munmap((char *)(start_addr + hop), MAP_CHUNK_SIZE);
+
 			hop += MAP_CHUNK_SIZE;
 		}
 	}
@@ -175,6 +202,7 @@ int main(void)
 			break;
 		}
 
+		mark_range(ptr[i], MAP_CHUNK_SIZE);
 		validate_addr(ptr[i], 0);
 	}
 	lchunks = i;
@@ -192,6 +220,7 @@ int main(void)
 		if (hptr[i] == MAP_FAILED)
 			break;
 
+		mark_range(ptr[i], MAP_CHUNK_SIZE);
 		validate_addr(hptr[i], 1);
 	}
 	hchunks = i;
_

Patches currently in -mm which might be from thomas.weissschuh@linutronix.de are

selftests-mm-virtual_address_range-mmap-without-prot_write.patch
selftests-mm-virtual_address_range-unmap-chunks-after-validation.patch
selftests-mm-vm_util-split-up-proc-self-smaps-parsing.patch
selftests-mm-virtual_address_range-avoid-reading-from-vm_io-mappings.patch

