Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A2DC433DF
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5274E20639
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597529551;
	bh=7Kmtoss9B2wqqJa6OYhDZvxmObVoM3fZi1CVnChqzxc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=SO58jjYrxUPDHkNMfyOBwCwqu33KOotrvQ1du48Ra46wdMhvf6JrTyZTVD63QcHsw
	 /03O0Hf0efc7VC6IW2rzp/hvqYbixXZuvqsoHl3k8CCbOhqkdi8p6oDvaTly6sOYHT
	 eXjKeavTFR72HESpBlk+oOfUD/4mo75sYoeDA7H8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbgHOWMU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:12:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729042AbgHOWK2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:28 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D383022D0B;
        Sat, 15 Aug 2020 00:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451495;
        bh=7Kmtoss9B2wqqJa6OYhDZvxmObVoM3fZi1CVnChqzxc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=J8dFhBRQXXcoVEPKDX2P9sDGwGAkOADOEeUAEwBB4SDl+8IVTqQavG6LLG4p7I6rb
         lhdP5+qhDCOZrwyldArCcLIgIKcC7oW2QZ25VfnSJBnV1pAf27n8YsdpPdOgdHYdnN
         4a2m4uHSR2V+F9EYKAwDhjTSFJQGW0cF1yDsLv5s=
Date:   Fri, 14 Aug 2020 17:31:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cai@lca.pw, david@redhat.com,
        dvyukov@google.com, elver@google.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        penguin-kernel@I-love.SAKURA.ne.jp, torvalds@linux-foundation.org
Subject:  [patch 26/39] mm/page_counter: fix various data races at
 memsw
Message-ID: <20200815003134.sVViWEyRz%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Qian Cai <cai@lca.pw>
Subject: mm/page_counter: fix various data races at memsw

Commit 3e32cb2e0a12 ("mm: memcontrol: lockless page counters") could had
memcg->memsw->watermark and memcg->memsw->failcnt been accessed
concurrently as reported by KCSAN,

 BUG: KCSAN: data-race in page_counter_try_charge / page_counter_try_charge

 read to 0xffff8fb18c4cd190 of 8 bytes by task 1081 on cpu 59:
  page_counter_try_charge+0x4d/0x150 mm/page_counter.c:138
  try_charge+0x131/0xd50 mm/memcontrol.c:2405
  __memcg_kmem_charge_memcg+0x58/0x140
  __memcg_kmem_charge+0xcc/0x280
  __alloc_pages_nodemask+0x1e1/0x450
  alloc_pages_current+0xa6/0x120
  pte_alloc_one+0x17/0xd0
  __pte_alloc+0x3a/0x1f0
  copy_p4d_range+0xc36/0x1990
  copy_page_range+0x21d/0x360
  dup_mmap+0x5f5/0x7a0
  dup_mm+0xa2/0x240
  copy_process+0x1b3f/0x3460
  _do_fork+0xaa/0xa20
  __x64_sys_clone+0x13b/0x170
  do_syscall_64+0x91/0xb47
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

 write to 0xffff8fb18c4cd190 of 8 bytes by task 1153 on cpu 120:
  page_counter_try_charge+0x5b/0x150 mm/page_counter.c:139
  try_charge+0x131/0xd50 mm/memcontrol.c:2405
  mem_cgroup_try_charge+0x159/0x460
  mem_cgroup_try_charge_delay+0x3d/0xa0
  wp_page_copy+0x14d/0x930
  do_wp_page+0x107/0x7b0
  __handle_mm_fault+0xce6/0xd40
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 BUG: KCSAN: data-race in page_counter_try_charge / page_counter_try_charge

 write to 0xffff88809bbf2158 of 8 bytes by task 11782 on cpu 0:
  page_counter_try_charge+0x100/0x170 mm/page_counter.c:129
  try_charge+0x185/0xbf0 mm/memcontrol.c:2405
  __memcg_kmem_charge_memcg+0x4a/0xe0 mm/memcontrol.c:2837
  __memcg_kmem_charge+0xcf/0x1b0 mm/memcontrol.c:2877
  __alloc_pages_nodemask+0x26c/0x310 mm/page_alloc.c:4780

 read to 0xffff88809bbf2158 of 8 bytes by task 11814 on cpu 1:
  page_counter_try_charge+0xef/0x170 mm/page_counter.c:129
  try_charge+0x185/0xbf0 mm/memcontrol.c:2405
  __memcg_kmem_charge_memcg+0x4a/0xe0 mm/memcontrol.c:2837
  __memcg_kmem_charge+0xcf/0x1b0 mm/memcontrol.c:2877
  __alloc_pages_nodemask+0x26c/0x310 mm/page_alloc.c:4780

Since watermark could be compared or set to garbage due to a data race
which would change the code logic, fix it by adding a pair of READ_ONCE()
and WRITE_ONCE() in those places.

The "failcnt" counter is tolerant of some degree of inaccuracy and is only
used to report stats, a data race will not be harmful, thus mark it as an
intentional data race using the data_race() macro.

Link: http://lkml.kernel.org/r/1581519682-23594-1-git-send-email-cai@lca.pw
Fixes: 3e32cb2e0a12 ("mm: memcontrol: lockless page counters")
Signed-off-by: Qian Cai <cai@lca.pw>
Reported-by: syzbot+f36cfe60b1006a94f9dc@syzkaller.appspotmail.com
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_counter.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/page_counter.c~mm-page_counter-fix-various-data-races-at-memsw
+++ a/mm/page_counter.c
@@ -77,8 +77,8 @@ void page_counter_charge(struct page_cou
 		 * This is indeed racy, but we can live with some
 		 * inaccuracy in the watermark.
 		 */
-		if (new > c->watermark)
-			c->watermark = new;
+		if (new > READ_ONCE(c->watermark))
+			WRITE_ONCE(c->watermark, new);
 	}
 }
 
@@ -119,9 +119,10 @@ bool page_counter_try_charge(struct page
 			propagate_protected_usage(c, new);
 			/*
 			 * This is racy, but we can live with some
-			 * inaccuracy in the failcnt.
+			 * inaccuracy in the failcnt which is only used
+			 * to report stats.
 			 */
-			c->failcnt++;
+			data_race(c->failcnt++);
 			*fail = c;
 			goto failed;
 		}
@@ -130,8 +131,8 @@ bool page_counter_try_charge(struct page
 		 * Just like with failcnt, we can live with some
 		 * inaccuracy in the watermark.
 		 */
-		if (new > c->watermark)
-			c->watermark = new;
+		if (new > READ_ONCE(c->watermark))
+			WRITE_ONCE(c->watermark, new);
 	}
 	return true;
 
_
