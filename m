Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6242C433F5
	for <mm-commits@archiver.kernel.org>; Sat,  7 May 2022 18:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350598AbiEGSmj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 May 2022 14:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiEGSmi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 7 May 2022 14:42:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3D31A046
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 11:38:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1BD2B80BA3
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 18:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4ECC385A5;
        Sat,  7 May 2022 18:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651948728;
        bh=krcCuuhsNjSE1oTuG4T26muVX9YOATpQU2U/x0XVjQM=;
        h=Date:To:From:Subject:From;
        b=sydjOWn+dioLQgrF3zpRnYDRBczh5kKLr+G6xhGBVqvZbj2VjaHv/fzUnkWzDiaeC
         uAldLAQFYFpsPtTlqRwXQC7ch9a7IGyOVsf9eUJhHufaokRmL6UJ5sAlcKRGcL3S8L
         GJ52OHhQy81gMDYosC9QuznvtMvlTMrm5iNtS9FI=
Date:   Sat, 07 May 2022 11:38:47 -0700
To:     mm-commits@vger.kernel.org, zhaochongxi2019@email.szu.edu.cn,
        zhangyinan2019@email.szu.edu.cn, yuhongf@szu.edu.cn,
        yejiajian2018@email.szu.edu.cn, liuyongqiang13@huawei.com,
        hanshenghong2019@email.szu.edu.cn, corbet@lwn.net,
        caoyixuan2019@email.szu.edu.cn, baihaowen@meizu.com,
        akiyks@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-vm-page_owner-tweak-literal-block-in-standard-format-specifiers.patch added to mm-unstable branch
Message-Id: <20220507183848.3F4ECC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs: vm/page_owner: tweak literal block in STANDARD FORMAT SPECIFIERS
has been added to the -mm mm-unstable branch.  Its filename is
     docs-vm-page_owner-tweak-literal-block-in-standard-format-specifiers.patch

This patch should soon appear in the mm-unstable branch at
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
From: Akira Yokosawa <akiyks@gmail.com>
Subject: docs: vm/page_owner: tweak literal block in STANDARD FORMAT SPECIFIERS

A semantic conflict between commit 5603f9bdea68 ("docs: vm/page_owner: use
literal blocks for param description") and a change queued for v5.19
authored by Jiajian Ye ("tools/vm/page_owner_sort.c: support sorting
blocks by multiple keys") results in a warning from "make htmldocs"
saying:

  [...]/vm/page_owner.rst:176: WARNING: Literal block expected; none found.

This is because a literal block in ReST ends at a line which has the same
indent as the paragraph preceding it.  In this case the one with no
indent.

Indent the two "For --xxxx option:" lines by two columns and make the
whole section a literal block.

While at it, fix indents by white spaces of "ator" keys.

Link: https://lkml.kernel.org/r/fdfecc82-d41e-6d8a-738d-4beb6faa27fb@gmail.com
Signed-of-by: Akira Yokosawa <akiyks@gmail.com>
Reported-by: Shenghong Han <hanshenghong2019@email.szu.edu.cn>
Cc: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: Chongxi Zhao <zhaochongxi2019@email.szu.edu.cn>
Cc: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Cc: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Yongqiang Liu <liuyongqiang13@huawei.com>
Cc: Yuhong Feng <yuhongf@szu.edu.cn>
Cc: Haowen Bai <baihaowen@meizu.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/vm/page_owner.rst~docs-vm-page_owner-tweak-literal-block-in-standard-format-specifiers
+++ a/Documentation/vm/page_owner.rst
@@ -173,7 +173,7 @@ STANDARD FORMAT SPECIFIERS
 ==========================
 ::
 
-For --sort option:
+  For --sort option:
 
 	KEY		LONG		DESCRIPTION
 	p		pid		process ID
@@ -183,9 +183,9 @@ For --sort option:
 	T		txt		full text of block
 	ft		free_ts		timestamp of the page when it was released
 	at		alloc_ts	timestamp of the page when it was allocated
-        ator            allocator       memory allocator for pages
+	ator		allocator	memory allocator for pages
 
-For --curl option:
+  For --curl option:
 
 	KEY		LONG		DESCRIPTION
 	p		pid		process ID
@@ -193,4 +193,4 @@ For --curl option:
 	n		name		task command name
 	f		free		whether the page has been released or not
 	st		stacktrace	stack trace of the page allocation
-        ator            allocator       memory allocator for pages
+	ator		allocator	memory allocator for pages
_

Patches currently in -mm which might be from akiyks@gmail.com are

docs-vm-page_owner-tweak-literal-block-in-standard-format-specifiers.patch

