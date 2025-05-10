Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9747722FAE1
	for <mm-commits@vger.kernel.org>; Sat, 10 May 2025 00:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746837952; cv=none; b=rrcmY83mExX9xdXGoHRKPCSy9Iy9jsTFoOYfnccY1KP9EKeH9THElAS6JbBPYOnQ2ZIg5wcVg6osdFk3E8m90/xkO2IctB+5lpBFpQ5qXAubq4QqdcPpb0pYRoGz2SR3ZIsOu+0anNP2deR5XV4VT8gA+Au1YPKzt4/Mf4Z1QEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746837952; c=relaxed/simple;
	bh=Iq3CvNCnvhT0y/tz8vFh73Iffqlu4NFG8ZlfORGA4h0=;
	h=Date:To:From:Subject:Message-Id; b=MaC9x2CBu+QNqdntyJPRbn9nzSdIO+xlZAYJ+M+2UxhENM6wz02/NRXlWA9V73D2mHQm/nQJbLojpazAVKicy0yG7V03fES9NzUs7VnyZBdaKqeokyii3TW0egHX4iXrrY+WOWNv09D1Vp4dYmjWTYXcup0Ml3GU9vF3BvtOaqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CWJ8tExT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CWJ8tExT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614A2C4CEE4;
	Sat, 10 May 2025 00:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746837952;
	bh=Iq3CvNCnvhT0y/tz8vFh73Iffqlu4NFG8ZlfORGA4h0=;
	h=Date:To:From:Subject:From;
	b=CWJ8tExTcZtC79gZxXGBvHa+BdSq3c0Xr9S3vh+/eMK0IDQkrlETMHjPO2dF/IMRA
	 jQ7gt8/i2VB0cvU95lh3wUY8WP5Vsxul2agNfpRy6P9jG3Iw25BMggzlfErrcq0TPc
	 7fXzJ/njE/qjviHOaE0JvdhwB8Xsl7OXo2c3sJxI=
Date: Fri, 09 May 2025 17:45:51 -0700
To: mm-commits@vger.kernel.org,linus.walleij@linaro.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-check-charging-success-before-zeroing-stack.patch added to mm-nonmm-unstable branch
Message-Id: <20250510004552.614A2C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fork: check charging success before zeroing stack
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fork-check-charging-success-before-zeroing-stack.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-check-charging-success-before-zeroing-stack.patch

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
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: fork: check charging success before zeroing stack
Date: Fri, 09 May 2025 08:29:28 +0200

No need to do zero cached stack if memcg charge fails, so move the
charging attempt before the memset operation.

[linus.walleij@linaro.org: rebased]
Link: https://lkml.kernel.org/r/20250509-fork-fixes-v3-3-e6c69dd356f2@linaro.org
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Link: https://lore.kernel.org/20240311164638.2015063-6-pasha.tatashin@soleen.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/fork.c~fork-check-charging-success-before-zeroing-stack
+++ a/kernel/fork.c
@@ -283,6 +283,11 @@ static int alloc_thread_stack_node(struc
 		if (!vm_area)
 			continue;
 
+		if (memcg_charge_kernel_stack(vm_area)) {
+			vfree(vm_area->addr);
+			return -ENOMEM;
+		}
+
 		/* Reset stack metadata. */
 		kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
 
@@ -291,11 +296,6 @@ static int alloc_thread_stack_node(struc
 		/* Clear stale pointers from reused stack. */
 		memset(stack, 0, THREAD_SIZE);
 
-		if (memcg_charge_kernel_stack(vm_area)) {
-			vfree(vm_area->addr);
-			return -ENOMEM;
-		}
-
 		tsk->stack_vm_area = vm_area;
 		tsk->stack = stack;
 		return 0;
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

task_stackh-remove-obsolete-__have_arch_kstack_end-check.patch
fork-clean-up-ifdef-logic-around-stack-allocation.patch
fork-clean-up-naming-of-vm_stack-vm_struct-variables-in-vmap-stacks-code.patch
fork-check-charging-success-before-zeroing-stack.patch

