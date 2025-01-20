Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3306E8BEC
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 01:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337159; cv=none; b=tAlfq7uM+MAyO/HYzA3uNEfH4jGL3xXtd8bJxY0B+iXRl6lX1NDSxeYkSLQsSY1EYjkmBI3P2lK8GjxziqUqt1CCB3Zx9LimveIutukd3hz8iuh+f/+e80lrBk+26mhTqsaPG7WE/KIkZTbpEAyZuD92Q3ft4IR0wM7pNcmd4Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337159; c=relaxed/simple;
	bh=nvRy6+ArZuLgd2FmGKtp+Gz8kkNFgDfOuO3CvfDym94=;
	h=Date:To:From:Subject:Message-Id; b=jldyumTl1Bx9tkzeyllb7OaZxJ67JvsDUvzhQ/UCZrrJXv60GsLtnSkYUqMltHqH7CtZrPIaH9z/tRKJLEkR1G0XvREBanlBj5FJ2JRq1BJdnfz9RImgA/gJVFRdru2LJIUkZ5zAlu0ZUKpK2rboIvh3EH6cxNSZSdCgjv8Ikyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zz1yi7vj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zz1yi7vj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBC4C4CED6;
	Mon, 20 Jan 2025 01:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737337157;
	bh=nvRy6+ArZuLgd2FmGKtp+Gz8kkNFgDfOuO3CvfDym94=;
	h=Date:To:From:Subject:From;
	b=Zz1yi7vj93r4Af3MoXAM9HNOspW1HbHso+wEcqgwuagI84yZ/2xp6jFOpfk+cjmDI
	 vD1qqtrtDF0rcJSGsS652oI7SQ+5l5eqDa6bYP+fvAvuRk4zWHvIJUvhgt5d4hX7FN
	 uR9q8F3hLNv3Koy7y5pubYR4rbmvaZokjarP+CFc=
Date: Sun, 19 Jan 2025 17:39:17 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,shuah@kernel.org,oliver.sang@intel.com,khandual@linux.vnet.ibm.com,dev.jain@arm.com,david@redhat.com,thomas.weissschuh@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-virtual_address_range-unmap-chunks-after-validation.patch removed from -mm tree
Message-Id: <20250120013917.9EBC4C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: virtual_address_range: unmap chunks after validation
has been removed from the -mm tree.  Its filename was
     selftests-mm-virtual_address_range-unmap-chunks-after-validation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Subject: selftests/mm: virtual_address_range: unmap chunks after validation
Date: Tue, 14 Jan 2025 17:06:46 +0100

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

Link: https://lkml.kernel.org/r/20250114-virtual_address_range-tests-v4-2-6fd7269934a5@linutronix.de
Fixes: 010409649885 ("selftests/mm: confirm VA exhaustion without reliance on correctness of mmap()")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
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
@@ -175,6 +202,7 @@ int main(int argc, char *argv[])
 			break;
 		}
 
+		mark_range(ptr[i], MAP_CHUNK_SIZE);
 		validate_addr(ptr[i], 0);
 	}
 	lchunks = i;
@@ -192,6 +220,7 @@ int main(int argc, char *argv[])
 		if (hptr[i] == MAP_FAILED)
 			break;
 
+		mark_range(ptr[i], MAP_CHUNK_SIZE);
 		validate_addr(hptr[i], 1);
 	}
 	hchunks = i;
_

Patches currently in -mm which might be from thomas.weissschuh@linutronix.de are


