Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B10EC64EC4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 22:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbjCCWiF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Mar 2023 17:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbjCCWhp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2023 17:37:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29B73A81
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 14:35:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8538761944
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 22:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC8BC433D2;
        Fri,  3 Mar 2023 22:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677882756;
        bh=Vdv2wbqTbvXy91RMYrJlS1lVWCGA9PSrQiy2gJTdKDs=;
        h=Date:To:From:Subject:From;
        b=RVKY31ajD/MRc6gijhUVgc5M0DdSajXHAHEXiYVmJsGFBRy7bEtHp52nY1JTB0etR
         Te4We0xTu3N3+Szb10vTPA/o1UcrBiDZ6773cMqjGE59Cf/UqxEEAzP6FDm6I3U+nr
         FsR8gu7WxgH4vtrhj2CsA66pPYvwJMptoo3SVIi8=
Date:   Fri, 03 Mar 2023 14:32:35 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, peterx@redhat.com,
        mingo@elte.hu, linux@armlinux.org.uk, hpa@zytor.com,
        hca@linux.ibm.com, frederic@kernel.org, david@redhat.com,
        cl@linux.com, chenhuacai@kernel.org, atomlin@atomlin.com,
        mtosatti@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + convert-this_cpu_cmpxchg-users-to-this_cpu_cmpxchg_local.patch added to mm-unstable branch
Message-Id: <20230303223235.DDC8BC433D2@smtp.kernel.org>
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
Date: Fri, 03 Mar 2023 16:58:48 -0300

this_cpu_cmpxchg was modified to atomic version, which can be more costly
than non-atomic version.

Switch users of this_cpu_cmpxchg to this_cpu_cmpxchg_local (which
preserves pre-non-atomic this_cpu_cmpxchg behaviour).

Link: https://lkml.kernel.org/r/20230303195908.926950608@redhat.com
Acked-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
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

mm-vmstat-remove-remote-node-draining.patch
this_cpu_cmpxchg-arm64-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-loongarch-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-s390-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-x86-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
add-this_cpu_cmpxchg_local-and-asm-generic-definitions.patch
convert-this_cpu_cmpxchg-users-to-this_cpu_cmpxchg_local.patch
mm-vmstat-switch-counter-modification-to-cmpxchg.patch
mm-vmstat-use-xchg-in-cpu_vm_stats_fold.patch
mm-vmstat-switch-vmstat-shepherd-to-flush-per-cpu-counters-remotely.patch
mm-vmstat-refresh-stats-remotely-instead-of-via-work-item.patch

