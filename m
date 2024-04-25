Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14249171D8
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 02:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714012527; cv=none; b=DIybFf1uXSjc+pfNA6rknMvK6xWbU9XSuuHUCJgd1y6U6pL81zdv37ZQjHblcucHyPcBLf6H+IXxFgMds0fEgpDakLqTu5VTXXps3vEX8MCkHGBVUJ0kNr7JAnrsK3Uw+uBGxl4kpfmGoGoyhUm317SW2Lik1OWvZr3i+MxKO78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714012527; c=relaxed/simple;
	bh=M9t/X3GyQR0FOa5Rbh4RxicY96j0WU7EY4xTribNCUA=;
	h=Date:To:From:Subject:Message-Id; b=U8IRILeTspN2derlvkBf0dL8oKY4jryEw1qJYJW8dbG4obAy0DB0gKs0saPSwi4g9JtxGl61hv9LVHtPMW/TLAU7p3W4GeuNFrg4Nissua1M7dy54lZML94IPOM5PkJWZ+8Btm0HCde4j5eOje7pjyuvHQRtSFnzmv0RfDtFpus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gN+hsl6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gN+hsl6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31B5C2BD10;
	Thu, 25 Apr 2024 02:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714012526;
	bh=M9t/X3GyQR0FOa5Rbh4RxicY96j0WU7EY4xTribNCUA=;
	h=Date:To:From:Subject:From;
	b=gN+hsl6fxGn2C/MVSSeBiUTpEtlPUbNaYpw13Z/mrKHBMmOoDUEC5qdM1hw6Ja8XA
	 3JJSeCSbOxqU9grttPkOGwjzXmfsOLIJNgJ43U8R9n+C9ooUmzInk3e/gZ/9cgRoeQ
	 qFuAuuq0RiwzaoflmyU7j4eBJTUgmKHRqWEYVS98=
Date: Wed, 24 Apr 2024 19:35:26 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,joey.gouly@arm.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-protection_keys-save-restore-nr_hugepages-value-from-launch-script.patch removed from -mm tree
Message-Id: <20240425023526.D31B5C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: mm: protection_keys: save/restore nr_hugepages value from launch script
has been removed from the -mm tree.  Its filename was
     selftests-mm-protection_keys-save-restore-nr_hugepages-value-from-launch-script.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: mm: protection_keys: save/restore nr_hugepages value from launch script
Date: Fri, 19 Apr 2024 16:50:27 +0500

The save/restore of nr_hugepages was added to the test itself by using the
atexit() functionality.  But it is broken as parent exits after creating
child.  Hence calling the atexit() function early.  That's not it.  The
child exits after creating its child and so on.

The parent cannot wait to get the termination status for its children as
it'll keep on holding the resources until the new pkey allocation fails. 
It is impossible to wait for exits of all the grand and great grand
children.  Hence the restoring of nr_hugepages value from parent is wrong.

Let's save/restore the nr_hugepages settings in the launch script
instead of doing it in the test.

Link: https://lkml.kernel.org/r/20240419115027.3848958-1-usama.anjum@collabora.com
Fixes: c52eb6db7b7d ("selftests: mm: restore settings from only parent process")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reported-by: Joey Gouly <joey.gouly@arm.com>
Closes: https://lore.kernel.org/all/20240418125250.GA2941398@e124191.cambridge.arm.com
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/protection_keys.c |   38 -----------------
 tools/testing/selftests/mm/run_vmtests.sh    |    2 
 2 files changed, 2 insertions(+), 38 deletions(-)

--- a/tools/testing/selftests/mm/protection_keys.c~selftests-mm-protection_keys-save-restore-nr_hugepages-value-from-launch-script
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -54,7 +54,6 @@ int test_nr;
 u64 shadow_pkey_reg;
 int dprint_in_signal;
 char dprint_in_signal_buffer[DPRINT_IN_SIGNAL_BUF_SIZE];
-char buf[256];
 
 void cat_into_file(char *str, char *file)
 {
@@ -1745,42 +1744,6 @@ void pkey_setup_shadow(void)
 	shadow_pkey_reg = __read_pkey_reg();
 }
 
-pid_t parent_pid;
-
-void restore_settings_atexit(void)
-{
-	if (parent_pid == getpid())
-		cat_into_file(buf, "/proc/sys/vm/nr_hugepages");
-}
-
-void save_settings(void)
-{
-	int fd;
-	int err;
-
-	if (geteuid())
-		return;
-
-	fd = open("/proc/sys/vm/nr_hugepages", O_RDONLY);
-	if (fd < 0) {
-		fprintf(stderr, "error opening\n");
-		perror("error: ");
-		exit(__LINE__);
-	}
-
-	/* -1 to guarantee leaving the trailing \0 */
-	err = read(fd, buf, sizeof(buf)-1);
-	if (err < 0) {
-		fprintf(stderr, "error reading\n");
-		perror("error: ");
-		exit(__LINE__);
-	}
-
-	parent_pid = getpid();
-	atexit(restore_settings_atexit);
-	close(fd);
-}
-
 int main(void)
 {
 	int nr_iterations = 22;
@@ -1788,7 +1751,6 @@ int main(void)
 
 	srand((unsigned int)time(NULL));
 
-	save_settings();
 	setup_handlers();
 
 	printf("has pkeys: %d\n", pkeys_supported);
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-protection_keys-save-restore-nr_hugepages-value-from-launch-script
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -385,6 +385,7 @@ CATEGORY="ksm_numa" run_test ./ksm_tests
 CATEGORY="ksm" run_test ./ksm_functional_tests
 
 # protection_keys tests
+nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
 if [ -x ./protection_keys_32 ]
 then
 	CATEGORY="pkey" run_test ./protection_keys_32
@@ -394,6 +395,7 @@ if [ -x ./protection_keys_64 ]
 then
 	CATEGORY="pkey" run_test ./protection_keys_64
 fi
+echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
 
 if [ -x ./soft-dirty ]
 then
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-exec-make-binaries-position-independent.patch

