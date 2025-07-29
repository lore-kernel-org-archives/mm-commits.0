Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02032BD595
	for <mm-commits@vger.kernel.org>; Tue, 29 Jul 2025 20:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753819743; cv=none; b=DaPPxSBQ9FdVPyYJT8XHqp503Gy66w9gPJ6lF3wK4X2ZJYOOgGMBH0opJ1c9w7E94j9QcxxAwGm/khrIEXjWm8dj1V6GU53E6lLZ529AC6YwgaacP4OmivlJ3518trH5FUH5rdbKsVRUNz3vat/SEkDppWXPP8Unj59CY48R1yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753819743; c=relaxed/simple;
	bh=LMqWZWj1637HyiSguj33yl4pKXl9m31e5Ncg0LfEqNM=;
	h=Date:To:From:Subject:Message-Id; b=oI6SHWV1+ZH2xezHTrEFCwyIwcpRSShKy5UFrfi7jDds4k8vDn6yeBLWxv+K8Z7l2XXK5NuKawb082UpW9LASoN/9DEWQJ3XVBOV4HHz/B8ft2C2KEq34wXePn0tBG/Cvxl+0aLgHK3MjuC0CaA2XTT1KGZ/IEgcDlvjSA1W65k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R+aU40qq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R+aU40qq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E03BC4CEF7;
	Tue, 29 Jul 2025 20:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753819742;
	bh=LMqWZWj1637HyiSguj33yl4pKXl9m31e5Ncg0LfEqNM=;
	h=Date:To:From:Subject:From;
	b=R+aU40qqJ1Wxw6AtB+4CboIe5uWG5GSGAzl3lragYO5MDSFtu0G9NqMMAneCcS3e/
	 whu7OWmcOH5ZKnVJs58g4MRXLCZQ0TsNIBkc+/7LlsMvnqTq+jCK6HnExyUSunyltU
	 fDK8DrmKQxn4wG3vda46yuKj1rlj+mgWUB6YAfQY=
Date: Tue, 29 Jul 2025 13:09:01 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,vbabka@suse.cz,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping-v2.patch added to mm-new branch
Message-Id: <20250729200902.5E03BC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: add test for SLAB_TYPESAFE_BY_RCU quarantine skipping
has been added to the -mm mm-new branch.  Its filename is
     kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping-v2.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: kasan: add test for SLAB_TYPESAFE_BY_RCU quarantine skipping
Date: Tue, 29 Jul 2025 18:49:40 +0200

- disable migration to ensure that all SLUB operations use the same
  percpu state (vbabka)

- use EXPECT instead of ASSERT for pointer equality check so that
  expectation failure doesn't terminate the test with migration still
  disabled

Link: https://lkml.kernel.org/r/20250729-kasan-tsbrcu-noquarantine-test-v2-1-d16bd99309c9@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/kasan/kasan_test_c.c~kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping-v2
+++ a/mm/kasan/kasan_test_c.c
@@ -1088,23 +1088,25 @@ static void kmem_cache_rcu_reuse(struct
 				  NULL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
 
+	migrate_disable();
 	p = kmem_cache_alloc(cache, GFP_KERNEL);
 	if (!p) {
 		kunit_err(test, "Allocation failed: %s\n", __func__);
-		kmem_cache_destroy(cache);
-		return;
+		goto out;
 	}
 
 	kmem_cache_free(cache, p);
 	p2 = kmem_cache_alloc(cache, GFP_KERNEL);
 	if (!p2) {
 		kunit_err(test, "Allocation failed: %s\n", __func__);
-		kmem_cache_destroy(cache);
-		return;
+		goto out;
 	}
-	KUNIT_ASSERT_PTR_EQ(test, p, p2);
+	KUNIT_EXPECT_PTR_EQ(test, p, p2);
 
 	kmem_cache_free(cache, p2);
+
+out:
+	migrate_enable();
 	kmem_cache_destroy(cache);
 }
 
_

Patches currently in -mm which might be from jannh@google.com are

kasan-test-fix-protection-against-compiler-elision.patch
kasan-skip-quarantine-if-object-is-still-accessible-under-rcu.patch
mm-rmap-add-anon_vma-lifetime-debug-check.patch
kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping.patch
kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping-v2.patch

