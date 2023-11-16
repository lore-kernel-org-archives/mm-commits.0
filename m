Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02BD1C197A0
	for <mm-commits@archiver.kernel.org>; Thu, 16 Nov 2023 21:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjKPVf0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Nov 2023 16:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjKPVfX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2023 16:35:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F96D50
        for <mm-commits@vger.kernel.org>; Thu, 16 Nov 2023 13:35:19 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42A5C433C7;
        Thu, 16 Nov 2023 21:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700170519;
        bh=0C+LTUW5sqg92h5YkOWuvu2GEFFqWXXqotQSoKAQerg=;
        h=Date:To:From:Subject:From;
        b=lDMAIdCAVZxrJyk67jxumk5m7AU7b3k8xxb4iy4zcWNoegBJrdznuoDSRostzXeST
         5tKi51ldTtahvi8U59pC0U/vTJVV2uCxWmdDzf8ICeGi5A6Xrypacx4E/tVnSB5ZYU
         erLchpP2feNJPfyiyBi5fXibE65c04X/VnmK702s=
Date:   Thu, 16 Nov 2023 13:35:18 -0800
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        david@redhat.com, avagin@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-selftests-fix-pagemap_ioctl-memory-map-test.patch added to mm-hotfixes-unstable branch
Message-Id: <20231116213518.E42A5C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/selftests: fix pagemap_ioctl memory map test
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-selftests-fix-pagemap_ioctl-memory-map-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-selftests-fix-pagemap_ioctl-memory-map-test.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/selftests: fix pagemap_ioctl memory map test
Date: Thu, 16 Nov 2023 15:15:47 -0500

__FILE__ is not guaranteed to exist in current dir.  Replace that with
argv[0] for memory map test.

Link: https://lkml.kernel.org/r/20231116201547.536857-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Fixes: 46fd75d4a3c9 ("selftests: mm: add pagemap ioctl tests")
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

mm-pagemap-fix-ioctlpagemap_scan-on-vma-check.patch
mm-pagemap-fix-wr-protect-even-if-pm_scan_wp_matching-not-set.patch
mm-selftests-fix-pagemap_ioctl-memory-map-test.patch

