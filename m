Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3CC749C
	for <mm-commits@vger.kernel.org>; Fri, 26 Jul 2024 16:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722011761; cv=none; b=eD/kgvRV1P3ovS7O2CBIHaW2W0CSMsoRvx2mYtVFM0v1NCEfTFpjBQFX6u5sh5qeJVVWhZKfYfoygRsqM18KNeFf/wfkjBDuIwN2LW2r5f1319Oa7DsNak6iYN19R2MI3hPhV3qPIimFL4IfWBP+Wn3SDBraFvngduRSXqs9AOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722011761; c=relaxed/simple;
	bh=irPJ7YA/z2vpkNfVHg2vGRg46911zeyeFRh8PxKNXCo=;
	h=Date:To:From:Subject:Message-Id; b=FZ9dzsxGbxXcNc4ynPpChjxjju6jkzz0FueYWYx6t5hJvfOT6WvlZ96r7tf3E64aX6/R+241DoB8kYeZ19NydAFXNB4nFCntEy1feotWh6D2I7zIYLDtCPJh4JMhH8Y8Ngaysj6TfFhoebW9DWfCvLLkncPKb1nuAuM6re/21ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xpPO5ZEX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xpPO5ZEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488ABC4AF07;
	Fri, 26 Jul 2024 16:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722011761;
	bh=irPJ7YA/z2vpkNfVHg2vGRg46911zeyeFRh8PxKNXCo=;
	h=Date:To:From:Subject:From;
	b=xpPO5ZEXeVJw4V/D9BuwqnniUri2DWlxyxc9aNZmgE84jr4ilNrJL5yHM8zZH0Ed7
	 uTe2pN2eunuennweWNapqciYA1bxiLMwrTPIyY3mNIJVJKtAr2v3YYkmcQpQnxWuRP
	 iXnAQgeSx6cRMIp7NgLjbON3WHFrHOLGENiLPDc8=
Date: Fri, 26 Jul 2024 09:36:00 -0700
To: mm-commits@vger.kernel.org,21cnbao@gmail.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-boilerplate-fix.patch added to mm-unstable branch
Message-Id: <20240726163601.488ABC4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-swap-remove-boilerplate-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-remove-boilerplate-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-boilerplate-fix.patch

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm-swap-remove-boilerplate-fix
Date: Fri, 26 Jul 2024 00:50:04 -0600

fix "BUG: using smp_processor_id() in preemptible"

Link: https://lkml.kernel.org/r/ZqNHHMiHn-9vy_II@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: Barry Song <21cnbao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/swap.c~mm-swap-remove-boilerplate-fix
+++ a/mm/swap.c
@@ -220,7 +220,7 @@ static void folio_batch_move_lru(struct
 	folios_put(fbatch);
 }
 
-static void __folio_batch_add_and_move(struct folio_batch *fbatch,
+static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
 		struct folio *folio, move_fn_t move_fn,
 		bool on_lru, bool disable_irq)
 {
@@ -233,16 +233,14 @@ static void __folio_batch_add_and_move(s
 		return;
 	}
 
-	if (folio_batch_add(fbatch, folio) && !folio_test_large(folio) &&
-	    !lru_cache_disabled())
-		return;
-
 	if (disable_irq)
 		local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
 	else
 		local_lock(&cpu_fbatches.lock);
 
-	folio_batch_move_lru(fbatch, move_fn);
+	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) || folio_test_large(folio) ||
+	    lru_cache_disabled())
+		folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
 
 	if (disable_irq)
 		local_unlock_irqrestore(&cpu_fbatches.lock_irq, flags);
@@ -252,7 +250,7 @@ static void __folio_batch_add_and_move(s
 
 #define folio_batch_add_and_move(folio, op, on_lru)						\
 	__folio_batch_add_and_move(								\
-		this_cpu_ptr(&cpu_fbatches.op),							\
+		&cpu_fbatches.op,								\
 		folio,										\
 		op,										\
 		on_lru,										\
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-hugetlb_vmemmap-dont-synchronize_rcu-without-hvo.patch
mm-swap-reduce-indentation-level.patch
mm-swap-rename-cpu_fbatches-activate.patch
mm-swap-fold-lru_rotate-into-cpu_fbatches.patch
mm-swap-remove-remaining-_fn-suffix.patch
mm-swap-remove-boilerplate.patch
mm-swap-remove-boilerplate-fix.patch

