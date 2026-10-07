Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA71C1E32D6
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338662; cv=none; b=pbDuuT7nTDzeSYzdsxdfndR0VIG3tp2F/sFQ2dsF4bG7kTX0MVlsV5ea/1clkqp7OpFmeCm8swUW8fO0zTfMkGOc4K7oZkrVw3oz4Q+JyAeJ3ke4MsXHt1Jt99zqUTv1n6ZF5FRBKYzFTMvdES9hCicXSsOHtdJgz1ac+DWtwEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338662; c=relaxed/simple;
	bh=89F7JPI8NocgK/6T57qjOtn86qT4yL6jOIEXj+4MUl0=;
	h=Date:To:From:Subject:Message-Id; b=Kk99ao9PFpwfapEIG/K8fZglOHUp3Q98LpGtk58pSlmdApSCCMGstFyIV3u3zQAeq4HDtUerXMptyQJaFTitHQjaiHGJtBO8GiBQV3pJ/SyCpSIKMYPg0vVVYpfR9g1eq1yCRKfgUcgMzlv50XO4EfX5/gP/Qrf632PGeDdNtLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XL7g8cGx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XL7g8cGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A3E1F0089C;
	Wed,  7 Oct 2026 02:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338660;
	bh=lT+EwUJ+eSIw+Z++Q4wdwIrwFVZnFkgsBzxTrUym1V4=;
	h=Date:To:From:Subject;
	b=XL7g8cGxejGmgmA9b6B+8rZLJ71r+PRnnXBhGUwT9ntl0XvdYW/1fi03S3ItB7/4W
	 v4ZhJSFeDzqc7omt9xsUHbiL2lPKLA23W720/XyrPG/gYr6UKM3QLd9oOYCZNtOa0h
	 fhBKL09U5Udt3yfJ7woQEMDSYQ0QiEBvsk/p+P+s=
Date: Tue, 06 Oct 2026 19:04:19 -0700
To: mm-commits@vger.kernel.org,wfelipe@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] init-main-fix-off-by-one-in-argv_init-cleanup.patch removed from -mm tree
Message-Id: <20261007020420.34A3E1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init/main: fix off-by-one in argv_init cleanup
has been removed from the -mm tree.  Its filename was
     init-main-fix-off-by-one-in-argv_init-cleanup.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -581,7 +581,7 @@ static int __init init_setup(char *str)
 	 * the shell think it should execute a script with such name.
 	 * So we ignore all arguments entered _before_ init=... [MJ]
 	 */
-	for (i = 1; i < MAX_INIT_ARGS; i++)
+	for (i = 1; i <= MAX_INIT_ARGS; i++)
 		argv_init[i] = NULL;
 	return 1;
 }
@@ -594,7 +594,7 @@ static int __init rdinit_setup(char *str
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

mm-zswap-convert-zswap_store_page-and-zswap_compress-to-take-a-folio.patch

