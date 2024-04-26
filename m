Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2BD7604D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103971; cv=none; b=GhaHVomH/pUNROxDpJsqhQlmpxrf2QtnTMchGAuIgYwvyfocvychcrXUUjqxsZ3ijm3c4JBxHGBxstrm1USvLZwZU+KrsEktmX1sC8bP+jku8NsKzsQJiDvIoR1te81mMeOc6jxFxy6VeW15tZSFYG1hE2o+9vFoP0i1mFSOFj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103971; c=relaxed/simple;
	bh=LNa2jZcJCZHW34il4Hbd5eDB1XMp85MMKUYUp453V1A=;
	h=Date:To:From:Subject:Message-Id; b=MQC+lYcp8/TwuzbYcQP6guptANyVKRK0BErni/avVZ0/9H0rEjcsjnQ5Tj7XhP5tCJrwJiOdBZd016s5lc5Ch0GUDutdcz/qOTL66aigpTfv0MIzAjuvLlUU9/6iHGWdYflYGwDVUoU+FtvRKgFLtZiZSelyhrTv+pyzY7HvAbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YZ/+kBe6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YZ/+kBe6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D37C116B1;
	Fri, 26 Apr 2024 03:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103970;
	bh=LNa2jZcJCZHW34il4Hbd5eDB1XMp85MMKUYUp453V1A=;
	h=Date:To:From:Subject:From;
	b=YZ/+kBe6N6wUmqhcXEvrOA12JY1iLHkBbNXQdie5FGmSQeUty5mKFrm1D0ElFbb4T
	 0LzppfyT15Le1ZvTd4eTm9VtmTLU1KB9kyx6ng5KZHYUJDjWYsfnml2ereraKOVGy5
	 /L47Ya0vrL6H2FqwFVgrlwqKZa7fYj/5NdWhKYME=
Date: Thu, 25 Apr 2024 20:59:30 -0700
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-disable-kasan-instrumentation-in-kmemleak.patch removed from -mm tree
Message-Id: <20240426035930.C1D37C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kmemleak: disable KASAN instrumentation in kmemleak
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-disable-kasan-instrumentation-in-kmemleak.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/kmemleak: disable KASAN instrumentation in kmemleak
Date: Thu, 7 Mar 2024 14:05:48 -0500

Kmemleak ia a memory leak checker.  KASAN is also a memory checker but it
focuses more on finding out-of-bounds and use-after-free bugs.  Since
kmemleak is inherently slow especially on systems with large number of
CPUs, adding KASAN instrumentation will make it slower even more.  As
kmemleak is not for production use, the utility of enabling KASAN there is
questionable.

This patch disables KASAN instrumentation for configurations that enable
both of them to slightly reduce performance overhead.

Link: https://lkml.kernel.org/r/20240307190548.963626-3-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/Makefile~mm-kmemleak-disable-kasan-instrumentation-in-kmemleak
+++ a/mm/Makefile
@@ -5,6 +5,7 @@
 
 KASAN_SANITIZE_slab_common.o := n
 KASAN_SANITIZE_slub.o := n
+KASAN_SANITIZE_kmemleak.o := n
 KCSAN_SANITIZE_kmemleak.o := n
 
 # These produce frequent data race reports: most of them are due to races on
_

Patches currently in -mm which might be from longman@redhat.com are


