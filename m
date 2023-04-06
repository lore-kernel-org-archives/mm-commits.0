Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDDA2C761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234884AbjDFCpz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234812AbjDFCpJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:45:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8705E86B6
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68B2F6422C
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D3CC433EF;
        Thu,  6 Apr 2023 02:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749107;
        bh=6cVQdbxa2j+CLhMtilk4/cd8PgngWOmJ5MryCxKVUXE=;
        h=Date:To:From:Subject:From;
        b=fE9apXB47zjGmWCJj4x9xiSpvW6O/4Wn/bahw7SHu3Lkg10/uFVAWBb9NEeqaD9fp
         +X3XDNMH90y0GnslUx7TcOBOVOHJQFc4hqXVkiTfT7Oh7LAzqHgF2cVdbRATrzeTWa
         4OvZHETocXxfNe1pQb8fG2J6pD6CiATPOdzSjv8A=
Date:   Wed, 05 Apr 2023 19:45:07 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, philmd@linaro.org, opendmb@gmail.com,
        mhocko@kernel.org, mgorman@suse.de, david@redhat.com,
        rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mips-fix-comment-about-pgtable_init.patch removed from -mm tree
Message-Id: <20230406024507.C0D3CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mips: fix comment about pgtable_init()
has been removed from the -mm tree.  Its filename was
     mips-fix-comment-about-pgtable_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: mips: fix comment about pgtable_init()
Date: Tue, 21 Mar 2023 19:05:00 +0200

Patch series "mm: move core MM initialization to mm/mm_init.c", v2.

This set moves most of the core MM initialization to mm/mm_init.c.

This largely includes free_area_init() and its helpers, functions used at
boot time, mm_init() from init/main.c and some of the functions it calls.

Aside from gaining some more space before mm/page_alloc.c hits 10k lines,
this makes mm/page_alloc.c to be mostly about buddy allocator and moves
the init code out of the way, which IMO improves maintainability.

Besides, this allows to move a couple of declarations out of include/linux
and make them private to mm/.

And as an added bonus there a slight decrease in vmlinux size.  For
tinyconfig and defconfig on x86 I've got

tinyconfig:
   text	   data	    bss	    dec	    hex	filename
 853206	 289376	1200128	2342710	 23bf36	a/vmlinux
 853198	 289344	1200128	2342670	 23bf0e	b/vmlinux

defconfig:
    text   	   data	    bss	    dec	    	    hex	filename
26152959	9730634	2170884	38054477	244aa4d	a/vmlinux
26152945	9730602	2170884	38054431	244aa1f	b/vmlinux


This patch (of 14):

Comment about fixrange_init() says that its called from pgtable_init()
while the actual caller is pagetabe_init().

Update comment to match the code.

Link: https://lkml.kernel.org/r/20230321170513.2401534-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20230321170513.2401534-2-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Philippe Mathieu-Daud <philmd@linaro.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/fixmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/include/asm/fixmap.h~mips-fix-comment-about-pgtable_init
+++ a/arch/mips/include/asm/fixmap.h
@@ -70,7 +70,7 @@ enum fixed_addresses {
 #include <asm-generic/fixmap.h>
 
 /*
- * Called from pgtable_init()
+ * Called from pagetable_init()
  */
 extern void fixrange_init(unsigned long start, unsigned long end,
 	pgd_t *pgd_base);
_

Patches currently in -mm which might be from rppt@kernel.org are

arm-reword-arch_force_max_order-prompt-and-help-text.patch
arm64-drop-ranges-in-definition-of-arch_force_max_order.patch
arm64-reword-arch_force_max_order-prompt-and-help-text.patch
arm64-reword-arch_force_max_order-prompt-and-help-text-v3.patch
csky-drop-arch_force_max_order.patch
ia64-dont-allow-users-to-override-arch_force_max_order.patch
m68k-reword-arch_force_max_order-prompt-and-help-text.patch
nios2-reword-arch_force_max_order-prompt-and-help-text.patch
nios2-drop-ranges-for-definition-of-arch_force_max_order.patch
powerpc-reword-arch_force_max_order-prompt-and-help-text.patch
powerpc-drop-ranges-for-definition-of-arch_force_max_order.patch
sh-reword-arch_force_max_order-prompt-and-help-text.patch
sh-reword-arch_force_max_order-prompt-and-help-text-v3.patch
sh-drop-ranges-for-definition-of-arch_force_max_order.patch
sh-drop-ranges-for-definition-of-arch_force_max_order-v3.patch
sparc-reword-arch_force_max_order-prompt-and-help-text.patch
xtensa-reword-arch_force_max_order-prompt-and-help-text.patch
mm-move-free_area_empty-to-mm-internalh.patch

