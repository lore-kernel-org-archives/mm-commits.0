Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF4F14B828
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 19:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708628940; cv=none; b=uirCD2kCzTrYGWDeEWxEEUJO77xhmGV+mbaGpapzSJpQgqLsMQuUCtUT24R/GCgrNpyAXjWjyhz6XWDXJvi15I8E4MXWrsoki0Dze1XOhBVNMkz5oJAy4WCqFdT943kF/0nsYjH3Ons9MFyelezf43XwLrPHeimcAC0XzenTrq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708628940; c=relaxed/simple;
	bh=U7DJAh3AzYxmjij/q8a7t8cqTUdTMbBqlEEa0UEQDAM=;
	h=Date:To:From:Subject:Message-Id; b=Ps3jDVRAzvFvAc08895ZEgQCLxNdOrkuq4iSTn5TKoOygDZko3LoH8zFmamUjdAUu7RxfQr4GRrOZ+dIyO5Y6kPkCEh83kIc7B/HPdGlYolB5wqNx7HBvlvGM9gKciNk7xcgY8AG29DU9n3I41F8K6woUlJDmqOjZ4sOUV/JRUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eMosIcIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eMosIcIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D12C433F1;
	Thu, 22 Feb 2024 19:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708628939;
	bh=U7DJAh3AzYxmjij/q8a7t8cqTUdTMbBqlEEa0UEQDAM=;
	h=Date:To:From:Subject:From;
	b=eMosIcITkKi04eXkL6em0WsinMJzPho6HcEUz7VnZPB2q5BTT7cRlK0QqkrrnbZ1s
	 g1GZ8e3wJ+od/DSX/0XHAHXeCYcpQWmvd9ZxQnlH4rx/tEFLdS7OvIQI75Cbd0HQ5I
	 VS31+8WkQNY2bzVDH8i5sb/rW2FNbTnWNUv2AxlU=
Date: Thu, 22 Feb 2024 11:08:59 -0800
To: mm-commits@vger.kernel.org,rientjes@google.com,paulmck@kernel.org,muchun.song@linux.dev,ligang.bdlg@bytedance.com,gang.li@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-have-config_hugetlbfs-select-config_padata.patch added to mm-unstable branch
Message-Id: <20240222190859.B7D12C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: have CONFIG_HUGETLBFS select CONFIG_PADATA
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-have-config_hugetlbfs-select-config_padata.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-have-config_hugetlbfs-select-config_padata.patch

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
From: Gang Li <gang.li@linux.dev>
Subject: hugetlb: have CONFIG_HUGETLBFS select CONFIG_PADATA
Date: Thu, 22 Feb 2024 22:04:19 +0800

Allow hugetlb use padata_do_multithreaded for parallel initialization. 
Select CONFIG_PADATA in this case.

Link: https://lkml.kernel.org/r/20240222140422.393911-7-gang.li@linux.dev
Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>
Tested-by: David Rientjes <rientjes@google.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/Kconfig~hugetlb-have-config_hugetlbfs-select-config_padata
+++ a/fs/Kconfig
@@ -261,6 +261,7 @@ menuconfig HUGETLBFS
 	depends on X86 || SPARC64 || ARCH_SUPPORTS_HUGETLBFS || BROKEN
 	depends on (SYSFS || SYSCTL)
 	select MEMFD_CREATE
+	select PADATA if SMP
 	help
 	  hugetlbfs is a filesystem backing for HugeTLB pages, based on
 	  ramfs. For architectures that support it, say Y here and read
_

Patches currently in -mm which might be from gang.li@linux.dev are

hugetlb-code-clean-for-hugetlb_hstate_alloc_pages.patch
hugetlb-split-hugetlb_hstate_alloc_pages.patch
hugetlb-pass-next_nid_to_alloc-directly-to-for_each_node_mask_to_alloc.patch
padata-dispatch-works-on-different-nodes.patch
padata-downgrade-padata_do_multithreaded-to-serial-execution-for-non-smp.patch
hugetlb-have-config_hugetlbfs-select-config_padata.patch
hugetlb-parallelize-2m-hugetlb-allocation-and-initialization.patch
hugetlb-parallelize-1g-hugetlb-initialization.patch

