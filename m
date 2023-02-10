Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90FA4C61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbjBJA5I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:57:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbjBJAzY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:55:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4AAD6F8FC
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60D3DB82396
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188D3C4339C;
        Fri, 10 Feb 2023 00:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990463;
        bh=TGjZuZ9csc2vc+uIJ56taNFj7Cw6lztGugvsTje5qu0=;
        h=Date:To:From:Subject:From;
        b=BOy4jkNVCczQyJMCTj7Zadd8VrRO3FD70a5OOW7dQ3LqYkjsQWZmBkcTU/mt+IW5p
         60HNuZ9UZi8q+t37m18mFf4bt4zSnBWZnznX52tZyEF71eNT4GMkdLf5La63yUNCoS
         4+K4WZFkJk38OR1VRZmmNyUvxJphQhyEJ7H6oFsM=
Date:   Thu, 09 Feb 2023 16:54:22 -0800
To:     mm-commits@vger.kernel.org, urezki@gmail.com,
        stephen.s.brennan@oracle.com, lstoakes@gmail.com,
        error27@gmail.com, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-skip-the-uninitilized-vmalloc-areas.patch removed from -mm tree
Message-Id: <20230210005423.188D3C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc: skip the uninitilized vmalloc areas
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-skip-the-uninitilized-vmalloc-areas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmalloc: skip the uninitilized vmalloc areas
Date: Mon, 6 Feb 2023 16:40:18 +0800

For areas allocated via vmalloc_xxx() APIs, it searches for unmapped area
to reserve and allocates new pages to map into, please see function
__vmalloc_node_range().  During the process, flag VM_UNINITIALIZED is set
in vm->flags to indicate that the pages allocation and mapping haven't
been done, until clear_vm_uninitialized_flag() is called to clear
VM_UNINITIALIZED.

For this kind of area, if VM_UNINITIALIZED is still set, let's ignore it
in vread() because pages newly allocated and being mapped in that area
only contains zero data.  reading them out by aligned_vread() is wasting
time.

Link: https://lkml.kernel.org/r/20230206084020.174506-6-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/vmalloc.c~mm-vmalloc-skip-the-uninitilized-vmalloc-areas
+++ a/mm/vmalloc.c
@@ -3587,6 +3587,11 @@ long vread(char *buf, char *addr, unsign
 		if (!vm && !flags)
 			continue;
 
+		if (vm && (vm->flags & VM_UNINITIALIZED))
+			continue;
+		/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
+		smp_rmb();
+
 		vaddr = (char *) va->va_start;
 		size = vm ? get_vm_area_size(vm) : va_size(va);
 
_

Patches currently in -mm which might be from bhe@redhat.com are


