Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36BDDC4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 00:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442061AbjLGAN2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 19:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441922AbjLGANU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 19:13:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30527C9
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 16:13:25 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BD3C433CA;
        Thu,  7 Dec 2023 00:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701908004;
        bh=DgQQDcz2aJo/TZKzUyfprQzk0zJ8FWoESFypPcclJVE=;
        h=Date:To:From:Subject:From;
        b=qmPGkV8gkRpOT+OJ4Q++erUXyQn8tg/jUR357e89Mb1kEXCQfZN9+x0WbmqhI5mKu
         FXRWg9zlSc/iQtDyiU1DdK71uaKRTJyE5u89RFwHJKTGdRaFTCCqbHuZmWnti+khUM
         Pk6J5zRAyzADIyz6t2sRXRM0mPB59uAuOVfpaU5Q=
Date:   Wed, 06 Dec 2023 16:13:24 -0800
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        david@redhat.com, avagin@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-selftests-fix-pagemap_ioctl-memory-map-test.patch removed from -mm tree
Message-Id: <20231207001324.B2BD3C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/selftests: fix pagemap_ioctl memory map test
has been removed from the -mm tree.  Its filename was
     mm-selftests-fix-pagemap_ioctl-memory-map-test.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/selftests: fix pagemap_ioctl memory map test
Date: Thu, 16 Nov 2023 15:15:47 -0500

__FILE__ is not guaranteed to exist in current dir.  Replace that with
argv[0] for memory map test.

Link: https://lkml.kernel.org/r/20231116201547.536857-4-peterx@redhat.com
Fixes: 46fd75d4a3c9 ("selftests: mm: add pagemap ioctl tests")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~mm-selftests-fix-pagemap_ioctl-memory-map-test
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -36,6 +36,7 @@ int pagemap_fd;
 int uffd;
 int page_size;
 int hpage_size;
+const char *progname;
 
 #define LEN(region)	((region.end - region.start)/page_size)
 
@@ -1149,11 +1150,11 @@ int sanity_tests(void)
 	munmap(mem, mem_size);
 
 	/* 9. Memory mapped file */
-	fd = open(__FILE__, O_RDONLY);
+	fd = open(progname, O_RDONLY);
 	if (fd < 0)
 		ksft_exit_fail_msg("%s Memory mapped file\n", __func__);
 
-	ret = stat(__FILE__, &sbuf);
+	ret = stat(progname, &sbuf);
 	if (ret < 0)
 		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
 
@@ -1472,12 +1473,14 @@ static void transact_test(int page_size)
 			      extra_thread_faults);
 }
 
-int main(void)
+int main(int argc, char *argv[])
 {
 	int mem_size, shmid, buf_size, fd, i, ret;
 	char *mem, *map, *fmem;
 	struct stat sbuf;
 
+	progname = argv[0];
+
 	ksft_print_header();
 
 	if (init_uffd())
_

Patches currently in -mm which might be from peterx@redhat.com are

fs-kconfig-make-hugetlbfs-a-menuconfig.patch
mm-gup-fix-follow_devmap_pd-on-page==null-handling.patch

