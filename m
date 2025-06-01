Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CDC16D4E6
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756854; cv=none; b=EJZNIydUb2pcY57pETczAUx3O+D6RelHri8bHI/Ov6XlUUUvQygFokkBeFVIIqZpuOSYtx9kkhqizdIOsJW8aDcEcxIPZCGlaOq9hTqgXOLPm1OdSDqE5CoLeLCSpmyQ2UvbTNKv7uy5Ifzpxme4gx2HhKCcUMhBT8x1K2YyJnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756854; c=relaxed/simple;
	bh=FypYHle7eFZKL2Eqhcb/NVo63zM4CqOVdBDz6E+xb/k=;
	h=Date:To:From:Subject:Message-Id; b=EajJi4W/b3FRNOIMpwVq9a09E5XOqRufjhqD/IxuEGrjNpxSsyqxngR2z8t5LpHz4YiXBGNbogtXmgOt1CFp9i0/ZtmVT/FB99yddkQ0M9mK08JuSk6GyXD9FmLPFIHNwadqTBHvW/cKv69ETaAWWh9SzIs2ZNmtNxrdgdZfsyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bSQWxcaw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bSQWxcaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AB3C4CEED;
	Sun,  1 Jun 2025 05:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756853;
	bh=FypYHle7eFZKL2Eqhcb/NVo63zM4CqOVdBDz6E+xb/k=;
	h=Date:To:From:Subject:From;
	b=bSQWxcawm05bUOJNRJXnLX7k2HDgqHesgZrfm8az4v69u1pd++M6+MoEIkIaWxhH0
	 f/9NjKcchlJmI1PiPuz1dH8gTwqksA0rR1OhFES4fppe2+WMx7+cz7FKG4/95NDyXA
	 K3tp7gQKpUu1wqCtv1NyUbR+HaQZ+h68YyQ5xGCw=
Date: Sat, 31 May 2025 22:47:33 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,lorenzo.stoakes@oracle.com,aishwarya.tcv@arm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-two-fixes-for-the-pfnmap-test.patch removed from -mm tree
Message-Id: <20250601054733.D1AB3C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: two fixes for the pfnmap test
has been removed from the -mm tree.  Its filename was
     selftests-mm-two-fixes-for-the-pfnmap-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


