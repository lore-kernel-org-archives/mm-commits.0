Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370627CF33
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103945; cv=none; b=E63yCBF+C1kBdhqh3U+4gfyeRikXhrwJy8y5B7K1P4N2FMgGASQxt34jhaUEx3DeCBCA1SFMrKdo83WDkz+u2UdM5df8Sl9++1FwXqA94sUvCYcLn6NoG/zh63aacVAs+SAVnB8lqX+ZUF5OJSwda62OFMb3RiMHHef8ybgIcsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103945; c=relaxed/simple;
	bh=8jDkGtXZCCwxrBISL1zT8bGJPuQ7AFA9yQHuqwPRklI=;
	h=Date:To:From:Subject:Message-Id; b=F60X2Zo8gcyw1FtKCO8VOSzzs/c3o3Ds1iA96pebCLhHv1c/VlV4eFo+MkABlC1sKR6md1vCngWheSlN7V6xGvt91xgsuPa6eyA7J7bEnX5/6AKhNsJ9Q7s9GKtIO5+PYD6sBeZ+wUXMGp8OhqtdOYp5y5QDwQHwAjBobLyoasc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1CxKDcrL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1CxKDcrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D12EC113CD;
	Fri, 26 Apr 2024 03:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103945;
	bh=8jDkGtXZCCwxrBISL1zT8bGJPuQ7AFA9yQHuqwPRklI=;
	h=Date:To:From:Subject:From;
	b=1CxKDcrLo8EOFXsmqNavVzsxvo1c+B4PyDCusKcWqjRCNFfMWkzp0XNjCQTM1vrve
	 mC+II6zxAfZFYFZTje+h7mSBd8kQ89CajrKxyOyiPv3zBb/xS8YcKSt13NYwXPYx3C
	 zGGuxV6cuRf78rBB+KcYuI+x2pc3VAnJ01aaDxQU=
Date: Thu, 25 Apr 2024 20:59:04 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap.patch removed from -mm tree
Message-Id: <20240426035905.0D12EC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: confirm VA exhaustion without reliance on correctness of mmap()
has been removed from the -mm tree.  Its filename was
     selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: selftests/mm: confirm VA exhaustion without reliance on correctness of mmap()
Date: Thu, 21 Mar 2024 16:05:22 +0530

Currently, VA exhaustion is being checked by passing a hint to mmap() and
expecting it to fail.

While populating the lower VA space, mmap() fails because we have 
exhausted the space.

Then, in validate_lower_address_hint(), because mmap() fails, we
confirm that we have indeed exhausted the space.  There is a circular
logic involved here.

Assume that there is a bug in mmap(), also assume that it exists
independent of whether you pass a hint address or not; that for some
reason it is not able to find a 1GB chunk.  My idea is to assert the
exhaustion against some other method.

This patch makes a stricter test by successful
write() calls from /proc/self/maps to a dump file, confirming that a free
chunk is indeed not available.

[dev.jain@arm.com: replace SZ_1GB with MAP_CHUNK_SIZE, tidy-up]
  Link: https://lkml.kernel.org/r/20240325042653.867055-1-dev.jain@arm.com
Link: https://lkml.kernel.org/r/20240321103522.516097-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/virtual_address_range.c |   66 +++++++++++
 1 file changed, 66 insertions(+)

--- a/tools/testing/selftests/mm/virtual_address_range.c~selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap
+++ a/tools/testing/selftests/mm/virtual_address_range.c
@@ -12,6 +12,8 @@
 #include <errno.h>
 #include <sys/mman.h>
 #include <sys/time.h>
+#include <fcntl.h>
+
 #include "../kselftest.h"
 
 /*
@@ -93,6 +95,66 @@ static int validate_lower_address_hint(v
 	return 1;
 }
 
+static int validate_complete_va_space(void)
+{
+	unsigned long start_addr, end_addr, prev_end_addr;
+	char line[400];
+	char prot[6];
+	FILE *file;
+	int fd;
+
+	fd = open("va_dump", O_CREAT | O_WRONLY, 0600);
+	unlink("va_dump");
+	if (fd < 0) {
+		ksft_test_result_skip("cannot create or open dump file\n");
+		ksft_finished();
+	}
+
+	file = fopen("/proc/self/maps", "r");
+	if (file == NULL)
+		ksft_exit_fail_msg("cannot open /proc/self/maps\n");
+
+	prev_end_addr = 0;
+	while (fgets(line, sizeof(line), file)) {
+		unsigned long hop;
+
+		if (sscanf(line, "%lx-%lx %s[rwxp-]",
+			   &start_addr, &end_addr, prot) != 3)
+			ksft_exit_fail_msg("cannot parse /proc/self/maps\n");
+
+		/* end of userspace mappings; ignore vsyscall mapping */
+		if (start_addr & (1UL << 63))
+			return 0;
+
+		/* /proc/self/maps must have gaps less than MAP_CHUNK_SIZE */
+		if (start_addr - prev_end_addr >= MAP_CHUNK_SIZE)
+			return 1;
+
+		prev_end_addr = end_addr;
+
+		if (prot[0] != 'r')
+			continue;
+
+		/*
+		 * Confirm whether MAP_CHUNK_SIZE chunk can be found or not.
+		 * If write succeeds, no need to check MAP_CHUNK_SIZE - 1
+		 * addresses after that. If the address was not held by this
+		 * process, write would fail with errno set to EFAULT.
+		 * Anyways, if write returns anything apart from 1, exit the
+		 * program since that would mean a bug in /proc/self/maps.
+		 */
+		hop = 0;
+		while (start_addr + hop < end_addr) {
+			if (write(fd, (void *)(start_addr + hop), 1) != 1)
+				return 1;
+			lseek(fd, 0, SEEK_SET);
+
+			hop += MAP_CHUNK_SIZE;
+		}
+	}
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	char *ptr[NR_CHUNKS_LOW];
@@ -133,6 +195,10 @@ int main(int argc, char *argv[])
 		validate_addr(hptr[i], 1);
 	}
 	hchunks = i;
+	if (validate_complete_va_space()) {
+		ksft_test_result_fail("BUG in mmap() or /proc/self/maps\n");
+		ksft_finished();
+	}
 
 	for (i = 0; i < lchunks; i++)
 		munmap(ptr[i], MAP_CHUNK_SIZE);
_

Patches currently in -mm which might be from dev.jain@arm.com are


