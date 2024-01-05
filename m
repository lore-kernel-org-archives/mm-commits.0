Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEE334571
	for <mm-commits@vger.kernel.org>; Fri,  5 Jan 2024 18:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u2Y2qdpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89CEC433C8;
	Fri,  5 Jan 2024 18:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704478732;
	bh=eE2b9vGAhYZfOGTyqP8DkaMFv41qxXqoUac2MOl54so=;
	h=Date:To:From:Subject:From;
	b=u2Y2qdpbEL7Gc5AGfEv/WJVSpGHaH240ry2SEQZevNg0a5JP6FI0pFkFPmCM0ghXX
	 3puALuLZP0q7w6oKFXXJ4HZMa+pdZWrY4qvdQTrge+CtoK5KG1GcxR75GOcblelyVK
	 lxJJBREqDp0nbfF1Lqk6wxM8n8ql9K+vfX6MA68Q=
Date: Fri, 05 Jan 2024 10:18:52 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-hugepage-mmap-conform-to-tap-format-output.patch removed from -mm tree
Message-Id: <20240105181852.C89CEC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: mm: hugepage-mmap: conform to TAP format output
has been removed from the -mm tree.  Its filename was
     selftests-mm-hugepage-mmap-conform-to-tap-format-output.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: mm: hugepage-mmap: conform to TAP format output
Date: Tue, 2 Jan 2024 10:32:22 +0500

Conform the layout, informational and status messages to TAP.  No
functional change is intended other than the layout of output messages.

Link: https://lkml.kernel.org/r/20240102053223.2099572-1-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugepage-mmap.c |   23 ++++++++++---------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/mm/hugepage-mmap.c~selftests-mm-hugepage-mmap-conform-to-tap-format-output
+++ a/tools/testing/selftests/mm/hugepage-mmap.c
@@ -22,6 +22,7 @@
 #include <unistd.h>
 #include <sys/mman.h>
 #include <fcntl.h>
+#include "../kselftest.h"
 
 #define LENGTH (256UL*1024*1024)
 #define PROTECTION (PROT_READ | PROT_WRITE)
@@ -37,7 +38,7 @@
 
 static void check_bytes(char *addr)
 {
-	printf("First hex is %x\n", *((unsigned int *)addr));
+	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
 }
 
 static void write_bytes(char *addr)
@@ -55,7 +56,7 @@ static int read_bytes(char *addr)
 	check_bytes(addr);
 	for (i = 0; i < LENGTH; i++)
 		if (*(addr + i) != (char)i) {
-			printf("Mismatch at %lu\n", i);
+			ksft_print_msg("Error: Mismatch at %lu\n", i);
 			return 1;
 		}
 	return 0;
@@ -66,20 +67,20 @@ int main(void)
 	void *addr;
 	int fd, ret;
 
+	ksft_print_header();
+	ksft_set_plan(1);
+
 	fd = memfd_create("hugepage-mmap", MFD_HUGETLB);
-	if (fd < 0) {
-		perror("memfd_create() failed");
-		exit(1);
-	}
+	if (fd < 0)
+		ksft_exit_fail_msg("memfd_create() failed: %s\n", strerror(errno));
 
 	addr = mmap(ADDR, LENGTH, PROTECTION, FLAGS, fd, 0);
 	if (addr == MAP_FAILED) {
-		perror("mmap");
 		close(fd);
-		exit(1);
+		ksft_exit_fail_msg("mmap(): %s\n", strerror(errno));
 	}
 
-	printf("Returned address is %p\n", addr);
+	ksft_print_msg("Returned address is %p\n", addr);
 	check_bytes(addr);
 	write_bytes(addr);
 	ret = read_bytes(addr);
@@ -87,5 +88,7 @@ int main(void)
 	munmap(addr, LENGTH);
 	close(fd);
 
-	return ret;
+	ksft_test_result(!ret, "Read same data\n");
+
+	ksft_exit(!ret);
 }
_

Patches currently in -mm which might be from usama.anjum@collabora.com are


