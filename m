Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDBE2C4338F
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 02:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C519E6105A
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 02:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbhHECEp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Aug 2021 22:04:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231173AbhHECEn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 4 Aug 2021 22:04:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80D9A60FC4;
        Thu,  5 Aug 2021 02:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628129069;
        bh=wgLvJ/G1HktjU2ga7A8Nqjm95X2xRoH1P4CD7ke09TY=;
        h=Date:From:To:Subject:From;
        b=mbtUrV3Xktzlg0CaWeFt0IZDNBVxqK9vuGJpYl2O+dHWnhyrNxGnotiPIRTZOgd52
         LE6w88jJDGfpTC4D5jWWRSyjLFo1eNcdGKnpn9YZQRHqQN5saExld861LW9GuMpv9o
         LqRD0KiePSaIXX8Al2OLROD+Jod/6UCGCMhgWiMU=
Date:   Wed, 04 Aug 2021 19:04:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, david@redhat.com, zhangkui@oppo.com
Subject:  + mm-madvise-add-madv_willneed-to-process_madvise.patch
 added to -mm tree
Message-ID: <20210805020429.kdf7D%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise: add MADV_WILLNEED to process_madvise()
has been added to the -mm tree.  Its filename is
     mm-madvise-add-madv_willneed-to-process_madvise.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-add-madv_willneed-to-process_madvise.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-add-madv_willneed-to-process_madvise.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: zhangkui <zhangkui@oppo.com>
Subject: mm/madvise: add MADV_WILLNEED to process_madvise()

There is a usecase in Android that an app process's memory is swapped out
by process_madvise() with MADV_PAGEOUT, such as the memory is swapped to
zram or a backing device.  When the process is scheduled to running, like
switch to foreground, multiple page faults may cause the app dropped
frames.

To reduce the problem, SMS can read-ahead memory of the process
immediately when the app switches to forground.  Calling process_madvise()
with MADV_WILLNEED can meet this need.

Link: https://lkml.kernel.org/r/20210804082010.12482-1-zhangkui@oppo.com
Signed-off-by: zhangkui <zhangkui@oppo.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/madvise.c~mm-madvise-add-madv_willneed-to-process_madvise
+++ a/mm/madvise.c
@@ -1048,6 +1048,7 @@ process_madvise_behavior_valid(int behav
 	switch (behavior) {
 	case MADV_COLD:
 	case MADV_PAGEOUT:
+	case MADV_WILLNEED:
 		return true;
 	default:
 		return false;
_

Patches currently in -mm which might be from zhangkui@oppo.com are

mm-madvise-add-madv_willneed-to-process_madvise.patch

