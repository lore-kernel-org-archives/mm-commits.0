Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3497DA7B
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248755; cv=none; b=BBocWlJtNBZ1S4mVFSQdRUg/D8fGTpE5gFmWOEHUbrbmxNBY06OhgKDSLJRahJPKrfqU2Z74nRDHORxcRDUY64anDOb3UpI7nPQVAYnQNCwdpSEUfcr4Ijx62CGyF0p2MCm9oSx1nV+pSWVlg2dtK+fHva8M06groDDZKcXC99c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248755; c=relaxed/simple;
	bh=5352q2WvbgAh05JUJEQi3brrxcxbn/h7ZGYFeN+JX/Q=;
	h=Date:To:From:Subject:Message-Id; b=iq9TFAhEHtJVCoDNPkGEF3P9gAj5PC3XPCJGIiEbP2mO2zYZvQ4LExBeUxIGuscOOmXKYDmpviybWGs7og4pg2b9gLQHqZjC29vaeYw13hxhQX971L+nPhA6gt5639f9mVNUdOCmxbGOopGjpCd7s1FI2hH0jG6KX2XNVdymGWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cIuL0J1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cIuL0J1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F16C4CEC2;
	Mon,  2 Sep 2024 03:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248754;
	bh=5352q2WvbgAh05JUJEQi3brrxcxbn/h7ZGYFeN+JX/Q=;
	h=Date:To:From:Subject:From;
	b=cIuL0J1ftdBj2pLKwidT8bf4/Az2MPSAYzUQSVqTkWDCrWV1TUYVGcN48dFzPWgF6
	 gWQxWnTf7vZT/hkftnbCKo/9Fb3aC6b6zn5orpfUv83hfxWSUXUyG30FRrKdwUsgbX
	 DAtnBsFSaSsfSp4shZEWeKv9cSyuPSzzGOdwuaAA=
Date: Sun, 01 Sep 2024 20:45:54 -0700
To: mm-commits@vger.kernel.org,ebiederm@xmission.com,bhe@redhat.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec-use-atomic_try_cmpxchg_acquire-in-kexec_trylock.patch removed from -mm tree
Message-Id: <20240902034554.D2F16C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec: use atomic_try_cmpxchg_acquire() in kexec_trylock()
has been removed from the -mm tree.  Its filename was
     kexec-use-atomic_try_cmpxchg_acquire-in-kexec_trylock.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: kexec: use atomic_try_cmpxchg_acquire() in kexec_trylock()
Date: Fri, 19 Jul 2024 12:38:52 +0200

Use atomic_try_cmpxchg_acquire(*ptr, &old, new) instead of
atomic_cmpxchg_acquire(*ptr, old, new) == old in kexec_trylock().
x86 CMPXCHG instruction returns success in ZF flag, so
this change saves a compare after cmpxchg.

Link: https://lkml.kernel.org/r/20240719103937.53742-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_internal.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/kexec_internal.h~kexec-use-atomic_try_cmpxchg_acquire-in-kexec_trylock
+++ a/kernel/kexec_internal.h
@@ -23,7 +23,8 @@ int kimage_is_destination_range(struct k
 extern atomic_t __kexec_lock;
 static inline bool kexec_trylock(void)
 {
-	return atomic_cmpxchg_acquire(&__kexec_lock, 0, 1) == 0;
+	int old = 0;
+	return atomic_try_cmpxchg_acquire(&__kexec_lock, &old, 1);
 }
 static inline void kexec_unlock(void)
 {
_

Patches currently in -mm which might be from ubizjak@gmail.com are

errh-add-err_ptr_pcpu-ptr_err_pcpu-and-is_err_pcpu-macros.patch
mm-kmemleak-use-is_err_pcpu-for-pointer-in-the-percpu-address-space.patch
squashfs-fix-percpu-address-space-issues-in-decompressor_multi_percpuc.patch

