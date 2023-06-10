Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5A24C7EE25
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjFJApm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbjFJAph (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87AE23AA5
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 180F0651CE
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD6EC433D2;
        Sat, 10 Jun 2023 00:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357925;
        bh=orzthzQDN0thJjan3vT4A4nZuQrT+OLH4DO0olZzzqI=;
        h=Date:To:From:Subject:From;
        b=ufJovX9ZXVWhQqSG3RNS69MNE3hcVdlTx67VA+4+yZUpxYUABwhdhxg9axWmFTD+h
         npKwMCp5P3ZBLwuPeqWIbPDglugstZ4ohd1ZBpVqO+ol99jGj1EP/wNxBCr0cmr1pl
         iZG+qUwCLSvjwaANDh7L9wgHBCclAeNLwV4hoTX8=
Date:   Fri, 09 Jun 2023 17:45:24 -0700
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
Subject: [merged mm-nonmm-stable] time_namespace-always-provide-arch_get_vdso_data-prototype-for-vdso.patch removed from -mm tree
Message-Id: <20230610004525.6CD6EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: time_namespace: always provide arch_get_vdso_data() prototype for vdso
has been removed from the -mm tree.  Its filename was
     time_namespace-always-provide-arch_get_vdso_data-prototype-for-vdso.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

kcov-add-prototypes-for-helper-functions.patch
decompressor-provide-missing-prototypes.patch
syscalls-add-sys_ni_posix_timers-prototype.patch

