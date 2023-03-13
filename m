Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C26EEC6FD19
	for <mm-commits@archiver.kernel.org>; Mon, 13 Mar 2023 18:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbjCMSHl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Mar 2023 14:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjCMSHh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Mar 2023 14:07:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFF14C6D9
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 11:07:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88B1B61454
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 18:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0209C433D2;
        Mon, 13 Mar 2023 18:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678730855;
        bh=hnOpTv+kOzhiKBDXKVyR0wG7kDi+jTfg0n3go/+3+wY=;
        h=Date:To:From:Subject:From;
        b=RaL7YJznBhR5xSNmAbC1mYBnUwLrkjFnpJBL3o3kwwK1FFuci4bndA45/jjozKjrw
         jsxGZwUCAyQDgdXl6sAuvIal+/0JWMvujW9E88lvpQhs+KvkdQNpcjvunTojpp0Y9J
         a/jZs1mv01Sy364h7bsEUmoBgzt3GBOnKJOKAPzM=
Date:   Mon, 13 Mar 2023 11:07:34 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        thomas.hellstrom@linux.intel.com, peterx@redhat.com,
        mhocko@suse.com, lstoakes@gmail.com, linux@armlinux.org.uk,
        kirill.shutemov@linux.intel.com, jgg@ziepe.ca, hca@linux.ibm.com,
        frederic@kernel.org, dan.j.williams@intel.com, cl@linux.com,
        christian.koenig@amd.com, chenhuacai@kernel.org,
        atomlin@atomlin.com, mtosatti@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + convert-this_cpu_cmpxchg-users-to-this_cpu_cmpxchg_local.patch added to mm-unstable branch
Message-Id: <20230313180734.E0209C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: convert this_cpu_cmpxchg users to this_cpu_cmpxchg_local
has been added to the -mm mm-unstable branch.  Its filename is
     convert-this_cpu_cmpxchg-users-to-this_cpu_cmpxchg_local.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/convert-this_cpu_cmpxchg-users-to-this_cpu_cmpxchg_local.patch

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
From: Marcelo Tosatti <mtosatti@redhat.com>
Subject: convert this_cpu_cmpxchg users to this_cpu_cmpxchg_local
Date: Mon, 13 Mar 2023 13:25:13 -0300

this_cpu_cmpxchg was modified to atomic version, which can be more costly
than non-atomic version.

Switch users of this_cpu_cmpxchg to this_cpu_cmpxchg_local (which
preserves pre-non-atomic this_cpu_cmpxchg behaviour).

Link: https://lkml.kernel.org/r/20230313162634.408562151@redhat.com
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/kernel/fork.c~convert-this_cpu_cmpxchg-users-to-this_cpu_cmpxchg_local
+++ a/kernel/fork.c
@@ -203,7 +203,7 @@ static bool try_release_thread_stack_to_
 	unsigned int i;
 
 	for (i = 0; i < NR_CACHED_STACKS; i++) {
-		if (this_cpu_cmpxchg(cached_stacks[i], NULL, vm) != NULL)
+		if (this_cpu_cmpxchg_local(cached_stacks[i], NULL, vm) != NULL)
 			continue;
 		return true;
 	}
--- a/kernel/scs.c~convert-this_cpu_cmpxchg-users-to-this_cpu_cmpxchg_local
+++ a/kernel/scs.c
@@ -83,7 +83,7 @@ void scs_free(void *s)
 	 */
 
 	for (i = 0; i < NR_CACHED_SCS; i++)
-		if (this_cpu_cmpxchg(scs_cache[i], 0, s) == NULL)
+		if (this_cpu_cmpxchg_local(scs_cache[i], 0, s) == NULL)
 			return;
 
 	kasan_unpoison_vmalloc(s, SCS_SIZE, KASAN_VMALLOC_PROT_NORMAL);
_

Patches currently in -mm which might be from mtosatti@redhat.com are

this_cpu_cmpxchg-arm64-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-loongarch-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-s390-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-x86-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
add-this_cpu_cmpxchg_local-and-asm-generic-definitions.patch
convert-this_cpu_cmpxchg-users-to-this_cpu_cmpxchg_local.patch
mm-vmstat-switch-counter-modification-to-cmpxchg.patch
vmstat-switch-per-cpu-vmstat-counters-to-32-bits.patch
mm-vmstat-use-xchg-in-cpu_vm_stats_fold.patch
mm-vmstat-switch-vmstat-shepherd-to-flush-per-cpu-counters-remotely.patch
mm-vmstat-refresh-stats-remotely-instead-of-via-work-item.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold.patch

