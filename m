Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C4D26B767;
	Mon, 28 Jul 2025 19:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753731889; cv=none; b=ouRDrP3EQi+kvQK3HhNrgUCHzVdnp1e3DCGVKFFPkujSqQPoCWBmC2as0LeboBrNq+uLAtyWg4ZFvp5Q3IZXvwcQQiFM++w7RoMuZekWD27f+KDlbNc5KfUwE2Eo2L+pblWFO2bLYE0sobov4rNTmnsVDVJq4mXZFQnQOz+BP0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753731889; c=relaxed/simple;
	bh=DfSclBjlddJc1UCKxu4XDjsKHM1abcpJNcQtgq0sEjk=;
	h=Date:To:From:Subject:Message-Id; b=oISYzzhzJjn6uf8jfP847PnvpMMopmYlOsZCi/xsez5/i3ZTV6/AwSaOC3zBtGZfguSOUWLfQ2KtzpVZDnHEx+G2/Ex9I/DHCGKnt+m5ezmHQS5xC6llxFMmXCVDwjcQrR4SQ7vkuh5s603EgFBsu7Khsk8K2yyx3jBzwamiXUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kfOLoYyd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kfOLoYyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D729C4CEE7;
	Mon, 28 Jul 2025 19:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753731889;
	bh=DfSclBjlddJc1UCKxu4XDjsKHM1abcpJNcQtgq0sEjk=;
	h=Date:To:From:Subject:From;
	b=kfOLoYydhbRKZaTacK72QLaVQtxh3pHOIdrWZ0LfOAnvvyXfNKn9O0oFO8lYmWArl
	 1W45vCMk3UJdkUfZbFkheyNG9KRY6j9dmKwpyEyilbzKA/2XK/DkQzw/p3Gpah255M
	 ifsV2GYt1EfB8xQlN2sImIWU6eA+eGyTOEBffA0s=
Date: Mon, 28 Jul 2025 12:44:48 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,catalin.marinas@arm.com,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-avoid-soft-lockup-in-__kmemleak_do_cleanup.patch added to mm-nonmm-unstable branch
Message-Id: <20250728194449.2D729C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kmemleak: avoid soft lockup in __kmemleak_do_cleanup()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-kmemleak-avoid-soft-lockup-in-__kmemleak_do_cleanup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-avoid-soft-lockup-in-__kmemleak_do_cleanup.patch

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
From: Waiman Long <longman@redhat.com>
Subject: mm/kmemleak: avoid soft lockup in __kmemleak_do_cleanup()
Date: Mon, 28 Jul 2025 15:02:48 -0400

A soft lockup warning was observed on a relative small system x86-64
system with 16 GB of memory when running a debug kernel with kmemleak
enabled.

  watchdog: BUG: soft lockup - CPU#8 stuck for 33s! [kworker/8:1:134]

The test system was running a workload with hot unplug happening in
parallel.  Then kemleak decided to disable itself due to its inability to
allocate more kmemleak objects.  The debug kernel has its
CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE set to 40,000.

The soft lockup happened in kmemleak_do_cleanup() when the existing
kmemleak objects were being removed and deleted one-by-one in a loop via a
workqueue.  In this particular case, there are at least 40,000 objects
that need to be processed and given the slowness of a debug kernel and the
fact that a raw_spinlock has to be acquired and released in
__delete_object(), it could take a while to properly handle all these
objects.

As kmemleak has been disabled in this case, the object removal and
deletion process can be further optimized as locking isn't really needed. 
However, it is probably not worth the effort to optimize for such an edge
case that should rarely happen.  So the simple solution is to call
cond_resched() at periodic interval in the iteration loop to avoid soft
lockup.

Link: https://lkml.kernel.org/r/20250728190248.605750-1-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/kmemleak.c~mm-kmemleak-avoid-soft-lockup-in-__kmemleak_do_cleanup
+++ a/mm/kmemleak.c
@@ -2181,6 +2181,7 @@ static const struct file_operations kmem
 static void __kmemleak_do_cleanup(void)
 {
 	struct kmemleak_object *object, *tmp;
+	unsigned int cnt = 0;
 
 	/*
 	 * Kmemleak has already been disabled, no need for RCU list traversal
@@ -2189,6 +2190,10 @@ static void __kmemleak_do_cleanup(void)
 	list_for_each_entry_safe(object, tmp, &object_list, object_list) {
 		__remove_object(object);
 		__delete_object(object);
+
+		/* Call cond_resched() once per 64 iterations to avoid soft lockup */
+		if (!(++cnt & 0x3f))
+			cond_resched();
 	}
 }
 
_

Patches currently in -mm which might be from longman@redhat.com are

mm-kmemleak-avoid-soft-lockup-in-__kmemleak_do_cleanup.patch

