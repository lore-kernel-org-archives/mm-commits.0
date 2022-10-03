Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC15FC43217
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiJCVPL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiJCVNw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:13:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE9A54667
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D14AB81123
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C8CC433C1;
        Mon,  3 Oct 2022 21:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831337;
        bh=fdMvwgGnM0OAMBh6+N0bvaRiaiqbkPoDarUreRPNfNs=;
        h=Date:To:From:Subject:From;
        b=mB6OvdnP+xPgIJqVPNTbwCrrnjUM5UG0GaHe+dOXbYJ1kAxwMna79H03JwjY4r2yj
         DKrlx4vhd1hxUhKzz4C6hdNcUn9o9c7x+6VCXsdbtcqgehXuAjg/zQw7UG8WHCYAfa
         9V6vbUPCzUfQJITR3EfSD05nUu9klkt/0QPo0H0k=
Date:   Mon, 03 Oct 2022 14:08:57 -0700
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
Subject: [merged mm-stable] x86-kmsan-skip-shadow-checks-in-__switch_to.patch removed from -mm tree
Message-Id: <20221003210857.C3C8CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86: kmsan: skip shadow checks in __switch_to()
has been removed from the -mm tree.  Its filename was
     x86-kmsan-skip-shadow-checks-in-__switch_to.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: x86: kmsan: skip shadow checks in __switch_to()
Date: Thu, 15 Sep 2022 17:04:07 +0200

When instrumenting functions, KMSAN obtains the per-task state (mostly
pointers to metadata for function arguments and return values) once per
function at its beginning, using the `current` pointer.

Every time the instrumented function calls another function, this state
(`struct kmsan_context_state`) is updated with shadow/origin data of the
passed and returned values.

When `current` changes in the low-level arch code, instrumented code can
not notice that, and will still refer to the old state, possibly
corrupting it or using stale data.  This may result in false positive
reports.

To deal with that, we need to apply __no_kmsan_checks to the functions
performing context switching - this will result in skipping all KMSAN
shadow checks and marking newly created values as initialized, preventing
all false positive reports in those functions.  False negatives are still
possible, but we expect them to be rare and impersistent.

Link: https://lkml.kernel.org/r/20220915150417.722975-34-glider@google.com
Suggested-by: Marco Elver <elver@google.com>
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

 arch/x86/kernel/process_64.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/process_64.c~x86-kmsan-skip-shadow-checks-in-__switch_to
+++ a/arch/x86/kernel/process_64.c
@@ -553,6 +553,7 @@ void compat_start_thread(struct pt_regs
  * Kprobes not supported here. Set the probe on schedule instead.
  * Function graph tracer not supported too.
  */
+__no_kmsan_checks
 __visible __notrace_funcgraph struct task_struct *
 __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 {
_

Patches currently in -mm which might be from glider@google.com are


