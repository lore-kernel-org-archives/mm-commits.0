Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DFABCE79B0
	for <mm-commits@archiver.kernel.org>; Tue, 19 Sep 2023 20:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbjISUWR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Sep 2023 16:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbjISUWP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Sep 2023 16:22:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645B5C4
        for <mm-commits@vger.kernel.org>; Tue, 19 Sep 2023 13:22:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF51BC433C9;
        Tue, 19 Sep 2023 20:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695154928;
        bh=jL88winMmuYlvzGeOJ5DNxoqtqsMvKxnMq0AZS674xU=;
        h=Date:To:From:Subject:From;
        b=JnquFaX4A3C+KlWIoERihixvpR3BfPu0UZQ1LuzVizpWbLUi6iOsLOwVorH9FVSZI
         +2SMJJPfKHDxyAs96lqV+gLINoz4v8NIpQ9/IbNtVXiQ5M33ec0M2ZmL8yTFYnrwE7
         q7wz9WSREiV27lddgTuK3a6JUIzPPdz+VGkiCt7E=
Date:   Tue, 19 Sep 2023 13:22:08 -0700
To:     mm-commits@vger.kernel.org, shr@devkernel.io, david@redhat.com,
        adobriyan@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] proc-fix-smaps_rollup-test-after-ksm-changes.patch removed from -mm tree
Message-Id: <20230919202208.AF51BC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/proc: fixup proc-empty-vm test after KSM changes
has been removed from the -mm tree.  Its filename was
     proc-fix-smaps_rollup-test-after-ksm-changes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: selftests/proc: fixup proc-empty-vm test after KSM changes
Date: Thu, 7 Sep 2023 14:10:12 +0300

/proc/${pid}/smaps_rollup is not empty file even if process's address
space is empty, update the test.

Link: https://lkml.kernel.org/r/725e041f-e9df-4f3d-b267-d4cd2774a78d@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/proc-empty-vm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/proc/proc-empty-vm.c~proc-fix-smaps_rollup-test-after-ksm-changes
+++ a/tools/testing/selftests/proc/proc-empty-vm.c
@@ -267,6 +267,7 @@ static const char g_smaps_rollup[] =
 "Private_Dirty:         0 kB\n"
 "Referenced:            0 kB\n"
 "Anonymous:             0 kB\n"
+"KSM:                   0 kB\n"
 "LazyFree:              0 kB\n"
 "AnonHugePages:         0 kB\n"
 "ShmemPmdMapped:        0 kB\n"
_

Patches currently in -mm which might be from adobriyan@gmail.com are

extract-and-use-file_line-macro.patch

