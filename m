Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25DB5C433E5
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F405E221E5
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781107;
	bh=QPd4SUwbzWoRFVG/dAfx5eUxU/5Sx3XlCV1Ji9AfAy8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=mhsYUf9GEN37qxKb3XGczzGatdjSFYKyA9PEMWhN4FeFdgVIyB1T+cLdSXGyIPbV1
	 gXXv3at9ukfpsjJzN7W3gkPlCY8CATk+u1z3ZjMGokK1DQZaHq4GF/o4N8spSQi2RJ
	 eEsktBW8CdTnss8m2G0tKcYcLMEi2otRm/I1fr/Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgHGGS0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:18:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGS0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:18:26 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4054D22C9F;
        Fri,  7 Aug 2020 06:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781106;
        bh=QPd4SUwbzWoRFVG/dAfx5eUxU/5Sx3XlCV1Ji9AfAy8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=k7/PlVT0hnO+fhkChoUJJwzDwStXExkcMMnCKhOcK9hMI8f+/VpTKpckmkNKneBIB
         cSo5GHtDowHLEEUs58RzhyZu9OX6OoriJ40FhgUafgZJrsSy/oATz3dOmAWWNnQFAM
         Es9EhSSpvCfBKx5G0yf/EXtf2742HN9Ku0WWx9hc=
Date:   Thu, 06 Aug 2020 23:18:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.popov@linux.com, cl@linux.com,
        guro@fb.com, iamjoonsoo.kim@lge.com, jannh@google.com,
        keescook@chromium.org, linux-mm@kvack.org, mjg59@google.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rdunlap@infradead.org, rientjes@google.com,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        vinmenon@codeaurora.org, vjitta@codeaurora.org
Subject:  [patch 025/163] mm/slab: add naive detection of double
 free
Message-ID: <20200807061824.s-f36OexL%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
