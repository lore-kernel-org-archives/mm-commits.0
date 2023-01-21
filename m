Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D1A1C05027
	for <mm-commits@archiver.kernel.org>; Sat, 21 Jan 2023 01:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjAUB2m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 20:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjAUB2i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 20:28:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836BF5CE68
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2023 17:28:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 200FD61E1F
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 01:28:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71556C433D2;
        Sat, 21 Jan 2023 01:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674264516;
        bh=oY169n2oub5XlUh8Cfost2j00G2s9mNdvgPj2YcDKl4=;
        h=Date:To:From:Subject:From;
        b=CRu/0XN+JW0fLvJGYhYtGWxBLwpOf9cUyTFWgNFgKzfigcxxYxPFCqvvnS6LemNOF
         oWq14eA4ZQ0JnjqIIYM1xQ5w5Ehb5yt6oImk8ojDO0ZgYqrM76EkzxXmBY5iQi2mcq
         WsHvhRW/oYN12rLcTGzEsccbPpvgFNvrHx9qhtUI=
Date:   Fri, 20 Jan 2023 17:28:35 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        tony.luck@intel.com, shy828301@gmail.com, rientjes@google.com,
        naoya.horiguchi@nec.com, jiaqiyan@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-document-memory-failure-stats.patch added to mm-unstable branch
Message-Id: <20230121012836.71556C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory-failure: document memory failure stats
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-document-memory-failure-stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-document-memory-failure-stats.patch

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
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: mm: memory-failure: document memory failure stats
Date: Fri, 20 Jan 2023 03:46:22 +0000

Add documentation for memory_failure's per NUMA node sysfs entries

Link: https://lkml.kernel.org/r/20230120034622.2698268-4-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/ABI/stable/sysfs-devices-node~mm-memory-failure-document-memory-failure-stats
+++ a/Documentation/ABI/stable/sysfs-devices-node
@@ -182,3 +182,42 @@ Date:		November 2021
 Contact:	Jarkko Sakkinen <jarkko@kernel.org>
 Description:
 		The total amount of SGX physical memory in bytes.
+
+What:		/sys/devices/system/node/nodeX/memory_failure/total
+Date:		January 2023
+Contact:	Jiaqi Yan <jiaqiyan@google.com>
+Description:
+		The total number of raw poisoned pages (pages containing
+		corrupted data due to memory errors) on a NUMA node.
+
+What:		/sys/devices/system/node/nodeX/memory_failure/ignored
+Date:		January 2023
+Contact:	Jiaqi Yan <jiaqiyan@google.com>
+Description:
+		Of the raw poisoned pages on a NUMA node, how many pages are
+		ignored by memory error recovery attempt, usually because
+		support for this type of pages is unavailable, and kernel
+		gives up the recovery.
+
+What:		/sys/devices/system/node/nodeX/memory_failure/failed
+Date:		January 2023
+Contact:	Jiaqi Yan <jiaqiyan@google.com>
+Description:
+		Of the raw poisoned pages on a NUMA node, how many pages are
+		failed by memory error recovery attempt. This usually means
+		a key recovery operation failed.
+
+What:		/sys/devices/system/node/nodeX/memory_failure/delayed
+Date:		January 2023
+Contact:	Jiaqi Yan <jiaqiyan@google.com>
+Description:
+		Of the raw poisoned pages on a NUMA node, how many pages are
+		delayed by memory error recovery attempt. Delayed poisoned
+		pages usually will be retried by kernel.
+
+What:		/sys/devices/system/node/nodeX/memory_failure/recovered
+Date:		January 2023
+Contact:	Jiaqi Yan <jiaqiyan@google.com>
+Description:
+		Of the raw poisoned pages on a NUMA node, how many pages are
+		recovered by memory error recovery attempt.
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-khugepaged-recover-from-poisoned-anonymous-memory.patch
mm-khugepaged-recover-from-poisoned-file-backed-memory.patch
mm-memory-failure-add-memory-failure-stats-to-sysfs.patch
mm-memory-failure-bump-memory-failure-stats-to-pglist_data.patch
mm-memory-failure-document-memory-failure-stats.patch

