Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C098C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 16:28:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbjKFQ2E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 11:28:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjKFQ2B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 11:28:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039A0D45
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 08:27:59 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC7BC433C8;
        Mon,  6 Nov 2023 16:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699288078;
        bh=7HcNsb92zNRHkRv/ZXHHMaqz0efvwkp27roVz0UH6s4=;
        h=Date:To:From:Subject:From;
        b=RbqYe8jaNmCWdLJk5O4k+XPh89rY22RWQB6EIn6iuarb/iSIfsfuBuF+TRHyk7XuQ
         NoJA6fr1v3hxXtuzfuDlgNmbc8Nwbi5uk7rHZkl1gid1SMFy6SjXcuzZ/GhHnupYdi
         mkZP3j4SKB/uxnM8uJSGAqiY0+LcOgnbM6OywMfY=
Date:   Mon, 06 Nov 2023 08:27:57 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, ryan.roberts@arm.com,
        usama.anjum@collabora.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-some-build-warnings.patch added to mm-hotfixes-unstable branch
Message-Id: <20231106162758.8BC7BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: mm: fix some build warnings
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-fix-some-build-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-some-build-warnings.patch

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: mm: fix some build warnings
Date: Fri, 3 Nov 2023 23:23:42 +0500

Fix build warnings:
pagemap_ioctl.c:1154:38: warning: format `%s' expects a matching `char *' argument [-Wformat=]
pagemap_ioctl.c:1162:51: warning: format `%ld' expects argument of type `long int', but argument 2 has type `int' [-Wformat=]
pagemap_ioctl.c:1192:51: warning: format `%ld' expects argument of type `long int', but argument 2 has type `int' [-Wformat=]
pagemap_ioctl.c:1600:51: warning: format `%ld' expects argument of type `long int', but argument 2 has type `int' [-Wformat=]
pagemap_ioctl.c:1628:51: warning: format `%ld' expects argument of type `long int', but argument 2 has type `int' [-Wformat=]

Link: https://lkml.kernel.org/r/20231103182343.2874015-2-usama.anjum@collabora.com
Fixes: 46fd75d4a3c9 ("selftests: mm: add pagemap ioctl tests")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-fix-some-build-warnings
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1151,7 +1151,7 @@ int sanity_tests(void)
 	/* 9. Memory mapped file */
 	fd = open(__FILE__, O_RDONLY);
 	if (fd < 0)
-		ksft_exit_fail_msg("%s Memory mapped file\n");
+		ksft_exit_fail_msg("%s Memory mapped file\n", __func__);
 
 	ret = stat(__FILE__, &sbuf);
 	if (ret < 0)
@@ -1159,7 +1159,7 @@ int sanity_tests(void)
 
 	fmem = mmap(NULL, sbuf.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
 	if (fmem == MAP_FAILED)
-		ksft_exit_fail_msg("error nomem %ld %s\n", errno, strerror(errno));
+		ksft_exit_fail_msg("error nomem %d %s\n", errno, strerror(errno));
 
 	tmp_buf = malloc(sbuf.st_size);
 	memcpy(tmp_buf, fmem, sbuf.st_size);
@@ -1189,7 +1189,7 @@ int sanity_tests(void)
 
 	fmem = mmap(NULL, buf_size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
 	if (fmem == MAP_FAILED)
-		ksft_exit_fail_msg("error nomem %ld %s\n", errno, strerror(errno));
+		ksft_exit_fail_msg("error nomem %d %s\n", errno, strerror(errno));
 
 	wp_init(fmem, buf_size);
 	wp_addr_range(fmem, buf_size);
@@ -1596,7 +1596,7 @@ int main(void)
 
 	fmem = mmap(NULL, sbuf.st_size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
 	if (fmem == MAP_FAILED)
-		ksft_exit_fail_msg("error nomem %ld %s\n", errno, strerror(errno));
+		ksft_exit_fail_msg("error nomem %d %s\n", errno, strerror(errno));
 
 	wp_init(fmem, sbuf.st_size);
 	wp_addr_range(fmem, sbuf.st_size);
@@ -1624,7 +1624,7 @@ int main(void)
 
 	fmem = mmap(NULL, buf_size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
 	if (fmem == MAP_FAILED)
-		ksft_exit_fail_msg("error nomem %ld %s\n", errno, strerror(errno));
+		ksft_exit_fail_msg("error nomem %d %s\n", errno, strerror(errno));
 
 	wp_init(fmem, buf_size);
 	wp_addr_range(fmem, buf_size);
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-skip-whole-test-instead-of-failure.patch
selftests-mm-fix-some-build-warnings.patch

