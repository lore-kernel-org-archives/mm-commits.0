Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF64AC77B75
	for <mm-commits@archiver.kernel.org>; Wed, 17 May 2023 21:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjEQVFP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 May 2023 17:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjEQVFK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 May 2023 17:05:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D1E7EC5
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 14:05:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93E8F64B52
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 21:05:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCB5C433EF;
        Wed, 17 May 2023 21:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684357508;
        bh=KIwz6EXWA2FjfmcSlNDm31lKRhYzGSlSRNWRt9WYffw=;
        h=Date:To:From:Subject:From;
        b=ExX1r2/l5gAuIlbF2tbIrQVLfy0G2iJyhBwh9gxjMUoE2ByGRhFav46N0/sZ5duzh
         IX9CINRxOva54drwFv4QTcxf9Q4xQ8IvVPWzwI+b6Eihk/HKpl1XDqW13/7KSHC/Kk
         +z+4dOeXLv7apPcpvXW55uYhFyFEKrz+oY5aKR00=
Date:   Wed, 17 May 2023 14:05:07 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        tsbogend@alpha.franken.de, tj@kernel.org, tglx@linutronix.de,
        rafael@kernel.org, peterz@infradead.org, pavel@ucw.cz,
        paul@paul-moore.com, palmer@dabbelt.com, mpe@ellerman.id.au,
        monstr@monstr.eu, mingo@redhat.com, longman@redhat.com,
        linux@armlinux.org.uk, hca@linux.ibm.com, eparis@redhat.com,
        dennis@kernel.org, deller@gmx.de, cl@linux.com,
        catalin.marinas@arm.com, boqun.feng@gmail.com, arnd@arndb.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + time_namespace-always-provide-arch_get_vdso_data-prototype-for-vdso.patch added to mm-nonmm-unstable branch
Message-Id: <20230517210507.DFCB5C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: time_namespace: always provide arch_get_vdso_data() prototype for vdso
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     time_namespace-always-provide-arch_get_vdso_data-prototype-for-vdso.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/time_namespace-always-provide-arch_get_vdso_data-prototype-for-vdso.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Arnd Bergmann <arnd@arndb.de>
Subject: time_namespace: always provide arch_get_vdso_data() prototype for vdso
Date: Wed, 17 May 2023 15:11:02 +0200

The arch_get_vdso_data() function is defined separately on each
architecture, but only called when CONFIG_TIME_NS is set.  If the
definition is a global function, this causes a W=1 warning without
TIME_NS:

arch/x86/entry/vdso/vma.c:35:19: error: no previous prototype for 'arch_get_vdso_data' [-Werror=missing-prototypes]

Move the prototype out of the #ifdef block to reliably turn off that
warning.

Link: https://lkml.kernel.org/r/20230517131102.934196-15-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/time_namespace.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/time_namespace.h~time_namespace-always-provide-arch_get_vdso_data-prototype-for-vdso
+++ a/include/linux/time_namespace.h
@@ -44,7 +44,6 @@ struct time_namespace *copy_time_ns(unsi
 				    struct time_namespace *old_ns);
 void free_time_ns(struct time_namespace *ns);
 void timens_on_fork(struct nsproxy *nsproxy, struct task_struct *tsk);
-struct vdso_data *arch_get_vdso_data(void *vvar_page);
 struct page *find_timens_vvar_page(struct vm_area_struct *vma);
 
 static inline void put_time_ns(struct time_namespace *ns)
@@ -163,4 +162,6 @@ static inline ktime_t timens_ktime_to_ho
 }
 #endif
 
+struct vdso_data *arch_get_vdso_data(void *vvar_page);
+
 #endif /* _LINUX_TIMENS_H */
_

Patches currently in -mm which might be from arnd@arndb.de are

radix-tree-move-declarations-to-header.patch
decompressor-provide-missing-prototypes.patch
kasan-add-kasan_tag_mismatch-prototype.patch
kasan-use-internal-prototypes-matching-gcc-13-builtins.patch
mm-percpu-unhide-pcpu_embed_first_chunk-prototype.patch
mm-page_poison-always-declare-__kernel_map_pages-function.patch
mm-sparse-mark-populate_section_memmap-static.patch
lib-devmem_is_allowed-include-linux-ioh.patch
locking-add-lockevent_read-prototype.patch
panic-hide-unused-global-functions.patch
panic-make-function-declarations-visible.patch
kunit-include-debugfs-header-file.patch
init-consolidate-prototypes-in-linux-inith.patch
init-move-cifs_root_data-prototype-into-linux-mounth.patch
thread_info-move-function-declarations-to-linux-thread_infoh.patch
time_namespace-always-provide-arch_get_vdso_data-prototype-for-vdso.patch

