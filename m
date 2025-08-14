Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824ED1C5D55
	for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2025 23:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755212439; cv=none; b=iHzTN58CDPMc03VXLcJc5tuzrW3a0MsartO63oeOFdjgb2DROBfCA8fmDFl3ZBmXfbY3NOyGdX81Y/AWmpCy9GO0OmAIFayIfT3N4c7+nnxBticBFAQElqPwTi7/NWz9H0YNb9KgLypYi0vJ3GtGB4T2Q6BRAegD/T1TMMA5TOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755212439; c=relaxed/simple;
	bh=b+DWa4hTatOD/o1fPGl1cIlKtHqaOVxFqZxFDYj4Wws=;
	h=Date:To:From:Subject:Message-Id; b=Ga8TnLKcl8lmUwq74RtGZ2Pj73b+DgwxKHV3N0WZEAGHdmDk4ihLWsA9nGS1ZMN10aTVCj4RJ9IUR1cjz9FgwI9kT8mqMHp/xiPqn+47lQqdk9/DCLvovEgUWXtM4g77Ly8n0/USWaklAOo4YFf7jei1G9U6ZUlj4XSDPcaMOe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MTletMpL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MTletMpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3BB8C4CEED;
	Thu, 14 Aug 2025 23:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755212438;
	bh=b+DWa4hTatOD/o1fPGl1cIlKtHqaOVxFqZxFDYj4Wws=;
	h=Date:To:From:Subject:From;
	b=MTletMpL5Wh4SsMq13kDvFS3gDlZwvDkCq+F+IYNZZlRr0dCA1BG0ypyMN7DHxZpz
	 Ot2Wv0jDa+/fGtTHRNb0at9wnkxxrnp8KZ1e+RVwo1tHu6Jyhj9X0R0tPBcK9Fc5Z1
	 7ppzqni983NG2zY7BvhtdmEHSIXIH9Cq+FNfECu4=
Date: Thu, 14 Aug 2025 16:00:38 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,vbabka@suse.cz,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping-v3.patch added to mm-unstable branch
Message-Id: <20250814230038.C3BB8C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping-v3
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping-v3.patch

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
From: Jann Horn <jannh@google.com>
Subject: kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping-v3
Date: Thu, 14 Aug 2025 17:11:10 +0200

make comment more verbose

Link: https://lkml.kernel.org/r/20250814-kasan-tsbrcu-noquarantine-test-v3-1-9e9110009b4e@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/kasan/kasan_test_c.c~kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping-v3
+++ a/mm/kasan/kasan_test_c.c
@@ -1076,6 +1076,8 @@ static void kmem_cache_rcu_uaf(struct ku
 /*
  * Check that SLAB_TYPESAFE_BY_RCU objects are immediately reused when
  * CONFIG_SLUB_RCU_DEBUG is off, and stay at the same address.
+ * Without this, KASAN builds would be unable to trigger bugs caused by
+ * SLAB_TYPESAFE_BY_RCU users handling reycled objects improperly.
  */
 static void kmem_cache_rcu_reuse(struct kunit *test)
 {
_

Patches currently in -mm which might be from jannh@google.com are

kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping.patch
kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping-v2.patch
kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping-v3.patch

