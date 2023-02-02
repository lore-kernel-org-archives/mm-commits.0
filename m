Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78DE1C05027
	for <mm-commits@archiver.kernel.org>; Thu,  2 Feb 2023 22:51:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjBBWvg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Feb 2023 17:51:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjBBWvf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2023 17:51:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D386B9B7
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 14:51:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 40652CE29D6
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D66C433EF;
        Thu,  2 Feb 2023 22:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675378287;
        bh=Gsnm/f4Jtj6YY7GC8m6FBX+49h3x47EsY7xQqVySKT0=;
        h=Date:To:From:Subject:From;
        b=q3P4UktWzeF2iyLkjk5vZuB61FbpfeJ5aKoVyBGoy9hwbHKuXjrpjKaSYJhjO4uRS
         HWJ1kgP6SuEeF06d02Om4CvZWT4K9fdaQkzXVw9s5SgCybcSS30VgqLF0aEmlAr3Tp
         dMhc5Bi3FNOoBnC63BvYD5cG/jGSfUbTKHFlKZRE=
Date:   Thu, 02 Feb 2023 14:51:26 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, lkp@intel.com,
        Kuan-Ying.Lee@mediatek.com, glider@google.com,
        andreyknvl@gmail.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-infer-allocation-size-by-scanning-metadata-fix.patch added to mm-unstable branch
Message-Id: <20230202225127.83D66C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-infer-allocation-size-by-scanning-metadata-fix
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-infer-allocation-size-by-scanning-metadata-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-infer-allocation-size-by-scanning-metadata-fix.patch

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
Subject: kasan-infer-allocation-size-by-scanning-metadata-fix
Date: Thu Feb  2 02:43:48 PM PST 2023

fix printk warning

Reported-by: kernel test robot <lkp@intel.com>
  Link: https://lkml.kernel.org/r/202302021325.700zGa0M-lkp@intel.com
Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/kasan/report.c~kasan-infer-allocation-size-by-scanning-metadata-fix
+++ a/mm/kasan/report.c
@@ -268,7 +268,7 @@ static void describe_object_addr(const v
 	}
 
 	pr_err("The buggy address is located %d bytes %s of\n"
-	       " %s%lu-byte region [%px, %px)\n",
+	       " %s%zu-byte region [%px, %px)\n",
 	       rel_bytes, rel_type, region_state, info->alloc_size,
 	       (void *)object_addr, (void *)(object_addr + info->alloc_size));
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-folio_add_new_anon_rmap-fix.patch
mm-remove-page_evictable-fix.patch
mm-remove-the-swap_readpage-return-value-fix.patch
block-remove-rw_page-fix.patch
mm-add-memcpy_from_file_folio-fix.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch
kasan-infer-allocation-size-by-scanning-metadata-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch

