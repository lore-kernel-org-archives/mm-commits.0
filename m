Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794972792;
	b=FwP2y7hw1hg9ZifQ8QpGz/n7QIHkFxfB6vDfa3E60K1B8gaHVblUCV2Uiz9gjzub5tVL
	 6fwUSBrTnK3UGSjkSyxRQ5FSewrA6qo0xVGFMSKl7vAn7bX4FMoYXPK8hJOCcroNacYsG
	 VTbjz0F+BVkusFV4SkjlF6pVIqA/JtojOYuXzGlqGKi1j+KjMbkGzMctxn/IVCzjHvQ3w
	 5dgNucyP1va5Af+YbajtRvIujJsVnPI6wSmQYiApzXexzeADx2jDxmtlgcP3jbFeIACw+
	 p7jyC4h0lDjFWY1ncGzuK8L7AVLjp4lifUuG2FBj2rCnNu4ZCAlJabsXJmSmu5KhZcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794972792;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=E92wKEq+mCMAHQm+Ui7JELiqJSKkIxVJOwNhuqI4Gjk=;
	b=rwfA7i7pftUyak96Ir2VNCZDg4GPYR2LpeJv8VJdE1AY8SNgROZfpmFf5p/f/RTHAIX+
	 zUcgiDxogdkEafPGeBw0K+o2NKjw7tnXQIQeuomx314JkUtrLvkpjpmGKxcXaQBaRtPKa
	 X/vsQqaE1M1KTBnmmQeoEnazzxOq2KnUH8dz81pqdGBJbxGl71tSCRjqKWzkco9E2YvY5
	 HlgaT5Xv+87gHjp3j09pDqjwIJkYXQ1aJgeP8y1TyLUr9KEzeOcMm5VYt4GyiErLiBePW
	 nS2+jHt0+YQgXaZTIhXgxMcojnow+x/bLaMwLq0f/jdpOTp67nw68x/gPatt1o5/D9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nkbhWljd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DC7606A31C
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 03:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nkbhWljd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A331F000C6;
	Wed, 18 Nov 2026 03:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794972791;
	bh=E92wKEq+mCMAHQm+Ui7JELiqJSKkIxVJOwNhuqI4Gjk=;
	h=Date:To:From:Subject;
	b=nkbhWljdN+qpkZEmYZls8gHa4K5gCcl5AYo2wDzVNLc9JR+0AoKIt3qDRdKcbFW4H
	 cPA5efQazOmeWr09vrvfZRl97/W0QVusfaCkUm0iUdymq33F+To7X9m98qRwu7/IaL
	 voTrA6GQS3J/6jn+t12aabTDRTc+2mDSiYalKW0U=
Date: Tue, 17 Nov 2026 19:33:11 -0800
To: mm-commits@vger.kernel.org,chenxionggui@lanxincomputing.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-handle-implicit-read-permissions-in-madv_populate.patch removed from -mm tree
Message-Id: <20261118033311.96A331F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: selftests/mm: handle implicit read permissions in madv_populate
has been removed from the -mm tree.  Its filename was
     selftests-mm-handle-implicit-read-permissions-in-madv_populate.patch

This patch was dropped because an updated version will be issued

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


