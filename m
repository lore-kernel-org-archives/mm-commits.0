Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4267625761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742255; cv=none; b=Fjgm7zSabye8p/o6aKv2II+36/UJxedTyYmrv7XMSxDG1k/spofsF1rkGAABnnHqHtgOiVU6ZOCZ+TshGO33brpBimp+Infa7mnEH/PnTxwFB/aPUpl+JAj8ijUoTCfvJcpr5p4FbHSSzZi+gosazSK/zBi0T+nbdGAhfM+D5MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742255; c=relaxed/simple;
	bh=VvOaxNAcKiHUwun4ZpEsW0q+TR653BkoGIKFHmw44Ec=;
	h=Date:To:From:Subject:Message-Id; b=Q1dvbCjbgE5AKI5SH7lR+vczjBMrPzOmGj7LAoL6vSCsq7VT5BcgFfACpeZRI5qcFoNdZTf0RySFT7qTrsyZCzAIQwlloQkRlKlrwwrWQfx0+C9QsiVzPIMpz3ZsiuqebwUmtcfDg/iUYwm0Bfl0W2QEugMh2bJin+EhGRbhq10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mpLm3cyl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mpLm3cyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C42C4CED6;
	Mon, 13 Jan 2025 04:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742255;
	bh=VvOaxNAcKiHUwun4ZpEsW0q+TR653BkoGIKFHmw44Ec=;
	h=Date:To:From:Subject:From;
	b=mpLm3cylnThSkwzRfsj6ksrHJ9hrZQMMFjwbMa+FfUB/szmm4+DtQo2vTHnZDnFVC
	 OD/F2Bt80GEBCvpBBybtiQ8ZwIbd8bO+JErSt29syeQbtz+02ZW+7Tb6qMODD17ye6
	 Dp0uIZRyPlFc4O2ToTwS2s5i60JFCn6EBiteyPXg=
Date: Sun, 12 Jan 2025 20:24:14 -0800
To: mm-commits@vger.kernel.org,tiozhang@didiglobal.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kthread-correct-comments-before-kthread_queue_work.patch removed from -mm tree
Message-Id: <20250113042415.19C42C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kthread: correct comments before kthread_queue_work()
has been removed from the -mm tree.  Its filename was
     kthread-correct-comments-before-kthread_queue_work.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tio Zhang <tiozhang@didiglobal.com>
Subject: kthread: correct comments before kthread_queue_work()
Date: Tue, 24 Dec 2024 17:53:44 +0800

s/kthread_worker_create/kthread_create_worker/ to avoid confusion when
reading comments before kthread_queue_work().

Link: https://lkml.kernel.org/r/20241224095344.GA7587@didi-ThinkCentre-M930t-N000
Signed-off-by: Tio Zhang <tiozhang@didiglobal.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kthread.c~kthread-correct-comments-before-kthread_queue_work
+++ a/kernel/kthread.c
@@ -1015,7 +1015,7 @@ static void kthread_insert_work(struct k
  * @work: kthread_work to queue
  *
  * Queue @work to work processor @task for async execution.  @task
- * must have been created with kthread_worker_create().  Returns %true
+ * must have been created with kthread_create_worker().  Returns %true
  * if @work was successfully queued, %false if it was already pending.
  *
  * Reinitialize the work if it needs to be used by another worker.
_

Patches currently in -mm which might be from tiozhang@didiglobal.com are


