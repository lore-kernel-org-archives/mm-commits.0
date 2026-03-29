Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F09613AD1C
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744925; cv=none; b=WU4oXcKfNOiDgoO/xVmcyIrbWyoKYc5RSV+l1PVRqapwOwyRe0IS7/3luwLvSBz2TEEl4Rc1pBj6DUOdlp0ai1F5H7APXj9OI1GxkpacXaYqGIp3XAUwInX3XpAY9Q8CK4+YrkLvdLFzs0VpIXVt1RCZKi9ElrNzcHZQB39HZpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744925; c=relaxed/simple;
	bh=I0KCFB5NOj5j5HJvNUNkv90sCzAwQmJWH4R93TYW2eQ=;
	h=Date:To:From:Subject:Message-Id; b=mPWN6IUAlNqJ1CNQ6kp0+oedSCNgXfQWU5AOoRMZZWmJJSBqRWNbc8klGlHiMKlhxC7PjOFQFjHkNMOAouDG8G1f2L+bRz0OhRANpVekXX+r571DutATUOzgQKOEz8otTrWqokSan+xWQpJh8pcsROxVg0+teMJxtfE1Ri+1fbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vCdwrjVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vCdwrjVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7FFC4CEF7;
	Sun, 29 Mar 2026 00:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744925;
	bh=I0KCFB5NOj5j5HJvNUNkv90sCzAwQmJWH4R93TYW2eQ=;
	h=Date:To:From:Subject:From;
	b=vCdwrjVf6llmzOK5hsVCIOQMynGqfOsqmaSFQgBx5+iP1RGBy+qnRKF8DnQnGe+qX
	 /unxwGMMpnaB1KeWqM1mLMV6/dkNGnYIIVhZbQ1lJGIyHsVM0iwecbGgLC/QdqiHSb
	 SOMjMjzG1hius/5wjRGAVsmaRT2m2l8DV9MVbZFo=
Date: Sat, 28 Mar 2026 17:42:04 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,sidhartha.kumar@oracle.com,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kconfig-make-config_memory_hotplug-depend-on-config_sparsemem_vmemmap.patch removed from -mm tree
Message-Id: <20260329004204.EA7FFC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/Kconfig: make CONFIG_MEMORY_HOTPLUG depend on CONFIG_SPARSEMEM_VMEMMAP
has been removed from the -mm tree.  Its filename was
     mm-kconfig-make-config_memory_hotplug-depend-on-config_sparsemem_vmemmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/Kconfig: make CONFIG_MEMORY_HOTPLUG depend on CONFIG_SPARSEMEM_VMEMMAP
Date: Fri, 20 Mar 2026 23:13:36 +0100

Ever since commit f8f03eb5f0f9 ("mm: stop making SPARSEMEM_VMEMMAP
user-selectable"), an architecture that supports CONFIG_SPARSEMEM_VMEMMAP
(by selecting SPARSEMEM_VMEMMAP_ENABLE) can no longer enable
CONFIG_SPARSEMEM without CONFIG_SPARSEMEM_VMEMMAP.

Right now, CONFIG_MEMORY_HOTPLUG is guarded by CONFIG_SPARSEMEM.

However, CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG is only enabled by
* arm64: which selects SPARSEMEM_VMEMMAP_ENABLE
* loongarch: which selects SPARSEMEM_VMEMMAP_ENABLE
* powerpc (64bit): which selects SPARSEMEM_VMEMMAP_ENABLE
* riscv (64bit): which selects SPARSEMEM_VMEMMAP_ENABLE
* s390 with SPARSEMEM: which selects SPARSEMEM_VMEMMAP_ENABLE
* x86 (64bit): which selects SPARSEMEM_VMEMMAP_ENABLE

So, we can make CONFIG_MEMORY_HOTPLUG depend on CONFIG_SPARSEMEM_VMEMMAP
without affecting any setups.

Link: https://lkml.kernel.org/r/20260320-sparsemem_cleanups-v2-4-096addc8800d@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/Kconfig~mm-kconfig-make-config_memory_hotplug-depend-on-config_sparsemem_vmemmap
+++ a/mm/Kconfig
@@ -472,7 +472,7 @@ config ARCH_ENABLE_MEMORY_HOTREMOVE
 menuconfig MEMORY_HOTPLUG
 	bool "Memory hotplug"
 	select MEMORY_ISOLATION
-	depends on SPARSEMEM
+	depends on SPARSEMEM_VMEMMAP
 	depends on ARCH_ENABLE_MEMORY_HOTPLUG
 	depends on 64BIT
 	select NUMA_KEEP_MEMINFO if NUMA
_

Patches currently in -mm which might be from david@kernel.org are


