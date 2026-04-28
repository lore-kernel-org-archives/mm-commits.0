Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BFE3EF0C9;
	Tue, 28 Apr 2026 13:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777381906; cv=none; b=RbAxQhBDfm2NG0HFRLFdNHE+KOS+IbtAi66MJE0u4RMPy05MQ4Q0NYbku+LoWZY3s1cSjjxR7ZszNkQNLC3ORE8llhoHVkGwGVT2iFLRcJ3S8/XrLz0qWuUuViH3UM0gNdFfWf417qAaOGLmzqSK5OGbUUDpv+y5U2QMEc/ObaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777381906; c=relaxed/simple;
	bh=jYgM0IF6kD5KCGMYtZjkmmlCECROFOMKTccfIZ3/5cA=;
	h=Date:To:From:Subject:Message-Id; b=NnrTVal79vrVMgo+yT5GYPjjJ4sIRA6iAu4vm9NLT00PgzVclZOiCEObchfr3Z8iHMiUnsuckFoVvNiwJL1FqVlnOLcX6+vm9hgzYPggZeCk1q+0bgLhTDHqSo1vu4s0LyRi/ZKwiByBgISnUh23SlWGyXnCNj9PA5NI64dofRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S6nBbZvj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S6nBbZvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452E3C2BCAF;
	Tue, 28 Apr 2026 13:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777381906;
	bh=jYgM0IF6kD5KCGMYtZjkmmlCECROFOMKTccfIZ3/5cA=;
	h=Date:To:From:Subject:From;
	b=S6nBbZvjW3txnCxJWOTTR5en0khbdFO/0bKPJM8itKOOFqEp4+Ape1L4wuPJEXmRV
	 Ygue+v7Ezm9HyDBGZG9dctvMb0gg4mMvDFVlL0H/ltCGmeuh2HcESTcM7fIODMEfPp
	 Dz+C/qXlzFYttOp1PY1pZcoCmEXwmsN8fhU39/zA=
Date: Tue, 28 Apr 2026 06:11:45 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,stable@vger.kernel.org,rafael@kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,huang.ying.caritas@gmail.com,gregkh@linuxfoundation.org,david@kernel.org,dakr@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-base-memory-fix-locking-for-poison-accounting-lookup.patch added to mm-hotfixes-unstable branch
Message-Id: <20260428131146.452E3C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/base/memory: fix locking for poison accounting lookup
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     drivers-base-memory-fix-locking-for-poison-accounting-lookup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-base-memory-fix-locking-for-poison-accounting-lookup.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: drivers/base/memory: fix locking for poison accounting lookup
Date: Tue, 28 Apr 2026 16:52:19 +0800

memblk_nr_poison_inc() and memblk_nr_poison_sub() call
find_memory_block_by_id(), which requires device_hotplug_lock to serialize
the xarray lookup against memory block removal.

Take device_hotplug_lock around the lookup and nr_hwpoison update so the
memory block cannot disappear between xa_load() and get_device().

Link: https://lore.kernel.org/20260428085219.1316047-4-songmuchun@bytedance.com
Fixes: 5033091de814 ("mm/hwpoison: introduce per-memory_block hwpoison counter")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Huang, Ying" <huang.ying.caritas@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memory-fix-locking-for-poison-accounting-lookup
+++ a/drivers/base/memory.c
@@ -1228,23 +1228,29 @@ int walk_dynamic_memory_groups(int nid,
 void memblk_nr_poison_inc(unsigned long pfn)
 {
 	const unsigned long block_id = pfn_to_block_id(pfn);
-	struct memory_block *mem = find_memory_block_by_id(block_id);
+	struct memory_block *mem;
 
+	lock_device_hotplug();
+	mem = find_memory_block_by_id(block_id);
 	if (mem) {
 		atomic_long_inc(&mem->nr_hwpoison);
 		put_device(&mem->dev);
 	}
+	unlock_device_hotplug();
 }
 
 void memblk_nr_poison_sub(unsigned long pfn, long i)
 {
 	const unsigned long block_id = pfn_to_block_id(pfn);
-	struct memory_block *mem = find_memory_block_by_id(block_id);
+	struct memory_block *mem;
 
+	lock_device_hotplug();
+	mem = find_memory_block_by_id(block_id);
 	if (mem) {
 		atomic_long_sub(i, &mem->nr_hwpoison);
 		put_device(&mem->dev);
 	}
+	unlock_device_hotplug();
 }
 
 static unsigned long memblk_nr_poison(struct memory_block *mem)
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memory_hotplug-fix-memory-block-reference-leak-on-remove.patch
drivers-base-memory-fix-memory-block-reference-leak-in-poison-accounting.patch
drivers-base-memory-fix-locking-for-poison-accounting-lookup.patch
mm-sparse-remove-sparse-buffer-pre-allocation-mechanism.patch
mm-sparse-vmemmap-fix-vmemmap-accounting-underflow.patch
mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch
mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths.patch
mm-sparse-vmemmap-fix-dax-vmemmap-accounting-with-optimization.patch
mm-mm_init-fix-pageblock-migratetype-for-zone_device-compound-pages.patch
mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch

