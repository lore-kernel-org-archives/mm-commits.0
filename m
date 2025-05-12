Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455482EB10
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011348; cv=none; b=VuofqIdt3gJvK3C0WaIaEv/QSZXwp3oAd3axNc18HgF6Icvn0FH4jdAkpfQaqzrMnWCI3B08hdHp/0ue5ih9u5X+GGrwPwU44J5xP1A8Lyu9N+2ZRc3G0zuv0VOKllleJ4wxVP/SmoqAMWauxMNT+Fk83EyrzxMl6zY4HtsQ19g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011348; c=relaxed/simple;
	bh=31YS7fXxiAynr9XaVe5u8yZWUJ/lVBFsoCxDUwUAzFE=;
	h=Date:To:From:Subject:Message-Id; b=sweDp/DkHkU1DP2G1hkf5qgmo1immvaaQAiOr1augb3mfeHWkxMLjgq3g16Es3YFZuyJPKrE0QpyncnuhtcnZHBF3Z5+zWX9z2BTpu4Y9W92ZMbKnR1g3UF7e+sxKfze2oGMNvsFxyh+JYZUbxGD85JAPoQ5XmyPN5gHydulaHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nuigcsID; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nuigcsID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFA6C4CEE4;
	Mon, 12 May 2025 00:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011348;
	bh=31YS7fXxiAynr9XaVe5u8yZWUJ/lVBFsoCxDUwUAzFE=;
	h=Date:To:From:Subject:From;
	b=nuigcsIDQfAgdt+bvD6Bj/cxrdrtPh/Zo1FitPFz7IGNSaZWvKSGAP4L6ST5CRTZO
	 SFIkD4QSgzkOMgGWXrAfhCsSV5MgL96jQ29QAnF2RUqDldrQrBdfjAWHtXAyluKde+
	 p59hbidculE8i1TWa4X+6Nuy4w+YfyJyUKfXpfvs=
Date: Sun, 11 May 2025 17:55:47 -0700
To: mm-commits@vger.kernel.org,viresh.kumar@linaro.org,lukas.bulwahn@gmail.com,louis.chauvet@bootlin.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,jim.cromie@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] powernow-use-pr_info_once.patch removed from -mm tree
Message-Id: <20250512005548.1BFA6C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powernow: use pr_info_once
has been removed from the -mm tree.  Its filename was
     powernow-use-pr_info_once.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jim Cromie <jim.cromie@gmail.com>
Subject: powernow: use pr_info_once
Date: Tue, 25 Mar 2025 17:51:56 -0600

This reduces log-msgs during boot from many pages to ~10 occurrences.  I
didn't investigate why it wasn't just 1, maybe its a low-level service to
other modules, re-probed by each of them ?

Link: https://lkml.kernel.org/r/20250325235156.663269-4-jim.cromie@gmail.com
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Louis Chauvet <louis.chauvet@bootlin.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/powernow-k8.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cpufreq/powernow-k8.c~powernow-use-pr_info_once
+++ a/drivers/cpufreq/powernow-k8.c
@@ -482,7 +482,7 @@ static void check_supported_cpu(void *_r
 		cpuid(CPUID_FREQ_VOLT_CAPABILITIES, &eax, &ebx, &ecx, &edx);
 		if ((edx & P_STATE_TRANSITION_CAPABLE)
 			!= P_STATE_TRANSITION_CAPABLE) {
-			pr_info("Power state transitions not supported\n");
+			pr_info_once("Power state transitions not supported\n");
 			return;
 		}
 		*rc = 0;
_

Patches currently in -mm which might be from jim.cromie@gmail.com are


