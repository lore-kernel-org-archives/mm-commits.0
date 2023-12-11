Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFCC7493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HZi/Rz4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B6DC433C7;
	Mon, 11 Dec 2023 01:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257834;
	bh=5/yDAhEmG7Nx1tpGa7ZmNOdaCY65y4bT/SxXBlpDyi0=;
	h=Date:To:From:Subject:From;
	b=HZi/Rz4ZwlD0bIiNBOu58/XR6a7xpoAnuJOWCgyYLQ1wjRjUG5fmhwyZbFuNbWean
	 P+5Dr2TapT4YCunNCa2XU2pbPmDNQLo5zJW8XsXqpMRSJSplBxiEPZFnGciRHrvgyu
	 bU2UEVZvSMWFg8bKynL6pRN+M+AqLqbgIyJp+p8Q=
Date: Sun, 10 Dec 2023 17:23:54 -0800
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,tudor.ambarus@linaro.org,tsbogend@alpha.franken.de,sfr@canb.auug.org.au,richard@nod.at,richard.henderson@linaro.org,peterz@infradead.org,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mattst88@gmail.com,masahiroy@kernel.org,keescook@chromium.org,ink@jurassic.park.msu.ru,gregkh@linuxfoundation.org,glaubitz@physik.fu-berlin.de,dwmw2@infradead.org,dinguyen@kernel.org,davem@davemloft.net,dalias@libc.org,chengzhihao1@huawei.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] sched-fair-move-unused-stub-functions-to-header.patch removed from -mm tree
Message-Id: <20231211012354.C8B6DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sched: fair: move unused stub functions to header
has been removed from the -mm tree.  Its filename was
     sched-fair-move-unused-stub-functions-to-header.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: sched: fair: move unused stub functions to header
Date: Thu, 23 Nov 2023 12:05:03 +0100

These four functions have a normal definition for CONFIG_FAIR_GROUP_SCHED,
and empty one that is only referenced when FAIR_GROUP_SCHED is disabled
but CGROUP_SCHED is still enabled.  If both are turned off, the functions
are still defined but the misisng prototype causes a W=1 warning:

kernel/sched/fair.c:12544:6: error: no previous prototype for 'free_fair_sched_group'
kernel/sched/fair.c:12546:5: error: no previous prototype for 'alloc_fair_sched_group'
kernel/sched/fair.c:12553:6: error: no previous prototype for 'online_fair_sched_group'
kernel/sched/fair.c:12555:6: error: no previous prototype for 'unregister_fair_sched_group'

Move the alternatives into the header as static inline functions with the
correct combination of #ifdef checks to avoid the warning without adding
even more complexity.

[A different patch with the same description got applied by accident
 and was later reverted, but the original patch is still missing]

Link: https://lkml.kernel.org/r/20231123110506.707903-4-arnd@kernel.org
Fixes: 7aa55f2a5902 ("sched/fair: Move unused stub functions to header")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/fair.c  |   13 -------------
 kernel/sched/sched.h |   11 +++++++++++
 2 files changed, 11 insertions(+), 13 deletions(-)

--- a/kernel/sched/fair.c~sched-fair-move-unused-stub-functions-to-header
+++ a/kernel/sched/fair.c
@@ -13036,19 +13036,6 @@ next_cpu:
 	return 0;
 }
 
-#else /* CONFIG_FAIR_GROUP_SCHED */
-
-void free_fair_sched_group(struct task_group *tg) { }
-
-int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
-{
-	return 1;
-}
-
-void online_fair_sched_group(struct task_group *tg) { }
-
-void unregister_fair_sched_group(struct task_group *tg) { }
-
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 
--- a/kernel/sched/sched.h~sched-fair-move-unused-stub-functions-to-header
+++ a/kernel/sched/sched.h
@@ -436,10 +436,21 @@ static inline int walk_tg_tree(tg_visito
 
 extern int tg_nop(struct task_group *tg, void *data);
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 extern void free_fair_sched_group(struct task_group *tg);
 extern int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent);
 extern void online_fair_sched_group(struct task_group *tg);
 extern void unregister_fair_sched_group(struct task_group *tg);
+#else
+static inline void free_fair_sched_group(struct task_group *tg) { }
+static inline int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
+{
+       return 1;
+}
+static inline void online_fair_sched_group(struct task_group *tg) { }
+static inline void unregister_fair_sched_group(struct task_group *tg) { }
+#endif
+
 extern void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 			struct sched_entity *se, int cpu,
 			struct sched_entity *parent);
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-fix-kexec_file-dependencies-fix.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch

