Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B2DBC636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbjBCGf4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbjBCGfe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926FD55BD
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ACFEBCE2EA3
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3187C4339C;
        Fri,  3 Feb 2023 06:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406130;
        bh=mh/jHjmT/blNRsz20Hofnuf0BN1KaD3L4XTMCwc0EMc=;
        h=Date:To:From:Subject:From;
        b=cZJxWavrvgOwPSLt0XKGgZ8hOASkrT1NUgwY09+GGbzCZMCcbhA84SLfQdMH8WeLd
         0/fr5mbfVYo37b8HyN9HA5s/4ewtp8KV+NOWd24AZq07cxonixYk2OtusIlhV+8vAv
         pVaMZoKKO5h2xpSUc2RrSMJFhljfiRQ5mw0ShzLA=
Date:   Thu, 02 Feb 2023 22:35:29 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-add-missing-kcompactd-wakeup-trace-event.patch removed from -mm tree
Message-Id: <20230203063529.E3187C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: add missing kcompactd wakeup trace event
has been removed from the -mm tree.  Its filename was
     mm-compaction-add-missing-kcompactd-wakeup-trace-event.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: add missing kcompactd wakeup trace event
Date: Tue, 10 Jan 2023 21:36:21 +0800

Add missing kcompactd wakeup trace event for proactive compaction,
meanwhile use order = -1 and the highest zone index of the pgdat for the
kcompactd wakeup trace event by proactive compaction.

Link: https://lkml.kernel.org/r/cbf8097a2d8a1b6800991f2a21575550d3613ce6.1673342761.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/compaction.c~mm-compaction-add-missing-kcompactd-wakeup-trace-event
+++ a/mm/compaction.c
@@ -2730,6 +2730,8 @@ int compaction_proactiveness_sysctl_hand
 				continue;
 
 			pgdat->proactive_compact_trigger = true;
+			trace_mm_compaction_wakeup_kcompactd(pgdat->node_id, -1,
+							     pgdat->nr_zones - 1);
 			wake_up_interruptible(&pgdat->kcompactd_wait);
 		}
 	}
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


