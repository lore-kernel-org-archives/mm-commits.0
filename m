Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23817C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0247461C14
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbhKPE2j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 23:28:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:54424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240474AbhKPE2C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 23:28:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE7C461B30;
        Tue, 16 Nov 2021 04:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637036706;
        bh=k9LCBn9LOM8tmII2dc7YUjgygsjd4PnwDtwFQTcrAVc=;
        h=Date:From:To:Subject:From;
        b=fZC9PAQPGo9b3iMROvkGdK7M9pd1pf1QlAKV0sno/RfUxlYG5gkTzTbWe8ICxFvET
         JS66QPLGfCK/RYh2nTK/2DbUv9pPQphGJhoMPQcj/ycEPRjml1V/AxsO03gZjzYCCo
         5NbPghblwpeUlPBOibevT16EpVhxvTvzeMz7qcn4=
Date:   Mon, 15 Nov 2021 20:25:05 -0800
From:   akpm@linux-foundation.org
To:     apw@canonical.com, dwaipayanray1@gmail.com, jerome@forissier.org,
        joe@perches.com, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org
Subject:  + checkpatch-relax-regexp-for-commit_log_long_line.patch
 added to -mm tree
Message-ID: <20211116042505.tgeyTWWgK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: relax regexp for COMMIT_LOG_LONG_LINE
has been added to the -mm tree.  Its filename is
     checkpatch-relax-regexp-for-commit_log_long_line.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-relax-regexp-for-commit_log_long_line.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-relax-regexp-for-commit_log_long_line.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jerome Forissier <jerome@forissier.org>
Subject: checkpatch: relax regexp for COMMIT_LOG_LONG_LINE

One exceptions to the COMMIT_LOG_LONG_LINE rule is a file path followed by
:.  That is typically some sort diagnostic message from a compiler or a
build tool, in which case we don't want to wrap the lines but keep the
message unmodified.

The regular expression used to match this pattern currently doesn't accept
absolute paths or + characters.  This can result in false positives as in
the following (out-of-tree) example:

  ...
  /home/jerome/work/optee_repo_qemu/build/../toolchains/aarch32/bin/arm-linux-gnueabihf-ld.bfd: /home/jerome/work/toolchains-gcc10.2/aarch32/bin/../lib/gcc/arm-none-linux-gnueabihf/10.2.1/../../../../arm-none-linux-gnueabihf/lib/libstdc++.a(eh_alloc.o): in function `__cxa_allocate_exception':
  /tmp/dgboter/bbs/build03--cen7x86_64/buildbot/cen7x86_64--arm-none-linux-gnueabihf/build/src/gcc/libstdc++-v3/libsupc++/eh_alloc.cc:284: undefined reference to `malloc'
  ...

Update the regular expression to match the above paths.

Link: https://lkml.kernel.org/r/20210923143842.2837983-1-jerome@forissier.org
Signed-off-by: Jerome Forissier <jerome@forissier.org>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-relax-regexp-for-commit_log_long_line
+++ a/scripts/checkpatch.pl
@@ -3172,7 +3172,7 @@ sub process {
 		    length($line) > 75 &&
 		    !($line =~ /^\s*[a-zA-Z0-9_\/\.]+\s+\|\s+\d+/ ||
 					# file delta changes
-		      $line =~ /^\s*(?:[\w\.\-]+\/)++[\w\.\-]+:/ ||
+		      $line =~ /^\s*(?:[\w\.\-\+]*\/)++[\w\.\-\+]+:/ ||
 					# filename then :
 		      $line =~ /^\s*(?:Fixes:|Link:|$signature_tags)/i ||
 					# A Fixes: or Link: line or signature tag line
_

Patches currently in -mm which might be from jerome@forissier.org are

checkpatch-relax-regexp-for-commit_log_long_line.patch

