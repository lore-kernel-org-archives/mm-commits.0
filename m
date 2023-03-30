Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61434C7619A
	for <mm-commits@archiver.kernel.org>; Thu, 30 Mar 2023 21:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjC3VDn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Mar 2023 17:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjC3VDm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Mar 2023 17:03:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFC1D51E
        for <mm-commits@vger.kernel.org>; Thu, 30 Mar 2023 14:03:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0C4E2CE2AA6
        for <mm-commits@vger.kernel.org>; Thu, 30 Mar 2023 21:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D95C433D2;
        Thu, 30 Mar 2023 21:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680210218;
        bh=G/W1O0aAMwutLx6v60/jFEaWOyDkb8DfGiP3Wp9DGbY=;
        h=Date:To:From:Subject:From;
        b=m2au87Gu+uDpeqj5oU5g0OYyR+u5LQrovlS+Q1TTBaesfHKAVcBlzRnqSh3mlyD8C
         vr0tMdbs973brZWMFcie6iP23XdQBQrMBRjmEd7IRsco+/YvbJEef6FnbTK4d8jDmI
         b3inQmfXlgC0HJxlNzT1rIKxmCG50UP1lu1RGYVo=
Date:   Thu, 30 Mar 2023 14:03:37 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, urezki@gmail.com,
        oleksiy.avramchenko@sony.com, lstoakes@gmail.com,
        hch@infradead.org, david@fromorbit.com, bhe@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix.patch added to mm-unstable branch
Message-Id: <20230330210338.46D95C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix
has been added to the -mm mm-unstable branch.  Its filename is
     lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix
Date: Thu Mar 30 02:02:39 PM PDT 2023

fix whitespace, per Lorenzo

Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_vmalloc.c~lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix
+++ a/lib/test_vmalloc.c
@@ -375,7 +375,7 @@ vm_map_ram_test(void)
 
 	nr_allocated = alloc_pages_bulk_array(GFP_KERNEL, map_nr_pages, pages);
 	if (nr_allocated != map_nr_pages)
-        goto cleanup;
+		goto cleanup;
 
 	/* Run the test loop. */
 	for (i = 0; i < test_loop_count; i++) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file-fix.patch
mm-add-new-api-to-enable-ksm-per-process-fix.patch
mm-treewide-redefine-max_order-sanely-fix-2.patch
mm-treewide-redefine-max_order-sanely-fix-3-fix.patch
memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch
mm-vmalloc-convert-vread-to-vread_iter-v8-fix.patch
lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix.patch
scripts-link-vmlinuxsh-fix-error-message-presentation.patch
notifiers-add-tracepoints-to-the-notifiers-infrastructure-checkpatch-fixes.patch

