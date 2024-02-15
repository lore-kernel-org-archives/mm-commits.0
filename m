Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0121A4A15
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 05:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707973372; cv=none; b=SubPILZlbrtRvIcvPXDC73nyApV2LWM6ZWdA1mbPlxh43CljdSHlaQ1aCl7FaEYip8dm2yW00c9oEgus6/kMQlsSiTySPuibAqu1woHAOxbItWH+xziaqZ66aFm85fSO+3mMEu/kjPYTic8vN8annLli4BS85Im1a4CHMRNPmP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707973372; c=relaxed/simple;
	bh=V0+HfvA0gdu9K8anBJcUlBaaERZ14n/QW9qScs8gpdQ=;
	h=Date:To:From:Subject:Message-Id; b=R6KefWtwfKVh20L2W1YEyN2q03SD+LVZt2jxty4PL+bgA3CP6illVCR/esrWqj0ufG16GAIo3dggMlvYtA8frWMPYHMb+XuS+aXr6WRxDs8BTfY2TTpOl37kzfCGR05bYigGvdmxblSYyE8Rxp5PkkrE5Us3Oj5CGORgem7GfaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DpiPEztw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DpiPEztw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B75C433C7;
	Thu, 15 Feb 2024 05:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707973371;
	bh=V0+HfvA0gdu9K8anBJcUlBaaERZ14n/QW9qScs8gpdQ=;
	h=Date:To:From:Subject:From;
	b=DpiPEztwq4uocizhciODncjRJ9XbQkUflI9ttmHNH3BpaDavHEkjzjJoyqRoUWI1O
	 PVUhJfNNtBM/rvWWu+OvjdY/ikHEs1TliWM3f1JwQ6xw479338ueqcsRFApPgE8q6b
	 H9E9babQgsMjOV/SqzQmQbNy/ZhsXt9cce+NXZ4U=
Date: Wed, 14 Feb 2024 21:02:50 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] selftests-mm-thp_settings-conform-to-tap-format-output.patch removed from -mm tree
Message-Id: <20240215050251.57B75C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: thp_settings: conform to TAP format output
has been removed from the -mm tree.  Its filename was
     selftests-mm-thp_settings-conform-to-tap-format-output.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: thp_settings: conform to TAP format output
Date: Fri, 2 Feb 2024 16:31:16 +0500

Conform the layout, informational and status messages to TAP.  No
functional change is intended other than the layout of output messages.

Link: https://lkml.kernel.org/r/20240202113119.2047740-10-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c   |    5 
 tools/testing/selftests/mm/thp_settings.c |  123 +++++++-------------
 tools/testing/selftests/mm/thp_settings.h |    4 
 3 files changed, 47 insertions(+), 85 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-thp_settings-conform-to-tap-format-output
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -159,10 +159,7 @@ static void get_finfo(const char *dir)
 		printf("%s: Pathname is too long\n", __func__);
 		exit(EXIT_FAILURE);
 	}
-	if (read_file(path, buf, sizeof(buf)) < 0) {
-		perror("read_file(read_num)");
-		exit(EXIT_FAILURE);
-	}
+	read_file(path, buf, sizeof(buf));
 	if (strstr(buf, "DEVTYPE=disk")) {
 		/* Found it */
 		if (snprintf(finfo.dev_queue_read_ahead_path,
--- a/tools/testing/selftests/mm/thp_settings.c~selftests-mm-thp_settings-conform-to-tap-format-output
+++ a/tools/testing/selftests/mm/thp_settings.c
@@ -5,7 +5,9 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include <errno.h>
 
+#include "../kselftest.h"
 #include "thp_settings.h"
 
 #define THP_SYSFS "/sys/kernel/mm/transparent_hugepage/"
@@ -42,58 +44,45 @@ static const char * const shmem_enabled_
 	NULL
 };
 
-int read_file(const char *path, char *buf, size_t buflen)
+void read_file(const char *path, char *buf, size_t buflen)
 {
 	int fd;
 	ssize_t numread;
 
 	fd = open(path, O_RDONLY);
 	if (fd == -1)
-		return 0;
+		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
 
 	numread = read(fd, buf, buflen - 1);
 	if (numread < 1) {
 		close(fd);
-		return 0;
+		ksft_exit_fail_msg("No data read\n");
 	}
 
 	buf[numread] = '\0';
 	close(fd);
-
-	return (unsigned int) numread;
 }
 
-int write_file(const char *path, const char *buf, size_t buflen)
+void write_file(const char *path, const char *buf, size_t buflen)
 {
 	int fd;
 	ssize_t numwritten;
 
 	fd = open(path, O_WRONLY);
-	if (fd == -1) {
-		printf("open(%s)\n", path);
-		exit(EXIT_FAILURE);
-		return 0;
-	}
+	if (fd == -1)
+		ksft_exit_fail_msg("%s open failed\n", path);
 
 	numwritten = write(fd, buf, buflen - 1);
 	close(fd);
-	if (numwritten < 1) {
-		printf("write(%s)\n", buf);
-		exit(EXIT_FAILURE);
-		return 0;
-	}
-
-	return (unsigned int) numwritten;
+	if (numwritten < 1)
+		ksft_exit_fail_msg("write failed (%s)\n", buf);
 }
 
 const unsigned long read_num(const char *path)
 {
 	char buf[21];
 
-	if (read_file(path, buf, sizeof(buf)) < 0) {
-		perror("read_file()");
-		exit(EXIT_FAILURE);
-	}
+	read_file(path, buf, sizeof(buf));
 
 	return strtoul(buf, NULL, 10);
 }
@@ -103,10 +92,7 @@ void write_num(const char *path, unsigne
 	char buf[21];
 
 	sprintf(buf, "%ld", num);
-	if (!write_file(path, buf, strlen(buf) + 1)) {
-		perror(path);
-		exit(EXIT_FAILURE);
-	}
+	write_file(path, buf, strlen(buf) + 1);
 }
 
 int thp_read_string(const char *name, const char * const strings[])
@@ -117,30 +103,22 @@ int thp_read_string(const char *name, co
 	int ret;
 
 	ret = snprintf(path, PATH_MAX, THP_SYSFS "%s", name);
-	if (ret >= PATH_MAX) {
-		printf("%s: Pathname is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
+	if (ret >= PATH_MAX)
+		ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
 
-	if (!read_file(path, buf, sizeof(buf))) {
-		perror(path);
-		exit(EXIT_FAILURE);
-	}
+	read_file(path, buf, sizeof(buf));
 
 	c = strchr(buf, '[');
-	if (!c) {
-		printf("%s: Parse failure\n", __func__);
-		exit(EXIT_FAILURE);
-	}
+	if (!c)
+		ksft_exit_fail_msg("%s: Parse failure\n", __func__);
 
 	c++;
 	memmove(buf, c, sizeof(buf) - (c - buf));
 
 	c = strchr(buf, ']');
-	if (!c) {
-		printf("%s: Parse failure\n", __func__);
-		exit(EXIT_FAILURE);
-	}
+	if (!c)
+		ksft_exit_fail_msg("%s: Parse failure\n", __func__);
+
 	*c = '\0';
 
 	ret = 0;
@@ -150,8 +128,8 @@ int thp_read_string(const char *name, co
 		ret++;
 	}
 
-	printf("Failed to parse %s\n", name);
-	exit(EXIT_FAILURE);
+	ksft_exit_fail_msg("Failed to parse %s\n", name);
+	return -1;
 }
 
 void thp_write_string(const char *name, const char *val)
@@ -160,15 +138,10 @@ void thp_write_string(const char *name,
 	int ret;
 
 	ret = snprintf(path, PATH_MAX, THP_SYSFS "%s", name);
-	if (ret >= PATH_MAX) {
-		printf("%s: Pathname is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
+	if (ret >= PATH_MAX)
+		ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
 
-	if (!write_file(path, val, strlen(val) + 1)) {
-		perror(path);
-		exit(EXIT_FAILURE);
-	}
+	write_file(path, val, strlen(val) + 1);
 }
 
 const unsigned long thp_read_num(const char *name)
@@ -177,10 +150,9 @@ const unsigned long thp_read_num(const c
 	int ret;
 
 	ret = snprintf(path, PATH_MAX, THP_SYSFS "%s", name);
-	if (ret >= PATH_MAX) {
-		printf("%s: Pathname is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
+	if (ret >= PATH_MAX)
+		ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
+
 	return read_num(path);
 }
 
@@ -190,10 +162,9 @@ void thp_write_num(const char *name, uns
 	int ret;
 
 	ret = snprintf(path, PATH_MAX, THP_SYSFS "%s", name);
-	if (ret >= PATH_MAX) {
-		printf("%s: Pathname is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
+	if (ret >= PATH_MAX)
+		ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
+
 	write_num(path, num);
 }
 
@@ -275,29 +246,26 @@ void thp_write_settings(struct thp_setti
 
 struct thp_settings *thp_current_settings(void)
 {
-	if (!settings_index) {
-		printf("Fail: No settings set");
-		exit(EXIT_FAILURE);
-	}
+	if (!settings_index)
+		ksft_exit_fail_msg("Fail: No settings set\n");
+
 	return settings_stack + settings_index - 1;
 }
 
 void thp_push_settings(struct thp_settings *settings)
 {
-	if (settings_index >= MAX_SETTINGS_DEPTH) {
-		printf("Fail: Settings stack exceeded");
-		exit(EXIT_FAILURE);
-	}
+	if (settings_index >= MAX_SETTINGS_DEPTH)
+		ksft_exit_fail_msg("Fail: Settings stack exceeded\n");
+
 	settings_stack[settings_index++] = *settings;
 	thp_write_settings(thp_current_settings());
 }
 
 void thp_pop_settings(void)
 {
-	if (settings_index <= 0) {
-		printf("Fail: Settings stack empty");
-		exit(EXIT_FAILURE);
-	}
+	if (settings_index <= 0)
+		ksft_exit_fail_msg("Fail: Settings stack empty\n");
+
 	--settings_index;
 	thp_write_settings(thp_current_settings());
 }
@@ -335,14 +303,11 @@ unsigned long thp_supported_orders(void)
 	for (i = 0; i < NR_ORDERS; i++) {
 		ret = snprintf(path, PATH_MAX, THP_SYSFS "hugepages-%ukB/enabled",
 			(getpagesize() >> 10) << i);
-		if (ret >= PATH_MAX) {
-			printf("%s: Pathname is too long\n", __func__);
-			exit(EXIT_FAILURE);
-		}
+		if (ret >= PATH_MAX)
+			ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
 
-		ret = read_file(path, buf, sizeof(buf));
-		if (ret)
-			orders |= 1UL << i;
+		read_file(path, buf, sizeof(buf));
+		orders |= 1UL << i;
 	}
 
 	return orders;
--- a/tools/testing/selftests/mm/thp_settings.h~selftests-mm-thp_settings-conform-to-tap-format-output
+++ a/tools/testing/selftests/mm/thp_settings.h
@@ -56,8 +56,8 @@ struct thp_settings {
 	struct hugepages_settings hugepages[NR_ORDERS];
 };
 
-int read_file(const char *path, char *buf, size_t buflen);
-int write_file(const char *path, const char *buf, size_t buflen);
+void read_file(const char *path, char *buf, size_t buflen);
+void write_file(const char *path, const char *buf, size_t buflen);
 const unsigned long read_num(const char *path);
 void write_num(const char *path, unsigned long num);
 
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-map_fixed_noreplace-conform-test-to-tap-format-output.patch
selftests-mm-map_hugetlb-conform-test-to-tap-format-output.patch
selftests-mm-map_populate-conform-test-to-tap-format-output.patch
selftests-mm-mlock-random-test-conform-test-to-tap-format-output.patch
selftests-mm-mlock2-tests-conform-test-to-tap-format-output.patch
selftests-mm-mrelease_test-conform-test-to-tap-format-output.patch
selftests-mm-mremap_dontunmap-conform-test-to-tap-format-output.patch
selftests-mm-split_huge_page_test-conform-test-to-tap-format-output.patch
selftests-mm-thuge-gen-conform-to-tap-format-output.patch
selftests-mm-transhuge-stress-conform-to-tap-format-output.patch
selftests-mm-virtual_address_range-conform-to-tap-format-output.patch
selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap-fix.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch
selftests-mm-run_vmtestssh-add-missing-tests-fix.patch

