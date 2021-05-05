Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E12CC433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3594C611AB
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhEEBit (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:38:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231124AbhEEBis (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:38:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDF2D61182;
        Wed,  5 May 2021 01:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178672;
        bh=8YIVxARpDwdJ824qQd5KRYSfeQowbwustDIsLRszFBA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Qb9m3EJBRgKhNTLO1ULF5qj+tRQbG1l8UYcGy5DiQ4RjwpqmV3HrhB6wovPr1kB6m
         qRvvdf199K+x0tcOpIcQBiZzC1lmO6hCnrNnZxyAwC0LEB8mE8SHuSLZoODcI8z/CN
         WSA1APaqe78m6ap/HVdadx8r7JHDm9F7GnDKIfv0=
Date:   Tue, 04 May 2021 18:37:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        hughd@google.com, linux-mm@kvack.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 096/143] mm: restore node stat checking in
 /proc/sys/vm/stat_refresh
Message-ID: <20210505013751.BS8Z6yw4k%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hugh Dickins <hughd@google.com>
Subject: mm: restore node stat checking in /proc/sys/vm/stat_refresh

v4.7 52b6f46bc163 ("mm: /proc/sys/vm/stat_refresh to force vmstat update")
introduced vmstat_refresh(), with its vmstat underflow checking; then v4.8
75ef71840539 ("mm, vmstat: add infrastructure for per-node vmstats") split
NR_VM_NODE_STAT_ITEMS out of NR_VM_ZONE_STAT_ITEMS without updating
vmstat_refresh(): so it has been missing out much of the vmstat underflow
checking ever since.  Reinstate it.  Thanks to Roman Gushchin
<guro@fb.com> for tangentially pointing this out.

Link: https://lkml.kernel.org/r/alpine.LSU.2.11.2102251502240.13363@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/vmstat.c~mm-restore-node-stat-checking-in-proc-sys-vm-stat_refresh
+++ a/mm/vmstat.c
@@ -1875,6 +1875,14 @@ int vmstat_refresh(struct ctl_table *tab
 		}
 	}
 #endif
+	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
+		val = atomic_long_read(&vm_node_stat[i]);
+		if (val < 0) {
+			pr_warn("%s: %s %ld\n",
+				__func__, node_stat_name(i), val);
+			err = -EINVAL;
+		}
+	}
 	if (err)
 		return err;
 	if (write)
_
