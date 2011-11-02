From: akpm@linux-foundation.org
Subject: [folded] init-add-root=partuuid=uuid-partnroff=%d-support-fix.patch removed from -mm tree
Date: Wed, 02 Nov 2011 13:17:08 -0700
Message-ID: <201111022017.pA2KH8mf012296@hpaq14.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:39251 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab1KBURU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Nov 2011 16:17:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, wad@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: init-add-root=partuuid=uuid-partnroff=%d-support-fix
has been removed from the -mm tree.  Its filename was
     init-add-root=partuuid=uuid-partnroff=%d-support-fix.patch

This patch was dropped because it was folded into init-add-root=partuuid=uuid-partnroff=%d-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: init-add-root=partuuid=uuid-partnroff=%d-support-fix

After merging the akpm tree, today's linux-next build (lost of them)
produced this warning:

WARNING: init/mounts.o(.text+0x192): Section mismatch in reference from the function devt_from_partuuid() to the variable .init.data:root_wait
The function devt_from_partuuid() references
the variable __initdata root_wait.
This is often because devt_from_partuuid lacks a __initdata
annotation or the annotation of root_wait is wrong.

Commit 185237e4cfab ("This patch makes two changes:"
init-add-root=partuuid=uuid-partnroff=%d-support-update.patch) adds the
reference to root_wait from the non-init function devt_from_partuuid().

The easiest thing to do is to remove __init_date from root_wait.

I have applied this patch as a merge fixup for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 10 Aug 2011 12:09:35 +1000
Subject: [PATCH] do_mounts: remove __init_data from root_wait

as it is now used from a non init routine.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Will Drewry <wad@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/do_mounts.c~init-add-root=partuuid=uuid-partnroff=%d-support-fix init/do_mounts.c
--- a/init/do_mounts.c~init-add-root=partuuid=uuid-partnroff=%d-support-fix
+++ a/init/do_mounts.c
@@ -28,7 +28,7 @@ int __initdata rd_doload;	/* 1 = load RA
 int root_mountflags = MS_RDONLY | MS_SILENT;
 static char * __initdata root_device_name;
 static char __initdata saved_root_name[64];
-static int __initdata root_wait;
+static int root_wait;
 
 dev_t ROOT_DEV;
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
init-add-root=partuuid=uuid-partnroff=%d-support.patch

