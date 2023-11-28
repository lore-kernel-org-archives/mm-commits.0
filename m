Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F93CC07E98
	for <mm-commits@archiver.kernel.org>; Tue, 28 Nov 2023 23:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376664AbjK1X7B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Nov 2023 18:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376640AbjK1X65 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Nov 2023 18:58:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99920DA
        for <mm-commits@vger.kernel.org>; Tue, 28 Nov 2023 15:59:03 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35147C433C8;
        Tue, 28 Nov 2023 23:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701215943;
        bh=bP38mNTBp68MbQB9LmdPaNn5bwVzYQ62BMN1qqPtOhI=;
        h=Date:To:From:Subject:From;
        b=qROfgSJIvS3aX5csDtCXOhPgDXKs9hpOO2FDEnMHMvBxDezNT6sgra3TmAl9ITCsB
         bFoR1cxU37NDXYag3l2LFjVknDJ7B8euWGvYq4fccB1xyhZS8Urw3V4fqtHOYQMCFM
         nZ5aZiPo/aS7pvx5y7cpVbyaYm4jtA/qB3rqaPUA=
Date:   Tue, 28 Nov 2023 15:59:02 -0800
To:     mm-commits@vger.kernel.org, osalvador@suse.de, mhocko@suse.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, david@redhat.com,
        anshuman.khandual@arm.com, aneesh.kumar@linux.ibm.com,
        agordeev@linux.ibm.com, sumanthk@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-sclp-remove-unhandled-memory-notifier-type.patch added to mm-unstable branch
Message-Id: <20231128235903.35147C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: s390/sclp: remove unhandled memory notifier type
has been added to the -mm mm-unstable branch.  Its filename is
     s390-sclp-remove-unhandled-memory-notifier-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-sclp-remove-unhandled-memory-notifier-type.patch

This patch will later appear in the mm-unstable branch at
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
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: s390/sclp: remove unhandled memory notifier type
Date: Tue, 28 Nov 2023 16:52:25 +0100

Remove memory notifier types which are unhandled by s390.  Unhandled
memory notifier types are covered by default case.

Link: https://lkml.kernel.org/r/20231128155227.1315063-4-sumanthk@linux.ibm.com
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Suggested-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/char/sclp_cmd.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/s390/char/sclp_cmd.c~s390-sclp-remove-unhandled-memory-notifier-type
+++ a/drivers/s390/char/sclp_cmd.c
@@ -340,9 +340,6 @@ static int sclp_mem_notifier(struct noti
 		if (contains_standby_increment(start, start + size))
 			rc = -EPERM;
 		break;
-	case MEM_ONLINE:
-	case MEM_CANCEL_OFFLINE:
-		break;
 	case MEM_GOING_ONLINE:
 		rc = sclp_mem_change_state(start, size, 1);
 		break;
_

Patches currently in -mm which might be from sumanthk@linux.ibm.com are

mm-memory_hotplug-add-missing-mem_hotplug_lock.patch
mm-memory_hotplug-fix-error-handling-in-add_memory_resource.patch
mm-use-vmem_altmap-code-without-config_zone_device.patch
mm-memory_hotplug-introduce-mem_prepare_online-mem_finish_offline-notifiers.patch
s390-mm-allocate-vmemmap-pages-from-self-contained-memory-range.patch
s390-sclp-remove-unhandled-memory-notifier-type.patch
s390-mm-implement-mem_prepare_online-mem_finish_offline-notifiers.patch
s390-enable-mhp_memmap_on_memory.patch

