Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59B18C10DAA
	for <mm-commits@archiver.kernel.org>; Tue, 28 Nov 2023 23:59:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376651AbjK1X7C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Nov 2023 18:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376663AbjK1X7A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Nov 2023 18:59:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B8019AC
        for <mm-commits@vger.kernel.org>; Tue, 28 Nov 2023 15:59:07 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F5EC433C8;
        Tue, 28 Nov 2023 23:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701215946;
        bh=v4LlQb9mYpjGWykuXuhGgb5ux6EsDW29VNQS6t9hgYU=;
        h=Date:To:From:Subject:From;
        b=Q1omdipUcK+BUrydnAb1CBz5+PBWNUPBSGMaQBsDlUXOybL6uEOXBvFr/8HoPTF7N
         BgpvxZaFrCoWm+ecStUwtr96aNjLWw3MlopCLFlAOJHMYoMjzk83GCx2QCt7SsOXGd
         p/pz9g7i9ojtdZFSABmSg2mutqSBYmcoDJjAdW+8=
Date:   Tue, 28 Nov 2023 15:59:06 -0800
To:     mm-commits@vger.kernel.org, osalvador@suse.de, mhocko@suse.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, david@redhat.com,
        anshuman.khandual@arm.com, aneesh.kumar@linux.ibm.com,
        agordeev@linux.ibm.com, sumanthk@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-enable-mhp_memmap_on_memory.patch added to mm-unstable branch
Message-Id: <20231128235906.B8F5EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: s390: enable MHP_MEMMAP_ON_MEMORY
has been added to the -mm mm-unstable branch.  Its filename is
     s390-enable-mhp_memmap_on_memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-enable-mhp_memmap_on_memory.patch

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
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: s390: enable MHP_MEMMAP_ON_MEMORY
Date: Tue, 28 Nov 2023 16:52:27 +0100

Enable MHP_MEMMAP_ON_MEMORY to support "memmap on memory". 
memory_hotplug.memmap_on_memory=true kernel parameter should be set in
kernel boot option to enable the feature.

Link: https://lkml.kernel.org/r/20231128155227.1315063-6-sumanthk@linux.ibm.com
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/Kconfig~s390-enable-mhp_memmap_on_memory
+++ a/arch/s390/Kconfig
@@ -113,6 +113,7 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_BH
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+	select ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
 	select ARCH_STACKWALK
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC
_

Patches currently in -mm which might be from sumanthk@linux.ibm.com are

mm-memory_hotplug-add-missing-mem_hotplug_lock.patch
mm-memory_hotplug-fix-error-handling-in-add_memory_resource.patch
mm-use-vmem_altmap-code-without-config_zone_device.patch
mm-memory_hotplug-introduce-mem_prepare_online-mem_finish_offline-notifiers.patch
s390-mm-allocate-vmemmap-pages-from-self-contained-memory-range.patch
s390-sclp-remove-unhandled-memory-notifier-type.patch
s390-mm-implement-mem_prepare_online-mem_finish_offline-notifiers.patch
s390-enable-mhp_memmap_on_memory.patch

