Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC1C5C433DF
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:12:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FCFD20639
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597529525;
	bh=cPddsZr2TriukXDrdAR40q1XaSKwcR7mRJ2iqIxajx4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=JAQ60GySsqfebEVs2EajFiOWmIDfMK3GMNRY4QDX3Pd5YQfqLKxbdslsjnBssjtAC
	 1teu93zuJjRZElWcHB3emHNGhfi08IGtMpHwLLwl1/pOimrTqkj8CkxztBCZBlhA3P
	 4gvTqx5d1N3mxwss7kUGSyJpJZS/vaw1hylvZ7Hs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbgHOWL6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:11:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729258AbgHOWK3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 325F722D6D;
        Sat, 15 Aug 2020 00:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451498;
        bh=cPddsZr2TriukXDrdAR40q1XaSKwcR7mRJ2iqIxajx4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WNB9gqjYMBHdfOAy/8tR+7IjrJWvngOG2E6w5giY3eXAFBUuM4M/6074u0N5P7/VZ
         8RiAHDXijJzPot8WX/dt8kYXIoig7Jg/+wd2kyPaFEx+rWK5v1nZAHU9WxhbUb2+V3
         ZMQr7djzNnKHq6nj3kVfPS2mxIcb0n02CCIke21s=
Date:   Fri, 14 Aug 2020 17:31:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cai@lca.pw, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com
Subject:  [patch 27/39] mm/memcontrol: fix a data race in scan
 count
Message-ID: <20200815003137.tAc9H8eZv%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Qian Cai <cai@lca.pw>
Subject: mm/memcontrol: fix a data race in scan count

struct mem_cgroup_per_node mz.lru_zone_size[zone_idx][lru] could be
accessed concurrently as noticed by KCSAN,

 BUG: KCSAN: data-race in lruvec_lru_size / mem_cgroup_update_lru_size

 write to 0xffff9c804ca285f8 of 8 bytes by task 50951 on cpu 12:
  mem_cgroup_update_lru_size+0x11c/0x1d0
  mem_cgroup_update_lru_size at mm/memcontrol.c:1266
  isolate_lru_pages+0x6a9/0xf30
  shrink_active_list+0x123/0xcc0
  shrink_lruvec+0x8fd/0x1380
  shrink_node+0x317/0xd80
  do_try_to_free_pages+0x1f7/0xa10
  try_to_free_pages+0x26c/0x5e0
  __alloc_pages_slowpath+0x458/0x1290
  __alloc_pages_nodemask+0x3bb/0x450
  alloc_pages_vma+0x8a/0x2c0
  do_anonymous_page+0x170/0x700
  __handle_mm_fault+0xc9f/0xd00
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 read to 0xffff9c804ca285f8 of 8 bytes by task 50964 on cpu 95:
  lruvec_lru_size+0xbb/0x270
  mem_cgroup_get_zone_lru_size at include/linux/memcontrol.h:536
  (inlined by) lruvec_lru_size at mm/vmscan.c:326
  shrink_lruvec+0x1d0/0x1380
  shrink_node+0x317/0xd80
  do_try_to_free_pages+0x1f7/0xa10
  try_to_free_pages+0x26c/0x5e0
  __alloc_pages_slowpath+0x458/0x1290
  __alloc_pages_nodemask+0x3bb/0x450
  alloc_pages_current+0xa6/0x120
  alloc_slab_page+0x3b1/0x540
  allocate_slab+0x70/0x660
  new_slab+0x46/0x70
  ___slab_alloc+0x4ad/0x7d0
  __slab_alloc+0x43/0x70
  kmem_cache_alloc+0x2c3/0x420
  getname_flags+0x4c/0x230
  getname+0x22/0x30
  do_sys_openat2+0x205/0x3b0
  do_sys_open+0x9a/0xf0
  __x64_sys_openat+0x62/0x80
  do_syscall_64+0x91/0xb47
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

 Reported by Kernel Concurrency Sanitizer on:
 CPU: 95 PID: 50964 Comm: cc1 Tainted: G        W  O L    5.5.0-next-20200204+ #6
 Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/10/2019

The write is under lru_lock, but the read is done as lockless.  The scan
count is used to determine how aggressively the anon and file LRU lists
should be scanned.  Load tearing could generate an inefficient heuristic,
so fix it by adding READ_ONCE() for the read.

Link: http://lkml.kernel.org/r/20200206034945.2481-1-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-fix-a-data-race-in-scan-count
+++ a/include/linux/memcontrol.h
@@ -630,7 +630,7 @@ unsigned long mem_cgroup_get_zone_lru_si
 	struct mem_cgroup_per_node *mz;
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	return mz->lru_zone_size[zone_idx][lru];
+	return READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
 }
 
 void mem_cgroup_handle_over_high(void);
_
