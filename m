Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB38EB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjFSXVP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjFSXUr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:20:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C791E10C7
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:20:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CCA760F5A
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B352DC433C8;
        Mon, 19 Jun 2023 23:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216843;
        bh=jSteGorb+gYGucx8kbeZUwAE6cR54Qlk2B+pqP4ZMtk=;
        h=Date:To:From:Subject:From;
        b=so54m/lIVIPzKDedAo1vguAva/Komjm+24oJ/jboJZoq8mCGhXXOSVAl+1AsvuDcG
         apAtASX1ZT5G9P1BrlzSjINmJ680/rQ+0x7TkWewkqY4ZxoYaMAXTpBPqDOPKZ5gsp
         r2b/L6DV4GoitoS1GNyYO52NM11Ewz7kS4a4uIT8=
Date:   Mon, 19 Jun 2023 16:20:43 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, osalvador@suse.de,
        mhocko@kernel.org, david@redhat.com, haifeng.xu@shopee.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat.patch removed from -mm tree
Message-Id: <20230619232043.B352DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory_hotplug: remove reset_node_managed_pages() in hotadd_init_pgdat()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: mm/memory_hotplug: remove reset_node_managed_pages() in hotadd_init_pgdat()
Date: Wed, 7 Jun 2023 02:45:48 +0000

managed pages has already been set to 0 in free_area_init_core_hotplug(),
via zone_init_internals() on each zone.  It's pointless to reset again.

Furthermore, reset_node_managed_pages() no longer needs to be exposed
outside of mm/memblock.c.  Remove declaration in include/linux/memblock.h
and define it as static.

In addtion to this, the only caller of reset_node_managed_pages() is
reset_all_zones_managed_pages(), which is annotated with __init, so it
should be safe to also mark reset_node_managed_pages() as __init.

Link: https://lkml.kernel.org/r/20230607024548.1240-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    1 -
 mm/memblock.c            |    2 +-
 mm/memory_hotplug.c      |    1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/memblock.h~mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat
+++ a/include/linux/memblock.h
@@ -128,7 +128,6 @@ int memblock_clear_nomap(phys_addr_t bas
 
 void memblock_free_all(void);
 void memblock_free(void *ptr, size_t size);
-void reset_node_managed_pages(pg_data_t *pgdat);
 void reset_all_zones_managed_pages(void);
 
 /* Low level functions */
--- a/mm/memblock.c~mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat
+++ a/mm/memblock.c
@@ -2122,7 +2122,7 @@ static unsigned long __init free_low_mem
 
 static int reset_managed_pages_done __initdata;
 
-void reset_node_managed_pages(pg_data_t *pgdat)
+static void __init reset_node_managed_pages(pg_data_t *pgdat)
 {
 	struct zone *z;
 
--- a/mm/memory_hotplug.c~mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat
+++ a/mm/memory_hotplug.c
@@ -1194,7 +1194,6 @@ static pg_data_t __ref *hotadd_init_pgda
 	 * online_pages() and offline_pages().
 	 * TODO: should be in free_area_init_core_hotplug?
 	 */
-	reset_node_managed_pages(pgdat);
 	reset_node_present_pages(pgdat);
 
 	return pgdat;
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

mm-memcontrol-do-not-tweak-node-in-mem_cgroup_init.patch
selftests-cgroup-fix-unexpected-failure-on-test_memcg_sock.patch

