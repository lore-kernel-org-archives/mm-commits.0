Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98F2239085
	for <mm-commits@vger.kernel.org>; Wed, 15 Apr 2026 10:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776247985; cv=none; b=Q2sBT8T+wuSt6fNaJynkBvTlaLwesBytqRustr2jqjE/Yl9T8FMJPro7mDxULmFPamwwNmrHNNi5OI0vh8he7c9zjsh2W5bGy3Gh8c25GPRARGXxWwZLxVKq1d7lAg15yZR/gAJf2Qkhx3srN9ogoMYhCl9OR/lkaH7Knix56dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776247985; c=relaxed/simple;
	bh=KNssawiX0kEv/te+opMI5edcVpaHXUsB6i5rcl6531Y=;
	h=Date:To:From:Subject:Message-Id; b=k3KTqUz7upQhrjXl2S6uy8OGKvBr+K+pKyEhr1SDWgV8UPnPKoJCRR8/w8WVfdUu8wJ2HEPcG8SYVQe6bHgE8zmTrpSEY8ivIKk4fKavoWf/PYUIIodRk5CQRwqGPmyUl1xVZ8nSJ2wevn45U+N6pW+cEJmEo2ptnBRJzgS/xBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l540s1/f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l540s1/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03EEC19424;
	Wed, 15 Apr 2026 10:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776247985;
	bh=KNssawiX0kEv/te+opMI5edcVpaHXUsB6i5rcl6531Y=;
	h=Date:To:From:Subject:From;
	b=l540s1/fXn5jVBL5V2GfzEt3hRkvAnvSN2DbzC6LRDN1rwiYQu16XL6yHIaLxuBtF
	 qYyRuirQMqVjNGWjkJWOcmO8E2PF7s4bjFJS5qt2nLr6DVXMbbsZRAxTi4DBcRLXQj
	 BF0PKKm8+R60B0qLCpS4bjwDDCOjhQmvmvi51NPg=
Date: Wed, 15 Apr 2026 03:13:00 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,koichiro.den@canonical.com,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,dave@stgolabs.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-avoid-false-positive-wuninitialized-warning.patch added to mm-unstable branch
Message-Id: <20260415101304.D03EEC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: avoid false-positive -Wuninitialized warning
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-avoid-false-positive-wuninitialized-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-avoid-false-positive-wuninitialized-warning.patch

This patch will later appear in the mm-unstable branch at
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
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm/vmscan: avoid false-positive -Wuninitialized warning
Date: Tue, 14 Apr 2026 08:51:58 +0200

When the -fsanitize=bounds sanitizer is enabled, gcc-16 sometimes runs
into a corner case in the read_ctrl_pos() pos function, where it sees
possible undefined behavior from the 'tier' index overflowing, presumably
in the case that this was called with a negative tier:

In function 'get_tier_idx',
    inlined from 'isolate_folios' at mm/vmscan.c:4671:14:
mm/vmscan.c: In function 'isolate_folios':
mm/vmscan.c:4645:29: error: 'pv.refaulted' is used uninitialized [-Werror=uninitialized]

Part of the problem seems to be that read_ctrl_pos() has unusual calling
conventions since commit 37a260870f2c ("mm/mglru: rework type selection")
where passing MAX_NR_TIERS makes it accumulate all tiers but passing a
smaller positive number makes it read a single tier instead.

Shut up the warning by adding a fake initialization to the two instances
of this variable that can run into that corner case.

Link: https://lore.kernel.org/all/CAJHvVcjtFW86o5FoQC8MMEXCHAC0FviggaQsd5EmiCHP+1fBpg@mail.gmail.com/
Link: https://lkml.kernel.org/r/20260414065206.3236176-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Koichiro Den <koichiro.den@canonical.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-avoid-false-positive-wuninitialized-warning
+++ a/mm/vmscan.c
@@ -4760,7 +4760,7 @@ static int scan_folios(unsigned long nr_
 static int get_tier_idx(struct lruvec *lruvec, int type)
 {
 	int tier;
-	struct ctrl_pos sp, pv;
+	struct ctrl_pos sp, pv = {};
 
 	/*
 	 * To leave a margin for fluctuations, use a larger gain factor (2:3).
@@ -4779,7 +4779,7 @@ static int get_tier_idx(struct lruvec *l
 
 static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 {
-	struct ctrl_pos sp, pv;
+	struct ctrl_pos sp, pv = {};
 
 	if (swappiness <= MIN_SWAPPINESS + 1)
 		return LRU_GEN_FILE;
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-vmscan-avoid-false-positive-wuninitialized-warning.patch

