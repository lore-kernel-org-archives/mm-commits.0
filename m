Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F146C4708F
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 20:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8559B61057
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 20:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbhFAUDQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Jun 2021 16:03:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233853AbhFAUDQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 1 Jun 2021 16:03:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 141AD6052B;
        Tue,  1 Jun 2021 20:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622577694;
        bh=L/6tewRFYonC3Io84fEOWIKkZmf0RC/RDwUr6oI3TqY=;
        h=Date:From:To:Subject:From;
        b=d7TLXcJj+qONvHRznVhZRNa3YSo2UkBVlvW1/uNycedKZLXv/ufELEvzDUzekqvY7
         1idbxpEI1JHu1u2+y3lM7vVWMSrx8+ANLH1tjKmaJ1VKGDIal/FYgZIxsGahVPyY+/
         f5wiyhiJ0TiUUt86jLEKm/9bdtwkyLhUFcjCRsZY=
Date:   Tue, 01 Jun 2021 13:01:32 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, joe@perches.com,
        mm-commits@vger.kernel.org, penberg@kernel.org, pmladek@suse.com,
        rientjes@google.com, songmuchun@bytedance.com, swboyd@chromium.org,
        vbabka@suse.cz
Subject:  + slub-indicate-slab_fix-uses-printf-formats.patch added
 to -mm tree
Message-ID: <20210601200132.WPDNzeJLu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: slub: indicate slab_fix() uses printf formats
has been added to the -mm tree.  Its filename is
     slub-indicate-slab_fix-uses-printf-formats.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/slub-indicate-slab_fix-uses-printf-formats.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/slub-indicate-slab_fix-uses-printf-formats.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: slub: indicate slab_fix() uses printf formats

Ideally, slab_fix() would be marked with __printf and the format here
would not use \n as that's emitted by the slab_fix().  Make these changes.

Link: https://lkml.kernel.org/r/20210601182202.3011020-4-swboyd@chromium.org
Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/slub.c~slub-indicate-slab_fix-uses-printf-formats
+++ a/mm/slub.c
@@ -691,6 +691,7 @@ static void slab_bug(struct kmem_cache *
 	va_end(args);
 }
 
+__printf(2, 3)
 static void slab_fix(struct kmem_cache *s, char *fmt, ...)
 {
 	struct va_format vaf;
@@ -805,7 +806,7 @@ static void init_object(struct kmem_cach
 static void restore_bytes(struct kmem_cache *s, char *message, u8 data,
 						void *from, void *to)
 {
-	slab_fix(s, "Restoring %s 0x%p-0x%p=0x%x\n", message, from, to - 1, data);
+	slab_fix(s, "Restoring %s 0x%p-0x%p=0x%x", message, from, to - 1, data);
 	memset(from, data, to - from);
 }
 
@@ -1058,13 +1059,13 @@ static int on_freelist(struct kmem_cache
 		slab_err(s, page, "Wrong number of objects. Found %d but should be %d",
 			 page->objects, max_objects);
 		page->objects = max_objects;
-		slab_fix(s, "Number of objects adjusted.");
+		slab_fix(s, "Number of objects adjusted");
 	}
 	if (page->inuse != page->objects - nr) {
 		slab_err(s, page, "Wrong object count. Counter is %d but counted were %d",
 			 page->inuse, page->objects - nr);
 		page->inuse = page->objects - nr;
-		slab_fix(s, "Object count adjusted.");
+		slab_fix(s, "Object count adjusted");
 	}
 	return search == NULL;
 }
_

Patches currently in -mm which might be from joe@perches.com are

slub-indicate-slab_fix-uses-printf-formats.patch

