Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B285AC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiJQAeR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiJQAeN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:34:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA967326C6
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:34:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66A2060C35
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04B9C433D6;
        Mon, 17 Oct 2022 00:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665966851;
        bh=AkLaFTFx9ldYOezT/wpIMtEGskQV0ysO4Ayv/+2XOMY=;
        h=Date:To:From:Subject:From;
        b=T/Zdjp/Ze7OkOBmeOaYSBMkC61zWCuGbkjUgBzWpU6LXsc5A3v8mXmYZ+latJCWmE
         YmIjLiCc7ncCEqxe6f5OQiZgeucCsJ6VgBJb2ur5K8NaqLzokuznGhP0HIUMGKi51W
         br2RUoz965aa9lxcMnsv9M4/CeQjHwjVsOIMlnQs=
Date:   Sun, 16 Oct 2022 17:34:11 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        axelrasmussen@google.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-use-memfd-for-hugepage-mremap-test.patch added to mm-unstable branch
Message-Id: <20221017003411.C04B9C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: use memfd for hugepage-mremap test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-use-memfd-for-hugepage-mremap-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-use-memfd-for-hugepage-mremap-test.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: selftests/vm: use memfd for hugepage-mremap test
Date: Fri, 14 Oct 2022 10:40:13 -0400

For dropping the hugetlb mountpoint in run_vmtests.sh.  Cleaned it up a
little bit around the changed codes.

Link: https://lkml.kernel.org/r/20221014144013.94027-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hugepage-mremap.c |   21 +++++++----------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/vm/hugepage-mremap.c~selftests-vm-use-memfd-for-hugepage-mremap-test
+++ a/tools/testing/selftests/vm/hugepage-mremap.c
@@ -22,6 +22,7 @@
 #include <sys/syscall.h> /* Definition of SYS_* constants */
 #include <linux/userfaultfd.h>
 #include <sys/ioctl.h>
+#include <string.h>
 
 #define DEFAULT_LENGTH_MB 10UL
 #define MB_TO_BYTES(x) (x * 1024 * 1024)
@@ -108,26 +109,23 @@ static void register_region_with_uffd(ch
 int main(int argc, char *argv[])
 {
 	size_t length = 0;
+	int ret = 0, fd;
 
-	if (argc != 2 && argc != 3) {
-		printf("Usage: %s [length_in_MB] <hugetlb_file>\n", argv[0]);
+	if (argc >= 2 && !strcmp(argv[1], "-h")) {
+		printf("Usage: %s [length_in_MB]\n", argv[0]);
 		exit(1);
 	}
 
 	/* Read memory length as the first arg if valid, otherwise fallback to
 	 * the default length.
 	 */
-	if (argc == 3)
-		length = argc > 2 ? (size_t)atoi(argv[1]) : 0UL;
+	if (argc >= 2)
+		length = (size_t)atoi(argv[1]);
+	else
+		length = DEFAULT_LENGTH_MB;
 
-	length = length > 0 ? length : DEFAULT_LENGTH_MB;
 	length = MB_TO_BYTES(length);
-
-	int ret = 0;
-
-	/* last arg is the hugetlb file name */
-	int fd = open(argv[argc-1], O_CREAT | O_RDWR, 0755);
-
+	fd = memfd_create(argv[0], MFD_HUGETLB);
 	if (fd < 0) {
 		perror("Open failed");
 		exit(1);
@@ -185,7 +183,6 @@ int main(int argc, char *argv[])
 	}
 
 	close(fd);
-	unlink(argv[argc-1]);
 
 	return ret;
 }
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-vm-use-memfd-for-uffd-hugetlb-tests.patch
selftests-vm-use-memfd-for-hugetlb-madvise-test.patch
selftests-vm-use-memfd-for-hugepage-mremap-test.patch
selftests-vm-drop-mnt-point-for-hugetlb-in-run_vmtestssh.patch

