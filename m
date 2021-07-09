Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3E0EC07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 23:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F6BC613B2
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 23:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbhGIXl2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 19:41:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:32908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229854AbhGIXl1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 19:41:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B96AC613BC;
        Fri,  9 Jul 2021 23:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625873922;
        bh=aCXuxArHkTqEEJPR3DxOSmPBMvZtPSGt+a0BCkb+pGs=;
        h=Date:From:To:Subject:From;
        b=AhlfhlCvV/e3o61T18/PM6LAVAgZr7Et4MCyFo2MTWXSXsU5h/kaJ+lfbOeLp2XUh
         f54qRrYNv7nuzTtyWD20EsDHotNbQ9wVNvmT8Va5W+vboP6yGw+o5f3IPHI/ID4HE/
         pLLQDGQugXtSNRUcFnRDz0828PydF0oQhASvI7PE=
Date:   Fri, 09 Jul 2021 16:38:37 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com, mhocko@suse.com,
        david@redhat.com, bhe@redhat.com, ohoono.kwon@samsung.com
Subject:  + mm-sparse-pass-section_nr-to-section_mark_present.patch
 added to -mm tree
Message-ID: <20210709233837.eNSzJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: sparse: pass section_nr to section_mark_present
has been added to the -mm tree.  Its filename is
     mm-sparse-pass-section_nr-to-section_mark_present.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-sparse-pass-section_nr-to-section_mark_present.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-sparse-pass-section_nr-to-section_mark_present.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ohhoon Kwon <ohoono.kwon@samsung.com>
Subject: mm: sparse: pass section_nr to section_mark_present

Patch series "mm: sparse: remove __section_nr() function", v4.


This patch (of 3):

With CONFIG_SPARSEMEM_EXTREME enabled, __section_nr() which converts
mem_section to section_nr could be costly since it iterates all section
roots to check if the given mem_section is in its range.

Since both callers of section_mark_present already know section_nr, let's
also pass section_nr as well as mem_section in order to reduce costly
translation.

Link: https://lkml.kernel.org/r/20210707150212.855-1-ohoono.kwon@samsung.com
Link: https://lkml.kernel.org/r/20210707150212.855-2-ohoono.kwon@samsung.com
Signed-off-by: Ohhoon Kwon <ohoono.kwon@samsung.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/sparse.c~mm-sparse-pass-section_nr-to-section_mark_present
+++ a/mm/sparse.c
@@ -187,10 +187,9 @@ void __meminit mminit_validate_memmodel_
  * those loops early.
  */
 unsigned long __highest_present_section_nr;
-static void section_mark_present(struct mem_section *ms)
+static void __section_mark_present(struct mem_section *ms,
+		unsigned long section_nr)
 {
-	unsigned long section_nr = __section_nr(ms);
-
 	if (section_nr > __highest_present_section_nr)
 		__highest_present_section_nr = section_nr;
 
@@ -280,7 +279,7 @@ static void __init memory_present(int ni
 		if (!ms->section_mem_map) {
 			ms->section_mem_map = sparse_encode_early_nid(nid) |
 							SECTION_IS_ONLINE;
-			section_mark_present(ms);
+			__section_mark_present(ms, section);
 		}
 	}
 }
@@ -934,7 +933,7 @@ int __meminit sparse_add_section(int nid
 
 	ms = __nr_to_section(section_nr);
 	set_section_nid(section_nr, nid);
-	section_mark_present(ms);
+	__section_mark_present(ms, section_nr);
 
 	/* Align memmap to section boundary in the subsection case */
 	if (section_nr_to_pfn(section_nr) != start_pfn)
_

Patches currently in -mm which might be from ohoono.kwon@samsung.com are

mm-sparse-pass-section_nr-to-section_mark_present.patch
mm-sparse-pass-section_nr-to-find_memory_block.patch
mm-sparse-remove-__section_nr-function.patch

