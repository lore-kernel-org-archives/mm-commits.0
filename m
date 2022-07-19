Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF92C43334
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jul 2022 22:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238087AbiGSWsF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jul 2022 18:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbiGSWsD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2022 18:48:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8A34E62F
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 15:48:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 028286020F
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 22:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562E7C341C6;
        Tue, 19 Jul 2022 22:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658270880;
        bh=Q7c6vjaOAyUi4hOl3A5V2wx85XCLNwM2Io8V3sbLp0M=;
        h=Date:To:From:Subject:From;
        b=Fe0EbnWFyxbOnQfOKGG+x3H+MDbe7DBj6w8D/RUgCT4OXt7t7Vxy29ILFT8GDkN2H
         9c9BIp9JnMiDP9HfyK9B3G8wHpXtfZsuKDGT9a+k9mCdyKSh5kJhfnFOQCS8voknUu
         dFJwv95PNX8+lGJlLLGzdeTy0S/h3uYyWMqGdxJo=
Date:   Tue, 19 Jul 2022 15:47:59 -0700
To:     mm-commits@vger.kernel.org, yi.zhang@huawei.com,
        viro@zeniv.linux.org.uk, vbabka@suse.cz, surenb@google.com,
        skhan@linuxfoundation.org, rppt@kernel.org, peterx@redhat.com,
        namit@vmware.com, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, ldv@altlinux.org, jack@suse.cz,
        hughd@google.com, glebfm@altlinux.org, dave.hansen@linux.intel.com,
        corbet@lwn.net, charante@codeaurora.org, axelrasmussen@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd.patch removed from -mm tree
Message-Id: <20220719224800.562E7C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: userfaultfd: selftests: modify selftest to use /dev/userfaultfd
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd: selftests: modify selftest to use /dev/userfaultfd
Date: Wed, 1 Jun 2022 14:09:48 -0700

We clearly want to ensure both userfaultfd(2) and /dev/userfaultfd keep
working into the future, so just run the test twice, using each interface.

Link: https://lkml.kernel.org/r/20220601210951.3916598-4-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Charan Teja Kalla <charante@codeaurora.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dmitry V. Levin <ldv@altlinux.org>
Cc: Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nadav Amit <namit@vmware.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   37 ++++++++++++++++++---
 1 file changed, 33 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -77,6 +77,9 @@ static int bounces;
 #define TEST_SHMEM	3
 static int test_type;
 
+/* test using /dev/userfaultfd, instead of userfaultfd(2) */
+static bool test_dev_userfaultfd;
+
 /* exercise the test_uffdio_*_eexist every ALARM_INTERVAL_SECS */
 #define ALARM_INTERVAL_SECS 10
 static volatile bool test_uffdio_copy_eexist = true;
@@ -154,12 +157,14 @@ static void usage(void)
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
@@ -383,13 +388,31 @@ static void assert_expected_ioctls_prese
 	}
 }
 
+static void __userfaultfd_open_dev(void)
+{
+	int fd;
+
+	uffd = -1;
+	fd = open("/dev/userfaultfd", O_RDWR | O_CLOEXEC);
+	if (fd < 0)
+		return;
+
+	uffd = ioctl(fd, USERFAULTFD_IOC_NEW,
+		     O_CLOEXEC | O_NONBLOCK | UFFD_USER_MODE_ONLY);
+	close(fd);
+}
+
 static void userfaultfd_open(uint64_t *features)
 {
 	struct uffdio_api uffdio_api;
 
-	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK | UFFD_USER_MODE_ONLY);
+	if (test_dev_userfaultfd)
+		__userfaultfd_open_dev();
+	else
+		uffd = syscall(__NR_userfaultfd,
+			       O_CLOEXEC | O_NONBLOCK | UFFD_USER_MODE_ONLY);
 	if (uffd < 0)
-		err("userfaultfd syscall not available in this kernel");
+		errexit(KSFT_SKIP, "creating userfaultfd failed");
 	uffd_flags = fcntl(uffd, F_GETFD, NULL);
 
 	uffdio_api.api = UFFD_API;
@@ -1691,6 +1714,12 @@ int main(int argc, char **argv)
 	}
 	printf("nr_pages: %lu, nr_pages_per_cpu: %lu\n",
 	       nr_pages, nr_pages_per_cpu);
+
+	test_dev_userfaultfd = false;
+	if (userfaultfd_stress())
+		return 1;
+
+	test_dev_userfaultfd = true;
 	return userfaultfd_stress();
 }
 
_

Patches currently in -mm which might be from axelrasmussen@google.com are

userfaultfd-update-documentation-to-describe-dev-userfaultfd.patch
userfaultfd-selftests-make-dev-userfaultfd-testing-configurable.patch
selftests-vm-add-dev-userfaultfd-test-cases-to-run_vmtestssh.patch

