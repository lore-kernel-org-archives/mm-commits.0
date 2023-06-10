Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2262FC7EE45
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjFJApk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbjFJApg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D9D3A9D
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AEEA651C3
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECC1C433D2;
        Sat, 10 Jun 2023 00:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357922;
        bh=I49l80tyyJSYWHGPd9n4ycenvLsN6LgM2gd7Inuokjs=;
        h=Date:To:From:Subject:From;
        b=bi1HHxxnigfb1/weL8HNyI9bwzhZIn+7Oud9pS4kVP4hkZZxyN1q6xzQDQXDTMaGD
         y9cVL/I3Gb23QmYpQ0Fg+gdDkrgC2JFba/J9hDlTW6Ig3Vv3iv9duEgxSRePcFff5p
         etKRFBhbPHq5aKa9dU+8WJYIb5KHXuqX9zRsjJ8I=
Date:   Fri, 09 Jun 2023 17:45:22 -0700
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
Subject: [merged mm-nonmm-stable] init-move-cifs_root_data-prototype-into-linux-mounth.patch removed from -mm tree
Message-Id: <20230610004522.CECC1C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: init: move cifs_root_data() prototype into linux/mount.h
has been removed from the -mm tree.  Its filename was
     init-move-cifs_root_data-prototype-into-linux-mounth.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

thread_info-move-function-declarations-to-linux-thread_infoh.patch
time_namespace-always-provide-arch_get_vdso_data-prototype-for-vdso.patch
kcov-add-prototypes-for-helper-functions.patch
decompressor-provide-missing-prototypes.patch
syscalls-add-sys_ni_posix_timers-prototype.patch

