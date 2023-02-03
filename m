Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E85C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbjBCGnf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbjBCGmI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF6114491
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D57A61DAC
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C264FC4339B;
        Fri,  3 Feb 2023 06:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406297;
        bh=cgi6uo+9AZ2R/VFL+7Pn5q9O/1XsTVRQEZtSqESv3N8=;
        h=Date:To:From:Subject:From;
        b=d2/9B2HdYDE8VlSOyLdnmUgp1YmlPgU9a3m1/qRMPXBXNr/6NC6hLi75OUshNLv2g
         E1xlFzklY0ONmURJ7+Y2m4SiW98sz07k/9lmHxqZnX4fwZa41L3R07t/PW5IfpM+TO
         MLwnUGowMYegBcg57UAnxs3WIKgJE2NSYfEqqJaY=
Date:   Thu, 02 Feb 2023 22:38:17 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        tony.luck@intel.com, shy828301@gmail.com, rientjes@google.com,
        naoya.horiguchi@nec.com, jiaqiyan@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-bump-memory-failure-stats-to-pglist_data.patch removed from -mm tree
Message-Id: <20230203063817.C264FC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory-failure: bump memory failure stats to pglist_data
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-bump-memory-failure-stats-to-pglist_data.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: mm: memory-failure: bump memory failure stats to pglist_data
Date: Fri, 20 Jan 2023 03:46:21 +0000

Right before memory_failure finishes its handling, accumulate poisoned
page's resolution counters to pglist_data's memory_failure_stats, so as to
update the corresponding sysfs entries.

Tested:
1) Start an application to allocate memory buffer chunks
2) Convert random memory buffer addresses to physical addresses
3) Inject memory errors using EINJ at chosen physical addresses
4) Access poisoned memory buffer and recover from SIGBUS
5) Check counter values under
   /sys/devices/system/node/node*/memory_failure/*

Link: https://lkml.kernel.org/r/20230120034622.2698268-3-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory-failure.c~mm-memory-failure-bump-memory-failure-stats-to-pglist_data
+++ a/mm/memory-failure.c
@@ -1227,6 +1227,39 @@ static struct page_state error_states[]
 #undef slab
 #undef reserved
 
+static void update_per_node_mf_stats(unsigned long pfn,
+				     enum mf_result result)
+{
+	int nid = MAX_NUMNODES;
+	struct memory_failure_stats *mf_stats = NULL;
+
+	nid = pfn_to_nid(pfn);
+	if (unlikely(nid < 0 || nid >= MAX_NUMNODES)) {
+		WARN_ONCE(1, "Memory failure: pfn=%#lx, invalid nid=%d", pfn, nid);
+		return;
+	}
+
+	mf_stats = &NODE_DATA(nid)->mf_stats;
+	switch (result) {
+	case MF_IGNORED:
+		++mf_stats->ignored;
+		break;
+	case MF_FAILED:
+		++mf_stats->failed;
+		break;
+	case MF_DELAYED:
+		++mf_stats->delayed;
+		break;
+	case MF_RECOVERED:
+		++mf_stats->recovered;
+		break;
+	default:
+		WARN_ONCE(1, "Memory failure: mf_result=%d is not properly handled", result);
+		break;
+	}
+	++mf_stats->total;
+}
+
 /*
  * "Dirty/Clean" indication is not 100% accurate due to the possibility of
  * setting PG_dirty outside page lock. See also comment above set_page_dirty().
@@ -1237,6 +1270,9 @@ static int action_result(unsigned long p
 	trace_memory_failure_event(pfn, type, result);
 
 	num_poisoned_pages_inc(pfn);
+
+	update_per_node_mf_stats(pfn, result);
+
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
 
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-khugepaged-recover-from-poisoned-anonymous-memory.patch
mm-khugepaged-recover-from-poisoned-file-backed-memory.patch

