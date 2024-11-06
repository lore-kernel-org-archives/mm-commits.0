Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3452C204958
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 21:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730929124; cv=none; b=qeh6vZ7JuMEiQfEQOnjKWtzC9mo43NiNoNO8RIcJtVBaIQHisGQW1OODbeh9FY/CQF+GNkxA+sIeyyrXqP5FaYXnfR7OF0exF9TOF18v7Ie/kHirEWRpHI/Mf9pD8dRfGFyuHH9q9pnyRfjpoTpF5+5R18SNYYwi9ES2eibbVSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730929124; c=relaxed/simple;
	bh=Sesoa5iPSZfEUXnkyjcF0CsYE3t7naqs3ZNjmZK9wlE=;
	h=Date:To:From:Subject:Message-Id; b=NmtZWEL2x233coE7mNZEYYY5qC4Tp40ywOroKt8zRm6afe5gihlWExiLzoCuC9mGgEpkc4/ZhZXM/+ynlzUGHiOutkkZinfTXcfBEEogpmeH0w1wXqdbng9Vj/Pb7XPTSfcdX3xmpvlUzeOsCYGI6qu2Z8+Eev+4owxfUS0ORO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RDsoL+DC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RDsoL+DC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE31C4CEC6;
	Wed,  6 Nov 2024 21:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730929123;
	bh=Sesoa5iPSZfEUXnkyjcF0CsYE3t7naqs3ZNjmZK9wlE=;
	h=Date:To:From:Subject:From;
	b=RDsoL+DCtZumu+eFTG2NqaMJw4hsac2VgAyPB0UQEVA+Zv/4gjrWKUjfdnKztGk4s
	 0Y6SSrqO3n0eZ83lo6cKYgYHYWJLG84lOWV6HXxO8xHqQufit8gHHtQFijDRkMo5eC
	 NbmQLI8bx/W4UdSC31a+83pEMmefCKL876gkrP3Y=
Date: Wed, 06 Nov 2024 13:38:43 -0800
To: mm-commits@vger.kernel.org,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] hung_task-add-detect-count-for-hung-tasks-fix.patch removed from -mm tree
Message-Id: <20241106213843.ABE31C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hung_task-add-detect-count-for-hung-tasks-fix
has been removed from the -mm tree.  Its filename was
     hung_task-add-detect-count-for-hung-tasks-fix.patch

This patch was dropped because it was folded into hung_task-add-detect-count-for-hung-tasks.patch

------------------------------------------------------
From: Lance Yang <ioworker0@gmail.com>
Subject: hung_task-add-detect-count-for-hung-tasks-fix
Date: Fri, 1 Nov 2024 19:48:33 +0800

sysctl_hung_task_detect_count is defined as an unsigned long, so we need
to use proc_doulongvec_minmax instead of proc_dointvec to handle it
correctly.

Link: https://lkml.kernel.org/r/20241101114833.8377-1-ioworker0@gmail.com
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/hung_task.c~hung_task-add-detect-count-for-hung-tasks-fix
+++ a/kernel/hung_task.c
@@ -330,7 +330,7 @@ static struct ctl_table hung_task_sysctl
 		.data		= &sysctl_hung_task_detect_count,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0444,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_doulongvec_minmax,
 	},
 };
 
_

Patches currently in -mm which might be from ioworker0@gmail.com are

hung_task-add-detect-count-for-hung-tasks.patch
hung_task-add-docs-for-hung_task_detect_count.patch

