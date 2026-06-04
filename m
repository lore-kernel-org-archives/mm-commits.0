Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EF02C1586
	for <mm-commits@vger.kernel.org>; Thu,  4 Jun 2026 17:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780594009; cv=none; b=j/Bds/AoQOfUt6/y8mGPFKPD/dWzQBTgS0YIewBeF/H6qb7xaSxnxHpsa4f0kIcMXwELXyoj0Cw/Qn0evDkrPzQoSn/YetSdOUIe8yc3vSiIOJtVZOSjjEuqsZRlN82FPRJxcWzowg2tgj61m79WLQbR6Atoxvb3+BexFvaj2ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780594009; c=relaxed/simple;
	bh=nKMHacfQtBmeZ5BSm03aQqcNp3RhNDIsROZ8mUV6jPU=;
	h=Date:To:From:Subject:Message-Id; b=c8ftiDj5H/Av1xC5ue+BL93McxL2h0BkoIzzov3jckRQcvzyVYVOYQ6DhnoQnX23nIvriafNVuOM70jVt5BZ6cp3IOw6uaNHIZoLz1wGodQZSlCCm3hmdnL3c5Dz6KLlfnzlu3I3yn/rLBM/eutJbdFEKuuOwA5B3YENPgr4OKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LEBaIRbZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LEBaIRbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B151F00893;
	Thu,  4 Jun 2026 17:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780594008;
	bh=yyMOOr9StzAJjU3HwUs9/RCLemslrVoB3QAkyNclrQM=;
	h=Date:To:From:Subject;
	b=LEBaIRbZtaHqxX1U4wz2344hGHEgA69B9sLqra9U+8dWOHY86CvPmMbcxvQRcPv37
	 9jLZXJVb4asoGroRv+cu99X/0pf3HjvJfs7/y35k9OWSbTtzNag+di6K9hS7UyEZgJ
	 OIl2Lety7TATa8EFwj7ploxh5QqF1UT0cIhhGqz4=
Date: Thu, 04 Jun 2026 10:26:47 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,elfring@users.sourceforge.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-simplify-data-output-in-zs_stats_size_show.patch added to mm-unstable branch
Message-Id: <20260604172648.27B151F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zsmalloc: simplify data output in zs_stats_size_show()
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-simplify-data-output-in-zs_stats_size_show.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-simplify-data-output-in-zs_stats_size_show.patch

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
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: zsmalloc: simplify data output in zs_stats_size_show()
Date: Thu, 4 Jun 2026 10:20:03 +0200

Move the specification for a line break from a seq_puts() call to a
seq_printf() call.

The source code was transformed by using the Coccinelle software.

Link: https://lore.kernel.org/126a924b-6f68-43bf-ae5a-449fb93e527b@web.de
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-simplify-data-output-in-zs_stats_size_show
+++ a/mm/zsmalloc.c
@@ -565,8 +565,7 @@ static int zs_stats_size_show(struct seq
 		total_freeable += freeable;
 	}
 
-	seq_puts(s, "\n");
-	seq_printf(s, " %5s %5s ", "Total", "");
+	seq_printf(s, "\n %5s %5s ", "Total", "");
 
 	for (fg = ZS_INUSE_RATIO_10; fg < NR_FULLNESS_GROUPS; fg++)
 		seq_printf(s, "%9lu ", inuse_totals[fg]);
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are

zsmalloc-simplify-data-output-in-zs_stats_size_show.patch

