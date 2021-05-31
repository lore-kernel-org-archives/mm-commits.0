Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB2E7C47080
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 21:54:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1A6A6135A
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 21:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbhEaVzz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 May 2021 17:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230439AbhEaVzy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 May 2021 17:55:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1370761002;
        Mon, 31 May 2021 21:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622498054;
        bh=NSPg4lXBBz87nQ1W3kULJm7VWH4NoHMVt0TXU1Pnm5U=;
        h=Date:From:To:Subject:From;
        b=xbTRjK6KVLRfcvK78yvexurb2+3yg9FyV9e3ZmHlTDHlvs/a0lmgWqTf7jDm8vfi2
         QPj0gh0XVYMC9CbOBPycGGW6IAQQuxZ+nx5lHsp+5LrI3lSTKwfOuBjV8/LI7bHSsx
         6rqIZdROxLK+MS2KWaARgJfUDbDSGTxozagS/30M=
Date:   Mon, 31 May 2021 14:54:13 -0700
From:   akpm@linux-foundation.org
To:     aisheng.dong@nxp.com, bhe@redhat.com, dyoung@redhat.com,
        mm-commits@vger.kernel.org, vgoyal@redhat.com
Subject:  +
 mm-rename-the-global-section-array-to-mem_sections.patch added to -mm tree
Message-ID: <20210531215413.8OSA_cjwR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename the global section array to mem_sections
has been added to the -mm tree.  Its filename is
     mm-rename-the-global-section-array-to-mem_sections.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rename-the-global-section-array-to-mem_sections.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rename-the-global-section-array-to-mem_sections.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dong Aisheng <aisheng.dong@nxp.com>
Subject: mm: rename the global section array to mem_sections

In order to distinguish the struct mem_section for a better code
readability and align with kernel doc [1] name below, change the global
mem section name to 'mem_sections' from 'mem_section'.

[1] Documentation/vm/memory-model.rst
"The `mem_section` objects are arranged in a two-dimensional array
called `mem_sections`."

Link: https://lkml.kernel.org/r/20210531091908.1738465-5-aisheng.dong@nxp.com
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   10 +++++-----
 kernel/crash_core.c    |    4 ++--
 mm/sparse.c            |   16 ++++++++--------
 3 files changed, 15 insertions(+), 15 deletions(-)

--- a/include/linux/mmzone.h~mm-rename-the-global-section-array-to-mem_sections
+++ a/include/linux/mmzone.h
@@ -1301,9 +1301,9 @@ struct mem_section {
 #define SECTION_ROOT_MASK	(SECTIONS_PER_ROOT - 1)
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
-extern struct mem_section **mem_section;
+extern struct mem_section **mem_sections;
 #else
-extern struct mem_section mem_section[NR_SECTION_ROOTS][SECTIONS_PER_ROOT];
+extern struct mem_section mem_sections[NR_SECTION_ROOTS][SECTIONS_PER_ROOT];
 #endif
 
 static inline unsigned long *section_to_usemap(struct mem_section *ms)
@@ -1314,12 +1314,12 @@ static inline unsigned long *section_to_
 static inline struct mem_section *__nr_to_section(unsigned long nr)
 {
 #ifdef CONFIG_SPARSEMEM_EXTREME
-	if (!mem_section)
+	if (!mem_sections)
 		return NULL;
 #endif
-	if (!mem_section[SECTION_NR_TO_ROOT(nr)])
+	if (!mem_sections[SECTION_NR_TO_ROOT(nr)])
 		return NULL;
-	return &mem_section[SECTION_NR_TO_ROOT(nr)][nr & SECTION_ROOT_MASK];
+	return &mem_sections[SECTION_NR_TO_ROOT(nr)][nr & SECTION_ROOT_MASK];
 }
 extern unsigned long __section_nr(struct mem_section *ms);
 extern size_t mem_section_usage_size(void);
--- a/kernel/crash_core.c~mm-rename-the-global-section-array-to-mem_sections
+++ a/kernel/crash_core.c
@@ -460,8 +460,8 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_SYMBOL(contig_page_data);
 #endif
 #ifdef CONFIG_SPARSEMEM
-	VMCOREINFO_SYMBOL_ARRAY(mem_section);
-	VMCOREINFO_LENGTH(mem_section, NR_SECTION_ROOTS);
+	VMCOREINFO_SYMBOL_ARRAY(mem_sections);
+	VMCOREINFO_LENGTH(mem_sections, NR_SECTION_ROOTS);
 	VMCOREINFO_STRUCT_SIZE(mem_section);
 	VMCOREINFO_OFFSET(mem_section, section_mem_map);
 	VMCOREINFO_NUMBER(MAX_PHYSMEM_BITS);
--- a/mm/sparse.c~mm-rename-the-global-section-array-to-mem_sections
+++ a/mm/sparse.c
@@ -23,12 +23,12 @@
  * 1) mem_section	- memory sections, mem_map's for valid memory
  */
 #ifdef CONFIG_SPARSEMEM_EXTREME
-struct mem_section **mem_section;
+struct mem_section **mem_sections;
 #else
-struct mem_section mem_section[NR_SECTION_ROOTS][SECTIONS_PER_ROOT]
+struct mem_section mem_sections[NR_SECTION_ROOTS][SECTIONS_PER_ROOT]
 	____cacheline_internodealigned_in_smp;
 #endif
-EXPORT_SYMBOL(mem_section);
+EXPORT_SYMBOL(mem_sections);
 
 #ifdef NODE_NOT_IN_PAGE_FLAGS
 /*
@@ -90,14 +90,14 @@ static int __meminit sparse_index_init(u
 	 *
 	 * The mem_hotplug_lock resolves the apparent race below.
 	 */
-	if (mem_section[root])
+	if (mem_sections[root])
 		return 0;
 
 	section = sparse_index_alloc(nid);
 	if (!section)
 		return -ENOMEM;
 
-	mem_section[root] = section;
+	mem_sections[root] = section;
 
 	return 0;
 }
@@ -130,7 +130,7 @@ unsigned long __section_nr(struct mem_se
 #else
 unsigned long __section_nr(struct mem_section *ms)
 {
-	return (unsigned long)(ms - mem_section[0]);
+	return (unsigned long)(ms - mem_sections[0]);
 }
 #endif
 
@@ -259,8 +259,8 @@ static void __init memory_present(int ni
 
 		size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
 		align = 1 << (INTERNODE_CACHE_SHIFT);
-		mem_section = memblock_alloc(size, align);
-		if (!mem_section)
+	mem_sections = memblock_alloc(size, align);
+	if (!mem_sections)
 			panic("%s: Failed to allocate %lu bytes align=0x%lx\n",
 			      __func__, size, align);
 	}
_

Patches currently in -mm which might be from aisheng.dong@nxp.com are

mm-rename-the-global-section-array-to-mem_sections.patch
mm-drop-section_shift-in-code-comments.patch

