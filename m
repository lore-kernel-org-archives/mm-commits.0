Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33E413E028
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 22:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735251607; cv=none; b=u7fuPxqjPzTpTcYkemfTAl+2vRRlPe/MjUuHJcH0+JalNyorTBionyvt/AZyg1wO33t7fZoo7kU+9b2+7oB7ZRu15hBh7xNOXQAKJlu9lJ9PbYLuE21fbkqN9WViL+A9s7gUTE057YXl7/5aZ60bPFOP1wBH9oDrpi36vg6GPvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735251607; c=relaxed/simple;
	bh=XEoMgEdY/U2jQuUsRJjnfwtL8WeCjVqUXx3Q8RC5kQo=;
	h=Date:To:From:Subject:Message-Id; b=NBl0aYyJfTEOjjgKU237kGl3J44GCI3WqmEufOSMorAuMOuk0+4hS/rkHn6eloV30yZAsz9td850fEbG0q39LdaV+BDmWi7MCDE4HxNHXFe0zIXLDNn7p8KK6fzaxwsNUmwG0Vbd2dF4SybIT4ze/vaK4Aqt+p5bLD7ATckP4ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nFj7qwuA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nFj7qwuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B87C4CED1;
	Thu, 26 Dec 2024 22:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735251607;
	bh=XEoMgEdY/U2jQuUsRJjnfwtL8WeCjVqUXx3Q8RC5kQo=;
	h=Date:To:From:Subject:From;
	b=nFj7qwuAJYIn7T/g8g6vsDQ0nYoSDmbWsgketwZVMBFGj+bUycZLB1BrDWqrnmGpm
	 Ls20Bzl6A4p/IahYrAdYqQ2zPOF7UW1WOjSqFxrxIM+TYopym4Qa7HcEsaIvUp7Zcy
	 AYzbgvpB/9b20MNSq+bI3MlYMuq8Ed83V3lEwiZ8=
Date: Thu, 26 Dec 2024 14:20:06 -0800
To: mm-commits@vger.kernel.org,tiozhang@didiglobal.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kthread-correct-comments-before-kthread_queue_work.patch added to mm-nonmm-unstable branch
Message-Id: <20241226222007.37B87C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kthread: correct comments before kthread_queue_work()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kthread-correct-comments-before-kthread_queue_work.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kthread-correct-comments-before-kthread_queue_work.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

kthread-correct-comments-before-kthread_queue_work.patch

