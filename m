Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E08435AC0E;
	Wed,  7 Oct 2026 02:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338718; cv=none; b=OjWaVIytvzZAo970aTwywtbJ0UAvuXC2nOZhZIRx2EqV6cPwg/FXVRVD35IfGRYh1871/ZHoNVJlnqonvbM0g2N6Eq9wS0Qf4ei7S63rBlyRkI8/P2jp1iZc7B2CsmkiCH2h+9heSbgVLd72TIIOrLZjBMljwIkqtidF6+U7aZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338718; c=relaxed/simple;
	bh=82F5Dfy4S+cn8VPAi9E09HESbVFPRk9RkxGuJBA3Oco=;
	h=Date:To:From:Subject:Message-Id; b=IYCjRUfgASIuaJcjh7nNeN/DhM4nH9jQE3Ht69GGhwn+02ys7Q5uSm79EbW9GlWBqQWAxDwgcD23HM4GrXlcV5ZPjOIN/7ze2/X9b4N0lds+Wvn/+WY7o/MY1118+0jeWsjT1Kqr4Gb0i7+2MyK7J9U2KnNPcVv4VTgfx4E7YzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vP56yCm8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vP56yCm8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FD11F0089B;
	Wed,  7 Oct 2026 02:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338717;
	bh=3te3DLB4EK4HCurvHtSNr0XgMlarC2SU+NLH/fMhF+E=;
	h=Date:To:From:Subject;
	b=vP56yCm852Vs1OkK3Lt7A6XeFcABREBj9M38qoKWTcOV15JCbiGFP3iDZG9aZK9Xw
	 q3j5rep6pZw4lg/EoeHJeWO1YTAsZ1tnD5HbfvRwno3g/2l60ety3Pv7FtKsQ9X9kc
	 syZDWXE1gns0dcUZ+nzrR2IQJaySPqnXic48olhA=
Date: Tue, 06 Oct 2026 19:05:16 -0700
To: mm-commits@vger.kernel.org,wim@linux-watchdog.org,wangjinchao600@gmail.com,stable@vger.kernel.org,sashiko-bot@kernel.org,pmladek@suse.com,linux@roeck-us.net,brads@mainlining.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-flatten-nmi_panic-control-flow.patch removed from -mm tree
Message-Id: <20261007020517.12FD11F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: flatten nmi_panic control flow
has been removed from the -mm tree.  Its filename was
     panic-flatten-nmi_panic-control-flow.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bradley Morgan <brads@mainlining.org>
Subject: panic: flatten nmi_panic control flow
Date: Wed, 16 Sep 2026 18:29:53 +0000

panic() is __noreturn, so the else after panic_try_start() is dead.  Drop
it so the force_cpu path can be added cleanly on top.

Link: https://lore.kernel.org/20260916182957.7788-3-brads@mainlining.org
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Guenetr Roeck <linux@roeck-us.net>
Cc: Sashiko <sashiko-bot@kernel.org>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: <stable@vger.kernel.org>
---

 kernel/panic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/panic.c~panic-flatten-nmi_panic-control-flow
+++ a/kernel/panic.c
@@ -517,7 +517,8 @@ void nmi_panic(struct pt_regs *regs, con
 {
 	if (panic_try_start())
 		panic("%s", msg);
-	else if (panic_on_other_cpu())
+
+	if (panic_on_other_cpu())
 		nmi_panic_self_stop(regs);
 }
 EXPORT_SYMBOL(nmi_panic);
_

Patches currently in -mm which might be from brads@mainlining.org are

watchdog-perf-one-digit-too-short-in-the-raw-event-config-copy.patch

