Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38F2351C1E;
	Wed,  7 Oct 2026 02:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338677; cv=none; b=VaXLtPAOSLZT5985CNVAq5MvCK0sv0wXBWntJ9dgO/5emllMeaTRFWTOSPhQVmiligdajoJBsSKaW/X/j2cAjCb1iKtitJjk117y4DEHgy2viOgG6woVfw9c+Gp25GPGW6PN+7MZjcp3J2Vu1Oq2aSglU5+vV9W4hQWSqOZkuOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338677; c=relaxed/simple;
	bh=PwzR/ysO+s24mTwsG/AacQqcFPleu87XDZpPpXmgw/Y=;
	h=Date:To:From:Subject:Message-Id; b=CV14mYKxRBIJiN5NSOFVfJKPh2ghVx0zpIVVShM8wtbXhDhWDQnd3cLnBy6fIikiZ219AkD0NUpIK0l/kgM2vEi3gKmYVfQUtEyoTF6f8Kb8PwNS9FqKf8uTNLahs+mcJ7sJoseYNniMhYOxKwZBMWoVgWGkxxqQP6/OhFUWu+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gma53Nmg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gma53Nmg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A1C1F0089C;
	Wed,  7 Oct 2026 02:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338676;
	bh=GgdayeBC89P3JHvyvvCmvvAzWpEcs/PN7NCA/oCuOdo=;
	h=Date:To:From:Subject;
	b=gma53NmggWukp4p1Hi+xjqiX575sRb1BNwmuo/vqoNZcSB1lIcsVeJBKN4kxGtEhW
	 hjPBEntKQBj/pBDOBI9RRsoc/h7G1aS8JWHUGJGArX3FiHZ2GYkMLECDlLIdaVdoFG
	 /iJ9zE+OgEn5nx58sL7EsIM85ikVRE1Fdpu0ARuQ=
Date: Tue, 06 Oct 2026 19:04:36 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,peterz@infradead.org,mingo@redhat.com,kees@kernel.org,include@grrlz.net,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fork-honor-task_structs-declared-alignment.patch removed from -mm tree
Message-Id: <20261007020436.76A1C1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fork: honor task_struct's declared alignment
has been removed from the -mm tree.  Its filename was
     fork-honor-task_structs-declared-alignment.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Karl Mehltretter <kmehltretter@gmail.com>
Subject: fork: honor task_struct's declared alignment
Date: Fri, 10 Jul 2026 14:39:57 +0200

Since commit cb7ca40a3882 ("x86/fpu: Make task_struct::thread constant
size"), struct task_struct is declared __attribute__((aligned(64))) on all
architectures.

But fork_init() still sets the task_struct slab cache's alignment to

	align = max(L1_CACHE_BYTES, ARCH_MIN_TASKALIGN)

which is smaller than 64 on architectures whose cache lines are below 64
bytes: e.g.  32 on ARMv5.

In practice plain SLUB happens to hand out 64-byte-aligned objects anyway.
With CONFIG_SLUB_DEBUG_ON the red-zone padding shifts objects to the
requested alignment.

With CONFIG_UBSAN_ALIGNMENT=y a boot on QEMU versatilepb (ARM926EJ-S,
v7.2-rc2, gcc 13.3) floods the console with reports like:

  UBSAN: misaligned-access in include/linux/sched.h:2087:9
  member access within misaligned address c295d7e0 for type 'struct task_struct'
  which requires 64 byte alignment
  CPU: 0 UID: 0 PID: 15 Comm: pr/ttyAMA-1 Not tainted 7.2.0-rc2 #1 VOLUNTARY

Set the slab alignment to at least the type's declared alignment.

Link: https://lore.kernel.org/20260710123957.31774-1-kmehltretter@gmail.com
Fixes: cb7ca40a3882 ("x86/fpu: Make task_struct::thread constant size")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Bradley Morgan <include@grrlz.net>
Assisted-by: Claude:claude-fable-5
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
---

 kernel/fork.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/fork.c~fork-honor-task_structs-declared-alignment
+++ a/kernel/fork.c
@@ -858,7 +858,8 @@ void __init fork_init(void)
 #ifndef ARCH_MIN_TASKALIGN
 #define ARCH_MIN_TASKALIGN	0
 #endif
-	int align = max_t(int, L1_CACHE_BYTES, ARCH_MIN_TASKALIGN);
+	int align = max3(L1_CACHE_BYTES, ARCH_MIN_TASKALIGN,
+			 __alignof__(struct task_struct));
 	unsigned long useroffset, usersize;
 
 	/* create a slab on which task_structs can be allocated */
_

Patches currently in -mm which might be from kmehltretter@gmail.com are

docs-mm-ksm-use-the-renamed-ksm-structure-names.patch
mm-secretmem-fix-the-enable-parameter-description.patch
mm-damon-core-preserve-the-quota-passed-to-damon_new_scheme.patch
mm-damon-tests-core-kunit-test-preservation-of-quota-state.patch
mm-damon-tests-core-kunit-test-psi-goal-values-with-explicit-samples.patch
ocfs2-cluster-hold-a-reference-on-the-heartbeat-thread.patch
resource-kunit-stop-selecting-get_free_region.patch
kcov-report-spurious-pcs-in-the-interrupt-selftest.patch
squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch
squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch

