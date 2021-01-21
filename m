Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 165C8C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 21 Jan 2021 22:22:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4348221E5
	for <mm-commits@archiver.kernel.org>; Thu, 21 Jan 2021 22:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbhAUWWH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Jan 2021 17:22:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:44584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbhAUWV5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Jan 2021 17:21:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C850221E5;
        Thu, 21 Jan 2021 22:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611267672;
        bh=Xfb17/TcavLp9dee9Vn1JUKQ9MY9eAyDNkPaSev57WM=;
        h=Date:From:To:Subject:From;
        b=WMmc7VMERfJiSUWyQ6bYarRj+QZ1ivZFrg4ps7koXMBbJiKsWTPSXm3amIBSwgO8E
         MsivWRBoODzIJVwjioyHYsnOWBwbo5qNvRqVxtgl8ReB+GQzDr32Lp22hSQHDxq6dh
         Jt25y2/owFjzyzy/+6RrC/uHaCf7MD0YE8wcEjQY=
Date:   Thu, 21 Jan 2021 14:21:10 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, ddstreet@ieee.org, efault@gmx.de,
        lkp@intel.com, mm-commits@vger.kernel.org, sjenning@redhat.com,
        song.bao.hua@hisilicon.com, tiantao6@hisilicon.com,
        vitaly.wool@konsulko.com
Subject:  +
 mm-zswap-fix-variable-entry-is-uninitialized-when-used.patch added to -mm
 tree
Message-ID: <20210121222110.JxcJlqs8h%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap: fix variable 'entry' is uninitialized when used
has been added to the -mm tree.  Its filename is
     mm-zswap-fix-variable-entry-is-uninitialized-when-used.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-zswap-fix-variable-entry-is-uninitialized-when-used.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-zswap-fix-variable-entry-is-uninitialized-when-used.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tian Tao <tiantao6@hisilicon.com>
Subject: mm/zswap: fix variable 'entry' is uninitialized when used

the entry has not been initialized when it is used, so allocate PAGE_SIZE

Link: https://lkml.kernel.org/r/1611223030-58346-1-git-send-email-tiantao6@hisilicon.com
Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-fix-variable-entry-is-uninitialized-when-used
+++ a/mm/zswap.c
@@ -944,7 +944,7 @@ static int zswap_writeback_entry(struct
 
 	if (!zpool_can_sleep_mapped(pool)) {
 
-		tmp = kmalloc(entry->length, GFP_ATOMIC);
+		tmp = kmalloc(PAGE_SIZE, GFP_ATOMIC);
 		if (!tmp)
 			return -ENOMEM;
 	}
_

Patches currently in -mm which might be from tiantao6@hisilicon.com are

mm-zswap-add-the-flag-can_sleep_mapped.patch
mm-zswap-fix-variable-entry-is-uninitialized-when-used.patch
mm-set-the-sleep_mapped-to-true-for-zbud-and-z3fold.patch

