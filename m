Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA111243334
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837078; cv=none; b=Jf9HfD055OCy6ha8NvBXcNKrhZHlcphwP08ZkJPqp1wEAHSVrsYwwEEBN0SEnb6hXlBT4J7ocwbkxf3BLlgbeKtRAY8Iz+rsvZeq12cfRbwC//3yEM48HjH8Oo1T4KOuVaD+rPzyX8DdWAH3Tqoc9limdsRqt7j4leTF7I+tA2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837078; c=relaxed/simple;
	bh=tA/bbnCDnE86oNEbzK/jPvt12yCh5O8oAYy01lIe6i0=;
	h=Date:To:From:Subject:Message-Id; b=C0DaiP+c8fAxs7JUNwd59VaHTgbHrIcfIuxTxHZ7eDtgR3Z4djHIe4aD1mhEoWEzlgpuGm3daxDG4HDr/+aRsgsd/ku5oSusPKEyA8OiVPSFtg2QwY/KYRofTSgPHe10NnobL7w+DwoOVf11jbABFWxAiAEKHl1xj85DxwKZ8Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=urT7apui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="urT7apui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D70CC4CEE1;
	Tue, 14 Jan 2025 06:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837078;
	bh=tA/bbnCDnE86oNEbzK/jPvt12yCh5O8oAYy01lIe6i0=;
	h=Date:To:From:Subject:From;
	b=urT7apuiLVvwZd6tGZy3vJ7CvXq5mJHjiAEC2vu0NINXaOV67OdMSen2/ziGmXKqP
	 GfW1U8wWMsfrl86fUR7nsqjmNDdOGjUi+ESEpGMh3rKBF+DUMMJAiHXzCtW67nMlpP
	 ULihY5IKv9cIZOi4ExtAEM8HvY9ed+8g31s5QoZs=
Date: Mon, 13 Jan 2025 22:44:38 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,torvalds@linux-foundation.org,tj@kernel.org,tglx@linutronix.de,peterz@infradead.org,pabeni@redhat.com,nadav.amit@gmail.com,mingo@kernel.org,luto@kernel.org,longman@redhat.com,kuba@kernel.org,kent.overstreet@linux.dev,hpa@zytor.com,edumazet@google.com,dvlasenk@redhat.com,dennis@kernel.org,davem@davemloft.net,dave.hansen@linux.intel.com,cl@linux.com,brgerst@gmail.com,bp@alien8.de,boqun.feng@gmail.com,arnd@arndb.de,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] percpu-repurpose-__percpu-tag-as-a-named-address-space-qualifier.patch removed from -mm tree
Message-Id: <20250114064438.9D70CC4CEE1@smtp.kernel.org>
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


