Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C420C61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbjBJA4y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjBJAzX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:55:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFE274316
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4A27B82395
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839EFC433EF;
        Fri, 10 Feb 2023 00:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990461;
        bh=oY+oDttTDZZ/oAKcYQmWj1ESvfsMRNqHNoxDDjGpeYQ=;
        h=Date:To:From:Subject:From;
        b=geBwdHuTfhidDv2ncvo9kWLHRFGlwnRaNycvNcUY3fk22afpaAEI5wyQLfGPppDxm
         cHTUqNywoUGlSzFwBdjj759qJuzGk2FI+P19Np0YuMoFm5HExPv1nLqo8K6REv6DFb
         wpJD/QtXPABiDsLGJALr2H/o/51iQy5Jp59EeDRY=
Date:   Thu, 09 Feb 2023 16:54:21 -0800
To:     mm-commits@vger.kernel.org, urezki@gmail.com,
        stephen.s.brennan@oracle.com, lstoakes@gmail.com,
        error27@gmail.com, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-explicitly-identify-vm_map_ram-area-when-shown-in-proc-vmcoreinfo.patch removed from -mm tree
Message-Id: <20230210005421.839EFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc: explicitly identify vm_map_ram area when shown in /proc/vmcoreinfo
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-explicitly-identify-vm_map_ram-area-when-shown-in-proc-vmcoreinfo.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmalloc: explicitly identify vm_map_ram area when shown in /proc/vmcoreinfo
Date: Mon, 6 Feb 2023 16:40:17 +0800

Now, by marking VMAP_RAM in vmap_area->flags for vm_map_ram area, we can
clearly differentiate it with other vmalloc areas.  So identify
vm_map_area area by checking VMAP_RAM of vmap_area->flags when shown in
/proc/vmcoreinfo.

Meanwhile, the code comment above vm_map_ram area checking in s_show() is
not needed any more, remove it here.

Link: https://lkml.kernel.org/r/20230206084020.174506-5-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-explicitly-identify-vm_map_ram-area-when-shown-in-proc-vmcoreinfo
+++ a/mm/vmalloc.c
@@ -4152,14 +4152,11 @@ static int s_show(struct seq_file *m, vo
 
 	va = list_entry(p, struct vmap_area, list);
 
-	/*
-	 * s_show can encounter race with remove_vm_area, !vm on behalf
-	 * of vmap area is being tear down or vm_map_ram allocation.
-	 */
 	if (!va->vm) {
-		seq_printf(m, "0x%pK-0x%pK %7ld vm_map_ram\n",
-			(void *)va->va_start, (void *)va->va_end,
-			va->va_end - va->va_start);
+		if (va->flags & VMAP_RAM)
+			seq_printf(m, "0x%pK-0x%pK %7ld vm_map_ram\n",
+				(void *)va->va_start, (void *)va->va_end,
+				va->va_end - va->va_start);
 
 		goto final;
 	}
_

Patches currently in -mm which might be from bhe@redhat.com are


