Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E979A524F
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235359; cv=none; b=ui77YstSw+UqdjFVXcmmZj97c1yg9m3FiUkYu+0AzKg0MXfam2UAhfS4p/DjmQLpdNljth6wepF7jgAQTp1L4LD3rHSvSi808aPEXAzLrsAOemxlda+DIWuyQ1eic9wISXiCCEkzz05gZzNzvQmw4XJaaOGqLZX71oRXvUxuzEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235359; c=relaxed/simple;
	bh=rt18WZ/ZPTeI4zepxen2viYCQUuNa6auVwacDKpSXeM=;
	h=Date:To:From:Subject:Message-Id; b=cTbJWUtfZl+3pOAWcfhIwNvQ8Xagdt9Jqh5+iGwkWAMjWwunAdEDAjzdNr1kGdImkYTppuaqO+I2F1UChXXz87lj0AaiiqxogLsVPazWYXZHIp90ZkqhKSI/WFSqZQTh+a8+8cj/q9wo+PGcKKZD4ZZdK6YGAjbJ43ryeS+ju/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dx6er1R1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dx6er1R1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD317C433C7;
	Fri, 26 Jan 2024 02:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235358;
	bh=rt18WZ/ZPTeI4zepxen2viYCQUuNa6auVwacDKpSXeM=;
	h=Date:To:From:Subject:From;
	b=Dx6er1R1mChf6c/koVui8kZWAiLakd+cIoXymlFWgqYiecginhBjXKysCp6b3gc5j
	 x0lJ9B/ZWH6L+vO6FzTti0whw5kZoF5kMHLJurK4B8YvHsVnU1Bng4M2jg8pN+LbVs
	 TS684g5H8R7w6BseNo08e6bYJMfaFDxOhg9aPSpM=
Date: Thu, 25 Jan 2024 18:15:54 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch added to mm-nonmm-unstable branch
Message-Id: <20240126021557.DD317C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: protection_keys: save/restore nr_hugepages settings
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: selftests/mm: protection_keys: save/restore nr_hugepages settings
Date: Thu, 25 Jan 2024 20:46:07 +0500

Save and restore nr_hugepages before changing it during the test.  A test
should not change system wide settings.

Link: https://lkml.kernel.org/r/20240125154608.720072-5-usama.anjum@collabora.com
Fixes: 5f23f6d082a9 ("x86/pkeys: Add self-tests")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/protection_keys.c |   34 +++++++++++++++++
 1 file changed, 34 insertions(+)

--- a/tools/testing/selftests/mm/protection_keys.c~selftests-mm-protection_keys-save-restore-nr_hugepages-settings
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -54,6 +54,7 @@ int test_nr;
 u64 shadow_pkey_reg;
 int dprint_in_signal;
 char dprint_in_signal_buffer[DPRINT_IN_SIGNAL_BUF_SIZE];
+char buf[256];
 
 void cat_into_file(char *str, char *file)
 {
@@ -1744,6 +1745,38 @@ void pkey_setup_shadow(void)
 	shadow_pkey_reg = __read_pkey_reg();
 }
 
+void restore_settings_atexit(void)
+{
+	cat_into_file(buf, "/proc/sys/vm/nr_hugepages");
+}
+
+void save_settings(void)
+{
+	int fd;
+	int err;
+
+	if (geteuid())
+		return;
+
+	fd = open("/proc/sys/vm/nr_hugepages", O_RDONLY);
+	if (fd < 0) {
+		fprintf(stderr, "error opening\n");
+		perror("error: ");
+		exit(__LINE__);
+	}
+
+	/* -1 to guarantee leaving the trailing \0 */
+	err = read(fd, buf, sizeof(buf)-1);
+	if (err < 0) {
+		fprintf(stderr, "error reading\n");
+		perror("error: ");
+		exit(__LINE__);
+	}
+
+	atexit(restore_settings_atexit);
+	close(fd);
+}
+
 int main(void)
 {
 	int nr_iterations = 22;
@@ -1751,6 +1784,7 @@ int main(void)
 
 	srand((unsigned int)time(NULL));
 
+	save_settings();
 	setup_handlers();
 
 	printf("has pkeys: %d\n", pkeys_supported);
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-mremap_test-fix-build-warning.patch
selftests-mm-switch-to-bash-from-sh.patch
selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch

