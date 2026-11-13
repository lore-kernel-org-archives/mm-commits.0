Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794546919;
	b=iYrFkvq2pd5dsgUF3G+NF6krANUzqSCEP+vORe5wIbJ7APGf0hHpFmULlht55zgyqstU
	 ABaUCxmXDKLOxup43Jwx7eZzKOXGEKvFtlVN1Pm19SdVwRY5/Vq1QnlEHMbCw4gCmWHsS
	 rxRdZibh5Or7duAvYMyiBLDyRFzs3SlB/oblFvkzz93YOw/4QOlgjRyBsWYCiPFH2Av1P
	 fCGV7jTMvxgSFlqH85oF9GY3MrlDXbET8R3xBvZOhSGDRBae1oft4Y6B8XaS7z3nyhisx
	 VVe7dvap/7dUQr1uvP7K6M+2fsvmMVjy6yocZ2/JaOiRjJENl/TOSqKvlXyt6avoOlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794546919;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=PNVt6yu1ICPwL0RcI+uaDmi+oPPSh1bc1+NxVxSgaHM=;
	b=cwZfbTwiqjyL4SMWq/HKfbnaViWhdn4q8fj5ZgLiXZTUbfBsVVU0OcQMIvfQW9N7XRBT
	 eMkxw0pwjPZJt1nFhiIkQ9TJQnX3JXyiSQI46oYQ2bfP/ESg+zymmdYQIHpUceU/Bc1GD
	 nQLd/TaciM98+hfeY3jiJ4NVvvIcpsdXMXZVQpeCUwR+DPtt4yOL0Rkkfjt92umJSse/r
	 16rnatNgZfnxWw6wkJISUHq5vvOclY2Dh4YAjd8ZLrPLVcnRGWZ/Nom42iKcOsTf4/a2c
	 6Kjgr7ZPpGkkwfxQiuJh3Yf6lFncruiR+p6nCeCOMAHxtEmmKEATU/E/uQDHjJLRC/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DmWp5NoR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E428606A321
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 05:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DmWp5NoR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A3C1F000C4;
	Fri, 13 Nov 2026 05:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794546918;
	bh=PNVt6yu1ICPwL0RcI+uaDmi+oPPSh1bc1+NxVxSgaHM=;
	h=Date:To:From:Subject;
	b=DmWp5NoRNOWyD3MDI9py7EEFJIco33RajJVPMPvC0R0g6O7wBEJXTLUKxWShEDxuP
	 6hMfWHHkAJXoK2SIia6uKAmMAouJFJt3s4uY82Kg+ovir60l+k7m5tXyiPOmPGoKIr
	 NBdmOg1HwU5IojncoGQ9tmq8LspmIVtVyZ+7EjlQ=
Date: Thu, 12 Nov 2026 21:15:18 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ljs@kernel.org,
	david@kernel.org,chenxionggui@lanxincomputing.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-handle-implicit-read-permissions-in-madv_populate.patch added to mm-new branch
Message-Id: <20261113051518.A8A3C1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: handle implicit read permissions in madv_populate
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-handle-implicit-read-permissions-in-madv_populate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-handle-implicit-read-permissions-in-madv_populate.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Xionggui Chen <chenxionggui@lanxincomputing.com>
Subject: selftests/mm: handle implicit read permissions in madv_populate
Date: Thu, 12 Nov 2026 03:18:11 +0000

The madv_populate selftest assumes that mmap(PROT_WRITE) creates a VMA
without VM_READ and expects MADV_POPULATE_READ to fail with EINVAL.

On RISC-V, commit 6c7559f22b6f ("riscv/mm: ensure PROT_WRITE leads to
VM_READ | VM_WRITE") makes the kernel set VM_READ for mappings requested
with PROT_WRITE.  MADV_POPULATE_READ checks this VMA permission, so it
succeeds and the test fails incorrectly.  Whether the hardware can read a
writable PTE does not, by itself, determine the madvise() result.

Check the VMA permissions through /proc/self/maps and adjust the expected
result accordingly.

Add a PROT_NONE test to verify that MADV_POPULATE_READ still fails with
EINVAL for mappings without read permission.

On RISC-V with Linux 7.2.0, the original test fails 1 out of 16 tests,
while the updated test passes all 17 tests.

Link: https://lore.kernel.org/20261112031811.56500-1-evers_chen@163.com
Fixes: e5bfac53e310 ("selftests/vm: add test for MADV_POPULATE_(READ|WRITE)")
Signed-off-by: Xionggui Chen <chenxionggui@lanxincomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
---

 tools/testing/selftests/mm/madv_populate.c |   67 +++++++++++++++++--
 1 file changed, 63 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/madv_populate.c~selftests-mm-handle-implicit-read-permissions-in-madv_populate
+++ a/tools/testing/selftests/mm/madv_populate.c
@@ -69,10 +69,38 @@ static void test_prot_read(void)
 	munmap(addr, SIZE);
 }
 
+static int mapping_is_readable(void *addr)
+{
+	FILE *maps;
+	char line[256];
+	unsigned long start, end;
+	char perms[5];
+	int readable = -1;
+
+	maps = fopen("/proc/self/maps", "r");
+	if (!maps)
+		return -1;
+
+	while (fgets(line, sizeof(line), maps)) {
+		if (sscanf(line, "%lx-%lx %4s",
+			   &start, &end, perms) != 3)
+			continue;
+
+		if (start <= (unsigned long)addr &&
+		    (unsigned long)addr < end) {
+			readable = perms[0] == 'r';
+			break;
+		}
+	}
+
+	fclose(maps);
+	return readable;
+}
+
 static void test_prot_write(void)
 {
 	char *addr;
-	int ret;
+	int ret, readable;
 
 	ksft_print_msg("[RUN] %s\n", __func__);
 
@@ -80,9 +108,19 @@ static void test_prot_write(void)
 	if (addr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap failed\n");
 
+	readable = mapping_is_readable(addr);
+	if (readable < 0)
+		ksft_exit_fail_msg("Cannot determine VMA permissions\n");
+
+	errno = 0;
 	ret = madvise(addr, SIZE, MADV_POPULATE_READ);
-	ksft_test_result(ret == -1 && errno == EINVAL,
-			 "MADV_POPULATE_READ with PROT_WRITE\n");
+
+	if (readable)
+		ksft_test_result(ret == 0,
+				 "MADV_POPULATE_READ with readable PROT_WRITE mapping\n");
+	else
+		ksft_test_result(ret == -1 && errno == EINVAL,
+				 "MADV_POPULATE_READ with write-only mapping\n");
 
 	ret = madvise(addr, SIZE, MADV_POPULATE_WRITE);
 	ksft_test_result(!ret, "MADV_POPULATE_WRITE with PROT_WRITE\n");
@@ -90,6 +128,26 @@ static void test_prot_write(void)
 	munmap(addr, SIZE);
 }
 
+static void test_prot_none(void)
+{
+	char *addr;
+	int ret;
+
+	ksft_print_msg("[RUN] %s\n", __func__);
+
+	addr = mmap(0, SIZE, PROT_NONE,
+		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	errno = 0;
+	ret = madvise(addr, SIZE, MADV_POPULATE_READ);
+	ksft_test_result(ret == -1 && errno == EINVAL,
+			 "MADV_POPULATE_READ with PROT_NONE\n");
+
+	munmap(addr, SIZE);
+}
+
 static void test_holes(void)
 {
 	char *addr;
@@ -266,7 +324,7 @@ static void test_softdirty(void)
 
 int main(int argc, char **argv)
 {
-	int nr_tests = 16;
+	int nr_tests = 17;
 	int err;
 
 	pagesize = getpagesize();
@@ -280,6 +338,7 @@ int main(int argc, char **argv)
 	sense_support();
 	test_prot_read();
 	test_prot_write();
+	test_prot_none();
 	test_holes();
 	test_populate_read();
 	test_populate_write();
_

Patches currently in -mm which might be from chenxionggui@lanxincomputing.com are

selftests-mm-handle-implicit-read-permissions-in-madv_populate.patch

