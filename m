Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC633C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D41DE611F2
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbhKKCpq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:45:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:51032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234183AbhKKCpq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:45:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9626361108;
        Thu, 11 Nov 2021 02:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598577;
        bh=leX+/lq5AiZi8NZ7Xd5X7ZHKcluSO0KfAnh3Fluoq70=;
        h=Date:From:To:Subject:From;
        b=IoPekTuJzhnKmbVfB/WNdTha2qi4L3+9IcmxhRrZxPRJhJyo18/QaNh7Zy/onndzU
         G5EYHFLlZBQAYn7cy0DLBYNfYwoKZBJPNKVS7/HYnBuYEXimszJmfRJAtKt7j6Sp9S
         AKDOm16SH6omfAPLzGJ6/3I4wvEHdcDE+ZMZG3nY=
Date:   Wed, 10 Nov 2021 18:42:57 -0800
From:   akpm@linux-foundation.org
To:     dave.hansen@linux.intel.com, david@redhat.com,
        lukas.bulwahn@gmail.com, mhocko@suse.com,
        mm-commits@vger.kernel.org
Subject:  [merged] memory-remove-unused-config_mem_block_size.patch
 removed from -mm tree
Message-ID: <20211111024257.NlLoJd1DT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memory: remove unused CONFIG_MEM_BLOCK_SIZE
has been removed from the -mm tree.  Its filename was
     memory-remove-unused-config_mem_block_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: memory: remove unused CONFIG_MEM_BLOCK_SIZE

Commit 3947be1969a9 ("[PATCH] memory hotplug: sysfs and add/remove
functions") defines CONFIG_MEM_BLOCK_SIZE, but this has never been
utilized anywhere.

It is a good practice to keep the CONFIG_* defines exclusively for the
Kbuild system.  So, drop this unused definition.

This issue was noticed due to running ./scripts/checkkconfigsymbols.py.

Link: https://lkml.kernel.org/r/20211006120354.7468-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/memory.h~memory-remove-unused-config_mem_block_size
+++ a/include/linux/memory.h
@@ -140,7 +140,6 @@ typedef int (*walk_memory_blocks_func_t)
 extern int walk_memory_blocks(unsigned long start, unsigned long size,
 			      void *arg, walk_memory_blocks_func_t func);
 extern int for_each_memory_block(void *arg, walk_memory_blocks_func_t func);
-#define CONFIG_MEM_BLOCK_SIZE	(PAGES_PER_SECTION<<PAGE_SHIFT)
 
 extern int memory_group_register_static(int nid, unsigned long max_pages);
 extern int memory_group_register_dynamic(int nid, unsigned long unit_pages);
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are


