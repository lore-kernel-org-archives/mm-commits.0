Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6921030E83A
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 01:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750383047; cv=none; b=Vs6wy/5Ql/cn7jRhCt8QFATgcVaV8OXe1fTsjuB9yvU88F/fJ+Jc+4+05QBewy3ykSR8i5ti0FQGbPH4iPCB85aClBWL6+9Vty/x5qYMPS3oRnlsnyAM/ZQ+1+GCxRg1o6UJvpQbyg34qXpf27Dc+7vBLgevbGT4+w2/eB+H5Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750383047; c=relaxed/simple;
	bh=f5qLwHwTILoLeKubl5vGazy1jFeYGgsoPspejkR8btQ=;
	h=Date:To:From:Subject:Message-Id; b=kQJOO/ttBYOaYeDMka5JwyyNGQ571D/arsp9zfsqiDZYxIgCvB1lFJ5/dUsZzfGKLlATMDTzlbNfXDUpR6aoDe3i8TzenvM5ZIwnPRPeCj3DVImOTZ27j1xkMdmLc04WYL5lQ43gjtmao2LlP6RKLC4UwFfDdfEsVpxrVJkbzB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GBU8CBjf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GBU8CBjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3374C4CEEA;
	Fri, 20 Jun 2025 01:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750383045;
	bh=f5qLwHwTILoLeKubl5vGazy1jFeYGgsoPspejkR8btQ=;
	h=Date:To:From:Subject:From;
	b=GBU8CBjftRormAX8yUYfNLuq1QxdvAmIa/eML0wCQ/1qWQC3HZPOjb5YROhtfo4ga
	 /tw4z7TAKVFOH0S3nqFXupIwZswv10ZCObC7MpDHym1OqZwfBlyn4pEuf64fO53quU
	 EsvKadGq56HOh+hzP0QUlCA1Q2Qhtiy08exNIvow=
Date: Thu, 19 Jun 2025 18:30:45 -0700
To: mm-commits@vger.kernel.org,yi.zhang@huawei.com,yangerkun@huawei.com,tglx@linutronix.de,ming.lei@redhat.com,john.g.garry@oracle.com,axboe@kernel.dk,yukuai3@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-group_cpus-fix-null-pointer-dereference-from-group_cpus_evenly-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20250620013045.D3374C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib-group_cpus-fix-null-pointer-dereference-from-group_cpus_evenly-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-group_cpus-fix-null-pointer-dereference-from-group_cpus_evenly-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-group_cpus-fix-null-pointer-dereference-from-group_cpus_evenly-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Yu Kuai <yukuai3@huawei.com>
Subject: lib-group_cpus-fix-null-pointer-dereference-from-group_cpus_evenly-fix
Date: Fri, 20 Jun 2025 09:09:58 +0800

also fix the non-SMP version

Link: https://lkml.kernel.org/r/20250620010958.1265984-1-yukuai1@huaweicloud.com
Fixes: 6a6dcae8f486 ("blk-mq: Build default queue map via group_cpus_evenly()")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Cc: ErKun Yang <yangerkun@huawei.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/group_cpus.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/lib/group_cpus.c~lib-group_cpus-fix-null-pointer-dereference-from-group_cpus_evenly-fix
+++ a/lib/group_cpus.c
@@ -429,8 +429,12 @@ struct cpumask *group_cpus_evenly(unsign
 #else /* CONFIG_SMP */
 struct cpumask *group_cpus_evenly(unsigned int numgrps)
 {
-	struct cpumask *masks = kcalloc(numgrps, sizeof(*masks), GFP_KERNEL);
+	struct cpumask *masks;
 
+	if (numgrps == 0)
+		return NULL;
+
+	masks = kcalloc(numgrps, sizeof(*masks), GFP_KERNEL);
 	if (!masks)
 		return NULL;
 
_

Patches currently in -mm which might be from yukuai3@huawei.com are

lib-group_cpus-fix-null-pointer-dereference-from-group_cpus_evenly.patch
lib-group_cpus-fix-null-pointer-dereference-from-group_cpus_evenly-fix.patch

