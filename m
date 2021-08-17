Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 435B4C4338F
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 20:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 241A161056
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 20:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbhHQUfp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 Aug 2021 16:35:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234474AbhHQUfp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 17 Aug 2021 16:35:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC17A6023E;
        Tue, 17 Aug 2021 20:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629232511;
        bh=ChZ2ddTJq0t/vEfx/3gsgXkXjHzqDDPRedhrfK8lg1Q=;
        h=Date:From:To:Subject:From;
        b=S0zC4VqWdLwpsyuaB8NqhZywu7EpfOAUjJbMkvN2j9mccdkeyeL8G3gp9+zMVmIr8
         rhOCS+sXY8MAYauC/GSVJx2BhfTx9M+ffQTexDZWfI39KRHkhvwdwRmHA3PV6zFrX9
         5TDWS7bu720bQ65oebp5IFSfyOcaVF4Hr0/+MmNI=
Date:   Tue, 17 Aug 2021 13:35:11 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, osalvador@suse.de, mhocko@suse.com,
        david@redhat.com, songmuchun@bytedance.com
Subject:  +
 mm-bootmem_info-mark-__init-on-register_page_bootmem_info_section.patch added
 to -mm tree
Message-ID: <20210817203511.sPTWh%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/bootmem_info.c: mark __init on register_page_bootmem_info_section
has been added to the -mm tree.  Its filename is
     mm-bootmem_info-mark-__init-on-register_page_bootmem_info_section.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-bootmem_info-mark-__init-on-register_page_bootmem_info_section.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-bootmem_info-mark-__init-on-register_page_bootmem_info_section.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/bootmem_info.c: mark __init on register_page_bootmem_info_section

register_page_bootmem_info_section() is only called from __init functions,
so mark it __init as well.

Link: https://lkml.kernel.org/r/20210817042221.77172-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem_info.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/bootmem_info.c~mm-bootmem_info-mark-__init-on-register_page_bootmem_info_section
+++ a/mm/bootmem_info.c
@@ -39,7 +39,7 @@ void put_page_bootmem(struct page *page)
 }
 
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
-static void register_page_bootmem_info_section(unsigned long start_pfn)
+static void __init register_page_bootmem_info_section(unsigned long start_pfn)
 {
 	unsigned long mapsize, section_nr, i;
 	struct mem_section *ms;
@@ -74,7 +74,7 @@ static void register_page_bootmem_info_s
 
 }
 #else /* CONFIG_SPARSEMEM_VMEMMAP */
-static void register_page_bootmem_info_section(unsigned long start_pfn)
+static void __init register_page_bootmem_info_section(unsigned long start_pfn)
 {
 	unsigned long mapsize, section_nr, i;
 	struct mem_section *ms;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-bootmem_info-mark-__init-on-register_page_bootmem_info_section.patch
mm-remove-redundant-compound_head-calling.patch

