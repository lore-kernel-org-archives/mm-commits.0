Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472B416FF45
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855627; cv=none; b=LWstYHwf+9VqVPJ6mFE+elE1PgIiKTuUwGvXHaitFzqwKaq+0yX6YY5Zw7eqQ0x9PRRkYdmxpxepCT2bPBOWczM7tzuyM/RXdNQ+/o4lWoybFpHOVjDyUr6DoNPh/mZeFhaeAHFdJTUbNqaxtCF3bdQPvjaBTds33TNphFN3UfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855627; c=relaxed/simple;
	bh=s0fHPfTyKK4IOgoPm/K27cx/OMgP3CmYu2vd/USNKM8=;
	h=Date:To:From:Subject:Message-Id; b=RyEcC5Luk8BidkJ+shm5Bp1plIZgscSnpMcUIoFtvQXnHr1m0+pxKEPb6rqkFnF7jTRtv4KK7U4nofLNLlg+Zbbpy5h69KsMBQrEoudhZSnxVnBQE4FtwYigEH5cRl9HIMoIqdNYLUy8QUEE9NBltNVryeZ+LwJzjdbaOzOXlCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IYG4BptN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IYG4BptN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDEEC4CECF;
	Wed,  6 Nov 2024 01:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855627;
	bh=s0fHPfTyKK4IOgoPm/K27cx/OMgP3CmYu2vd/USNKM8=;
	h=Date:To:From:Subject:From;
	b=IYG4BptNAf0cSVjxhJHpsu0jWPrWBX4eteZmxjk/UtZ92Em/1/PH8WNtXj04Kjmd4
	 iZV2fvZGvp5xUAssc2v9VzS/CNRozptu0XJdE9o1x7lR8L2s85Wx5RcvXRL04B/WQt
	 RW4+y7J/5q/UCXVXOguTWPQqCXL19WOuO08MmpuM=
Date: Tue, 05 Nov 2024 17:13:46 -0800
To: mm-commits@vger.kernel.org,xavier_qy@163.com,tj@kernel.org,mkoutny@suse.com,longman@redhat.com,llong@redhat.com,lizefan.x@bytedance.com,jserv@ccns.ncku.edu.tw,hch@lst.de,hannes@cmpxchg.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-makefile-make-union-find-compilation-conditional-on-config_cpusets.patch removed from -mm tree
Message-Id: <20241106011347.1BDEEC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/Makefile: make union-find compilation conditional on CONFIG_CPUSETS
has been removed from the -mm tree.  Its filename was
     lib-makefile-make-union-find-compilation-conditional-on-config_cpusets.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
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
@@ -1157,6 +1157,7 @@ config CGROUP_HUGETLB
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


