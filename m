Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB7FC433E1
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CB3620789
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597790477;
	bh=qvfmI7VWb37LZVLmv96s5kIYnoos/zUIZMLVARWU0Pw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=VcWC3ZEq3Zj92zf/HpkTkxAf0xkXN5t8owRhyAcPZHXCzr0zs23BVTbRJlJUluaFp
	 D0sFNHTKH+ITo4OLUMCtYvOHaLWM38s0QV8S8kTjs9rHUHCxUcYJOp5Du1po2G5cMo
	 FyfT/EJ351Qw39qor8LOKI9iYiUfV59KPADp/ab8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgHRWlR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:41:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727768AbgHRWlN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 18:41:13 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E3A320674;
        Tue, 18 Aug 2020 22:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597790472;
        bh=qvfmI7VWb37LZVLmv96s5kIYnoos/zUIZMLVARWU0Pw=;
        h=Date:From:To:Subject:From;
        b=0oeoRtcrSaqNDNYyaDw9YGJftlQQo2vcXRqlNtCLTKsm7XrjAlXgh7hY9wypcJYoP
         wKHYRdM+RsCes/JYIzvPrlkDcz1OJ/1lU8mXTpIjn6ZnJjJEqjPgHM81DgsHSR+wl4
         R6ifqts0OyT+6E1CKgkqFdfcUp90ZeQcRLjN2CeQ=
Date:   Tue, 18 Aug 2020 15:41:12 -0700
From:   akpm@linux-foundation.org
To:     cai@lca.pw, dan.j.williams@intel.com, david@redhat.com,
        elver@google.com, ira.weiny@intel.com, jack@suse.cz,
        jhubbard@nvidia.com, mm-commits@vger.kernel.org, paulmck@kernel.org
Subject:  [merged] mm-annotate-a-data-race-in-page_zonenum.patch
 removed from -mm tree
Message-ID: <20200818224112.YHcIg0hP5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: annotate a data race in page_zonenum()
has been removed from the -mm tree.  Its filename was
     mm-annotate-a-data-race-in-page_zonenum.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm: annotate a data race in page_zonenum()

 BUG: KCSAN: data-race in page_cpupid_xchg_last / put_page

 write (marked) to 0xfffffc0d48ec1a00 of 8 bytes by task 91442 on cpu 3:
  page_cpupid_xchg_last+0x51/0x80
  page_cpupid_xchg_last at mm/mmzone.c:109 (discriminator 11)
  wp_page_reuse+0x3e/0xc0
  wp_page_reuse at mm/memory.c:2453
  do_wp_page+0x472/0x7b0
  do_wp_page at mm/memory.c:2798
  __handle_mm_fault+0xcb0/0xd00
  handle_pte_fault at mm/memory.c:4049
  (inlined by) __handle_mm_fault at mm/memory.c:4163
  handle_mm_fault+0xfc/0x2f0
  handle_mm_fault at mm/memory.c:4200
  do_page_fault+0x263/0x6f9
  do_user_addr_fault at arch/x86/mm/fault.c:1465
  (inlined by) do_page_fault at arch/x86/mm/fault.c:1539
  page_fault+0x34/0x40

 read to 0xfffffc0d48ec1a00 of 8 bytes by task 94817 on cpu 69:
  put_page+0x15a/0x1f0
  page_zonenum at include/linux/mm.h:923
  (inlined by) is_zone_device_page at include/linux/mm.h:929
  (inlined by) page_is_devmap_managed at include/linux/mm.h:948
  (inlined by) put_page at include/linux/mm.h:1023
  wp_page_copy+0x571/0x930
  wp_page_copy at mm/memory.c:2615
  do_wp_page+0x107/0x7b0
  __handle_mm_fault+0xcb0/0xd00
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 Reported by Kernel Concurrency Sanitizer on:
 CPU: 69 PID: 94817 Comm: systemd-udevd Tainted: G        W  O L 5.5.0-next-20200204+ #6
 Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/10/2019

A page never changes its zone number. The zone number happens to be
stored in the same word as other bits which are modified, but the zone
number bits will never be modified by any other write, so it can accept
a reload of the zone bits after an intervening write and it don't need
to use READ_ONCE(). Thus, annotate this data race using
ASSERT_EXCLUSIVE_BITS() to also assert that there are no concurrent
writes to it.

Link: http://lkml.kernel.org/r/1581619089-14472-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Suggested-by: Marco Elver <elver@google.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/mm.h~mm-annotate-a-data-race-in-page_zonenum
+++ a/include/linux/mm.h
@@ -1067,6 +1067,7 @@ vm_fault_t finish_mkwrite_fault(struct v
 
 static inline enum zone_type page_zonenum(const struct page *page)
 {
+	ASSERT_EXCLUSIVE_BITS(page->flags, ZONES_MASK << ZONES_PGSHIFT);
 	return (page->flags >> ZONES_PGSHIFT) & ZONES_MASK;
 }
 
_

Patches currently in -mm which might be from cai@lca.pw are

fork-silence-a-false-postive-warning-in-__mmdrop.patch

