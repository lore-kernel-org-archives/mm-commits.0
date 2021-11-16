Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2F31C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 05:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9404061BFA
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 05:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbhKPFDZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 Nov 2021 00:03:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:36518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236668AbhKPFCe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Nov 2021 00:02:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D34D161BF5;
        Tue, 16 Nov 2021 04:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637038775;
        bh=CSOPHzIAYJdlnBIZG/noTJ88b0B0Hx4NPCZtEpX1Y6g=;
        h=Date:From:To:Subject:From;
        b=yx1jtT+fMn9tK7aufyxijcz5HAkn7/TWaOTtsbHyzWz/R/YbvFAO7HLJqa1OyclZf
         dWtjLnBHbm2neeuJDaGTKR4l0S664Suy54h517ZJlMuuM35ShmxU2OKmtOBVfz7FbZ
         QtW7ZIA5xIEQbUvskpdpibDSf4An+Qh4hSyu7Oh4=
Date:   Mon, 15 Nov 2021 20:59:34 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, dvyukov@google.com, elver@google.com,
        glider@google.com, iamjoonsoo.kim@lge.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  +
 mm-slab_common-use-warn-if-cache-still-has-objects-on-destroy.patch added
 to -mm tree
Message-ID: <20211116045934.FFVGCi6Ik%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab_common: use WARN() if cache still has objects on destroy
has been added to the -mm tree.  Its filename is
     mm-slab_common-use-warn-if-cache-still-has-objects-on-destroy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slab_common-use-warn-if-cache-still-has-objects-on-destroy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slab_common-use-warn-if-cache-still-has-objects-on-destroy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: mm/slab_common: use WARN() if cache still has objects on destroy

Calling kmem_cache_destroy() while the cache still has objects allocated
is a kernel bug, and will usually result in the entire cache being leaked.
While the message in kmem_cache_destroy() resembles a warning, it is
currently not implemented using a real WARN().

This is problematic for infrastructure testing the kernel, all of which
rely on the specific format of WARN()s to pick up on bugs.

Some 13 years ago this used to be a simple WARN_ON() in slub, but
d629d8195793 ("slub: improve kmem_cache_destroy() error message") changed
it into an open-coded warning to avoid confusion with a bug in slub
itself.

Instead, turn the open-coded warning into a real WARN() with the message
preserved, so that test systems can actually identify these issues, and we
get all the other benefits of using a normal WARN().  The warning message
is extended with "when called from <caller-ip>" to make it even clearer
where the fault lies.

For most configurations this is only a cosmetic change, however, note that
WARN() here will now also respect panic_on_warn.

Link: https://lkml.kernel.org/r/20211102170733.648216-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/mm/slab_common.c~mm-slab_common-use-warn-if-cache-still-has-objects-on-destroy
+++ a/mm/slab_common.c
@@ -489,8 +489,6 @@ void slab_kmem_cache_release(struct kmem
 
 void kmem_cache_destroy(struct kmem_cache *s)
 {
-	int err;
-
 	if (unlikely(!s))
 		return;
 
@@ -501,12 +499,9 @@ void kmem_cache_destroy(struct kmem_cach
 	if (s->refcount)
 		goto out_unlock;
 
-	err = shutdown_cache(s);
-	if (err) {
-		pr_err("%s %s: Slab cache still has objects\n",
-		       __func__, s->name);
-		dump_stack();
-	}
+	WARN(shutdown_cache(s),
+	     "%s %s: Slab cache still has objects when called from %pS",
+	     __func__, s->name, (void *)_RET_IP_);
 out_unlock:
 	mutex_unlock(&slab_mutex);
 	cpus_read_unlock();
_

Patches currently in -mm which might be from elver@google.com are

mm-slab_common-use-warn-if-cache-still-has-objects-on-destroy.patch
panic-use-error_report_end-tracepoint-on-warnings.patch

