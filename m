Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B92A60DE5
	for <mm-commits@vger.kernel.org>; Wed, 14 Feb 2024 18:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707936506; cv=none; b=TJlLdZscVHw+NHQgYUemi2FCDtFeEz4RRJGlKHhWEApHip+zmhLDfw3XatrUPadO99dtrmQMOO/3P2kNPVKxBLZ3qd26JR3g5ed0FaA+RJZjRh4+w7SFCv+lLVybbC0e8SnZqo2fsvSCEgO+YsCsbiSid5JTfOSm91mo49N+MYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707936506; c=relaxed/simple;
	bh=w3sq42bVFxaFbQJyDB/KAdvgAUX4vGK+x2YRwnAPR0Q=;
	h=Date:To:From:Subject:Message-Id; b=fXqpNoCrws3mimuwwZCIVXiefJmMj3rKTcDIBPozIGmg6FPqtnQQsfrN2kjqbl6rG+M//9F0BD9sJdYA4+ANFb7xmeXmMVhNaEa3sx278xmBEXo/k9LEMtxxeio6gCWJFuVz8li80qn2N/jk/VG6ilHrOrBZbBYkgCEySDpXJK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uPwEERI0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uPwEERI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66795C433C7;
	Wed, 14 Feb 2024 18:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707936505;
	bh=w3sq42bVFxaFbQJyDB/KAdvgAUX4vGK+x2YRwnAPR0Q=;
	h=Date:To:From:Subject:From;
	b=uPwEERI00T08wM5eUx52KaVsvEzSzHTnJi+vVKHCAehx1+3q1wpKv8g4+oJh1nXnv
	 /r8dLaJslLuBT2xF2GkvrXGfEI0vJPBAGcDqAqC36jt4o93Dl6u7GTktLEJlhOHnrk
	 Ebsjy11ofzk03VN5NR1nBUEFRL7kQVQc3jaqxeRY=
Date: Wed, 14 Feb 2024 10:48:24 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,mpe@ellerman.id.au,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,bgray@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-guard-release_free_meta-shadow-access-with-kasan_arch_is_ready.patch added to mm-hotfixes-unstable branch
Message-Id: <20240214184825.66795C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: guard release_free_meta() shadow access with kasan_arch_is_ready()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-guard-release_free_meta-shadow-access-with-kasan_arch_is_ready.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-guard-release_free_meta-shadow-access-with-kasan_arch_is_ready.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Benjamin Gray <bgray@linux.ibm.com>
Subject: kasan: guard release_free_meta() shadow access with kasan_arch_is_ready()
Date: Tue, 13 Feb 2024 14:39:58 +1100

release_free_meta() accesses the shadow directly through the path

  kasan_slab_free
    __kasan_slab_free
      kasan_release_object_meta
        release_free_meta
          kasan_mem_to_shadow

There are no kasan_arch_is_ready() guards here, allowing an oops when the
shadow is not initialized.  The oops can be seen on a Power8 KVM guest.

This patch adds the guard to release_free_meta(), as it's the first level
that specifically requires the shadow.

It is safe to put the guard at the start of this function, before the
stack put: only kasan_save_free_info() can initialize the saved stack,
which itself is guarded with kasan_arch_is_ready() by its caller
poison_slab_object().  If the arch becomes ready before
release_free_meta() then we will not observe KASAN_SLAB_FREE_META in the
object's shadow, so we will not put an uninitialized stack either.

Link: https://lkml.kernel.org/r/20240213033958.139383-1-bgray@linux.ibm.com
Fixes: 63b85ac56a64 ("kasan: stop leaking stack trace handles")
Signed-off-by: Benjamin Gray <bgray@linux.ibm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/generic.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/kasan/generic.c~kasan-guard-release_free_meta-shadow-access-with-kasan_arch_is_ready
+++ a/mm/kasan/generic.c
@@ -522,6 +522,9 @@ static void release_alloc_meta(struct ka
 
 static void release_free_meta(const void *object, struct kasan_free_meta *meta)
 {
+	if (!kasan_arch_is_ready())
+		return;
+
 	/* Check if free meta is valid. */
 	if (*(u8 *)kasan_mem_to_shadow(object) != KASAN_SLAB_FREE_META)
 		return;
_

Patches currently in -mm which might be from bgray@linux.ibm.com are

kasan-guard-release_free_meta-shadow-access-with-kasan_arch_is_ready.patch

