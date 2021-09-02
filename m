Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 620E5C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D80660FA0
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347578AbhIBV47 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347809AbhIBV4o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:56:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97891610E5;
        Thu,  2 Sep 2021 21:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619744;
        bh=dDJ2Lir8ULLWordPxNDt39TLU0Zmr1s05cFkjWcTJMo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Vqh9HZy/bxOtT7LhDdBZ12ClQRWZc4k5uCTj+SHkp3MLgZf0X0ROHCcmJ0Ja4rQsF
         Y1aLlIQ/CaZjvbGbtuR+JELiEnazjdQruO0MiR+xgbWZgXCAYFMt5pB++DgHqPEi3m
         cClkABHrxQtLIBjr1EhhRcZvYsmseNIb6JfscU1g=
Date:   Thu, 02 Sep 2021 14:55:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     0x7f454c46@gmail.com, adobriyan@gmail.com,
        akpm@linux-foundation.org, avagin@gmail.com, axboe@kernel.dk,
        bfields@fieldses.org, bp@alien8.de, bp@suse.de,
        christian.brauner@ubuntu.com, ebiederm@xmission.com,
        gregkh@linuxfoundation.org, guro@fb.com, hannes@cmpxchg.org,
        hpa@zytor.com, jirislaby@kernel.org, jlayton@kernel.org,
        ktkhai@virtuozzo.com, linux-mm@kvack.org, lizefan.x@bytedance.com,
        mhocko@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        nglaive@gmail.com, oleg@redhat.com, serge@hallyn.com,
        shakeelb@google.com, tglx@linutronix.de, tj@kernel.org,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com,
        viro@zeniv.linux.org.uk, vvs@virtuozzo.com
Subject:  [patch 107/212] memcg: enable accounting for ldt_struct
 objects
Message-ID: <20210902215543.9Ef2Zvxt2%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>
Subject: memcg: enable accounting for ldt_struct objects

Each task can request own LDT and force the kernel to allocate up to 64Kb
memory per-mm.

There are legitimate workloads with hundreds of processes and there can be
hundreds of workloads running on large machines.  The unaccounted memory
can cause isolation issues between the workloads particularly on highly
utilized machines.

It makes sense to account for this objects to restrict the host's memory
consumption from inside the memcg-limited container.

Link: https://lkml.kernel.org/r/38010594-50fe-c06d-7cb0-d1f77ca422f3@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Acked-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yutian Yang <nglaive@gmail.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/ldt.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/ldt.c~memcg-enable-accounting-for-ldt_struct-objects
+++ a/arch/x86/kernel/ldt.c
@@ -154,7 +154,7 @@ static struct ldt_struct *alloc_ldt_stru
 	if (num_entries > LDT_ENTRIES)
 		return NULL;
 
-	new_ldt = kmalloc(sizeof(struct ldt_struct), GFP_KERNEL);
+	new_ldt = kmalloc(sizeof(struct ldt_struct), GFP_KERNEL_ACCOUNT);
 	if (!new_ldt)
 		return NULL;
 
@@ -168,9 +168,9 @@ static struct ldt_struct *alloc_ldt_stru
 	 * than PAGE_SIZE.
 	 */
 	if (alloc_size > PAGE_SIZE)
-		new_ldt->entries = vzalloc(alloc_size);
+		new_ldt->entries = __vmalloc(alloc_size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	else
-		new_ldt->entries = (void *)get_zeroed_page(GFP_KERNEL);
+		new_ldt->entries = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
 
 	if (!new_ldt->entries) {
 		kfree(new_ldt);
_
