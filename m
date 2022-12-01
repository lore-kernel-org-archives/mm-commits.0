Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C26E3C352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbiLAAGc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbiLAAEb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:04:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED9F900E5
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA5156176C
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F50AC433B5;
        Thu,  1 Dec 2022 00:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852918;
        bh=eDZndgGfQiEnfvvw3Cv0I3u0CqEx10KSLxlpQk/w2QU=;
        h=Date:To:From:Subject:From;
        b=dPMw6fs+6MUysbqLrjetTi7RK7+TXO9bGZtcGvWVYqOM+Q3w42NMUh8EIByKZIMf9
         BI19rkI/YBwYXOEX6d7RKSGv0KagtWQNLA1/uK9bEg3TLRuCBJfezB8UBFzhNzazcP
         fWOxahKAsI1h6RGKW5ZmZxuHkgYKEZeu06udFl/E=
Date:   Wed, 30 Nov 2022 16:01:57 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org, rongtao@cestc.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-fix-unnecessary-compilation-warnings.patch removed from -mm tree
Message-Id: <20221201000158.0F50AC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/damon: fix unnecessary compilation warnings
has been removed from the -mm tree.  Its filename was
     selftests-damon-fix-unnecessary-compilation-warnings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

radix-tree-test-suite-fix-uninitialized-variable-compilation-warning.patch

