Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E12FC6379F
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 05:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjANFHM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Jan 2023 00:07:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjANFHG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 Jan 2023 00:07:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89483580
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 21:07:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CB02B822CC
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 05:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2E1C433EF;
        Sat, 14 Jan 2023 05:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673672823;
        bh=xVy7At8VjQaSkpSjDnh+j2cEbmUSZrVw5fCm76s7fDw=;
        h=Date:To:From:Subject:From;
        b=2tF9LkfcykX9hV8Na7FRZWbABhZq9SwMXRk8WB4vEtVHsBX/jMFGO62LAzqIJ50WB
         PFJRJPOpf9wF1hAR5jahEy0U5xHxgbVOCQkUGNxBJqOA7JOB3U+oMmZM53MwrXsMzw
         F+shC356Uc8WHrHf0MYijzkH23saUuWdj5UgWNrQ=
Date:   Fri, 13 Jan 2023 21:07:02 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, urezki@gmail.com,
        stephen.s.brennan@oracle.com, lstoakes@gmail.com,
        hch@infradead.org, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-explicitly-identify-vm_map_ram-area-when-shown-in-proc-vmcoreinfo.patch added to mm-unstable branch
Message-Id: <20230114050702.DA2E1C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: explicitly identify vm_map_ram area when shown in /proc/vmcoreinfo
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-explicitly-identify-vm_map_ram-area-when-shown-in-proc-vmcoreinfo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-explicitly-identify-vm_map_ram-area-when-shown-in-proc-vmcoreinfo.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmalloc: explicitly identify vm_map_ram area when shown in /proc/vmcoreinfo
Date: Fri, 13 Jan 2023 11:19:18 +0800

Now, by marking VMAP_RAM in vmap_area->flags for vm_map_ram, we can
clearly differentiate it with other vmalloc areas.  So identify
vm_map_area area by checking VMAP_RAM of vmap_area->flags when shown in
/proc/vmcoreinfo.

Meanwhile, the code comment above vm_map_ram area checking in s_show() is
not needed any more, remove it here.

Link: https://lkml.kernel.org/r/20230113031921.64716-5-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmalloc.c~mm-vmalloc-explicitly-identify-vm_map_ram-area-when-shown-in-proc-vmcoreinfo
+++ a/mm/vmalloc.c
@@ -4225,11 +4225,7 @@ static int s_show(struct seq_file *m, vo
 
 	va = list_entry(p, struct vmap_area, list);
 
-	/*
-	 * s_show can encounter race with remove_vm_area, !vm on behalf
-	 * of vmap area is being tear down or vm_map_ram allocation.
-	 */
-	if (!va->vm) {
+	if (!va->vm && (va->flags & VMAP_RAM)) {
 		seq_printf(m, "0x%pK-0x%pK %7ld vm_map_ram\n",
 			(void *)va->va_start, (void *)va->va_end,
 			va->va_end - va->va_start);
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmallocc-add-used_map-into-vmap_block-to-track-space-of-vmap_block.patch
mm-vmallocc-add-flags-to-mark-vm_map_ram-area.patch
mm-vmallocc-allow-vread-to-read-out-vm_map_ram-areas.patch
mm-vmalloc-explicitly-identify-vm_map_ram-area-when-shown-in-proc-vmcoreinfo.patch
mm-vmalloc-skip-the-uninitilized-vmalloc-areas.patch
powerpc-mm-add-vm_ioremap-flag-to-the-vmalloc-area.patch
sh-mm-set-vm_ioremap-flag-to-the-vmalloc-area.patch

