Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84AE9C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbjBCGnn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:43:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232428AbjBCGmJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE82166DC
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8163F61DA8
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F7AC433EF;
        Fri,  3 Feb 2023 06:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406299;
        bh=4lVwz3rQ9bpcYgh6/38Pjns/Pc+omgliBIAZ2yM5ekU=;
        h=Date:To:From:Subject:From;
        b=d94yJN7x57fbCuMc9aE+ny/XBriLEGbWMebU4240LvcbeTcTUpviETJTEodn1i7N5
         t5h5Uu+sZ1nnbTpHcWbX4wAsxE8IuYbZ4j1DiW4/UtYuBQCOccPg0WNgeELVKILvrh
         4ekDbOCqEhjeA/Bf1oX2tk2Qb1ldA9KPfS3/YUxU=
Date:   Thu, 02 Feb 2023 22:38:18 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        tony.luck@intel.com, shy828301@gmail.com, rientjes@google.com,
        naoya.horiguchi@nec.com, jiaqiyan@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-document-memory-failure-stats.patch removed from -mm tree
Message-Id: <20230203063818.D9F7AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory-failure: document memory failure stats
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-document-memory-failure-stats.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: mm: memory-failure: document memory failure stats
Date: Fri, 20 Jan 2023 03:46:22 +0000

Add documentation for memory_failure's per NUMA node sysfs entries

Link: https://lkml.kernel.org/r/20230120034622.2698268-4-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
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

