Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D73C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D64B923118
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbgLPEN0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:13:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:42006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgLPEN0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:13:26 -0500
Date:   Tue, 15 Dec 2020 20:12:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608091965;
        bh=8+A4/6mi60AQjyz9da1AZCvJUhto+Pz4FHnK9o/+jGQ=;
        h=From:To:Subject:From;
        b=UHk3LuFloXC/IQaqA9ez+eyzyVLH68QRJz8MT8x9XNFcO6Zqgq9N1yZrpAGjGqTHC
         BUpFjwwiPbzK0/BzqDF73LNRnG8+V4Typ2YgfA9uXriOLs2ILs9gL6GsQmrj4Kruwd
         VAiU9mqufOfRAUkhZcmhXlwB895CNJxz+DVha/48=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dwaipayanray1@gmail.com,
        joe@perches.com, mm-commits@vger.kernel.org, yepeilin.cs@gmail.com
Subject:  [folded-merged]
 checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch
 removed from -mm tree
Message-ID: <20201216041245.ruXzqbgbf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch

This patch was dropped because it was folded into checkpatch-fix-typo_spelling-check-for-words-with-apostrophe.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix

make matched misspelling more obvious, per Joe

Link: https://lkml.kernel.org/r/09c24ef1aa2f1c4fe909d76f5426f08780b9d81c.camel@perches.com
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix
+++ a/scripts/checkpatch.pl
@@ -3185,7 +3185,7 @@ sub process {
 			while ($rawline =~ /(?:^|[^\w\-'`])($misspellings)(?:[^\w\-'`]|$)/gi) {
 				my $typo = $1;
 				my $blank = copy_spacing($rawline);
-				my $ptr = substr($blank, 0, $-[1]) . "^";
+				my $ptr = substr($blank, 0, $-[1]) . "^" x length($typo);
 				my $hereptr = "$hereline$ptr\n";
 				my $typo_fix = $spelling_fix{lc($typo)};
 				$typo_fix = ucfirst($typo_fix) if ($typo =~ /^[A-Z]/);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

checkpatch-fix-typo_spelling-check-for-words-with-apostrophe.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
lib-ubsanc-mark-type_check_kinds-with-static-keyword-fix.patch
mm.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
kmap-stupid-hacks-to-make-it-compile.patch
epoll-wire-up-syscall-epoll_pwait2-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

