Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F098C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiKIBke (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiKIBjj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:39:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D3066C9F
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7585B81C38
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9B5C433D7;
        Wed,  9 Nov 2022 01:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957938;
        bh=UFUg+veLv1f+zDxPKCFgRcyozNYaItPg/sZ5PZCu0Xc=;
        h=Date:To:From:Subject:From;
        b=vffKnZmnPEJUprRLzmAyGUsHZ1Ptatt2sP+n+lOhxSzetj3BANhert2VhvJzQn7lo
         6w10y429M62Emc7ufmsO0SEuOlqbw3uyM9cyW72NmwMOqXsKd5Zpm+PGrAQ/JrzRwx
         zT2WO2loWZi3m7AUegCfVfzuSP9Km/v1w64oFeBk=
Date:   Tue, 08 Nov 2022 17:38:57 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rostedt@goodmis.org, oleksiy.avramchenko@sony.com,
        npiggin@gmail.com, hch@lst.de, urezki@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-use-trace_free_vmap_area_noflush-event.patch removed from -mm tree
Message-Id: <20221109013858.5D9B5C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: vmalloc: use trace_free_vmap_area_noflush event
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-use-trace_free_vmap_area_noflush-event.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: use trace_free_vmap_area_noflush event
Date: Tue, 18 Oct 2022 20:10:52 +0200

It is for debug purposes and is called when a vmap area gets freed.  This
event gives some indication about:

- a start address of released area;
- a current number of outstanding pages;
- a maximum number of allowed outstanding pages.

Link: https://lkml.kernel.org/r/20221018181053.434508-7-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-trace_free_vmap_area_noflush-event
+++ a/mm/vmalloc.c
@@ -1821,6 +1821,8 @@ static void drain_vmap_area_work(struct
  */
 static void free_vmap_area_noflush(struct vmap_area *va)
 {
+	unsigned long nr_lazy_max = lazy_max_pages();
+	unsigned long va_start = va->va_start;
 	unsigned long nr_lazy;
 
 	spin_lock(&vmap_area_lock);
@@ -1838,8 +1840,10 @@ static void free_vmap_area_noflush(struc
 		&purge_vmap_area_root, &purge_vmap_area_list);
 	spin_unlock(&purge_vmap_area_lock);
 
+	trace_free_vmap_area_noflush(va_start, nr_lazy, nr_lazy_max);
+
 	/* After this point, we may free va at any time */
-	if (unlikely(nr_lazy > lazy_max_pages()))
+	if (unlikely(nr_lazy > nr_lazy_max))
 		schedule_work(&drain_vmap_work);
 }
 
_

Patches currently in -mm which might be from urezki@gmail.com are


