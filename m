Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48879C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiKIBiO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiKIBiL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B93060E96
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47027B81C38
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F85C433D7;
        Wed,  9 Nov 2022 01:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957888;
        bh=YnVSdhFqcaG9d5KbSpcokUiSRYlTEwZmDOlwtztyTSg=;
        h=Date:To:From:Subject:From;
        b=2EkZQzne3V6w1975l78jxzffXrfve0J8syXszNvEkD5QmtTL4ZChGOaPfPoc8iNlk
         Rs8XbtNraGoKVKUWUbMpONgf3tsxBGiXccpykQnUDXtllT0IPhUSmS9Y7SPCRg1513
         x8fSGeRlDBf1cEzUik2MSU+EQfTsU+z0GFP/6rQU=
Date:   Tue, 08 Nov 2022 17:38:07 -0800
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        axelrasmussen@google.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-use-memfd-for-hugepage-mremap-test.patch removed from -mm tree
Message-Id: <20221109013807.E6F85C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: use memfd for hugepage-mremap test
has been removed from the -mm tree.  Its filename was
     selftests-vm-use-memfd-for-hugepage-mremap-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-always-compile-in-pte-markers.patch
mm-use-pte-markers-for-swap-errors.patch

