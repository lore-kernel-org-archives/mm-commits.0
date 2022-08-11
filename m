Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB9CFC25B07
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 00:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbiHKAmq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Aug 2022 20:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232964AbiHKAmp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2022 20:42:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3112844CB
        for <mm-commits@vger.kernel.org>; Wed, 10 Aug 2022 17:42:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EF71610AA
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 00:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B80C433D7;
        Thu, 11 Aug 2022 00:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660178563;
        bh=J0fSgxG1Nn1Vardcnoc4vmXheQdwaiDzmhYuDE3BPJ4=;
        h=Date:To:From:Subject:From;
        b=BgzaQHCu3czTC2cgd+7xAsejvFfAtOdNotSrcghBNs7aVpHRS0uWS6shmvrtqBnwE
         CfLGir8PcxJWT5kcx4ppjh/YAGf71abHJtfHaXlvDa5H8MHQL2kg+Sycww3J2texks
         DMBFGBEp7dQSewBmqtvt75gwlbYyoa6z+ny+buJY=
Date:   Wed, 10 Aug 2022 17:42:43 -0700
To:     mm-commits@vger.kernel.org, yi.zhang@huawei.com,
        viro@zeniv.linux.org.uk, vbabka@suse.cz, surenb@google.com,
        skhan@linuxfoundation.org, shuah@kernel.org, rppt@kernel.org,
        peterx@redhat.com, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, ldv@altlinux.org, jack@suse.cz,
        hughd@google.com, glebfm@altlinux.org, dave.hansen@linux.intel.com,
        corbet@lwn.net, axelrasmussen@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd.patch added to mm-unstable branch
Message-Id: <20220811004243.D2B80C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: selftests: modify selftest to use /dev/userfaultfd
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd.patch

This patch will later appear in the mm-unstable branch at
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
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd: selftests: modify selftest to use /dev/userfaultfd
Date: Mon, 8 Aug 2022 10:56:12 -0700

We clearly want to ensure both userfaultfd(2) and /dev/userfaultfd keep
working into the future, so just run the test twice, using each interface.

Instead of always testing both userfaultfd(2) and /dev/userfaultfd, let
the user choose which to test.

As with other test features, change the behavior based on a new command
line flag.  Introduce the idea of "test mods", which are generic (not
specific to a test type) modifications to the behavior of the test.  This
is sort of borrowed from this RFC patch series [1], but simplified a bit.

The benefit is, in "typical" configurations this test is somewhat slow
(say, 30sec or something).  Testing both clearly doubles it, so it may not
always be desirable, as users are likely to use one or the other, but
never both, in the "real world".

[1]: https://patchwork.kernel.org/project/linux-mm/patch/20201129004548.1619714-14-namit@vmware.com/

Link: https://lkml.kernel.org/r/20220808175614.3885028-4-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dmitry V. Levin <ldv@altlinux.org>
Cc: Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   69 ++++++++++++++++++---
 1 file changed, 60 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -77,6 +77,11 @@ static int bounces;
 #define TEST_SHMEM	3
 static int test_type;
 
+#define UFFD_FLAGS	(O_CLOEXEC | O_NONBLOCK | UFFD_USER_MODE_ONLY)
+
+/* test using /dev/userfaultfd, instead of userfaultfd(2) */
+static bool test_dev_userfaultfd;
+
 /* exercise the test_uffdio_*_eexist every ALARM_INTERVAL_SECS */
 #define ALARM_INTERVAL_SECS 10
 static volatile bool test_uffdio_copy_eexist = true;
@@ -125,6 +130,8 @@ struct uffd_stats {
 const char *examples =
     "# Run anonymous memory test on 100MiB region with 99999 bounces:\n"
     "./userfaultfd anon 100 99999\n\n"
+    "# Run the same anonymous memory test, but using /dev/userfaultfd:\n"
+    "./userfaultfd anon:dev 100 99999\n\n"
     "# Run share memory test on 1GiB region with 99 bounces:\n"
     "./userfaultfd shmem 1000 99\n\n"
     "# Run hugetlb memory test on 256MiB region with 50 bounces:\n"
@@ -141,6 +148,14 @@ static void usage(void)
 		"[hugetlbfs_file]\n\n");
 	fprintf(stderr, "Supported <test type>: anon, hugetlb, "
 		"hugetlb_shared, shmem\n\n");
+	fprintf(stderr, "'Test mods' can be joined to the test type string with a ':'. "
+		"Supported mods:\n");
+	fprintf(stderr, "\tsyscall - Use userfaultfd(2) (default)\n");
+	fprintf(stderr, "\tdev - Use /dev/userfaultfd instead of userfaultfd(2)\n");
+	fprintf(stderr, "\nExample test mod usage:\n");
+	fprintf(stderr, "# Run anonymous memory test with /dev/userfaultfd:\n");
+	fprintf(stderr, "./userfaultfd anon:dev 100 99999\n\n");
+
 	fprintf(stderr, "Examples:\n\n");
 	fprintf(stderr, "%s", examples);
 	exit(1);
@@ -154,12 +169,14 @@ static void usage(void)
 			ret, __LINE__);				\
 	} while (0)
 
-#define err(fmt, ...)				\
+#define errexit(exitcode, fmt, ...)		\
 	do {					\
 		_err(fmt, ##__VA_ARGS__);	\
-		exit(1);			\
+		exit(exitcode);			\
 	} while (0)
 
+#define err(fmt, ...) errexit(1, fmt, ##__VA_ARGS__)
+
 static void uffd_stats_reset(struct uffd_stats *uffd_stats,
 			     unsigned long n_cpus)
 {
@@ -383,13 +400,29 @@ static void assert_expected_ioctls_prese
 	}
 }
 
+static int __userfaultfd_open_dev(void)
+{
+	int fd, _uffd = -1;
+
+	fd = open("/dev/userfaultfd", O_RDWR | O_CLOEXEC);
+	if (fd < 0)
+		return -1;
+
+	_uffd = ioctl(fd, USERFAULTFD_IOC_NEW, UFFD_FLAGS);
+	close(fd);
+	return _uffd;
+}
+
 static void userfaultfd_open(uint64_t *features)
 {
 	struct uffdio_api uffdio_api;
 
-	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK | UFFD_USER_MODE_ONLY);
+	if (test_dev_userfaultfd)
+		uffd = __userfaultfd_open_dev();
+	else
+		uffd = syscall(__NR_userfaultfd, UFFD_FLAGS);
 	if (uffd < 0)
-		err("userfaultfd syscall not available in this kernel");
+		errexit(KSFT_SKIP, "creating userfaultfd failed");
 	uffd_flags = fcntl(uffd, F_GETFD, NULL);
 
 	uffdio_api.api = UFFD_API;
@@ -1584,8 +1617,6 @@ unsigned long default_huge_page_size(voi
 
 static void set_test_type(const char *type)
 {
-	uint64_t features = UFFD_API_FEATURES;
-
 	if (!strcmp(type, "anon")) {
 		test_type = TEST_ANON;
 		uffd_test_ops = &anon_uffd_test_ops;
@@ -1603,9 +1634,29 @@ static void set_test_type(const char *ty
 		test_type = TEST_SHMEM;
 		uffd_test_ops = &shmem_uffd_test_ops;
 		test_uffdio_minor = true;
-	} else {
-		err("Unknown test type: %s", type);
 	}
+}
+
+static void parse_test_type_arg(const char *raw_type)
+{
+	char *buf = strdup(raw_type);
+	uint64_t features = UFFD_API_FEATURES;
+
+	while (buf) {
+		const char *token = strsep(&buf, ":");
+
+		if (!test_type)
+			set_test_type(token);
+		else if (!strcmp(token, "dev"))
+			test_dev_userfaultfd = true;
+		else if (!strcmp(token, "syscall"))
+			test_dev_userfaultfd = false;
+		else
+			err("unrecognized test mod '%s'", token);
+	}
+
+	if (!test_type)
+		err("failed to parse test type argument: '%s'", raw_type);
 
 	if (test_type == TEST_HUGETLB)
 		page_size = default_huge_page_size();
@@ -1653,7 +1704,7 @@ int main(int argc, char **argv)
 		err("failed to arm SIGALRM");
 	alarm(ALARM_INTERVAL_SECS);
 
-	set_test_type(argv[1]);
+	parse_test_type_arg(argv[1]);
 
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
 	nr_pages_per_cpu = atol(argv[2]) * 1024*1024 / page_size /
_

Patches currently in -mm which might be from axelrasmussen@google.com are

selftests-vm-add-hugetlb_shared-userfaultfd-test-to-run_vmtestssh.patch
userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control.patch
userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd.patch
userfaultfd-update-documentation-to-describe-dev-userfaultfd.patch
selftests-vm-add-dev-userfaultfd-test-cases-to-run_vmtestssh.patch

