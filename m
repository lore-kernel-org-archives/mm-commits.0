Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B365DC433F5
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:44:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81BC061004
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbhISXpm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 19 Sep 2021 19:45:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhISXpm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 19 Sep 2021 19:45:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C89861004;
        Sun, 19 Sep 2021 23:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632095056;
        bh=WgkcjbQjrpAineOqXUZjjbiNuTOtVOocfO0UH8W4K/A=;
        h=Date:From:To:Subject:From;
        b=NgSMvODHcGMuSlw+XiV5LWchPUI9UCewZpQJtLGw9cVm/N9CEYOEJ8Wuj4gQN0OJ4
         mdL7u6lUYPP2Z9ID+7ScuAWAyf58H7uGxNmc6PN8eb3YarjDGNP0jALk/knly65axg
         cQODfLb5DJg5T5ZD0a19Bk3SjQYb/zlkU4+lwo40=
Date:   Sun, 19 Sep 2021 16:44:15 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, changbin.du@gmail.com
Subject:  +
 tools-vm-page-types-remove-dependency-on-opt_file-for-idle-page-tracking.patch
 added to -mm tree
Message-ID: <20210919234415.GeLrf%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page-types: remove dependency on opt_file for idle page tracking
has been added to the -mm tree.  Its filename is
     tools-vm-page-types-remove-dependency-on-opt_file-for-idle-page-tracking.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page-types-remove-dependency-on-opt_file-for-idle-page-tracking.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page-types-remove-dependency-on-opt_file-for-idle-page-tracking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Changbin Du <changbin.du@gmail.com>
Subject: tools/vm/page-types: remove dependency on opt_file for idle page tracking

Idle page tracking can also be used for process address space, not only
file mappings.

Without this change, using with '-i' option for process address space
encounters below errors reported.

$ sudo ./page-types -p $(pidof bash) -i
mark page idle: Bad file descriptor
mark page idle: Bad file descriptor
mark page idle: Bad file descriptor
mark page idle: Bad file descriptor
mark page idle: Bad file descriptor
mark page idle: Bad file descriptor
....

Link: https://lkml.kernel.org/r/20210917032826.10669-1-changbin.du@gmail.com
Signed-off-by: Changbin Du <changbin.du@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page-types.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/vm/page-types.c~tools-vm-page-types-remove-dependency-on-opt_file-for-idle-page-tracking
+++ a/tools/vm/page-types.c
@@ -1331,7 +1331,7 @@ int main(int argc, char *argv[])
 	if (opt_list && opt_list_mapcnt)
 		kpagecount_fd = checked_open(PROC_KPAGECOUNT, O_RDONLY);
 
-	if (opt_mark_idle && opt_file)
+	if (opt_mark_idle)
 		page_idle_fd = checked_open(SYS_KERNEL_MM_PAGE_IDLE, O_RDWR);
 
 	if (opt_list && opt_pid)
_

Patches currently in -mm which might be from changbin.du@gmail.com are

tools-vm-page-types-remove-dependency-on-opt_file-for-idle-page-tracking.patch

