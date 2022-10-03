Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 289D8C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiJCVPF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiJCVNt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:13:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD5853D35
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:08:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72B01611FC
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C712AC433D6;
        Mon,  3 Oct 2022 21:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831327;
        bh=FywP+lTiMnPrfoPqop8xRY/5Xt9VrgSW6zE1r9V2nLA=;
        h=Date:To:From:Subject:From;
        b=QSzcXFfAPiq+0B29zaQxPgwLMDOWFbU8pb8PaZ0iwgTK0/zmFacacs42gunizyW3W
         KRmMXM5bpaShSlI0Uxp5usHugMahx63orrSWxuDiCPQz7v0rTe9EZB87cQsLVoF8tm
         G6q1lS0zCzZF0HdX3KsWkMrNk1aUXF/csUHEg4jE=
Date:   Mon, 03 Oct 2022 14:08:47 -0700
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
Subject: [merged mm-stable] kmsan-disable-physical-page-merging-in-biovec.patch removed from -mm tree
Message-Id: <20221003210847.C712AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kmsan: disable physical page merging in biovec
has been removed from the -mm tree.  Its filename was
     kmsan-disable-physical-page-merging-in-biovec.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: kmsan: disable physical page merging in biovec
Date: Thu, 15 Sep 2022 17:04:01 +0200

KMSAN metadata for adjacent physical pages may not be adjacent, therefore
accessing such pages together may lead to metadata corruption.  We disable
merging pages in biovec to prevent such corruptions.

Link: https://lkml.kernel.org/r/20220915150417.722975-28-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
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
Cc: Eric Biggers <ebiggers@google.com>
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

 block/blk.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/block/blk.h~kmsan-disable-physical-page-merging-in-biovec
+++ a/block/blk.h
@@ -88,6 +88,13 @@ static inline bool biovec_phys_mergeable
 	phys_addr_t addr1 = page_to_phys(vec1->bv_page) + vec1->bv_offset;
 	phys_addr_t addr2 = page_to_phys(vec2->bv_page) + vec2->bv_offset;
 
+	/*
+	 * Merging adjacent physical pages may not work correctly under KMSAN
+	 * if their metadata pages aren't adjacent. Just disable merging.
+	 */
+	if (IS_ENABLED(CONFIG_KMSAN))
+		return false;
+
 	if (addr1 + vec1->bv_len != addr2)
 		return false;
 	if (xen_domain() && !xen_biovec_phys_mergeable(vec1, vec2->bv_page))
_

Patches currently in -mm which might be from glider@google.com are


