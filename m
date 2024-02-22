Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B67140392
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645214; cv=none; b=oZXDBd/1rSvufZR7tcNctlzO/dtWcQ/wmqx8wRd2gxRgAWPVNREr9WWoIApT9bdwpQ84BhiUaGfb13Q2Hcd2PsmNhL6pzHUO9+KRYSBVFnlFsljaDnMFTQ4tjpI+8SZogDxlfWo5nYVJ5+u3p42hh0XbQcDuWYc/+WcVGzf/5oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645214; c=relaxed/simple;
	bh=4pJ77n60wOV+Y4TewhvBkjUrfH3eGcObyDF+nI1XOdI=;
	h=Date:To:From:Subject:Message-Id; b=fyadDqGpXnCL1Fp+aH2sKsb7CUC62A7C1SHe75oAaY1eOyQT5+LL3MNbLe4UbKGTD1b0MoEXFC5gafAVyP/Ff0x8IwF5dTh3k2riE7K8hK/UpzC29uEU5leffMhzibvSUyvrorudbUXND6x7MHz0D/I75b92XUYIjveNMMF3nak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xrr3qVkx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xrr3qVkx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46973C433F1;
	Thu, 22 Feb 2024 23:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645214;
	bh=4pJ77n60wOV+Y4TewhvBkjUrfH3eGcObyDF+nI1XOdI=;
	h=Date:To:From:Subject:From;
	b=xrr3qVkxYXGhilOCDPUjE7KdtXg9o1qLQKwu/ZfVSlEmLLxA5T53+eIs3AjRKWR4l
	 WHLX9IspLPuMP9BwlIsSXve3mBz64z6+9UWF0six5JDb2A2vNwPbN5uaCYW/RjFw+H
	 zoxvrIofNJTLdb4Z4Jzgp1ARSkg0h/rAiox5f3Ik=
Date: Thu, 22 Feb 2024 15:40:13 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch removed from -mm tree
Message-Id: <20240222234014.46973C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: protection_keys: save/restore nr_hugepages settings
has been removed from the -mm tree.  Its filename was
     selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


