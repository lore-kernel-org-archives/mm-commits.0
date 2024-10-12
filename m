Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C01717BCE
	for <mm-commits@vger.kernel.org>; Sat, 12 Oct 2024 22:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728772277; cv=none; b=GeDFC1UxU18nnln4fX4PnBPdmuk+hzszB+w1qRzFpwWxaSQTN5Sbp9MiGl/HgOLTBbtydKKGjwlKc5op/vL3g+mHnpkcWUFpxguJ+0IgvEKkYlY2RdAL2wVeScXphjTWii02qKepy5an43Y+bpgpW2rVOrdW+biMz9zEfuG0VgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728772277; c=relaxed/simple;
	bh=RmjUMCVHMyPmgUDlsFhAVVz5meklGXPBFK06ARyREB0=;
	h=Date:To:From:Subject:Message-Id; b=mf5mgr4Q8rAjJmu8xS9eVDGBiZ6qlbgeXGOQ1/LeqdIEYGLNz8YqkWpKigMjntf9mBMJEb/1DY3Iw+YGkddDUv5Urpbp5yt7jAhJRTEvqhjfRMboEl34aqrwSanElaWPjEyPLlsCnvFysoOFH/4BYfSRzkaNhZHz/lXjdNQi4u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N/WbL1LX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N/WbL1LX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41CCC4CEC6;
	Sat, 12 Oct 2024 22:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728772276;
	bh=RmjUMCVHMyPmgUDlsFhAVVz5meklGXPBFK06ARyREB0=;
	h=Date:To:From:Subject:From;
	b=N/WbL1LX/fipkVs9d68V/zu0oigOrOWLupbpDjiHqKxtNa7PL+nAAha7UjeQUIVUE
	 /GDOh2fNqiOaATkdfFSYnYXUIMNBTrDzRtqr4q/m5ynYDP4Vya2Cms3j30heza7Gk8
	 z7P+3O2zqI8FG7NhdNSxTxiOdioiZ9Aw5a7LYoZ4=
Date: Sat, 12 Oct 2024 15:31:16 -0700
To: mm-commits@vger.kernel.org,xavier_qy@163.com,tj@kernel.org,mkoutny@suse.com,longman@redhat.com,llong@redhat.com,lizefan.x@bytedance.com,jserv@ccns.ncku.edu.tw,hch@infradead.org,hannes@cmpxchg.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-makefile-make-union-find-compilation-conditional-on-config_cpusets.patch added to mm-nonmm-unstable branch
Message-Id: <20241012223116.D41CCC4CEC6@smtp.kernel.org>
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
Date: Fri, 11 Oct 2024 22:12:14 +0800

Currently, cpuset is the only user of the union-find implementation. 
Compiling union-find in all configurations unnecessarily increases the
code size when building the kernel without cgroup support.  Modify the
build system to compile union-find only when CONFIG_CPUSETS is enabled.

Link: https://lore.kernel.org/lkml/1ccd6411-5002-4574-bb8e-3e64bba6a757@redhat.com/
Link: https://lkml.kernel.org/r/20241011141214.87096-1-visitorckw@gmail.com
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

 init/Kconfig |    1 +
 lib/Kconfig  |    3 +++
 lib/Makefile |    3 ++-
 3 files changed, 6 insertions(+), 1 deletion(-)

--- a/init/Kconfig~lib-makefile-make-union-find-compilation-conditional-on-config_cpusets
+++ a/init/Kconfig
@@ -1153,6 +1153,7 @@ config CGROUP_HUGETLB
 config CPUSETS
 	bool "Cpuset controller"
 	depends on SMP
+	select UNION_FIND
 	help
 	  This option will let you create and manage CPUSETs which
 	  allow dynamically partitioning a system into sets of CPUs and
--- a/lib/Kconfig~lib-makefile-make-union-find-compilation-conditional-on-config_cpusets
+++ a/lib/Kconfig
@@ -777,3 +777,6 @@ config POLYNOMIAL
 
 config FIRMWARE_TABLE
 	bool
+
+config UNION_FIND
+	bool
--- a/lib/Makefile~lib-makefile-make-union-find-compilation-conditional-on-config_cpusets
+++ a/lib/Makefile
@@ -35,8 +35,9 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
 	 earlycpio.o seq_buf.o siphash.o dec_and_lock.o \
 	 nmi_backtrace.o win_minmax.o memcat_p.o \
-	 buildid.o objpool.o union_find.o
+	 buildid.o objpool.o
 
+lib-$(CONFIG_UNION_FIND) += union_find.o
 lib-$(CONFIG_PRINTK) += dump_stack.o
 lib-$(CONFIG_SMP) += cpumask.o
 
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-kconfigdebug-move-int_pow-test-option-to-runtime-testing-section.patch
lib-makefile-make-union-find-compilation-conditional-on-config_cpusets.patch

