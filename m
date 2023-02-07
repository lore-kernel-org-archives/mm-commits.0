Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C032C61DA4
	for <mm-commits@archiver.kernel.org>; Tue,  7 Feb 2023 01:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbjBGBSY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Feb 2023 20:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjBGBSS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2023 20:18:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1B325B81
        for <mm-commits@vger.kernel.org>; Mon,  6 Feb 2023 17:18:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B6E2B816C6
        for <mm-commits@vger.kernel.org>; Tue,  7 Feb 2023 01:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD720C433D2;
        Tue,  7 Feb 2023 01:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675732692;
        bh=qsziNc4E6gHxOzcfk4YubrXnPG21ql1nTaty2MrSmsM=;
        h=Date:To:From:Subject:From;
        b=jCSUS/r0oVfcAi2XzdfCmBe3++yc0/6um2gxeyutUW9cC7C79FBJ2w379LEe0QUUc
         hs9Wb8IDssl3s+bqrlc24qwzfM2scJ/b1lWzpe5ePAhc+fJFWM5fL6/LPVIoZh3736
         79zHrb1NQLYy0Ppncel97bDbB62MYGMMInIxsB5g=
Date:   Mon, 06 Feb 2023 17:18:12 -0800
To:     mm-commits@vger.kernel.org, urezki@gmail.com,
        stephen.s.brennan@oracle.com, lstoakes@gmail.com,
        error27@gmail.com, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-explicitly-identify-vm_map_ram-area-when-shown-in-proc-vmcoreinfo.patch added to mm-unstable branch
Message-Id: <20230207011812.AD720C433D2@smtp.kernel.org>
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

mm-vmallocc-add-used_map-into-vmap_block-to-track-space-of-vmap_block.patch
mm-vmallocc-add-flags-to-mark-vm_map_ram-area.patch
mm-vmallocc-allow-vread-to-read-out-vm_map_ram-areas.patch
mm-vmalloc-explicitly-identify-vm_map_ram-area-when-shown-in-proc-vmcoreinfo.patch
mm-vmalloc-skip-the-uninitilized-vmalloc-areas.patch
powerpc-mm-add-vm_ioremap-flag-to-the-vmalloc-area.patch
sh-mm-set-vm_ioremap-flag-to-the-vmalloc-area.patch

