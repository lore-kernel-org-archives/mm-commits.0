Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F99C636D4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 05:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbjBCF34 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 00:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbjBCF3r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 00:29:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC43638EA9
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 21:29:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 102CDB82976
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 05:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A309DC433D2;
        Fri,  3 Feb 2023 05:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675402182;
        bh=tO2OOj0m4h8yFrkx9f0RyEu/4vZjxhQA7c+56+VzQXk=;
        h=Date:To:From:Subject:From;
        b=QbiEhDlwzvyvL91DFmlowijaHsLTStsxCd37kkP4Ft0e5oqc6fwFS5ha1343TFpwn
         DkoO9DitZRAw+SLD+kS9c7rMucYrdE+eiv2uicVhZ4RFOlSIJopJlyMVYR3nZmxfCP
         +H/qJua3Cx5C7qbm5Cc9MKwkzgoQa6oya54h1ZII=
Date:   Thu, 02 Feb 2023 21:29:42 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, urezki@gmail.com,
        stephen.s.brennan@oracle.com, lstoakes@gmail.com,
        hch@infradead.org, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-explicitly-identify-vm_map_ram-area-when-shown-in-proc-vmcoreinfo.patch removed from -mm tree
Message-Id: <20230203052942.A309DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc: explicitly identify vm_map_ram area when shown in /proc/vmcoreinfo
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-explicitly-identify-vm_map_ram-area-when-shown-in-proc-vmcoreinfo.patch

This patch was dropped because an updated version will be merged

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
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
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

mm-vmalloc-skip-the-uninitilized-vmalloc-areas.patch
powerpc-mm-add-vm_ioremap-flag-to-the-vmalloc-area.patch
sh-mm-set-vm_ioremap-flag-to-the-vmalloc-area.patch

