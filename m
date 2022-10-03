Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12C1DC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbiJCVPK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiJCVNu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:13:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302E3543F2
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:08:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D490FB81611
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723F2C433C1;
        Mon,  3 Oct 2022 21:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831329;
        bh=JL2R+Vt2WEaGV3957sjja0lUwyFQUcfvVNOZvAUYFHI=;
        h=Date:To:From:Subject:From;
        b=BI2VJCfJNTL/ggUue+M9FD29toVDAzroccw0kF4SdkPCb2126/eeVSJfeXIRQRAm3
         tcjVm4j74CI5gnMRAar9byHQ3UWXq4E+lxgBXYD58mWFQSU2amXYuF3OR4k32zpYVG
         z87j5eKprgxwHrq9LkN1BA5RumXR2nrqLK3t8lyU=
Date:   Mon, 03 Oct 2022 14:08:48 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, vegard.nossum@oracle.com, vbabka@suse.cz,
        tglx@linutronix.de, sfr@canb.auug.org.au, rostedt@goodmis.org,
        rientjes@google.com, pmladek@suse.com, peterz@infradead.org,
        penberg@kernel.org, mst@redhat.com, mingo@redhat.com,
        mark.rutland@arm.com, luto@kernel.org, keescook@chromium.org,
        iii@linux.ibm.com, iamjoonsoo.kim@lge.com,
        herbert@gondor.apana.org.au, hch@lst.de,
        gregkh@linuxfoundation.org, gor@linux.ibm.com, elver@google.com,
        edumazet@google.com, ebiggers@kernel.org, ebiggers@google.com,
        dvyukov@google.com, cl@linux.com, bp@alien8.de, axboe@kernel.dk,
        ast@kernel.org, arnd@arndb.de, andreyknvl@google.com,
        andreyknvl@gmail.com, glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] block-kmsan-skip-bio-block-merging-logic-for-kmsan.patch removed from -mm tree
Message-Id: <20221003210849.723F2C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: block: kmsan: skip bio block merging logic for KMSAN
has been removed from the -mm tree.  Its filename was
     block-kmsan-skip-bio-block-merging-logic-for-kmsan.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: block: kmsan: skip bio block merging logic for KMSAN
Date: Thu, 15 Sep 2022 17:04:02 +0200

KMSAN doesn't allow treating adjacent memory pages as such, if they were
allocated by different alloc_pages() calls.  The block layer however does
so: adjacent pages end up being used together.  To prevent this, make
page_is_mergeable() return false under KMSAN.

Link: https://lkml.kernel.org/r/20220915150417.722975-29-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Suggested-by: Eric Biggers <ebiggers@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/bio.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/block/bio.c~block-kmsan-skip-bio-block-merging-logic-for-kmsan
+++ a/block/bio.c
@@ -869,6 +869,8 @@ static inline bool page_is_mergeable(con
 	*same_page = ((vec_end_addr & PAGE_MASK) == page_addr);
 	if (*same_page)
 		return true;
+	else if (IS_ENABLED(CONFIG_KMSAN))
+		return false;
 	return (bv->bv_page + bv_end / PAGE_SIZE) == (page + off / PAGE_SIZE);
 }
 
_

Patches currently in -mm which might be from glider@google.com are


