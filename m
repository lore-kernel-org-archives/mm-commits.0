Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0371C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BA5922CF6
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781556;
	bh=ce4neBU6X+Nr8OQlTN/dP6Ie8BCHq2dGf+sS7zv4IHk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Ywn2ul88Dc/rv0unVM6NXEPWs0TSf48rP4rivjQ3DjmgGtyCNlv3S/+NsQReLBcgR
	 0BK0BefWygYhai6IPMy3XHynVBdfSQCs74sh222HRVT/5KRlz9uEOQgSFC6dqAEbhg
	 OGAUBUkaQc7DZ6BZm8HIytwXa0nHQ9W/F5HCVXO4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgHGGZ4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHGGZ4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:25:56 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3902A22CAE;
        Fri,  7 Aug 2020 06:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781555;
        bh=ce4neBU6X+Nr8OQlTN/dP6Ie8BCHq2dGf+sS7zv4IHk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Z7JSPiUcihIuhQD30uTMmuX62yUmkq0NhLP/U8i5ZFkY0QlYT2d06sC75L5IMxmLO
         31zQlH2Zx+kTp3TDoEz2ALDvgszR9SuvLI1TW/QLtMPFNAN/ob1nKQUtGHGpbl920j
         FEALlpkN1S4JmExfFB6JSJV1uvxhQ+d8QmMwkwlg=
Date:   Thu, 06 Aug 2020 23:25:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, borntraeger@de.ibm.com, cai@lca.pw,
        dvyukov@google.com, glider@google.com, gor@linux.ibm.com,
        heiko.carstens@de.ibm.com, keescook@chromium.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 152/163] mm/page_alloc: silence a KASAN false
 positive
Message-ID: <20200807062554.7dNZPfXvz%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Qian Cai <cai@lca.pw>
Subject: mm/page_alloc: silence a KASAN false positive

kernel_init_free_pages() will use memset() on s390 to clear all pages from
kmalloc_order() which will override KASAN redzones because a redzone was
setup from the end of the allocation size to the end of the last page. 
Silence it by not reporting it there.  An example of the report is,

 BUG: KASAN: slab-out-of-bounds in __free_pages_ok
 Write of size 4096 at addr 000000014beaa000
 Call Trace:
 show_stack+0x152/0x210
 dump_stack+0x1f8/0x248
 print_address_description.isra.13+0x5e/0x4d0
 kasan_report+0x130/0x178
 check_memory_region+0x190/0x218
 memset+0x34/0x60
 __free_pages_ok+0x894/0x12f0
 kfree+0x4f2/0x5e0
 unpack_to_rootfs+0x60e/0x650
 populate_rootfs+0x56/0x358
 do_one_initcall+0x1f4/0xa20
 kernel_init_freeable+0x758/0x7e8
 kernel_init+0x1c/0x170
 ret_from_fork+0x24/0x28
 Memory state around the buggy address:
 000000014bea9f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 000000014bea9f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>000000014beaa000: 03 fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
                    ^
 000000014beaa080: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
 000000014beaa100: fe fe fe fe fe fe fe fe fe fe fe fe fe fe

Link: http://lkml.kernel.org/r/20200610052154.5180-1-cai@lca.pw
Fixes: 6471384af2a6 ("mm: security: introduce init_on_alloc=1 and init_on_free=1 boot options")
Signed-off-by: Qian Cai <cai@lca.pw>
Acked-by: Vasily Gorbik <gor@linux.ibm.com>
Tested-by: Vasily Gorbik <gor@linux.ibm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-silence-a-kasan-false-positive
+++ a/mm/page_alloc.c
@@ -1156,8 +1156,11 @@ static void kernel_init_free_pages(struc
 {
 	int i;
 
+	/* s390's use of memset() could override KASAN redzones. */
+	kasan_disable_current();
 	for (i = 0; i < numpages; i++)
 		clear_highpage(page + i);
+	kasan_enable_current();
 }
 
 static __always_inline bool free_pages_prepare(struct page *page,
_
