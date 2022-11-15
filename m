Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B6D9C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 23:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238619AbiKOXEv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 18:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238581AbiKOXEi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 18:04:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6E420984
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 15:04:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF54DB81B88
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 23:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3BAC433C1;
        Tue, 15 Nov 2022 23:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668553471;
        bh=dLDtaziBoR4Dv/MYp69hi1BlsGforSEw7w6JlvNt69M=;
        h=Date:To:From:Subject:From;
        b=2f6JF2auctvn/py59BdQmKTIksNXu+iSkkj++AsW3jxRDrZNs8GWLnnad5ZNBB+V7
         jco4GI5kf8XyFbhsTeNJB0k+IvhPbLyyBiELEhv+GpoQhed0Ddc5Nn2JWoGIDKx6kr
         6P1CqS11yG5HFePAqNgz66yb8WTgDHXGS3vQilNc=
Date:   Tue, 15 Nov 2022 15:04:30 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org, rongtao@cestc.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-fix-unnecessary-compilation-warnings.patch added to mm-unstable branch
Message-Id: <20221115230431.4D3BAC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/damon: fix unnecessary compilation warnings
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-fix-unnecessary-compilation-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-fix-unnecessary-compilation-warnings.patch

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
From: Rong Tao <rongtao@cestc.cn>
Subject: selftests/damon: fix unnecessary compilation warnings
Date: Sun, 13 Nov 2022 08:38:45 +0800

When testing overflow and overread, there is no need to keep unnecessary
compilation warnings, we should simply ignore them.

The motivation for this patch is to eliminate the compilation warning,
maybe one day we will compile the kernel with "-Werror -Wall", at which
point this compilation warning will turn into a compilation error, we
should fix this error in advance.

How to reproduce the problem (with gcc-11.3.1):

    $ make -C tools/testing/selftests/
    ...
    warning: `write' reading 4294967295 bytes from a region of size 1
    [-Wstringop-overread]
    warning: `read' writing 4294967295 bytes into a region of size 25
    overflows the destination [-Wstringop-overflow=]

"-Wno-stringop-overread" is supported at least in gcc-11.1.0.

Link: https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=d14c547abd484d3540b692bb8048c4a6efe92c8b
Link: https://lkml.kernel.org/r/tencent_51C4ACA8CB3895C2D7F35178440283602107@qq.com
Signed-off-by: Rong Tao <rongtao@cestc.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/huge_count_read_write.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/tools/testing/selftests/damon/huge_count_read_write.c~selftests-damon-fix-unnecessary-compilation-warnings
+++ a/tools/testing/selftests/damon/huge_count_read_write.c
@@ -8,6 +8,13 @@
 #include <unistd.h>
 #include <stdio.h>
 
+#pragma GCC diagnostic push
+#if __GNUC__ >= 11 && __GNUC_MINOR__ >= 1
+/* Ignore read(2) overflow and write(2) overread compile warnings */
+#pragma GCC diagnostic ignored "-Wstringop-overread"
+#pragma GCC diagnostic ignored "-Wstringop-overflow"
+#endif
+
 void write_read_with_huge_count(char *file)
 {
 	int filedesc = open(file, O_RDWR);
@@ -27,6 +34,8 @@ void write_read_with_huge_count(char *fi
 	close(filedesc);
 }
 
+#pragma GCC diagnostic pop
+
 int main(int argc, char *argv[])
 {
 	if (argc != 2) {
_

Patches currently in -mm which might be from rongtao@cestc.cn are

tools-vm-page_owner-ignore-page_owner_sort-binary.patch
selftests-damon-fix-unnecessary-compilation-warnings.patch
radix-tree-test-suite-fix-uninitialized-variable-compilation-warning.patch

