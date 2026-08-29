Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9659C39182E
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 23:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788047189; cv=none; b=q4h+xOQ0UftVF8TDz284DuX/lghMDtv97n4xFHFU8Og4tE6YBIIXruuvOgAnLFDhxt/a4febkkTvsE/LvVJ4BFILNNDtebnm8zSmERbz4bGszyxC9m4IjF32jwtgjT/2DwIXXCvyy+9pFFQXA2qd1gVd3x4CpsuQRjsW3veIDKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788047189; c=relaxed/simple;
	bh=L91SbQ7KafLtif4HEIj7TZW2U11jM5JouZkVLTVLvGw=;
	h=Date:To:From:Subject:Message-Id; b=fIOalZQTUsqzL1svD/HpulU2Gl4QTw6H9sUK3r6odHsHDedjPIu3q+DZUtzKB5ndxIkAz8/sJLi4A7GX/umJmN/shXhGi8c9FRkrLFx8398Taeu9HowabYmEDajE+8yKNA/fBBRqFJJykEdDDBe4MYg+nvDPUzirNMUQbBhNGoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RNesJb/5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RNesJb/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D95A1F000E9;
	Sat, 29 Aug 2026 23:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788047188;
	bh=78wolC+298tm/Fw3SpCkaMkdojQUq4CkxcTV7pGmiRw=;
	h=Date:To:From:Subject;
	b=RNesJb/5p3IDPFr1ZDUJgn2SuXah5Ns0mhvs5FO3tB6GSJdXSo+m4/hzs60862chx
	 BwdAwfY7Y/rKfY2rdV4DUVm8fFFcQohKwzo1wfoM9hf5IjHyuPxmnup5eMNxxjAwml
	 I4AYTMuLJmrDs6Pe9p1OKeYfkHxT4VOKozWRmVvk=
Date: Sat, 29 Aug 2026 16:46:27 -0700
To: mm-commits@vger.kernel.org,wfelipe@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-main-fix-off-by-one-in-argv_init-cleanup.patch added to mm-nonmm-unstable branch
Message-Id: <20260829234628.0D95A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init/main: fix off-by-one in argv_init cleanup
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-main-fix-off-by-one-in-argv_init-cleanup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-main-fix-off-by-one-in-argv_init-cleanup.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Wilson Felipe Pereira <wfelipe@google.com>
Subject: init/main: fix off-by-one in argv_init cleanup
Date: Tue, 18 Aug 2026 04:53:46 +0000

Patch series "init: fix array boundary bugs in boot parameter parsing".

This series fixes two distinct boundary logic edge-case bugs in
`init/main.c` related to parsing boot command-line arguments and
environment variables.  Both bugs have been present since the early git
history (Linux-2.6.12-rc2).

1. The first patch fixes an off-by-one error in `init_setup()` where
   the final slot of the `argv_init` array was left uncleared. This
   allowed a stale kernel parameter to leak into the `init` process's
   user-space command line if exactly `MAX_INIT_ARGS` unknown
   parameters were passed.

2. The second patch fixes a false-positive kernel panic in
   `unknown_bootoption()`. If a user filled the environment variable
   array up to its exact limit (32) and then attempted to overwrite
   the final variable, the kernel would panic before evaluating
   whether it was a harmless duplicate.

Exact QEMU reproduction steps for both edge cases are documented inside
their respective commit descriptions.


This patch (of 2):

When cleaning up argv_init in init_setup() and rdinit_setup(), the loop
terminates one element early due to using '<' instead of '<='.  Since
argv_init is sized MAX_INIT_ARGS+2, index MAX_INIT_ARGS is a valid element
that should be cleared to NULL.

If exactly MAX_INIT_ARGS unknown arguments are passed before 'init=', the
uncleared argv_init[MAX_INIT_ARGS] can act as a ghost argument to
/sbin/init or cause a spurious kernel panic when later appended to.

To verify the argument leak, boot a VM into a shell with 32 unknown kernel
arguments, the init parameter, and 31 user arguments:

  STALE_ARGS=$(for i in {1..32}; do echo -n "stale$i "; done)
  USER_ARGS=$(for i in {1..31}; do echo -n "user$i "; done)
  qemu-system-x86_64 -kernel bzImage \
      -append "$STALE_ARGS init=/bin/sh $USER_ARGS"

Running `cat /proc/1/cmdline` inside the shell reveals that the 32nd
kernel argument ('stale32') incorrectly leaked into the init process's
command line.  This patch zeroes the final slot, cleanly terminating the
array.

Link: https://lore.kernel.org/20260818045357.4123784-1-wfelipe@google.com
Link: https://lore.kernel.org/20260818045357.4123784-2-wfelipe@google.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: ffdfc40976dd ("[PATCH] Add rdinit parameter to pick early userspace init")
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/init/main.c~init-main-fix-off-by-one-in-argv_init-cleanup
+++ a/init/main.c
@@ -576,7 +576,7 @@ static int __init init_setup(char *str)
 	 * the shell think it should execute a script with such name.
 	 * So we ignore all arguments entered _before_ init=... [MJ]
 	 */
-	for (i = 1; i < MAX_INIT_ARGS; i++)
+	for (i = 1; i <= MAX_INIT_ARGS; i++)
 		argv_init[i] = NULL;
 	return 1;
 }
@@ -589,7 +589,7 @@ static int __init rdinit_setup(char *str
 	ramdisk_execute_command = str;
 	ramdisk_execute_command_set = true;
 	/* See "auto" comment in init_setup */
-	for (i = 1; i < MAX_INIT_ARGS; i++)
+	for (i = 1; i <= MAX_INIT_ARGS; i++)
 		argv_init[i] = NULL;
 	return 1;
 }
_

Patches currently in -mm which might be from wfelipe@google.com are

selftests-cgroup-test_zswap-wait-for-cgroup-to-unpopulate-in-test_zswap_writeback.patch
selftests-cgroup-test_zswap-fix-implicit-unsigned-promotion-bug-in-test_no_kmem_bypass.patch
init-arch-make-config_command_line_size-globally-configurable.patch
init-kconfig-make-config-init_env_arg_limit-user-configurable.patch
init-main-fix-off-by-one-in-argv_init-cleanup.patch
init-main-fix-false-positive-kernel-panic-on-environment-variable-overwrite.patch

