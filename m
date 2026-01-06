Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0820F35E553
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 17:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721680; cv=none; b=rTKwqDGOQrAcUUUudqOwYwHPOffyRA09vB66z/JTZtZG77D27ck5k4jtY8y3HH9uiupVqvYbU2jBslNkiE7NfF2tZy9lCBovjioor42gBJcTC2SkaRJ1TEfKnNF+rGLRYUnX+Jnp6vwMMy7f0tLllYzGwNDZTZLty/kh3NY5hS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721680; c=relaxed/simple;
	bh=Bmd/tTAgy4ggwTGkAboHVxM35NMUHa8h2aa0uRUIqAM=;
	h=Date:To:From:Subject:Message-Id; b=qSBnivgBL/uSBjfAV2Y7jo24nYusWewfkFXYWLwKf3fDvgW9DRJyQy2a+EfWzFF0R1nYsQQasBkQ2F6+PU1Qq2YKE1oHQbTWVRfcUMDiEdsEr6Cfmn34ctbDXdOkswEjXV8DI3mh4tgjeXAPFZM8waBoynQLMlSgdR6XyMHb8rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qyrw+jPJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qyrw+jPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2706C116C6;
	Tue,  6 Jan 2026 17:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767721679;
	bh=Bmd/tTAgy4ggwTGkAboHVxM35NMUHa8h2aa0uRUIqAM=;
	h=Date:To:From:Subject:From;
	b=Qyrw+jPJvl0vusPik7oNdK3QAqMkuYNiu+dC4njvZqVxGxgS1rbMU4ogTFo7akCCH
	 mImesFy/gwEggwWq3UxUIMylsRZw+mEJTkXtDLplR/uCzgDQClhQkgG14UOO2rHR2/
	 EqXiinDh3z1Rhcmd+slqOpRhHlnJoybciw0PgUmc=
Date: Tue, 06 Jan 2026 09:47:59 -0800
To: mm-commits@vger.kernel.org,lirongqing@baidu.com,lance.yang@linux.dev,jm@machine-hall.org,tglozar@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-kconfigdebug-fix-bootparam_hung_task_panic-comment.patch added to mm-nonmm-unstable branch
Message-Id: <20260106174759.B2706C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/Kconfig.debug: fix BOOTPARAM_HUNG_TASK_PANIC comment
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-kconfigdebug-fix-bootparam_hung_task_panic-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-kconfigdebug-fix-bootparam_hung_task_panic-comment.patch

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
From: Tomas Glozar <tglozar@redhat.com>
Subject: lib/Kconfig.debug: fix BOOTPARAM_HUNG_TASK_PANIC comment
Date: Tue, 6 Jan 2026 15:01:40 +0100

The comment for CONFIG_BOOTPARAM_HUNG_TASK_PANIC says:

   Say N if unsure.

but since commit 9544f9e6947f ("hung_task: panic when there are more than
N hung tasks at the same time"), N is not a valid value for the option,
leading to a warning at build time:

   .config:11736:warning: symbol value 'n' invalid for BOOTPARAM_HUNG_TASK_PANIC

as well as an error when given to menuconfig.

Fix the comment to say '0' instead of 'N'.

Link: https://lkml.kernel.org/r/20260106140140.136446-1-tglozar@redhat.com
Fixes: 9544f9e6947f ("hung_task: panic when there are more than N hung tasks at the same time")
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Reported-by: Johnny Mnemonic <jm@machine-hall.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.debug~lib-kconfigdebug-fix-bootparam_hung_task_panic-comment
+++ a/lib/Kconfig.debug
@@ -1274,7 +1274,7 @@ config BOOTPARAM_HUNG_TASK_PANIC
 	  high-availability systems that have uptime guarantees and
 	  where a hung tasks must be resolved ASAP.
 
-	  Say N if unsure.
+	  Say 0 if unsure.
 
 config DETECT_HUNG_TASK_BLOCKER
 	bool "Dump Hung Tasks Blocker"
_

Patches currently in -mm which might be from tglozar@redhat.com are

lib-kconfigdebug-fix-bootparam_hung_task_panic-comment.patch

