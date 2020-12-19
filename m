Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1479C4361B
	for <mm-commits@archiver.kernel.org>; Sat, 19 Dec 2020 01:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA4B223BAD
	for <mm-commits@archiver.kernel.org>; Sat, 19 Dec 2020 01:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgLSBOJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 20:14:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:37310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725879AbgLSBOJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 20:14:09 -0500
Date:   Fri, 18 Dec 2020 17:13:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608340408;
        bh=nKaF5qMP2EADBNzYCp8XcuHsLze37G8BzZ55UwoLvGA=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=ugBwM0PbxDkOZP+paw7FM6DkKwSuAnWHNcIUQQTQ3hDWacF7zYfvz5uQImRqJSIJ7
         /wCCVQ40FuOQrnp/I5c+/ke889q+1fDwBwDG+IcopVvbET2FfN6d4JE1CBwElSgAC5
         n3Xxhc+H/YPAcSRpkieRoBrgO9mlaZoPqu7zCU98=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Marco Elver <elver@google.com>
Cc:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, eugenis@google.com, glider@google.com,
        gor@linux.ibm.com, kevin.brodsky@arm.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject: Re: [patch 21/78] kasan: split out shadow.c from common.c
Message-Id: <20201218171327.180140338d183b41a962742d@linux-foundation.org>
In-Reply-To: <X91JLZhrXYaLzoB8@elver.google.com>
References: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
        <20201218220233.pgX0nYYVt%akpm@linux-foundation.org>
        <X91JLZhrXYaLzoB8@elver.google.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, 19 Dec 2020 01:28:29 +0100 Marco Elver <elver@google.com> wrote:

> [...]
> > -/*
> > - * Poisons the shadow memory for 'size' bytes starting from 'addr'.
> > - * Memory addresses should be aligned to KASAN_GRANULE_SIZE.
> > - */
> > -void poison_range(const void *address, size_t size, u8 value)
> > -{
> > -	void *shadow_start, *shadow_end;
> > -
> > -	/*
> > -	 * Perform shadow offset calculation based on untagged address, as
> > -	 * some of the callers (e.g. kasan_poison_object_data) pass tagged
> > -	 * addresses to this function.
> > -	 */
> > -	address = reset_tag(address);
> > -
> 
> The moved lines do not mention kfence...
> (The same commit in -next does.)

They shouldn't.

> > -	shadow_start = kasan_mem_to_shadow(address);
> > -	shadow_end = kasan_mem_to_shadow(address + size);
> > -
> > -	__memset(shadow_start, value, shadow_end - shadow_start);
> > -}
> [...]
> > --- /dev/null
> > +++ a/mm/kasan/shadow.c
> > @@ -0,0 +1,518 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * This file contains KASAN runtime code that manages shadow memory for
> > + * generic and software tag-based KASAN modes.
> > + *
> > + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
> > + * Author: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> > + *
> > + * Some code borrowed from https://github.com/xairy/kasan-prototype by
> > + *        Andrey Konovalov <andreyknvl@gmail.com>
> > + */
> > +
> > +#include <linux/init.h>
> > +#include <linux/kasan.h>
> > +#include <linux/kernel.h>
> > +#include <linux/kfence.h>
> 
> This is the first time kfence is mentioned. Is this correct?

Yes.

> Is my assumption correct that the kasan changes and kfence changes are
> to be swapped?

Yes, kfence came in fairly late and seems a bit fresh.  I was planning
on holding it off until next cycle.

Sigh.  I don't have access to my capable-of-compiling-KASAN machine at
present :(  We'll need this, yes?

--- a/mm/kasan/kasan.h~a
+++ a/mm/kasan/kasan.h
@@ -3,7 +3,6 @@
 #define __MM_KASAN_KASAN_H
 
 #include <linux/kasan.h>
-#include <linux/kfence.h>
 #include <linux/stackdepot.h>
 
 #ifdef CONFIG_KASAN_HW_TAGS
@@ -305,20 +304,12 @@ static inline u8 random_tag(void) { retu
 
 static inline void poison_range(const void *address, size_t size, u8 value)
 {
-	/* Skip KFENCE memory if called explicitly outside of sl*b. */
-	if (is_kfence_address(address))
-		return;
-
 	hw_set_mem_tag_range(kasan_reset_tag(address),
 			round_up(size, KASAN_GRANULE_SIZE), value);
 }
 
 static inline void unpoison_range(const void *address, size_t size)
 {
-	/* Skip KFENCE memory if called explicitly outside of sl*b. */
-	if (is_kfence_address(address))
-		return;
-
 	hw_set_mem_tag_range(kasan_reset_tag(address),
 			round_up(size, KASAN_GRANULE_SIZE), get_tag(address));
 }
--- a/mm/kasan/shadow.c~a
+++ a/mm/kasan/shadow.c
@@ -13,7 +13,6 @@
 #include <linux/init.h>
 #include <linux/kasan.h>
 #include <linux/kernel.h>
-#include <linux/kfence.h>
 #include <linux/kmemleak.h>
 #include <linux/memory.h>
 #include <linux/mm.h>
@@ -85,10 +84,6 @@ void poison_range(const void *address, s
 	address = kasan_reset_tag(address);
 	size = round_up(size, KASAN_GRANULE_SIZE);
 
-	/* Skip KFENCE memory if called explicitly outside of sl*b. */
-	if (is_kfence_address(address))
-		return;
-
 	shadow_start = kasan_mem_to_shadow(address);
 	shadow_end = kasan_mem_to_shadow(address + size);
 
@@ -106,14 +101,6 @@ void unpoison_range(const void *address,
 	 */
 	address = kasan_reset_tag(address);
 
-	/*
-	 * Skip KFENCE memory if called explicitly outside of sl*b. Also note
-	 * that calls to ksize(), where size is not a multiple of machine-word
-	 * size, would otherwise poison the invalid portion of the word.
-	 */
-	if (is_kfence_address(address))
-		return;
-
 	poison_range(address, size, tag);
 
 	if (size & KASAN_GRANULE_MASK) {
_

