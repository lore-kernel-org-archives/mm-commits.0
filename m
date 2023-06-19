Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E895C0015E
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjFSXY0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjFSXWY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:22:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C53A173C
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1388C60FB7
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D50FC433C8;
        Mon, 19 Jun 2023 23:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216936;
        bh=WLoAjia3lsyliEloRULxxbJa2V5vAXFsjefIR6ikRB4=;
        h=Date:To:From:Subject:From;
        b=D995FKAKDKT5t+dZLcrManbId4UgcL0hylpsX5O06gNtA0XkfDzmtM/Zy3mmnQPip
         UcNLy73dGv5vOJ/cmmmjjvBLFj8PbHB/wTIcVbDpKhFeP4/DhhGVDqTVrXzdBlwr+g
         6WNjm2jc4bI6cTMf7fFuK12LAvXkhKxXx/474Nmc=
Date:   Mon, 19 Jun 2023 16:22:15 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, vbabka@suse.cz,
        snitzer@kernel.org, saravanak@google.com, robin.murphy@arm.com,
        rafael@kernel.org, maz@kernel.org, logang@deltatee.com,
        lars@metafoo.de, jsnitsel@redhat.com, joro@8bytes.org,
        Jonathan.Cameron@huawei.com, jic23@kernel.org,
        isaacmanjarres@google.com, herbert@gondor.apana.org.au, hch@lst.de,
        gregkh@linuxfoundation.org, daniel@ffwll.ch, broonie@kernel.org,
        arnd@arndb.de, ardb@kernel.org, agk@redhat.com,
        catalin.marinas@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-slab-simplify-create_kmalloc_cache-args-and-make-it-static.patch removed from -mm tree
Message-Id: <20230619232216.6D50FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/slab: simplify create_kmalloc_cache() args and make it static
has been removed from the -mm tree.  Its filename was
     mm-slab-simplify-create_kmalloc_cache-args-and-make-it-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm/slab: simplify create_kmalloc_cache() args and make it static
Date: Mon, 12 Jun 2023 16:31:47 +0100

In the slab variant of kmem_cache_init(), call new_kmalloc_cache() instead
of initialising the kmalloc_caches array directly.  With this,
create_kmalloc_cache() is now only called from new_kmalloc_cache() in the
same file, so make it static.  In addition, the useroffset argument is
always 0 while usersize is the same as size.  Remove them.

Link: https://lkml.kernel.org/r/20230612153201.554742-4-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jerry Snitselaar <jsnitsel@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Saravana Kannan <saravanak@google.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c        |    6 +-----
 mm/slab.h        |    5 ++---
 mm/slab_common.c |   14 ++++++--------
 3 files changed, 9 insertions(+), 16 deletions(-)

--- a/mm/slab.c~mm-slab-simplify-create_kmalloc_cache-args-and-make-it-static
+++ a/mm/slab.c
@@ -1240,11 +1240,7 @@ void __init kmem_cache_init(void)
 	 * Initialize the caches that provide memory for the  kmem_cache_node
 	 * structures first.  Without this, further allocations will bug.
 	 */
-	kmalloc_caches[KMALLOC_NORMAL][INDEX_NODE] = create_kmalloc_cache(
-				kmalloc_info[INDEX_NODE].name[KMALLOC_NORMAL],
-				kmalloc_info[INDEX_NODE].size,
-				ARCH_KMALLOC_FLAGS, 0,
-				kmalloc_info[INDEX_NODE].size);
+	new_kmalloc_cache(INDEX_NODE, KMALLOC_NORMAL, ARCH_KMALLOC_FLAGS);
 	slab_state = PARTIAL_NODE;
 	setup_kmalloc_cache_index_table();
 
--- a/mm/slab_common.c~mm-slab-simplify-create_kmalloc_cache-args-and-make-it-static
+++ a/mm/slab_common.c
@@ -658,17 +658,16 @@ void __init create_boot_cache(struct kme
 	s->refcount = -1;	/* Exempt from merging for now */
 }
 
-struct kmem_cache *__init create_kmalloc_cache(const char *name,
-		unsigned int size, slab_flags_t flags,
-		unsigned int useroffset, unsigned int usersize)
+static struct kmem_cache *__init create_kmalloc_cache(const char *name,
+						      unsigned int size,
+						      slab_flags_t flags)
 {
 	struct kmem_cache *s = kmem_cache_zalloc(kmem_cache, GFP_NOWAIT);
 
 	if (!s)
 		panic("Out of memory when creating slab %s\n", name);
 
-	create_boot_cache(s, name, size, flags | SLAB_KMALLOC, useroffset,
-								usersize);
+	create_boot_cache(s, name, size, flags | SLAB_KMALLOC, 0, size);
 	list_add(&s->list, &slab_caches);
 	s->refcount = 1;
 	return s;
@@ -863,7 +862,7 @@ void __init setup_kmalloc_cache_index_ta
 	}
 }
 
-static void __init
+void __init
 new_kmalloc_cache(int idx, enum kmalloc_cache_type type, slab_flags_t flags)
 {
 	if ((KMALLOC_RECLAIM != KMALLOC_NORMAL) && (type == KMALLOC_RECLAIM)) {
@@ -880,8 +879,7 @@ new_kmalloc_cache(int idx, enum kmalloc_
 
 	kmalloc_caches[type][idx] = create_kmalloc_cache(
 					kmalloc_info[idx].name[type],
-					kmalloc_info[idx].size, flags, 0,
-					kmalloc_info[idx].size);
+					kmalloc_info[idx].size, flags);
 
 	/*
 	 * If CONFIG_MEMCG_KMEM is enabled, disable cache merging for
--- a/mm/slab.h~mm-slab-simplify-create_kmalloc_cache-args-and-make-it-static
+++ a/mm/slab.h
@@ -255,9 +255,8 @@ gfp_t kmalloc_fix_flags(gfp_t flags);
 /* Functions provided by the slab allocators */
 int __kmem_cache_create(struct kmem_cache *, slab_flags_t flags);
 
-struct kmem_cache *create_kmalloc_cache(const char *name, unsigned int size,
-			slab_flags_t flags, unsigned int useroffset,
-			unsigned int usersize);
+void __init new_kmalloc_cache(int idx, enum kmalloc_cache_type type,
+			      slab_flags_t flags);
 extern void create_boot_cache(struct kmem_cache *, const char *name,
 			unsigned int size, slab_flags_t flags,
 			unsigned int useroffset, unsigned int usersize);
_

Patches currently in -mm which might be from catalin.marinas@arm.com are


