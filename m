Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE77C43334
	for <mm-commits@archiver.kernel.org>; Tue,  5 Jul 2022 21:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbiGEVVC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Jul 2022 17:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiGEVVA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jul 2022 17:21:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723DD14037
        for <mm-commits@vger.kernel.org>; Tue,  5 Jul 2022 14:20:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E90B61C81
        for <mm-commits@vger.kernel.org>; Tue,  5 Jul 2022 21:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63697C341C8;
        Tue,  5 Jul 2022 21:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657056058;
        bh=CWiMONrLh8SUW5umNek1OOo6Dn817jr5mC04sT9omHE=;
        h=Date:To:From:Subject:From;
        b=E5KR6RMpIFtlSNNyZJ9GVR3c9DiNPdNlLh/G7HrxfQaDJ66NRCJid9k6rSBC0cSok
         fNc++3rof75eRNzGoEA0qGBFhsot/+TW4T+XUXPNF5F1uqUibb1SoxNnIa/Ed5gExU
         r5kShFqgS3sd6120t4sKgL1HueS89jQhRM0zux6c=
Date:   Tue, 05 Jul 2022 14:20:57 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, dennis@kernel.org,
        cl@linux.com, catalin.marinas@arm.com, patrick.wang.shcn@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-percpu-use-kmemleak_ignore_phys-instead-of-kmemleak_free.patch added to mm-unstable branch
Message-Id: <20220705212058.63697C341C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: percpu: use kmemleak_ignore_phys() instead of kmemleak_free()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-percpu-use-kmemleak_ignore_phys-instead-of-kmemleak_free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-percpu-use-kmemleak_ignore_phys-instead-of-kmemleak_free.patch

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
From: Patrick Wang <patrick.wang.shcn@gmail.com>
Subject: mm: percpu: use kmemleak_ignore_phys() instead of kmemleak_free()
Date: Tue, 5 Jul 2022 19:31:58 +0800

Kmemleak recently added a rbtree to store the objects allocted with
physical address.  Those objects can't be freed with kmemleak_free().  Use
kmemleak_ignore_phys() instead of kmemleak_free() for those objects.

Link: https://lkml.kernel.org/r/20220705113158.127600-1-patrick.wang.shcn@gmail.com
Signed-off-by: Patrick Wang <patrick.wang.shcn@gmail.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/percpu.c~mm-percpu-use-kmemleak_ignore_phys-instead-of-kmemleak_free
+++ a/mm/percpu.c
@@ -3104,7 +3104,7 @@ int __init pcpu_embed_first_chunk(size_t
 			goto out_free_areas;
 		}
 		/* kmemleak tracks the percpu allocations separately */
-		kmemleak_free(ptr);
+		kmemleak_ignore_phys(__pa(ptr));
 		areas[group] = ptr;
 
 		base = min(ptr, base);
@@ -3304,7 +3304,7 @@ int __init pcpu_page_first_chunk(size_t
 				goto enomem;
 			}
 			/* kmemleak tracks the percpu allocations separately */
-			kmemleak_free(ptr);
+			kmemleak_ignore_phys(__pa(ptr));
 			pages[j++] = virt_to_page(ptr);
 		}
 	}
@@ -3417,7 +3417,7 @@ void __init setup_per_cpu_areas(void)
 	if (!ai || !fc)
 		panic("Failed to allocate memory for percpu areas.");
 	/* kmemleak tracks the percpu allocations separately */
-	kmemleak_free(fc);
+	kmemleak_ignore_phys(__pa(fc));
 
 	ai->dyn_size = unit_size;
 	ai->unit_size = unit_size;
_

Patches currently in -mm which might be from patrick.wang.shcn@gmail.com are

mm-percpu-use-kmemleak_ignore_phys-instead-of-kmemleak_free.patch

