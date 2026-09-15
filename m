Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BBD3A9870
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 21:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789508277; cv=none; b=PsFviq/kFYkk9XGnz4b2fvTiz9esVIfck4uut72aSwRidvInGnbOjdKThkSrM62Ty3ktS2Ar5qJm5eCM/K7XpOwBFYtAPTihAaDonwR803EoEqsthBad6anKs7xdC6wCUgIRvEMCVWRbWxJy6BqnkvHtUv2bTYk7xejKhSdehxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789508277; c=relaxed/simple;
	bh=5LT8gJWqF7NIMSydXb+WmREQ/yptZ0UhlnjpDUHbqf0=;
	h=Date:To:From:Subject:Message-Id; b=Ck9Nel6MN0eiP0i77D9Th+/qlNejmne/94AgjKkPMqizr492f3D9MPgOFsqTRKgkPtyZZFNpAxX/74rXxbZM4/UPbOynD8SNEGPqrqeWChIRd7W8W2UvBIwlRWoA41MkIF/kilMf7JNftye4E3LaoHsJhVqBnA2NicYOQEmV0RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t1aA9HoR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t1aA9HoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA85A1F000FF;
	Tue, 15 Sep 2026 21:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789508275;
	bh=41kcZqJhqoZrmDRs0X9kpGQcMYhzbUZSAMFoLMmA/rQ=;
	h=Date:To:From:Subject;
	b=t1aA9HoRiC175LV9CGB0tS8yxGq9WPdbxwHYjDVWaQzgzmvZVia6WXP4GJZ5vgY7p
	 yvPrGs3kJIrYE1r2UsG52vtl7dAX+kMpjX87Wl+eAsLK9DAlySc+nuvgsgjXmFP/pz
	 leec737+68j54F+B8zlZCgSHMq3JZ70hqGkAYaaw=
Date: Tue, 15 Sep 2026 14:37:55 -0700
To: mm-commits@vger.kernel.org,balbirs@nvidia.com,brads@mainlining.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + taskstats-drop-the-unused-cpu_dont_care-enum-member.patch added to mm-nonmm-unstable branch
Message-Id: <20260915213755.AA85A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: taskstats: drop the unused CPU_DONT_CARE enum member
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     taskstats-drop-the-unused-cpu_dont_care-enum-member.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/taskstats-drop-the-unused-cpu_dont_care-enum-member.patch

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
From: Bradley Morgan <brads@mainlining.org>
Subject: taskstats: drop the unused CPU_DONT_CARE enum member
Date: Tue, 15 Sep 2026 18:06:23 +0000

CPU_DONT_CARE was added by the original listener cpumask code in 2006
(f9fd8914c1ac) and has never had a single user, not even in the
commit that introduced it. It survived every refactor of the listener
path since, including the recent handler folds.

Kill it, twenty years is enough.

Link: https://lore.kernel.org/20260915180623.22058-1-brads@mainlining.org
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbirs@nvidia.com>
---

 kernel/taskstats.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/taskstats.c~taskstats-drop-the-unused-cpu_dont_care-enum-member
+++ a/kernel/taskstats.c
@@ -59,8 +59,7 @@ static DEFINE_PER_CPU(struct listener_li
 
 enum actions {
 	REGISTER,
-	DEREGISTER,
-	CPU_DONT_CARE
+	DEREGISTER
 };
 
 static int prepare_reply(struct genl_info *info, u8 cmd, struct sk_buff **skbp,
_

Patches currently in -mm which might be from brads@mainlining.org are

taskstats-copy-signal-stats-under-siglock-in-taskstats_exit.patch
mailmap-update-email-address-for-bradley-morgan.patch
taskstats-drop-the-unused-cpu_dont_care-enum-member.patch

