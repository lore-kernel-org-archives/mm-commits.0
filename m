Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805BE29E11D
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 22:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757801227; cv=none; b=NOvEgVsX1LZt9ajz9u/kKSdLuYr02Q48eeE/NfpN8QKNCsAWWo1NCxKZM8t5p1HOQxq4uAgdwvC36OCe7FLT5L1MUxN9q+CSOjaMz/bNgZsmu2jev3AC2VjH6APtIEQvw4CgEtHxDPzIx6v+yLJCUxpveGp92GefQvu7Frpn/kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757801227; c=relaxed/simple;
	bh=koEueQgbxZo9XV8skDX5cj73VfYxb+ncoBI0JrhiA1o=;
	h=Date:To:From:Subject:Message-Id; b=rR4ZlQ/h5LXNv8m5G1/WPyQ2u0MHPIL4RVJwvHIOpA+6hCJQb7wqTJ0zBvLv8GIJ/MSZof4SuIw/gM3YVzdzKFDAdSWcmPEFPoCAVoebFRPznjVjIOMWJKVu7weYXTIWxHhVXxG2UFAvG+FANxP1Fvs7pFuCHxQvdsZGAiayHBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WDVhe+Kp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WDVhe+Kp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410A6C4CEEB;
	Sat, 13 Sep 2025 22:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757801227;
	bh=koEueQgbxZo9XV8skDX5cj73VfYxb+ncoBI0JrhiA1o=;
	h=Date:To:From:Subject:From;
	b=WDVhe+KpNnFTa3hPbpOnPDAIrPo0IyYUo5twuESpM1OcFYmkM/wiz8P1YhsFMZNob
	 x74GpjDIYvSMhpY/Fjyfdc2x0ea7hFN9TraUINxbzip27xOAhBRohJWOFtg2Dz4OIS
	 7EhLxZUFAYkFF0dl8Ufu8HFuTrwvT0LY8G5MKNMI=
Date: Sat, 13 Sep 2025 15:07:06 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,vbabka@suse.cz,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping-v3.patch removed from -mm tree
Message-Id: <20250913220707.410A6C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping-v3
has been removed from the -mm tree.  Its filename was
     kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping-v3.patch

This patch was dropped because it was folded into kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping.patch

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

