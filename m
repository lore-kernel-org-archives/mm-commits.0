Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E569FC0E
	for <mm-commits@vger.kernel.org>; Wed, 28 May 2025 21:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748466411; cv=none; b=pDa7gvaVSRfcmZ2Mcpl6rCq8EQlX4f7/zTFrHPu4uSKd9KVQRE+6DlpcfELm9GOfFcARZyvfsb8Gj/rwXQoG/r2GBdy7PGbAI8WjmsvFF//cllHlPT8GSoBU5IwG0Tr4EATZY2TWmliuSA3HSm04GNvIoSsX5AcPS1tLckID2zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748466411; c=relaxed/simple;
	bh=AJKhl5TK61uk4iyZqAkgZncd7Z4++xCvexX8DfcLC/w=;
	h=Date:To:From:Subject:Message-Id; b=myheVyBbS0+qWEejPDMDmkhvTSYB6LaSuPRiKIvI58tu+ukPi3H8878EtKt1YLuW2T8iUIlwXYxuS+MvAvKEdH32MWycljIbhIQ6An4PGEzlOjFkoCLChi9qYSldmscokgkVdGpxMVct2woZFGeswdlBDivtXYpJiQC7qVLv0K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pJouGbuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pJouGbuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEA8C4CEE7;
	Wed, 28 May 2025 21:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748466411;
	bh=AJKhl5TK61uk4iyZqAkgZncd7Z4++xCvexX8DfcLC/w=;
	h=Date:To:From:Subject:From;
	b=pJouGbuGQjimYiF1ZnZyCIf/RLNo44iOmDJJqc2LX4djItwNeruLwkxlNZ9pjfEKa
	 JuPQp4Izq2R+l4Pep+G+p1dsYpgFTl4T5btqmb9NyZegLrsQ0hSKWjXQZstKBAdNKy
	 fSD8dnVAuMPngRMu7XxCSW2PsR+OJkDlTAqniDEE=
Date: Wed, 28 May 2025 14:06:50 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,lorenzo.stoakes@oracle.com,aishwarya.tcv@arm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-two-fixes-for-the-pfnmap-test.patch added to mm-unstable branch
Message-Id: <20250528210650.EEEA8C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: two fixes for the pfnmap test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-two-fixes-for-the-pfnmap-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-two-fixes-for-the-pfnmap-test.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: selftests/mm: two fixes for the pfnmap test
Date: Wed, 28 May 2025 21:52:44 +0200

When unregistering the signal handler, we have to pass SIG_DFL, and
blindly reading from PFN 0 and PFN 1 seems to be problematic on !x86
systems.  In particularly, on arm64 tx2 machines where noting resides at
these physical memory locations, we can generate RAS errors.

Let's fix it by scanning /proc/iomem for actual "System RAM".

Link: https://lkml.kernel.org/r/20250528195244.1182810-1-david@redhat.com
Fixes: 2616b370323a ("selftests/mm: add simple VM_PFNMAP tests based on mmap'ing /dev/mem")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Closes: https://lore.kernel.org/all/232960c2-81db-47ca-a337-38c4bce5f997@arm.com/T/#u
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Aishwarya TCV <aishwarya.tcv@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pfnmap.c |   61 ++++++++++++++++++++++++--
 1 file changed, 57 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/pfnmap.c~selftests-mm-two-fixes-for-the-pfnmap-test
+++ a/tools/testing/selftests/mm/pfnmap.c
@@ -12,6 +12,8 @@
 #include <stdint.h>
 #include <unistd.h>
 #include <errno.h>
+#include <stdio.h>
+#include <ctype.h>
 #include <fcntl.h>
 #include <signal.h>
 #include <setjmp.h>
@@ -43,14 +45,62 @@ static int test_read_access(char *addr,
 			/* Force a read that the compiler cannot optimize out. */
 			*((volatile char *)(addr + offs));
 	}
-	if (signal(SIGSEGV, signal_handler) == SIG_ERR)
+	if (signal(SIGSEGV, SIG_DFL) == SIG_ERR)
 		return -EINVAL;
 
 	return ret;
 }
 
+static int find_ram_target(off_t *phys_addr,
+		unsigned long long pagesize)
+{
+	unsigned long long start, end;
+	char line[80], *end_ptr;
+	FILE *file;
+
+	/* Search /proc/iomem for the first suitable "System RAM" range. */
+	file = fopen("/proc/iomem", "r");
+	if (!file)
+		return -errno;
+
+	while (fgets(line, sizeof(line), file)) {
+		/* Ignore any child nodes. */
+		if (!isalnum(line[0]))
+			continue;
+
+		if (!strstr(line, "System RAM\n"))
+			continue;
+
+		start = strtoull(line, &end_ptr, 16);
+		/* Skip over the "-" */
+		end_ptr++;
+		/* Make end "exclusive". */
+		end = strtoull(end_ptr, NULL, 16) + 1;
+
+		/* Actual addresses are not exported */
+		if (!start && !end)
+			break;
+
+		/* We need full pages. */
+		start = (start + pagesize - 1) & ~(pagesize - 1);
+		end &= ~(pagesize - 1);
+
+		if (start != (off_t)start)
+			break;
+
+		/* We need two pages. */
+		if (end > start + 2 * pagesize) {
+			fclose(file);
+			*phys_addr = start;
+			return 0;
+		}
+	}
+	return -ENOENT;
+}
+
 FIXTURE(pfnmap)
 {
+	off_t phys_addr;
 	size_t pagesize;
 	int dev_mem_fd;
 	char *addr1;
@@ -63,14 +113,17 @@ FIXTURE_SETUP(pfnmap)
 {
 	self->pagesize = getpagesize();
 
+	/* We'll require two physical pages throughout our tests ... */
+	if (find_ram_target(&self->phys_addr, self->pagesize))
+		SKIP(return, "Cannot find ram target in '/proc/iomem'\n");
+
 	self->dev_mem_fd = open("/dev/mem", O_RDONLY);
 	if (self->dev_mem_fd < 0)
 		SKIP(return, "Cannot open '/dev/mem'\n");
 
-	/* We'll require the first two pages throughout our tests ... */
 	self->size1 = self->pagesize * 2;
 	self->addr1 = mmap(NULL, self->size1, PROT_READ, MAP_SHARED,
-			   self->dev_mem_fd, 0);
+			   self->dev_mem_fd, self->phys_addr);
 	if (self->addr1 == MAP_FAILED)
 		SKIP(return, "Cannot mmap '/dev/mem'\n");
 
@@ -129,7 +182,7 @@ TEST_F(pfnmap, munmap_split)
 	 */
 	self->size2 = self->pagesize;
 	self->addr2 = mmap(NULL, self->pagesize, PROT_READ, MAP_SHARED,
-			   self->dev_mem_fd, 0);
+			   self->dev_mem_fd, self->phys_addr);
 	ASSERT_NE(self->addr2, MAP_FAILED);
 }
 
_

Patches currently in -mm which might be from david@redhat.com are

selftests-mm-two-fixes-for-the-pfnmap-test.patch

