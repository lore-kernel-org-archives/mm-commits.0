Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B93C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:44:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5361E2086A
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596779095;
	bh=HkG4E/T45k5OXtL7SlF4MM5ggZ2yWlZXgYq7MDAIC0Q=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=XngM4ExX2/iWlfEtlBZkelesTQLML5h6hdylFcFGqOSWSKNglu2q0fg3EWdtq6D9s
	 so76B09HyO3od46NNMfFGpdvbo4UnoXogkKhlChLVkLwjUXFnsEKo1LuTAxGoneV7U
	 1NWlRpNDO6ss24z1nKjv87fFU5qY9+/XpqjhGNIQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725379AbgHGFoz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 01:44:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbgHGFoy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 01:44:54 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FA8620855;
        Fri,  7 Aug 2020 05:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596779094;
        bh=HkG4E/T45k5OXtL7SlF4MM5ggZ2yWlZXgYq7MDAIC0Q=;
        h=Date:From:To:Subject:From;
        b=U0Wz7coQpGouOCvth/pEjdfixEtsP/IoFJUrp/UKblofJ4QEQIF9rRY4O/oer9UP5
         YZet2RlBsGro607mYjn+F/dIiHN3lvUYxCGQ6JTHod9Abs7NPm0R4o6U6D1kb+ZV1C
         /Lsv0Zx+8+H8UqRHO65Z25ES+jmmOFn50K6KCO2I=
Date:   Thu, 06 Aug 2020 22:44:53 -0700
From:   akpm@linux-foundation.org
To:     keescook@chromium.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, sfr@canb.auug.org.au
Subject:  [folded-merged]
 slab-add-naive-detection-of-double-free-fix.patch removed from -mm tree
Message-ID: <20200807054453.ryk_6Mtr4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: slab: fix misplaced __free_one()
has been removed from the -mm tree.  Its filename was
     slab-add-naive-detection-of-double-free-fix.patch

This patch was dropped because it was folded into slab-add-naive-detection-of-double-free.patch

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: slab: fix misplaced __free_one()

The implementation of __free_one() was accidentally placed inside a
CONFIG_NUMA #ifdef. Move it above.

Link: http://lkml.kernel.org/r/202006261306.0D82A2B@keescook
Link: https://lore.kernel.org/lkml/7ff248c7-d447-340c-a8e2-8c02972aca70@infradead.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>	[build tested]
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/slab.c~slab-add-naive-detection-of-double-free-fix
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
@@ -749,16 +759,6 @@ static void drain_alien_cache(struct kme
 	}
 }
 
-/* &alien->lock must be held by alien callers. */
-static __always_inline void __free_one(struct array_cache *ac, void *objp)
-{
-	/* Avoid trivial double-free. */
-	if (IS_ENABLED(CONFIG_SLAB_FREELIST_HARDENED) &&
-	    WARN_ON_ONCE(ac->avail > 0 && ac->entry[ac->avail - 1] == objp))
-		return;
-	ac->entry[ac->avail++] = objp;
-}
-
 static int __cache_free_alien(struct kmem_cache *cachep, void *objp,
 				int node, int page_node)
 {
_

Patches currently in -mm which might be from keescook@chromium.org are

mm-expand-config_slab_freelist_hardened-to-include-slab.patch
slab-add-naive-detection-of-double-free.patch
exec-change-uselib2-is_sreg-failure-to-eacces.patch
exec-move-s_isreg-check-earlier.patch
exec-move-path_noexec-check-earlier.patch

