Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A9773441
	for <mm-commits@vger.kernel.org>; Fri, 28 Jun 2024 19:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719603073; cv=none; b=gWINIBdmuI0IZaizrYpwYRJYL6I36vFdbjebcPkWxTS7zhNvZcb/vOOCM4lD5eA6pZyGRw5cmcFOayVsabh6P6CYpgZ2g/DuhjoH1jiROxMooOnfNH1UcPULDZijiyK+7NvNvrpvJB5qwIMw8Y9JXg188KDDKziONwF7Euf8M0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719603073; c=relaxed/simple;
	bh=ft8+SeODpza+VTeIZFGzBO+MgFFYnZVhUt9aa97Hy0o=;
	h=Date:To:From:Subject:Message-Id; b=fU0CbkCX7DP50DN8HJRY+L6ztW5We5UgI18PKUn3eTSiHbfodsenlbp0GrZBGbVX3BpBJCK+5JYVD6nro8932lLsCSkJJh/mwysbcc+dSjQGRpJqBKWCLDq1NXi/cxcDD5JkW2oNzSTf123kgcSKBrfVn0eg/ll7gGggIsG9wTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vvzdVoYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vvzdVoYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F738C116B1;
	Fri, 28 Jun 2024 19:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719603073;
	bh=ft8+SeODpza+VTeIZFGzBO+MgFFYnZVhUt9aa97Hy0o=;
	h=Date:To:From:Subject:From;
	b=vvzdVoYYYf2vFrAq4EjGFEEGBdVry9JXmpNuXbHZ6p4n2NUt4JZhfSQ8w5ku+DibS
	 cLNZBnqeTePTbAyN5ibBBJUgYbbdwtMUlyPvz/fg5Lp2RvhPhicF+QV34sw12+wFyK
	 kwlXZ3orl2VhkoyEVcyS/4ruV/U0pRh+KYbH8c8U=
Date: Fri, 28 Jun 2024 12:31:12 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,xiujianfeng@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-adjust-the-warning-when-seq_buf-overflows.patch added to mm-unstable branch
Message-Id: <20240628193113.4F738C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: adjust the warning when seq_buf overflows
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-adjust-the-warning-when-seq_buf-overflows.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-adjust-the-warning-when-seq_buf-overflows.patch

This patch will later appear in the mm-unstable branch at
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
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: mm: memcg: adjust the warning when seq_buf overflows
Date: Fri, 28 Jun 2024 07:23:33 +0000

Currently it uses WARN_ON_ONCE() if seq_buf overflows when user reads
memory.stat, the only advantage of WARN_ON_ONCE is that the splat is so
verbose that it gets noticed.  And also it panics the system if
panic_on_warn is enabled.  It seems like the warning is just an over
reaction and a simple pr_warn should just achieve the similar effect.

Link: https://lkml.kernel.org/r/20240628072333.2496527-1-xiujianfeng@huawei.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-adjust-the-warning-when-seq_buf-overflows
+++ a/mm/memcontrol.c
@@ -1484,7 +1484,8 @@ static void memory_stat_format(struct me
 		memcg_stat_format(memcg, s);
 	else
 		memcg1_stat_format(memcg, s);
-	WARN_ON_ONCE(seq_buf_has_overflowed(s));
+	if (seq_buf_has_overflowed(s))
+		pr_warn("%s: Warning, stat buffer overflow, please report\n", __func__);
 }
 
 /**
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are

mm-memcg-remove-redundant-seq_buf_has_overflowed.patch
mm-memcg-adjust-the-warning-when-seq_buf-overflows.patch

