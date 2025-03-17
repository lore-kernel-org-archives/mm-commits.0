Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BEFA59
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188166; cv=none; b=gNCSx/0sDG8emmIrVz8GhqAF591Rj1a5FfDKyWEL/KiWRJfV6HPhGsliJgqet8yBj8YOeN+41DUGUkauFLxF8bQaC7iEVvwwXVrQNPxabm+Kw1+QiwpdvlQefxQCLmO0JS7kutndsLgcEPMKtOtT+krsAmkPs+33Zb6aLcwrkRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188166; c=relaxed/simple;
	bh=9DxvqqgYdbHn90/zLXRRcmOIRvZTrDy6KGpim6eMCqw=;
	h=Date:To:From:Subject:Message-Id; b=dUOc/xanbTYqdVREQ1I6Lw2jXE5u28DFBqYLUZ2mSSgK+2rKnzSRvQbUpIhWR9R5ocksGJddKlV7aGKKLLCUaqU5ZSgiGFY32obJh2KCt0ey9kp9c53pYJytr4/xg0X1EhF6H8yK70D8MWbufE+XHuTLl0qxXLn5MPiiYh+4D5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jqux9yMV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jqux9yMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA911C4CEEC;
	Mon, 17 Mar 2025 05:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188165;
	bh=9DxvqqgYdbHn90/zLXRRcmOIRvZTrDy6KGpim6eMCqw=;
	h=Date:To:From:Subject:From;
	b=jqux9yMVuOIBAu9XEDwZYYkRy9J0W7llj48rcDph5M7zBuVhLBjst3tffHXPeniyG
	 RrrNZdPQIdWyY5QN2kqzYc8QZx4GD1gho04Q/ZT/gJBm6NknZJHUZlYaNCydwYcDQX
	 P8xg1tMRE6kLEaKcO1Jxo5RFCrrpZbNEyN+j19go=
Date: Sun, 16 Mar 2025 22:09:25 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,torvalds@linux-foundation.org,tj@kernel.org,tglx@linutronix.de,peterz@infradead.org,pabeni@redhat.com,nadav.amit@gmail.com,mingo@kernel.org,luto@kernel.org,longman@redhat.com,kuba@kernel.org,kent.overstreet@linux.dev,hpa@zytor.com,edumazet@google.com,dvlasenk@redhat.com,dennis@kernel.org,davem@davemloft.net,dave.hansen@linux.intel.com,cl@linux.com,brgerst@gmail.com,bp@alien8.de,boqun.feng@gmail.com,arnd@arndb.de,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] percpu-repurpose-__percpu-tag-as-a-named-address-space-qualifier.patch removed from -mm tree
Message-Id: <20250317050925.CA911C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu: repurpose __percpu tag as a named address space qualifier
has been removed from the -mm tree.  Its filename was
     percpu-repurpose-__percpu-tag-as-a-named-address-space-qualifier.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: percpu: repurpose __percpu tag as a named address space qualifier
Date: Mon, 27 Jan 2025 17:05:09 +0100

The patch introduces __percpu_qual define and repurposes __percpu tag as a
named address space qualifier using the new define.

Arches can now conditionally define __percpu_qual as their named address
space qualifier for percpu variables.

Link: https://lkml.kernel.org/r/20250127160709.80604-6-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Acked-by: Nadav Amit <nadav.amit@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/percpu.h   |   13 +++++++++++++
 include/linux/compiler_types.h |    2 +-
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/include/asm-generic/percpu.h~percpu-repurpose-__percpu-tag-as-a-named-address-space-qualifier
+++ a/include/asm-generic/percpu.h
@@ -6,6 +6,19 @@
 #include <linux/threads.h>
 #include <linux/percpu-defs.h>
 
+/*
+ * __percpu_qual is the qualifier for the percpu named address space.
+ *
+ * Most arches use generic named address space for percpu variables but
+ * some arches define percpu variables in different named address space
+ * (on the x86 arch, percpu variable may be declared as being relative
+ * to the %fs or %gs segments using __seg_fs or __seg_gs named address
+ * space qualifier).
+ */
+#ifndef __percpu_qual
+# define __percpu_qual
+#endif
+
 #ifdef CONFIG_SMP
 
 /*
--- a/include/linux/compiler_types.h~percpu-repurpose-__percpu-tag-as-a-named-address-space-qualifier
+++ a/include/linux/compiler_types.h
@@ -57,7 +57,7 @@ static inline void __chk_io_ptr(const vo
 #  define __user	BTF_TYPE_TAG(user)
 # endif
 # define __iomem
-# define __percpu	BTF_TYPE_TAG(percpu)
+# define __percpu	__percpu_qual BTF_TYPE_TAG(percpu)
 # define __rcu		BTF_TYPE_TAG(rcu)
 
 # define __chk_user_ptr(x)	(void)0
_

Patches currently in -mm which might be from ubizjak@gmail.com are


