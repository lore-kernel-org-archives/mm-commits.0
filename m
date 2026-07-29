Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8444738D6B5
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298382; cv=none; b=a12eetmJb6yHBQgX1iTzpDCtCC16e4y9yN5VZvzBhH7hQqzD6O8mtfJQ1JkCQ5ObnYMArpzgMT5PysqwZ1dTr//qQ7Q3lMIR2pKVYZooy99gaKdKjxg+4VoHIW0L0VnxFZBabzGtbF7XT/ypRiFwBfCeqB1UkQJJjHzrAF9Gx/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298382; c=relaxed/simple;
	bh=tjRaiuRIJ8Dzp0m4t+yYzk1IJgQVlXYjlhSflK/LsAU=;
	h=Date:To:From:Subject:Message-Id; b=GLxS19V+xA9JFwmp7HCJ9SC4ASvPBhSYgeiEWg/Y3R3Z7t7BUxT7P4X6gOjt5HQr8av0KnjW5ToEZJ4oIpIWAzCTZ80voQFIi8na4idmRY3J/THkg7c5M58uwDeQWNbMAR3SZunPYeaSmgg0uAqbDsiX9lW7xlulgcJ5iKAjlaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NKgUsQPs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NKgUsQPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFD41F00A3A;
	Wed, 29 Jul 2026 04:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298381;
	bh=PAfafGcGDDta9MQAHHYGHJeK2gLUcDHldNadeN3UoH4=;
	h=Date:To:From:Subject;
	b=NKgUsQPsMUqwyUY61OcRApukSU2Ojg0qgTVtNCvLiyKcPkKeh94i+pHrp4z+XgBw4
	 PTwYeKUdg/q7AbZFcWav/2HIVz9QRCn2Pp0SAJGKNaRjNqGmVF7thcvWijF0GJFkwP
	 9rGq+ETRuPt3bo7UfJ++NJpwRgZurO8quRMexP6U=
Date: Tue, 28 Jul 2026 21:13:00 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,sj@kernel.org,ryabinin.a.a@gmail.com,nao.horiguchi@gmail.com,linmiaohe@huawei.com,lance.yang@linux.dev,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,igorpetindev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-remove-redundant-initialization-for-hw_memory_failure.patch removed from -mm tree
Message-Id: <20260729041301.0FFD41F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: remove redundant initialization for hw_memory_failure
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-remove-redundant-initialization-for-hw_memory_failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


