Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D7213666E
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 21:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711057910; cv=none; b=rXtoc8jb3GZ5HZWk3t0WdsS98AikO2hkAxmsXja04ndWo61iLBUHJVCnLzRcvhVhYVULh/1MARe+hSTOWXLoCAlNeJzuLQXU1Nj8ykizsR5TOH0vEE03jhmQSi2zL0DNWf7XNg76IB9bDnHHvdtvDRiwUqa01fUpTREBP/dGodU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711057910; c=relaxed/simple;
	bh=CciTBRcBk63yVtShOV7zcCYj6DrG67OpEh4FaAXYTNs=;
	h=Date:To:From:Subject:Message-Id; b=j9LpuZZoXy1KJepSzdHPO/cTPD5dzAn1FOscwvCv68x4e/j2f4Ddoo9cIj4Jfk32iPocb8iLuBvKvtSal/+zUBp9T3OdnrFUZrRKf4Wnbepct2j6Oxs3EZ7j73sfc4dPckLwEu+Z/JHKTJ0GK/4MX6flnr2+1mbHPjT7kVnteQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m4ztDL89; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m4ztDL89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2073CC43394;
	Thu, 21 Mar 2024 21:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711057910;
	bh=CciTBRcBk63yVtShOV7zcCYj6DrG67OpEh4FaAXYTNs=;
	h=Date:To:From:Subject:From;
	b=m4ztDL89raOo20ThOKgBOcAceNczaFj2GnPVcG3d7Uhvw06oiYiOyzMtdFKFVC+lQ
	 SURsIfu9oqQthTP/HxZ9FCX1uiVTxAXnjoN7yP1rtd+pIzan49cNNfKLZBEDOM8Njp
	 /Q/kFV/EHCpoQuiI+UM1No5wP7XspjQS5OrsalUE=
Date: Thu, 21 Mar 2024 14:51:49 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap.patch added to mm-unstable branch
Message-Id: <20240321215150.2073CC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: confirm VA exhaustion without reliance on correctness of mmap()
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap.patch

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
Subject: selftests/mm: confirm VA exhaustion without reliance on correctness of mmap()
Date: Thu, 21 Mar 2024 16:05:22 +0530

Currently, VA exhaustion is being checked by passing a hint to mmap() and
expecting it to fail.  This patch makes a stricter test by successful
write() calls from /proc/self/maps to a dump file, confirming that a free
chunk is indeed not available.

Link: https://lkml.kernel.org/r/20240321103522.516097-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/virtual_address_range.c |   69 +++++++++++
 1 file changed, 69 insertions(+)

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
@@ -93,6 +95,69 @@ static int validate_lower_address_hint(v
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
+		int ret;
+
+		ret = sscanf(line, "%lx-%lx %s[rwxp-]",
+			     &start_addr, &end_addr, prot);
+		if (ret != 3)
+			ksft_exit_fail_msg("sscanf failed, cannot parse\n");
+
+		/* end of userspace mappings; ignore vsyscall mapping */
+		if (start_addr & (1UL << 63))
+			return 0;
+
+		/* /proc/self/maps must have gaps less than 1GB only */
+		if (start_addr - prev_end_addr >= SZ_1GB)
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
+			else
+				lseek(fd, 0, SEEK_SET);
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
@@ -133,6 +198,10 @@ int main(int argc, char *argv[])
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

selftests-mm-virtual_address_range-switch-to-ksft_exit_fail_msg.patch
selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap.patch

