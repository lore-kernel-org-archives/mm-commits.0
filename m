From: akpm@linux-foundation.org
Subject: + init-add-root=partuuid=uuid-partnroff=%d-support-fix.patch added to -mm tree
Date: Tue, 16 Aug 2011 13:47:21 -0700
Message-ID: <201108162047.p7GKlLNb026117@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752542Ab1HPUr6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 16:47:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, wad@chromium.org


The patch titled
     init-add-root=partuuid=uuid-partnroff=%d-support-fix
has been added to the -mm tree.  Its filename is
     init-add-root=partuuid=uuid-partnroff=%d-support-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init-add-root=partuuid=uuid-partnroff=%d-support-fix
From: Stephen Rothwell <sfr@canb.auug.org.au>

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
linux-next.patch
consolidate-config_debug_strict_user_copy_checks.patch
init-add-root=partuuid=uuid-partnroff=%d-support-fix.patch

