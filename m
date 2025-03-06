Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9959419E98D;
	Thu,  6 Mar 2025 05:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239442; cv=none; b=sHLjeHIqApi4B/kBLXs2RaW97ItQDLMKZOhb4Xk21Zbi5jCQX9zI+QNoAtNGl697YJl6pnznU/bvQgw64V9jCKV2xKH9bBi5PI4/y3W4+RrvDybNlYi4V9arNYbjDihFGmzI478bg87HqPdO0SgNecH0KhYr1zGOI4ltWS4O32U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239442; c=relaxed/simple;
	bh=AUIHM4K8cSpKyeeS9gcp2HmtoCz/+umgoWIbBHItCIM=;
	h=Date:To:From:Subject:Message-Id; b=t/w8RZBxQC8PJAJtsbEjy9maUjbHRXcE2pn9X470vANohGVM5Ou7FBDByhN69tolfcUrCdaB8aSvyWMlO/APkiER8CP38O6buDo0OywLJVGKj+IeobJrnk4IC9Tnx+lQWEcFhU3PS3CBCjAfJWffKeet2pVtz/J7w6sgfHJzunY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1OqK6llE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1OqK6llE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B2AC4CEE4;
	Thu,  6 Mar 2025 05:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239442;
	bh=AUIHM4K8cSpKyeeS9gcp2HmtoCz/+umgoWIbBHItCIM=;
	h=Date:To:From:Subject:From;
	b=1OqK6llEGIL3miDCB5jShdrGEhFpXIyca0vq1/NZ0MiW/CCxzsT3zLGBSAi+cRxNP
	 JkIvOyOci59sShbiKz9FLt6yEOpduXx8p0Zn2yE+BqJK5tXQ6AEWlH1k44/RBlbrkt
	 LhTJscZcZJ31nvYXZfegVGc/PAgTD2786xByRyLo=
Date: Wed, 05 Mar 2025 21:37:21 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,mhocko@suse.com,linmiaohe@huawei.com,david@redhat.com,mawupeng1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] hwpoison-memory_hotplug-lock-folio-before-unmap-hwpoisoned-folio.patch removed from -mm tree
Message-Id: <20250306053722.65B2AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hwpoison, memory_hotplug: lock folio before unmap hwpoisoned folio
has been removed from the -mm tree.  Its filename was
     hwpoison-memory_hotplug-lock-folio-before-unmap-hwpoisoned-folio.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ma Wupeng <mawupeng1@huawei.com>
Subject: hwpoison, memory_hotplug: lock folio before unmap hwpoisoned folio
Date: Mon, 17 Feb 2025 09:43:29 +0800

Commit b15c87263a69 ("hwpoison, memory_hotplug: allow hwpoisoned pages to
be offlined) add page poison checks in do_migrate_range in order to make
offline hwpoisoned page possible by introducing isolate_lru_page and
try_to_unmap for hwpoisoned page.  However folio lock must be held before
calling try_to_unmap.  Add it to fix this problem.

Warning will be produced if folio is not locked during unmap:

  ------------[ cut here ]------------
  kernel BUG at ./include/linux/swapops.h:400!
  Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
  Modules linked in:
  CPU: 4 UID: 0 PID: 411 Comm: bash Tainted: G        W          6.13.0-rc1-00016-g3c434c7ee82a-dirty #41
  Tainted: [W]=WARN
  Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
  pstate: 40400005 (nZcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : try_to_unmap_one+0xb08/0xd3c
  lr : try_to_unmap_one+0x3dc/0xd3c
  Call trace:
   try_to_unmap_one+0xb08/0xd3c (P)
   try_to_unmap_one+0x3dc/0xd3c (L)
   rmap_walk_anon+0xdc/0x1f8
   rmap_walk+0x3c/0x58
   try_to_unmap+0x88/0x90
   unmap_poisoned_folio+0x30/0xa8
   do_migrate_range+0x4a0/0x568
   offline_pages+0x5a4/0x670
   memory_block_action+0x17c/0x374
   memory_subsys_offline+0x3c/0x78
   device_offline+0xa4/0xd0
   state_store+0x8c/0xf0
   dev_attr_store+0x18/0x2c
   sysfs_kf_write+0x44/0x54
   kernfs_fop_write_iter+0x118/0x1a8
   vfs_write+0x3a8/0x4bc
   ksys_write+0x6c/0xf8
   __arm64_sys_write+0x1c/0x28
   invoke_syscall+0x44/0x100
   el0_svc_common.constprop.0+0x40/0xe0
   do_el0_svc+0x1c/0x28
   el0_svc+0x30/0xd0
   el0t_64_sync_handler+0xc8/0xcc
   el0t_64_sync+0x198/0x19c
  Code: f9407be0 b5fff320 d4210000 17ffff97 (d4210000)
  ---[ end trace 0000000000000000 ]---

Link: https://lkml.kernel.org/r/20250217014329.3610326-4-mawupeng1@huawei.com
Fixes: b15c87263a69 ("hwpoison, memory_hotplug: allow hwpoisoned pages to be offlined")
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~hwpoison-memory_hotplug-lock-folio-before-unmap-hwpoisoned-folio
+++ a/mm/memory_hotplug.c
@@ -1832,8 +1832,11 @@ static void do_migrate_range(unsigned lo
 		    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio))) {
 			if (WARN_ON(folio_test_lru(folio)))
 				folio_isolate_lru(folio);
-			if (folio_mapped(folio))
+			if (folio_mapped(folio)) {
+				folio_lock(folio);
 				unmap_poisoned_folio(folio, pfn, false);
+				folio_unlock(folio);
+			}
 
 			goto put_folio;
 		}
_

Patches currently in -mm which might be from mawupeng1@huawei.com are


