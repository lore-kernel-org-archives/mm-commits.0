Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F44A2F2E
	for <mm-commits@vger.kernel.org>; Sun, 20 Apr 2025 23:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745191297; cv=none; b=OZFf/TCwKDxX0uwnTZZZtrIZEbe8po38Pkzr44uEbNX5C6P7U19jMY5m0B17mmhkABZZ98iXwt7KEVmo9HQ0wRacidp+aefNhvqEnOgytU/7z9PF+mioL+ilK+vHkMaqgaWLD98DEYmIX5ezWbXk2L2GyBIiVSCubWhLjLHlgjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745191297; c=relaxed/simple;
	bh=4hQl6KYg5CVAbmtB1iDQCPzcN6WorTXOYVAmezKRM7Q=;
	h=Date:To:From:Subject:Message-Id; b=useAsqaIJToDMrdiTOWOxbqJXRB9CHooDALnOFvYqBUxwE6O3jApqiXDr7W+pUu3NxoWLMPkGq/B2tIK7dRgP6XLGM4mjnCe2IuCX2dxJRp+iVFYxXGPjS0VctMuOsWpzVxgahbLoTSFi6akrkv32HC2ZAm2nThBYjIkRI/VNug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kjZN26vb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kjZN26vb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B7AC4CEE2;
	Sun, 20 Apr 2025 23:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745191297;
	bh=4hQl6KYg5CVAbmtB1iDQCPzcN6WorTXOYVAmezKRM7Q=;
	h=Date:To:From:Subject:From;
	b=kjZN26vb+oa7tcuCj4xG9+DLi1qzytFFaWJWxBs9wYghdzG+Xqg9fdfuVESXny3WK
	 yIMODLVrByRM6VIfnJQtNPtfKC2By1Y5F8Pdb13+AM0DveA3Y1EKjTPjZGznzWJReU
	 8Q4tSn/ZdE/JUB7MzG4IwbFoHgwnP/Q3hwfGk9m4=
Date: Sun, 20 Apr 2025 16:21:36 -0700
To: mm-commits@vger.kernel.org,samitolvanen@google.com,petr.pavlu@suse.com,nathan@kernel.org,mcgrof@kernel.org,da.gomez@samsung.com,herton@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_kmod-do-not-hardcode-depend-on-any-filesystem.patch added to mm-nonmm-unstable branch
Message-Id: <20250420232137.55B7AC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_kmod: do not hardcode/depend on any filesystem
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-test_kmod-do-not-hardcode-depend-on-any-filesystem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_kmod-do-not-hardcode-depend-on-any-filesystem.patch

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
From: "Herton R. Krzesinski" <herton@redhat.com>
Subject: lib/test_kmod: do not hardcode/depend on any filesystem
Date: Fri, 18 Apr 2025 13:50:47 -0300

Right now test_kmod has hardcoded dependencies on btrfs/xfs.  That is not
optimal since you end up needing to select/build them, but it is not
really required since other fs could be selected for the testing.  Also,
we can't change the default/driver module used for testing on
initialization.

Thus make it more generic: introduce two module parameters (start_driver
and start_test_fs), which allow to select which modules/fs to use for the
testing on test_kmod initialization.  Then it's up to the user to select
which modules/fs to use for testing based on his config.  However, keep
test_module as required default.

This way, config/modules becomes selectable as when the testing is done
from selftests (userspace).

While at it, also change trigger_config_run_type, since at module
initialization we already set the defaults at __kmod_config_init and
should not need to do it again in test_kmod_init(), thus we can avoid to
again set test_driver/test_fs.

Link: https://lkml.kernel.org/r/20250418165047.702487-1-herton@redhat.com
Signed-off-by: Herton R. Krzesinski <herton@redhat.com>
Reviewed-by: Luis Chambelrain <mcgrof@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug                   |    6 --
 lib/test_kmod.c                     |   64 +++++++++++++-------------
 tools/testing/selftests/kmod/config |    5 --
 3 files changed, 34 insertions(+), 41 deletions(-)

--- a/lib/Kconfig.debug~lib-test_kmod-do-not-hardcode-depend-on-any-filesystem
+++ a/lib/Kconfig.debug
@@ -2982,13 +2982,7 @@ config TEST_DYNAMIC_DEBUG
 config TEST_KMOD
 	tristate "kmod stress tester"
 	depends on m
-	depends on NETDEVICES && NET_CORE && INET # for TUN
-	depends on BLOCK
-	depends on PAGE_SIZE_LESS_THAN_256KB # for BTRFS
 	select TEST_LKM
-	select XFS_FS
-	select TUN
-	select BTRFS_FS
 	help
 	  Test the kernel's module loading mechanism: kmod. kmod implements
 	  support to load modules using the Linux kernel's usermode helper.
--- a/lib/test_kmod.c~lib-test_kmod-do-not-hardcode-depend-on-any-filesystem
+++ a/lib/test_kmod.c
@@ -28,14 +28,20 @@
 
 #define TEST_START_NUM_THREADS	50
 #define TEST_START_DRIVER	"test_module"
-#define TEST_START_TEST_FS	"xfs"
 #define TEST_START_TEST_CASE	TEST_KMOD_DRIVER
 
-
 static bool force_init_test = false;
-module_param(force_init_test, bool_enable_only, 0644);
+module_param(force_init_test, bool_enable_only, 0444);
 MODULE_PARM_DESC(force_init_test,
 		 "Force kicking a test immediately after driver loads");
+static char *start_driver;
+module_param(start_driver, charp, 0444);
+MODULE_PARM_DESC(start_driver,
+		 "Module/driver to use for the testing after driver loads");
+static char *start_test_fs;
+module_param(start_test_fs, charp, 0444);
+MODULE_PARM_DESC(start_test_fs,
+		 "File system to use for the testing after driver loads");
 
 /*
  * For device allocation / registration
@@ -508,6 +514,11 @@ static int __trigger_config_run(struct k
 	case TEST_KMOD_DRIVER:
 		return run_test_driver(test_dev);
 	case TEST_KMOD_FS_TYPE:
+		if (!config->test_fs) {
+			dev_warn(test_dev->dev,
+				 "No fs type specified, can't run the test\n");
+			return -EINVAL;
+		}
 		return run_test_fs_type(test_dev);
 	default:
 		dev_warn(test_dev->dev,
@@ -721,26 +732,20 @@ static ssize_t config_test_fs_show(struc
 static DEVICE_ATTR_RW(config_test_fs);
 
 static int trigger_config_run_type(struct kmod_test_device *test_dev,
-				   enum kmod_test_case test_case,
-				   const char *test_str)
+				   enum kmod_test_case test_case)
 {
-	int copied = 0;
 	struct test_config *config = &test_dev->config;
 
 	mutex_lock(&test_dev->config_mutex);
 
 	switch (test_case) {
 	case TEST_KMOD_DRIVER:
-		kfree_const(config->test_driver);
-		config->test_driver = NULL;
-		copied = config_copy_test_driver_name(config, test_str,
-						      strlen(test_str));
 		break;
 	case TEST_KMOD_FS_TYPE:
-		kfree_const(config->test_fs);
-		config->test_fs = NULL;
-		copied = config_copy_test_fs(config, test_str,
-					     strlen(test_str));
+		if (!config->test_fs) {
+			mutex_unlock(&test_dev->config_mutex);
+			return 0;
+		}
 		break;
 	default:
 		mutex_unlock(&test_dev->config_mutex);
@@ -751,11 +756,6 @@ static int trigger_config_run_type(struc
 
 	mutex_unlock(&test_dev->config_mutex);
 
-	if (copied <= 0 || copied != strlen(test_str)) {
-		test_dev->test_is_oom = true;
-		return -ENOMEM;
-	}
-
 	test_dev->test_is_oom = false;
 
 	return trigger_config_run(test_dev);
@@ -800,19 +800,24 @@ static unsigned int kmod_init_test_threa
 static int __kmod_config_init(struct kmod_test_device *test_dev)
 {
 	struct test_config *config = &test_dev->config;
+	const char *test_start_driver = start_driver ? start_driver :
+						       TEST_START_DRIVER;
 	int ret = -ENOMEM, copied;
 
 	__kmod_config_free(config);
 
-	copied = config_copy_test_driver_name(config, TEST_START_DRIVER,
-					      strlen(TEST_START_DRIVER));
-	if (copied != strlen(TEST_START_DRIVER))
+	copied = config_copy_test_driver_name(config, test_start_driver,
+					      strlen(test_start_driver));
+	if (copied != strlen(test_start_driver))
 		goto err_out;
 
-	copied = config_copy_test_fs(config, TEST_START_TEST_FS,
-				     strlen(TEST_START_TEST_FS));
-	if (copied != strlen(TEST_START_TEST_FS))
-		goto err_out;
+
+	if (start_test_fs) {
+		copied = config_copy_test_fs(config, start_test_fs,
+					     strlen(start_test_fs));
+		if (copied != strlen(start_test_fs))
+			goto err_out;
+	}
 
 	config->num_threads = kmod_init_test_thread_limit();
 	config->test_result = 0;
@@ -1178,12 +1183,11 @@ static int __init test_kmod_init(void)
 	 * lowering the init level for more fun.
 	 */
 	if (force_init_test) {
-		ret = trigger_config_run_type(test_dev,
-					      TEST_KMOD_DRIVER, "tun");
+		ret = trigger_config_run_type(test_dev, TEST_KMOD_DRIVER);
 		if (WARN_ON(ret))
 			return ret;
-		ret = trigger_config_run_type(test_dev,
-					      TEST_KMOD_FS_TYPE, "btrfs");
+
+		ret = trigger_config_run_type(test_dev, TEST_KMOD_FS_TYPE);
 		if (WARN_ON(ret))
 			return ret;
 	}
--- a/tools/testing/selftests/kmod/config~lib-test_kmod-do-not-hardcode-depend-on-any-filesystem
+++ a/tools/testing/selftests/kmod/config
@@ -1,7 +1,2 @@
 CONFIG_TEST_KMOD=m
 CONFIG_TEST_LKM=m
-CONFIG_XFS_FS=m
-
-# For the module parameter force_init_test is used
-CONFIG_TUN=m
-CONFIG_BTRFS_FS=m
_

Patches currently in -mm which might be from herton@redhat.com are

lib-test_kmod-do-not-hardcode-depend-on-any-filesystem.patch

