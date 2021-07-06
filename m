Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40BC0C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 290DF61C83
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhGFTL6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:11:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230031AbhGFTL4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:11:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93F5A61C81;
        Tue,  6 Jul 2021 19:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598557;
        bh=S17+FrtZFF5UwMBycE72coZcly5v/vdNBJHCHInvUYY=;
        h=Date:From:To:Subject:From;
        b=icm8mwyqK7qcb5ST674qJ+rPNIS5XE4q/ssOpk2rF1KAvPvLl9NddMCTEtH2OS2aL
         d4S1BBRUwfcK4jpJ7aMjiQ7fJ/JBWihTyP0qFYkk5qj7x76Y0bBR8sxV3iHV25/ZFW
         ITAXlboe8ImAFOmF52BJ4MWZNqz2Jfj+izsdjptw=
Date:   Tue, 06 Jul 2021 12:09:17 -0700
From:   akpm@linux-foundation.org
To:     aquini@redhat.com, atomlin@redhat.com, cl@linux.com,
        iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_c_gdjako@quicinc.com, rientjes@google.com,
        vbabka@suse.cz
Subject:  [merged]
 mm-slub-add-taint-after-the-errors-are-printed.patch removed from -mm tree
Message-ID: <20210706190917.abaIC4IVx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: add taint after the errors are printed
has been removed from the -mm tree.  Its filename was
     mm-slub-add-taint-after-the-errors-are-printed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Aaron Tomlin <atomlin@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
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


