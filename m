Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05FADC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB6B72073E
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026885;
	bh=eHt2S3LMSznClhCCq3uQPfmvw7aDCH39zdSZbAXZyek=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=c/kt/XZy1aoT5kHKDgB1k9dXN8k35Djwtbl93bLPN9qN+EGy5mFWJKCm2sg1M/yxJ
	 a/WRgJ/orISuUrLGdrQS+WxRaKY5gcPTHolcXA/IXzOnlW+98njAc3VqhOahWyGLKa
	 nNu4FIvLurfY+ljB3QdqpWRLMFC8bRiQDTO9/vI8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgHJCep (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:34:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCep (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:34:45 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C09BF206E9;
        Mon, 10 Aug 2020 02:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026884;
        bh=eHt2S3LMSznClhCCq3uQPfmvw7aDCH39zdSZbAXZyek=;
        h=Date:From:To:Subject:From;
        b=OoTJJHg0t7VoC76xr+/At0gI6/gM6xCnduDjBJ39kQx+agRq7Et6riLHQlvQ9rx9I
         8EHdRkHxUTz3XHywkQPvGU1fIxiUleVLf9QM9t/cHNaUIDBCeu9/cPtf+zBEdKtI5a
         VVvCDro9z7HW5J4421Cj0qCV2IELlDihiWyf9LuM=
Date:   Sun, 09 Aug 2020 19:34:43 -0700
From:   akpm@linux-foundation.org
To:     alex.popov@linux.com, cl@linux.com, guro@fb.com,
        iamjoonsoo.kim@lge.com, jannh@google.com, keescook@chromium.org,
        mjg59@google.com, mm-commits@vger.kernel.org, penberg@kernel.org,
        rdunlap@infradead.org, rientjes@google.com, vbabka@suse.cz,
        vinmenon@codeaurora.org, vjitta@codeaurora.org
Subject:  [merged] slab-add-naive-detection-of-double-free.patch
 removed from -mm tree
Message-ID: <20200810023443.WtfZeQL2m%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: add naive detection of double free
has been removed from the -mm tree.  Its filename was
     slab-add-naive-detection-of-double-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mm/slab: add naive detection of double free

Similar to commit ce6fa91b9363 ("mm/slub.c: add a naive detection of
double free or corruption"), add a very cheap double-free check for SLAB
under CONFIG_SLAB_FREELIST_HARDENED.  With this added, the
"SLAB_FREE_DOUBLE" LKDTM test passes under SLAB:

  lkdtm: Performing direct entry SLAB_FREE_DOUBLE
  lkdtm: Attempting double slab free ...
  ------------[ cut here ]------------
  WARNING: CPU: 2 PID: 2193 at mm/slab.c:757 ___cache _free+0x325/0x390

[keescook@chromium.org: fix misplaced __free_one()]
  Link: http://lkml.kernel.org/r/202006261306.0D82A2B@keescook
  Link: https://lore.kernel.org/lkml/7ff248c7-d447-340c-a8e2-8c02972aca70@infradead.org
Link: http://lkml.kernel.org/r/20200625215548.389774-3-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Randy Dunlap <rdunlap@infradead.org>	[build tested]
Cc: Roman Gushchin <guro@fb.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Alexander Popov <alex.popov@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Matthew Garrett <mjg59@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/slab.c~slab-add-naive-detection-of-double-free
+++ a/mm/slab.c
@@ -588,6 +588,16 @@ static int transfer_objects(struct array
 	return nr;
 }
 
+/* &alien->lock must be held by alien callers. */
+static __always_inline void __free_one(struct array_cache *ac, void *objp)
+{
+	/* Avoid trivial double-free. */
+	if (IS_ENABLED(CONFIG_SLAB_FREELIST_HARDENED) &&
+	    WARN_ON_ONCE(ac->avail > 0 && ac->entry[ac->avail - 1] == objp))
+		return;
+	ac->entry[ac->avail++] = objp;
+}
+
 #ifndef CONFIG_NUMA
 
 #define drain_alien_cache(cachep, alien) do { } while (0)
@@ -767,7 +777,7 @@ static int __cache_free_alien(struct kme
 			STATS_INC_ACOVERFLOW(cachep);
 			__drain_alien_cache(cachep, ac, page_node, &list);
 		}
-		ac->entry[ac->avail++] = objp;
+		__free_one(ac, objp);
 		spin_unlock(&alien->lock);
 		slabs_destroy(cachep, &list);
 	} else {
@@ -3466,7 +3476,7 @@ void ___cache_free(struct kmem_cache *ca
 		}
 	}
 
-	ac->entry[ac->avail++] = objp;
+	__free_one(ac, objp);
 }
 
 /**
_

Patches currently in -mm which might be from keescook@chromium.org are

exec-change-uselib2-is_sreg-failure-to-eacces.patch
exec-move-s_isreg-check-earlier.patch
exec-move-path_noexec-check-earlier.patch

