Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F20748D
	for <mm-commits@vger.kernel.org>; Fri, 13 Dec 2024 03:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734061803; cv=none; b=noiSBmjS8JYQ+L4Qenm25ALy/SMSlw8bjJuCvJmIIJypx11hzhO3x8vec1Nkf8vz5octgcwxLRmPyq8QjZlBGdfnxovLbsufNAx0OOZkILNR2d0xMe2XQkAFTRszlB5NIB+ar0fsKZIpEJGIt8VdM5xUWuOMC8joQ47rucE6JyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734061803; c=relaxed/simple;
	bh=FqUOMw1jd47BT6dy6RqEAqrJaIS+Xoy6hfGk4GUOTvY=;
	h=Date:To:From:Subject:Message-Id; b=WaHxyUJDKPRY7Lwixa6agcONthEq+mkRPR9C/oniWrEKeTU8Cl0ZXmpE53tmS0efrBF+bKOK95keajqDVfCW1yB+BuOmpfhOoJIqk4DyVFj1q8OzHobDIPzVC2ACdWugq1Zl6ZSUE8HxtTypVGvuGCmGwm3ml0bdjk5D6LWC6fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nmcg+26k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nmcg+26k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473F0C4CED2;
	Fri, 13 Dec 2024 03:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734061803;
	bh=FqUOMw1jd47BT6dy6RqEAqrJaIS+Xoy6hfGk4GUOTvY=;
	h=Date:To:From:Subject:From;
	b=Nmcg+26kxpc34EvDN2eryUCW4DhGZYDci3U2gVzs2wDyks9KDfS9PUxxtItW5pQ9a
	 8MwPyHOIyePXknoUyymRCDqC6EKGsV44QfjEYFj24hoMRbINqYZTGhQLnPoV5Z6lrJ
	 13sVG5jGq83sfnK6b43sPy1yslEYrcr0sVbOSEoo=
Date: Thu, 12 Dec 2024 19:50:02 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,torvalds@linux-foundation.org,tj@kernel.org,tglx@linutronix.de,peterz@infradead.org,pabeni@redhat.com,nadav.amit@gmail.com,mingo@kernel.org,luto@kernel.org,longman@redhat.com,kuba@kernel.org,kent.overstreet@linux.dev,hpa@zytor.com,edumazet@google.com,dvlasenk@redhat.com,dennis@kernel.org,davem@davemloft.net,dave.hansen@linux.intel.com,cl@linux.com,brgerst@gmail.com,bp@alien8.de,boqun.feng@gmail.com,arnd@arndb.de,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-repurpose-__percpu-tag-as-a-named-address-space-qualifier.patch added to mm-unstable branch
Message-Id: <20241213035003.473F0C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu: repurpose __percpu tag as a named address space qualifier
has been added to the -mm mm-unstable branch.  Its filename is
     percpu-repurpose-__percpu-tag-as-a-named-address-space-qualifier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-repurpose-__percpu-tag-as-a-named-address-space-qualifier.patch

This patch will later appear in the mm-unstable branch at
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
From: Uros Bizjak <ubizjak@gmail.com>
Subject: percpu: repurpose __percpu tag as a named address space qualifier
Date: Sun, 8 Dec 2024 21:45:20 +0100

The patch introduces __percpu_qual define and repurposes __percpu tag as a
named address space qualifier using the new define.

Arches can now conditionally define __percpu_qual as their named address
space qualifier for percpu variables.

Link: https://lkml.kernel.org/r/20241208204708.3742696-6-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Acked-by: Nadav Amit <nadav.amit@gmail.com>
Acked-by: Dennis Zhou <dennis@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
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

x86-kgdb-use-is_err_pcpu-macro.patch
compilerh-introduce-typeof_unqual-macro.patch
percpu-use-typeof_unqual-in-variable-declarations.patch
percpu-use-typeof_unqual-in-_cpu_ptr-accessors.patch
percpu-repurpose-__percpu-tag-as-a-named-address-space-qualifier.patch
percpu-x86-enable-strict-percpu-checks-via-named-as-qualifiers.patch

