Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D412F3E1680
	for <mm-commits@vger.kernel.org>; Wed, 24 Jun 2026 20:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782333892; cv=none; b=otBt2V6nXPQHHbhtiPdTLe4qi996nk8jTKi9W3fpX8fEMbybdgzIxos/o25Oj7eD6HTQqGS59xPbfFBnDzh549vInKJp+X83azt1oaiSPADw0/vl5CtPnI5DgHp08vcnF6BZmknboLQzWExRMiXJEwnVhPohQ7Wquz/NXSArAes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782333892; c=relaxed/simple;
	bh=S6E0k3SwrENQjCxpoEur2QFSX7nVxEycSuZ+nF56ae8=;
	h=Date:To:From:Subject:Message-Id; b=fha0lzrNFrh42MLPwgLDBSYUvAomeQKNs94pcCMkUC0glwP6gYKWjV++G21tu/K4NUZ2ALolAohNj7xGhKe5I/c8JfZz12RkqcBasgZIjAs9hK6pRPytdhi/sBOrhEhm23T9MOvoO/HGMuKu/ikYcUkx7c3ETg/n4pDg1zb1O7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CXrkwg0E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CXrkwg0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5695B1F000E9;
	Wed, 24 Jun 2026 20:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782333891;
	bh=+h+Laf0Zqrw7U2U27PF3vZFHMmfFlIXkGab/6kl5nhc=;
	h=Date:To:From:Subject;
	b=CXrkwg0EoFPjYNt+FgZsacQi4NLBxXnvRGXavDMxz/3AkUrZLkgIgC15ZoK7GVPuJ
	 qimYSMmu5hUZjnOtUAbFflLU9LuQSDCxxneXxIJgz8BSU6WdxRpZBhxIXDm56+Yf3i
	 bawu0PzVEoJSgzbKR178qhWDvwhiQ/adVeCaehoQ=
Date: Wed, 24 Jun 2026 13:44:50 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,sj@kernel.org,ryabinin.a.a@gmail.com,nao.horiguchi@gmail.com,linmiaohe@huawei.com,lance.yang@linux.dev,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,igorpetindev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-remove-redundant-initialization-for-hw_memory_failure.patch added to mm-new branch
Message-Id: <20260624204451.5695B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: remove redundant initialization for hw_memory_failure
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-failure-remove-redundant-initialization-for-hw_memory_failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-remove-redundant-initialization-for-hw_memory_failure.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Igor Putko <igorpetindev@gmail.com>
Subject: mm/memory-failure: remove redundant initialization for hw_memory_failure
Date: Tue, 23 Jun 2026 14:47:43 +0300

The static variable 'hw_memory_failure' is implicitly initialized to
false.  Remove the explicit initialization to follow the Linux kernel
coding style.

Link: https://lore.kernel.org/20260623114743.4565-3-igorpetindev@gmail.com
Signed-off-by: Igor Putko <igorpetindev@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failure-remove-redundant-initialization-for-hw_memory_failure
+++ a/mm/memory-failure.c
@@ -76,7 +76,7 @@ static int sysctl_enable_soft_offline __
 
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
-static bool hw_memory_failure __read_mostly = false;
+static bool hw_memory_failure __read_mostly;
 
 static DEFINE_MUTEX(mf_mutex);
 
_

Patches currently in -mm which might be from igorpetindev@gmail.com are

mm-kasan-remove-redundant-initialization-for-kasan_flag_write_only.patch
mm-memory-failure-remove-redundant-initialization-for-hw_memory_failure.patch

