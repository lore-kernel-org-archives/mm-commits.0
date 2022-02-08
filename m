Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D50F3C46467
	for <mm-commits@archiver.kernel.org>; Tue,  8 Feb 2022 22:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386821AbiBHWZv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386456AbiBHUgF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2022 15:36:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E376C0613CB
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 12:36:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EBFDB81A85
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 20:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDCDC004E1;
        Tue,  8 Feb 2022 20:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644352561;
        bh=nXbyYVvxO90DQQOUEEPrsXKAe7mPayNye/tqkkeNjRA=;
        h=Date:To:From:Subject:From;
        b=mDev9obs9eheTHaTWefN4ny9BWoyiKpFN1TbwN7Zm5Z/Y+Z25WfjruK99OZcCoxc0
         u20k9pSrjTP5hQHluBFXCC9BdccfB15WT15UpguwDlImSeIQP3CgswIBuYaNx0kxEl
         Six9Ikiq1peSpD7M9vc+cQ0y5+KqV3KFOh69jDPw=
Date:   Tue, 08 Feb 2022 12:36:01 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        lixuefeng@loongson.cn, elver@google.com, corbet@lwn.net,
        bhe@redhat.com, yangtiezhu@loongson.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-kdump-add-scp-example-to-write-out-the-dump-file.patch added to -mm tree
Message-Id: <20220208203601.CCDCDC004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs: kdump: add scp example to write out the dump file
has been added to the -mm tree.  Its filename is
     docs-kdump-add-scp-example-to-write-out-the-dump-file.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/docs-kdump-add-scp-example-to-write-out-the-dump-file.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/docs-kdump-add-scp-example-to-write-out-the-dump-file.patch

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
Subject: docs: kdump: add scp example to write out the dump file

Except cp and makedumpfile, add scp example to write out the dump file.

Link: https://lkml.kernel.org/r/1644324666-15947-3-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marco Elver <elver@google.com>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kdump/kdump.rst |    4 ++++
 1 file changed, 4 insertions(+)

--- a/Documentation/admin-guide/kdump/kdump.rst~docs-kdump-add-scp-example-to-write-out-the-dump-file
+++ a/Documentation/admin-guide/kdump/kdump.rst
@@ -533,6 +533,10 @@ the following command::
 
    cp /proc/vmcore <dump-file>
 
+or use scp to write out the dump file between hosts on a network, e.g::
+
+   scp /proc/vmcore remote_username@remote_ip:<dump-file>
+
 You can also use makedumpfile utility to write out the dump file
 with specified options to filter out unwanted contents, e.g::
 
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

docs-kdump-update-description-about-sysfs-file-system-support.patch
docs-kdump-add-scp-example-to-write-out-the-dump-file.patch
panic-unset-panic_on_warn-inside-panic.patch
ubsan-no-need-to-unset-panic_on_warn-in-ubsan_epilogue.patch
kasan-no-need-to-unset-panic_on_warn-in-end_report.patch

