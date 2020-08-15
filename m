Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A87FC433DF
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2801520657
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597529462;
	bh=X6lX7m6NUoXLTN3olMcWyQXXrQGbAcHZenjZfttSmzs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=MJgb6SSNNWtfMBG2ZIWH891+bNQGtddiP2casFIlECLDvfCoKdmgXgyKm/PoeaX5e
	 I/y9DNIXutPdhr2MddstGdfXI9QO/yLejxlj4tEHJwLNg8VBGr7/B/lPKFTHTImz5A
	 5SA+ny84qFFlLFG9CT5vB4y3p1ep/gMyY7EfF2tY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729772AbgHOWKy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729462AbgHOWKb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:31 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BCF422D3E;
        Sat, 15 Aug 2020 00:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451514;
        bh=X6lX7m6NUoXLTN3olMcWyQXXrQGbAcHZenjZfttSmzs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Txr9I1xZDkIJaXBWBOeIU2vnJV4D1GZKoOKacPQR2ucIqDhaB6iwHgCGHLWBkH9m8
         P+xKsJi+R3LWmegt1gmNzRqXUod1LmOigoA2cvwLn6LjphMdnTK5ssmOCNYZgLyALf
         3MWYf13YC1GvFkWXmtNcG/nBZkU9Cq0bmHDE4IhQ=
Date:   Fri, 14 Aug 2020 17:31:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cai@lca.pw, dan.j.williams@intel.com,
        david@redhat.com, elver@google.com, ira.weiny@intel.com,
        jack@suse.cz, jhubbard@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, paulmck@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 32/39] mm: annotate a data race in page_zonenum()
Message-ID: <20200815003153.u2a5W_kRT%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
