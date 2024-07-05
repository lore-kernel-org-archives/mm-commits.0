Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B114CC15B
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141636; cv=none; b=L7TOWR2nGEwymvtVygxSJkeT3E7egwnzh85X/gmiyd/XF2enkfM3STUz2ilAFHxup6SxNOa2LPkoJSiRIecKPEMyP2R8TK/7y7cVIpa1PM2Tn4gA9/6QES00HAGF4Ywysl1UisT52nOCnRBRcEfjDbgO5gcRtg7aLh8JhYWMSrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141636; c=relaxed/simple;
	bh=Uo6uiJFc06xuaB2iArLWI1ODpoNWedxnWp23OOcdQic=;
	h=Date:To:From:Subject:Message-Id; b=hycTEE7QL06THh/hqnEichkFhA3FYFkg0UiEdyu4j4W2RFae8GOrblmyRmNlwiZr4RfJkblmBA9K+bk+oKza7kmHYlfhwpXgMFXAuCgT1O9JtvpDY3WuXd/uu0AUuD6+8Pud8gR4L9qghorjaANBS8yhXgQSF8ZTzCkjUKF437Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d2kq8ZwS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d2kq8ZwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84447C3277B;
	Fri,  5 Jul 2024 01:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141636;
	bh=Uo6uiJFc06xuaB2iArLWI1ODpoNWedxnWp23OOcdQic=;
	h=Date:To:From:Subject:From;
	b=d2kq8ZwSyuq3J6tX8uW/qvgtm/uQxPlZohx0j2+W/um+Cp4lRu1gbm27eOl9mVarG
	 RCEBptYLKsNuQx2GZ5zbzBKBJRGE+1nBBC/2vUT4KkNegf9vqQNOwBt4HreTgvDQor
	 NEfKAbHiJRLVjavdj7efrj0mPN92awdUqnxlyy4k=
Date: Thu, 04 Jul 2024 18:07:16 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,xiujianfeng@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-adjust-the-warning-when-seq_buf-overflows.patch removed from -mm tree
Message-Id: <20240705010716.84447C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: adjust the warning when seq_buf overflows
has been removed from the -mm tree.  Its filename was
     mm-memcg-adjust-the-warning-when-seq_buf-overflows.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-hugetlb_cgroup-introduce-peak-and-rsvdpeak-to-v2.patch

