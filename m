Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C541514CC
	for <mm-commits@vger.kernel.org>; Wed,  9 Oct 2024 20:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728505956; cv=none; b=ri78Y4kWPvtlXvVOiuK+16FuHwvauxbq4Ml5szYSgIXooT2hASX4GaWnptb9kZKA/jB4Uu/4Nnn2qHNrlZDuw+fa671pXOlnJh4/QuAxYaN//aKr4S5dIE6HlusgW9TNPHydUAKhZNdRNjoSOudJGKfWXLDgiWAmckiSYToy7XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728505956; c=relaxed/simple;
	bh=omoIKViEqw00zLr+Pi6wsymUetnywNW/XHNl3rX+gfU=;
	h=Date:To:From:Subject:Message-Id; b=P7ylHDIgB5ukwHVOwFXshz2Vv2j7se6kW3TmBwtH6xz+cejKWTl9YQcoH5X3BgXsuyyU8vsrEgR/SOEZ8Nb31EEn9UFlFaNq/mHAsT3JKtHfUP4LlgMTmRiZe6y2Q79T9FrSJtSgA2ZC/jWENnXxhnl3wVEtRfy2tcBRACbhAw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nalJ6us1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nalJ6us1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB72DC4CEC3;
	Wed,  9 Oct 2024 20:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728505954;
	bh=omoIKViEqw00zLr+Pi6wsymUetnywNW/XHNl3rX+gfU=;
	h=Date:To:From:Subject:From;
	b=nalJ6us196yZTOSRqowWONIas0KrWlbTHnW8vxmjvU9OkcfuU83nUoCYihNhgbh6j
	 Ne2z/Qo6Dz6e7U5SXMo8OjyE2qTqW3nSrgvluXm+OiV5uQxBlQPJ8migKI2FD+HgyG
	 duJTWgATqAbRTaP0L5a5mh0YnWTxU6CE+C8CahTs=
Date: Wed, 09 Oct 2024 13:32:34 -0700
To: mm-commits@vger.kernel.org,xavier_qy@163.com,tj@kernel.org,mkoutny@suse.com,longman@redhat.com,llong@redhat.com,lizefan.x@bytedance.com,jserv@ccns.ncku.edu.tw,hch@infradead.org,hannes@cmpxchg.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-makefile-make-union-find-compilation-conditional-on-config_cpusets.patch added to mm-nonmm-unstable branch
Message-Id: <20241009203234.BB72DC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/Makefile: make union-find compilation conditional on CONFIG_CPUSETS
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-makefile-make-union-find-compilation-conditional-on-config_cpusets.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-makefile-make-union-find-compilation-conditional-on-config_cpusets.patch

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
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib/Makefile: make union-find compilation conditional on CONFIG_CPUSETS
Date: Wed, 9 Oct 2024 23:40:22 +0800

Currently, cpuset is the only user of the union-find implementation. 
Compiling union-find in all configurations unnecessarily increases the
code size when building the kernel without cgroup support.  Modify the
build system to compile union-find only when CONFIG_CPUSETS is enabled.

Link: https://lore.kernel.org/lkml/1ccd6411-5002-4574-bb8e-3e64bba6a757@redhat.com/
Link: https://lkml.kernel.org/r/20241009154022.2432662-1-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Suggested-by: Waiman Long <llong@redhat.com>
Acked-by: Waiman Long <longman@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Xavier <xavier_qy@163.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/Makefile~lib-makefile-make-union-find-compilation-conditional-on-config_cpusets
+++ a/lib/Makefile
@@ -35,8 +35,9 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
 	 earlycpio.o seq_buf.o siphash.o dec_and_lock.o \
 	 nmi_backtrace.o win_minmax.o memcat_p.o \
-	 buildid.o objpool.o union_find.o
+	 buildid.o objpool.o
 
+lib-$(CONFIG_CPUSETS) += union_find.o
 lib-$(CONFIG_PRINTK) += dump_stack.o
 lib-$(CONFIG_SMP) += cpumask.o
 
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-kconfigdebug-move-int_pow-test-option-to-runtime-testing-section.patch
lib-makefile-make-union-find-compilation-conditional-on-config_cpusets.patch

