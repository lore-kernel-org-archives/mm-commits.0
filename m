Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C4F1C77B7A
	for <mm-commits@archiver.kernel.org>; Wed, 17 May 2023 21:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjEQVFL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 May 2023 17:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjEQVFE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 May 2023 17:05:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78F644A3
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 14:05:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64E4164AEF
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 21:05:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FEEC433D2;
        Wed, 17 May 2023 21:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684357502;
        bh=D+ed/turYQFnsQqSFzMSxOuaoLLrY9AH/DYYNLIHl8E=;
        h=Date:To:From:Subject:From;
        b=CE2D9iudgGX9ckiX7IrnMwi9YAgkVDYrZM++ad15Zp51fz81SrRYpln+ml+zZQZic
         hKC0cQnDNIy0xed9kNfwZl1D/vZpjMqH/H1h2XqxwgHL0WvCd5RATabBzuFXUff5ge
         Q9Ufu6SpHk3gs4880kq/GAI5vsx7e2y6yMEl6dBc=
Date:   Wed, 17 May 2023 14:05:02 -0700
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
Subject: + init-move-cifs_root_data-prototype-into-linux-mounth.patch added to mm-nonmm-unstable branch
Message-Id: <20230517210502.B6FEEC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init: move cifs_root_data() prototype into linux/mount.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-move-cifs_root_data-prototype-into-linux-mounth.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-move-cifs_root_data-prototype-into-linux-mounth.patch

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
Subject: init: move cifs_root_data() prototype into linux/mount.h
Date: Wed, 17 May 2023 15:11:00 +0200

cifs_root_data() is defined in cifs and called from early init code, but
lacks a global prototype:

fs/cifs/cifsroot.c:83:12: error: no previous prototype for 'cifs_root_data'

Move the declaration from do_mounts.c into an appropriate header.

Link: https://lkml.kernel.org/r/20230517131102.934196-13-arnd@kernel.org
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

 include/linux/mount.h |    2 ++
 init/do_mounts.c      |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mount.h~init-move-cifs_root_data-prototype-into-linux-mounth
+++ a/include/linux/mount.h
@@ -124,4 +124,6 @@ extern int iterate_mounts(int (*)(struct
 			  struct vfsmount *);
 extern void kern_unmount_array(struct vfsmount *mnt[], unsigned int num);
 
+extern int cifs_root_data(char **dev, char **opts);
+
 #endif /* _LINUX_MOUNT_H */
--- a/init/do_mounts.c~init-move-cifs_root_data-prototype-into-linux-mounth
+++ a/init/do_mounts.c
@@ -489,8 +489,6 @@ static int __init mount_nfs_root(void)
 
 #ifdef CONFIG_CIFS_ROOT
 
-extern int cifs_root_data(char **dev, char **opts);
-
 #define CIFSROOT_TIMEOUT_MIN	5
 #define CIFSROOT_TIMEOUT_MAX	30
 #define CIFSROOT_RETRY_MAX	5
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

