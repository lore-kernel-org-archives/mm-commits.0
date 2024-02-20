Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB65152DE9
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 22:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708467758; cv=none; b=POjcpVngugNsGjKszAB7yIEdethBGahqbD8yGdBawmKsmRDsH7Tfk35sChWCs8PYvioJlkECOoZDMxq3E34Rk8TAcH2C35YZb5HtL9RsUWs/N3Pe9ThUkvw+LfCtjknhXpNTe/nTD2gvwpvznQ8iJGF4CEmkCVv8QdT7EkteqpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708467758; c=relaxed/simple;
	bh=FANPq+gMtQk+X9L794Vtikqop/0EOL49zIewsjFzXNc=;
	h=Date:To:From:Subject:Message-Id; b=GiiUaEoUNWpRXDDggK4BvQ+/2FN1eZAhg4QwRwDroZXKCdnn7RGTrMTfAlVyezLHE0N3QfxqqywYjymA7maKoSHPF2qSbxoXrTP28DoNi/+8vM6AkdKE9/7Tmszak5oX+gotoWhWSYViPGV23AWeSGZh+RgiBcof6dnzdSEKS3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RxytWIPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RxytWIPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9504C43390;
	Tue, 20 Feb 2024 22:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708467757;
	bh=FANPq+gMtQk+X9L794Vtikqop/0EOL49zIewsjFzXNc=;
	h=Date:To:From:Subject:From;
	b=RxytWIPnkkTuJwxMd90Gb6vL5BiuViDj0+Hh/jgI8o/uO1Zl5q8wiqJ+8HMJN5KF+
	 msY8IIFPU76SSbYhIcCYIblfFaLpEUiWiRWRI3oHiY1FsJdDLj0Q50K5s+HnN6MhjA
	 6JpUm5/JMpDpzQnZZp6tX/0gJxLLep7VG7KDNAWU=
Date: Tue, 20 Feb 2024 14:22:37 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,mpe@ellerman.id.au,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,bgray@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kasan-guard-release_free_meta-shadow-access-with-kasan_arch_is_ready.patch removed from -mm tree
Message-Id: <20240220222237.B9504C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: guard release_free_meta() shadow access with kasan_arch_is_ready()
has been removed from the -mm tree.  Its filename was
     kasan-guard-release_free_meta-shadow-access-with-kasan_arch_is_ready.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
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


