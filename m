Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AAE10A3B
	for <mm-commits@vger.kernel.org>; Fri, 19 Apr 2024 21:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713560785; cv=none; b=lcEpqEwFpzn4PIonBwBb+B5pbAGa+afu+PzrAA798eqv/pJsHTr/7YWa9s6I/7sCpzMoT7FtuJAJVApuPcq049VBQA93trKZIfJBODxGwjGfBctPh+WGkNPKiKdrd/pckM6XOngQDxPJx9Rl20QMnOkyjprzfr2M2GaFuHmFOWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713560785; c=relaxed/simple;
	bh=VWNvoVTFlu3tROCNri7xEgFSGKVQ+rLu3Ow1jWIKuVg=;
	h=Date:To:From:Subject:Message-Id; b=X7WyxKCEbDnLX8TvMWctFu/HnC4GQJeKyxDRjJHcFhns0mfBTl46DkeuE8S3Lb3Pdt+QZ75SSNFMnExdnHdpj7ECVFiZIIqX8e4ross2NnJSbWPjEl56fwo9M6vunrcsA3UNXSRSoQT9bTefXSXNqbFQjpkly118oSPXm5RUlMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WrHyFYtq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WrHyFYtq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957DCC072AA;
	Fri, 19 Apr 2024 21:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713560783;
	bh=VWNvoVTFlu3tROCNri7xEgFSGKVQ+rLu3Ow1jWIKuVg=;
	h=Date:To:From:Subject:From;
	b=WrHyFYtqZlSUoxEZ13c328gV49VPVsir+TfjghQD9zPf1HqobMbz5aJ7BJLlN4Qgi
	 VyBlHLFD5KbguSXf13YsD0qj2tje2ZThbxVXPzc2xbpwf1788biw2gH/jEcoXx93uE
	 64Q9wN6D2EH6QxA0dBBpDPz6jRfT2QnSEhMjb9wo=
Date: Fri, 19 Apr 2024 14:06:22 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,joey.gouly@arm.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-protection_keys-save-restore-nr_hugepages-value-from-launch-script.patch added to mm-hotfixes-unstable branch
Message-Id: <20240419210623.957DCC072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: mm: protection_keys: save/restore nr_hugepages value from launch script
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-protection_keys-save-restore-nr_hugepages-value-from-launch-script.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-protection_keys-save-restore-nr_hugepages-value-from-launch-script.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

selftests-harness-remove-use-of-line_max-fix-fix-fix.patch
selftests-mm-fix-unused-and-uninitialized-variable-warning.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-value-from-launch-script.patch
selftests-exec-make-binaries-position-independent.patch

