Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DBCC49EA7
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 22:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16DAA613FA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 22:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234249AbhFPWvm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Jun 2021 18:51:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234266AbhFPWvk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Jun 2021 18:51:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37F88613ED;
        Wed, 16 Jun 2021 22:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623883773;
        bh=jFl5qNC3B/T0jKjizMGTNJWXMS7w/EkerdasnxHGxLc=;
        h=Date:From:To:Subject:From;
        b=Tb3bZ526mivh5ogehAQIG24iOttHW4ArYa3kzmOsbzUbKLerOQ2Zj8aUScAyNUelh
         snTtokL9RiHyUrfB7ETC8lxrRvPrvCJAAiALeIuntWqOX+Y8dPmoLVBdvRO2y6Q5Qd
         rp6snGiqvwLAT05ih2FDEH2sJMBkQ1TYeT/wSf+s=
Date:   Wed, 16 Jun 2021 15:49:32 -0700
From:   akpm@linux-foundation.org
To:     aquini@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        quic_c_gdjako@quicinc.com, rientjes@google.com, vbabka@suse.cz
Subject:  + mm-slub-add-taint-after-the-errors-are-printed.patch
 added to -mm tree
Message-ID: <20210616224932.W_bvHPmKm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: add taint after the errors are printed
has been added to the -mm tree.  Its filename is
     mm-slub-add-taint-after-the-errors-are-printed.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-add-taint-after-the-errors-are-printed.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-add-taint-after-the-errors-are-printed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Georgi Djakov <quic_c_gdjako@quicinc.com>
Subject: mm/slub: add taint after the errors are printed

When running the kernel with panic_on_taint, the usual slub debug error
messages are not being printed when object corruption happens.  That's
because we panic in add_taint(), which is called before printing the
additional information.  This is a bit unfortunate as the error messages
are actually very useful, especially before a panic.  Let's fix this by
moving add_taint() after the errors are printed on the console.

Link: https://lkml.kernel.org/r/1623860738-146761-1-git-send-email-quic_c_gdjako@quicinc.com
Signed-off-by: Georgi Djakov <quic_c_gdjako@quicinc.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/slub.c~mm-slub-add-taint-after-the-errors-are-printed
+++ a/mm/slub.c
@@ -708,8 +708,6 @@ static void slab_bug(struct kmem_cache *
 	pr_err("=============================================================================\n");
 	pr_err("BUG %s (%s): %pV\n", s->name, print_tainted(), &vaf);
 	pr_err("-----------------------------------------------------------------------------\n\n");
-
-	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 	va_end(args);
 }
 
@@ -790,6 +788,7 @@ void object_err(struct kmem_cache *s, st
 
 	slab_bug(s, "%s", reason);
 	print_trailer(s, page, object);
+	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
 
 static __printf(3, 4) void slab_err(struct kmem_cache *s, struct page *page,
@@ -807,6 +806,7 @@ static __printf(3, 4) void slab_err(stru
 	slab_bug(s, "%s", buf);
 	print_page_info(page);
 	dump_stack();
+	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
 
 static void init_object(struct kmem_cache *s, void *object, u8 val)
@@ -858,6 +858,7 @@ static int check_bytes_and_report(struct
 					fault, end - 1, fault - addr,
 					fault[0], value);
 	print_trailer(s, page, object);
+	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 
 skip_bug_print:
 	restore_bytes(s, what, value, fault, end);
_

Patches currently in -mm which might be from quic_c_gdjako@quicinc.com are

mm-slub-add-taint-after-the-errors-are-printed.patch

