Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ABD5C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  8 Feb 2022 22:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386598AbiBHWZp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386455AbiBHUgB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2022 15:36:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD76C0613CB
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 12:36:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80797615F0
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 20:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D567FC004E1;
        Tue,  8 Feb 2022 20:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644352559;
        bh=Zkuj6P2hZWXzblGY6BapjN7mANVdPJyUa7uWTR6BRyk=;
        h=Date:To:From:Subject:From;
        b=Opz+WXPUloCEWFkrLoqZ9hNrdNX00NXiR6QiIBYGonwkxDazDHq+3UDcqN/exoN1O
         dz0VHl56Jcq88mH+RoWJfrqN/iLg9issiuHLonZ9NGZOI28W3Pxa7/CZLzA8rRzcNF
         rRXWE+kwDSb4E3pAMuWvaXOK9oPkDwRMky4hlAkg=
Date:   Tue, 08 Feb 2022 12:35:59 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        lixuefeng@loongson.cn, elver@google.com, corbet@lwn.net,
        bhe@redhat.com, yangtiezhu@loongson.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-kdump-update-description-about-sysfs-file-system-support.patch added to -mm tree
Message-Id: <20220208203559.D567FC004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs: kdump: update description about sysfs file system support
has been added to the -mm tree.  Its filename is
     docs-kdump-update-description-about-sysfs-file-system-support.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/docs-kdump-update-description-about-sysfs-file-system-support.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/docs-kdump-update-description-about-sysfs-file-system-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: docs: kdump: update description about sysfs file system support

Patch series "Update doc and fix some issues about kdump", v2.


This patch (of 5):

After commit 6a108a14fa35 ("kconfig: rename CONFIG_EMBEDDED to
CONFIG_EXPERT"), "Configure standard kernel features (for small systems)"
is not exist, we should use "Configure standard kernel features (expert
users)" now.

Link: https://lkml.kernel.org/r/1644324666-15947-1-git-send-email-yangtiezhu@loongson.cn
Link: https://lkml.kernel.org/r/1644324666-15947-2-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kdump/kdump.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/kdump/kdump.rst~docs-kdump-update-description-about-sysfs-file-system-support
+++ a/Documentation/admin-guide/kdump/kdump.rst
@@ -146,9 +146,9 @@ System kernel config options
 	CONFIG_SYSFS=y
 
    Note that "sysfs file system support" might not appear in the "Pseudo
-   filesystems" menu if "Configure standard kernel features (for small
-   systems)" is not enabled in "General Setup." In this case, check the
-   .config file itself to ensure that sysfs is turned on, as follows::
+   filesystems" menu if "Configure standard kernel features (expert users)"
+   is not enabled in "General Setup." In this case, check the .config file
+   itself to ensure that sysfs is turned on, as follows::
 
 	grep 'CONFIG_SYSFS' .config
 
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

docs-kdump-update-description-about-sysfs-file-system-support.patch
docs-kdump-add-scp-example-to-write-out-the-dump-file.patch
panic-unset-panic_on_warn-inside-panic.patch
ubsan-no-need-to-unset-panic_on_warn-in-ubsan_epilogue.patch
kasan-no-need-to-unset-panic_on_warn-in-end_report.patch

