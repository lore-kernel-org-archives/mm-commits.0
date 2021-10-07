Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C84C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 02:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEBFF6125F
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 02:17:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhJGCTc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Oct 2021 22:19:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230443AbhJGCTb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 6 Oct 2021 22:19:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B024E61215;
        Thu,  7 Oct 2021 02:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633573058;
        bh=xNXK/XCb/Y05QyezdeC7PDmtHHfyFgbMDRliuLnWPr8=;
        h=Date:From:To:Subject:From;
        b=ACIAN9DOD0btVK5IRTatTq5ss4OkSvyHSv9K8AMbFJFEO9pOIqnhH1yw3Y0GumoNp
         xx3qp2QyYKbfmQMplEyjmgKRap/glTT+cQXf30h2/DziTpg+kM5rZPcETqcBKaudyJ
         Ua7fg7MyaaOImgigCfvy8Iv9ZIL5OMcDeAA953VI=
Date:   Wed, 06 Oct 2021 19:17:38 -0700
From:   akpm@linux-foundation.org
To:     dave.hansen@linux.intel.com, david@redhat.com,
        lukas.bulwahn@gmail.com, mhocko@suse.com,
        mm-commits@vger.kernel.org
Subject:  + memory-remove-unused-config_mem_block_size.patch added
 to -mm tree
Message-ID: <20211007021738.xlcvWbcoo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memory: remove unused CONFIG_MEM_BLOCK_SIZE
has been added to the -mm tree.  Its filename is
     memory-remove-unused-config_mem_block_size.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memory-remove-unused-config_mem_block_size.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memory-remove-unused-config_mem_block_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

elfcore-correct-reference-to-config_uml.patch
memory-remove-unused-config_mem_block_size.patch

