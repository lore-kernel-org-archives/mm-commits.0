Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90505C54E94
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 00:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236068AbjAZAbH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 19:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235264AbjAZAbH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 19:31:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C89C64DA2
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 16:30:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D1D1B80DC0
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 00:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391C0C433D2;
        Thu, 26 Jan 2023 00:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674693019;
        bh=jz+0U4qe3K5NrjzMrr/oVuq0vXbKGGwmSJWHWIg07Zg=;
        h=Date:To:From:Subject:From;
        b=prfQdLKCuh29EFOMB/9susSzZmc/96GXhMUPtXGaGLkxpwNc0opjTsq1rdfm6y7z6
         B0GwnrE+W/WQ8Zn6fbwRg1RwhWTWfphDePGvRlSavrZKnUH4DS8aOc8Vy1jPEHeqnC
         YaqUoxBK4vjfXgB+maBU7F6ECl9RKI10rslbzZmg=
Date:   Wed, 25 Jan 2023 16:30:18 -0800
To:     mm-commits@vger.kernel.org, mhocko@suse.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-fork-convert-vma-assignment-to-a-memcpy.patch added to mm-unstable branch
Message-Id: <20230126003019.391C0C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/fork: convert vma assignment to a memcpy
has been added to the -mm mm-unstable branch.  Its filename is
     kernel-fork-convert-vma-assignment-to-a-memcpy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-fork-convert-vma-assignment-to-a-memcpy.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: kernel/fork: convert vma assignment to a memcpy
Date: Wed, 25 Jan 2023 15:35:48 -0800

Patch series "introduce vm_flags modifier functions", v3.

This patchset was originally published as a part of per-VMA locking [1] and
was split after suggestion that it's viable on its own and to facilitate
the review process. It is now a preprequisite for the next version of per-VMA
lock patchset, which reuses vm_flags modifier functions to lock the VMA when
vm_flags are being updated.

VMA vm_flags modifications are usually done under exclusive mmap_lock
protection because this attrubute affects other decisions like VMA merging
or splitting and races should be prevented. Introduce vm_flags modifier
functions to enforce correct locking.


This patch (of 7):

Convert vma assignment in vm_area_dup() to a memcpy() to prevent compiler
errors when we add a const modifier to vma->vm_flags.

Link: https://lkml.kernel.org/r/20230125233554.153109-2-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/kernel/fork.c~kernel-fork-convert-vma-assignment-to-a-memcpy
+++ a/kernel/fork.c
@@ -472,7 +472,7 @@ struct vm_area_struct *vm_area_dup(struc
 		 * orig->shared.rb may be modified concurrently, but the clone
 		 * will be reinitialized.
 		 */
-		*new = data_race(*orig);
+		memcpy(new, orig, sizeof(*new));
 		INIT_LIST_HEAD(&new->anon_vma_chain);
 		dup_anon_vma_name(orig, new);
 	}
_

Patches currently in -mm which might be from surenb@google.com are

kernel-fork-convert-vma-assignment-to-a-memcpy.patch
mm-introduce-vma-vm_flags-wrapper-functions.patch
mm-replace-vm_locked_clear_mask-with-vm_locked_mask.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls.patch
mm-replace-vma-vm_flags-indirect-modification-in-ksm_madvise.patch
mm-introduce-mod_vm_flags_nolock-and-use-it-in-untrack_pfn.patch
mm-export-dump_mm.patch

