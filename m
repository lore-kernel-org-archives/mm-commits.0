Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9CA320B
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560153; cv=none; b=k/Lz1UuKmiXkedgRa13gFhOfjLwdtms137adhHr89MZivV44shAiKwMAoBUGSC1ViMeetoCgaIldV8KysmbmZ7RS5pcEoenEppyaxAbaweoEGfz5ohOv0TmzTQ8cBVn6DA+6PpsPHzKISREtxQkpsPEn0lzPsqv6RyoFZfuJZXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560153; c=relaxed/simple;
	bh=w/8/eO+e+5neZHptJWyEEmv3Jpefb38P7kw625YIkEM=;
	h=Date:To:From:Subject:Message-Id; b=OpggvxzITGDVOk2UuR3fgmP4pAYjTXidcHmAB7/+8yM0UTchCiO0ny6ut9XpGZNQokDCvjLwLg3AaQ6uKmcnQmxDZujHXTt4TZspI6qCkiMFtc39M4UcX7XDEJUNHuelO6GS33ITueyNIEZiLUx1OoRNPkRC7m52Jx+iSLq3Nl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1gx85FC+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1gx85FC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1167C433C7;
	Thu, 22 Feb 2024 00:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560153;
	bh=w/8/eO+e+5neZHptJWyEEmv3Jpefb38P7kw625YIkEM=;
	h=Date:To:From:Subject:From;
	b=1gx85FC+IH0zUTOAg7r8KQB3jRGFflPRnBjMZ56zBZPFpTAl294JnYVvV++eIhezV
	 v+Pa0PDzfGBwxCNMaN/tjJCQSE0UCwpq6zfUEyPSxVRhtCGTGJ9vO01/dXOpuvovx6
	 NM+nvdTLd3LdN2NKR40YrDT0d5AIx/AeUJkIH1XY=
Date: Wed, 21 Feb 2024 16:02:33 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-map_hugetlb-conform-test-to-tap-format-output.patch removed from -mm tree
Message-Id: <20240222000233.B1167C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: map_hugetlb: conform test to TAP format output
has been removed from the -mm tree.  Its filename was
     selftests-mm-map_hugetlb-conform-test-to-tap-format-output.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: map_hugetlb: conform test to TAP format output
Date: Fri, 2 Feb 2024 16:31:09 +0500

Conform the layout, informational and status messages to TAP.  No
functional change is intended other than the layout of output messages.

Link: https://lkml.kernel.org/r/20240202113119.2047740-3-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/map_hugetlb.c |   42 ++++++++++-----------
 1 file changed, 20 insertions(+), 22 deletions(-)

--- a/tools/testing/selftests/mm/map_hugetlb.c~selftests-mm-map_hugetlb-conform-test-to-tap-format-output
+++ a/tools/testing/selftests/mm/map_hugetlb.c
@@ -16,6 +16,7 @@
 #include <sys/mman.h>
 #include <fcntl.h>
 #include "vm_util.h"
+#include "../kselftest.h"
 
 #define LENGTH (256UL*1024*1024)
 #define PROTECTION (PROT_READ | PROT_WRITE)
@@ -31,7 +32,7 @@
 
 static void check_bytes(char *addr)
 {
-	printf("First hex is %x\n", *((unsigned int *)addr));
+	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
 }
 
 static void write_bytes(char *addr, size_t length)
@@ -42,23 +43,21 @@ static void write_bytes(char *addr, size
 		*(addr + i) = (char)i;
 }
 
-static int read_bytes(char *addr, size_t length)
+static void read_bytes(char *addr, size_t length)
 {
 	unsigned long i;
 
 	check_bytes(addr);
 	for (i = 0; i < length; i++)
-		if (*(addr + i) != (char)i) {
-			printf("Mismatch at %lu\n", i);
-			return 1;
-		}
-	return 0;
+		if (*(addr + i) != (char)i)
+			ksft_exit_fail_msg("Mismatch at %lu\n", i);
+
+	ksft_test_result_pass("Read correct data\n");
 }
 
 int main(int argc, char **argv)
 {
 	void *addr;
-	int ret;
 	size_t hugepage_size;
 	size_t length = LENGTH;
 	int flags = FLAGS;
@@ -69,6 +68,9 @@ int main(int argc, char **argv)
 	if (hugepage_size > length)
 		length = hugepage_size;
 
+	ksft_print_header();
+	ksft_set_plan(1);
+
 	if (argc > 1)
 		length = atol(argv[1]) << 20;
 	if (argc > 2) {
@@ -78,27 +80,23 @@ int main(int argc, char **argv)
 	}
 
 	if (shift)
-		printf("%u kB hugepages\n", 1 << (shift - 10));
+		ksft_print_msg("%u kB hugepages\n", 1 << (shift - 10));
 	else
-		printf("Default size hugepages\n");
-	printf("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
+		ksft_print_msg("Default size hugepages\n");
+	ksft_print_msg("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
 
 	addr = mmap(ADDR, length, PROTECTION, flags, -1, 0);
-	if (addr == MAP_FAILED) {
-		perror("mmap");
-		exit(1);
-	}
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
 
-	printf("Returned address is %p\n", addr);
+	ksft_print_msg("Returned address is %p\n", addr);
 	check_bytes(addr);
 	write_bytes(addr, length);
-	ret = read_bytes(addr, length);
+	read_bytes(addr, length);
 
 	/* munmap() length of MAP_HUGETLB memory must be hugepage aligned */
-	if (munmap(addr, length)) {
-		perror("munmap");
-		exit(1);
-	}
+	if (munmap(addr, length))
+		ksft_exit_fail_msg("munmap: %s\n", strerror(errno));
 
-	return ret;
+	ksft_finished();
 }
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap-fix.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch
selftests-mm-run_vmtestssh-add-missing-tests-fix.patch

