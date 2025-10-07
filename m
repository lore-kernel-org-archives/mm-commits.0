Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5B8170A11;
	Tue,  7 Oct 2025 21:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759870908; cv=none; b=WEQ4/FtTaGFfg0DdO4FTuxvA3uvwBdfF+ilUd+x5CHqei/EmLZt3sWh1+6fiLvKdg1fTHcliSrGKINsSjKgJRVNAfSe7ymGeIcWcf4P1SyhijZkEhKUw2OwodPIh3Q/PXTaQ1kFBD7HfZb5LUYbgUUWNI03D+4gAwn7rXSn5A0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759870908; c=relaxed/simple;
	bh=x+J9eQYLlkTzqNpL7AHnho/40dEdQZdEafRMKtT40XY=;
	h=Date:To:From:Subject:Message-Id; b=t7bR6WyHHxWtPuC5QD3xw5EWHWAImrWcvBDFwZZreyrxZk0NKe0Sy80i0gpi15Zk2WdUi6hU6TpZxzb2PlJzNZRjx3Gj3QxlYTt1cvvaG3S/JBkUsxyuaijHytfSgPZoQNEIwtVnfaGA8PCluXTSLQiON18EFjG3H/sjHU4+Sw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CFni1JTR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CFni1JTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7B2C4CEF1;
	Tue,  7 Oct 2025 21:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759870906;
	bh=x+J9eQYLlkTzqNpL7AHnho/40dEdQZdEafRMKtT40XY=;
	h=Date:To:From:Subject:From;
	b=CFni1JTRH9Qe7ZVw4t2bbI8ALSz1Pa1KDhKQaQkvUMupXMi12KQabpWJIA3l4Tpz8
	 jiMP/esVPHWLc2R7Pv68KIVlwvZQxxfJFdVXI8KksmWgI8K1hxVvOyro/URW6AQBgL
	 xi9fInhpTpUCYNudW/fTiI7AqMcEys0oS/EtyXD0=
Date: Tue, 07 Oct 2025 14:01:45 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,dev.jain@arm.com,david@redhat.com,cl@gentwo.org,catalin.marinas@arm.com,carl@os.amperecomputing.com,anshuman.khandual@arm.com,yang@os.amperecomputing.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-avoid-soft-lockup-when-mprotect-to-large-memory-area.patch removed from -mm tree
Message-Id: <20251007210146.7D7B2C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb: avoid soft lockup when mprotect to large memory area
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-avoid-soft-lockup-when-mprotect-to-large-memory-area.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Shi <yang@os.amperecomputing.com>
Subject: mm: hugetlb: avoid soft lockup when mprotect to large memory area
Date: Mon, 29 Sep 2025 13:24:02 -0700

When calling mprotect() to a large hugetlb memory area in our customer's
workload (~300GB hugetlb memory), soft lockup was observed:

watchdog: BUG: soft lockup - CPU#98 stuck for 23s! [t2_new_sysv:126916]

CPU: 98 PID: 126916 Comm: t2_new_sysv Kdump: loaded Not tainted 6.17-rc7
Hardware name: GIGACOMPUTING R2A3-T40-AAV1/Jefferson CIO, BIOS 5.4.4.1 07/15/2025
pstate: 20400009 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : mte_clear_page_tags+0x14/0x24
lr : mte_sync_tags+0x1c0/0x240
sp : ffff80003150bb80
x29: ffff80003150bb80 x28: ffff00739e9705a8 x27: 0000ffd2d6a00000
x26: 0000ff8e4bc00000 x25: 00e80046cde00f45 x24: 0000000000022458
x23: 0000000000000000 x22: 0000000000000004 x21: 000000011b380000
x20: ffff000000000000 x19: 000000011b379f40 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
x11: 0000000000000000 x10: 0000000000000000 x9 : ffffc875e0aa5e2c
x8 : 0000000000000000 x7 : 0000000000000000 x6 : 0000000000000000
x5 : fffffc01ce7a5c00 x4 : 00000000046cde00 x3 : fffffc0000000000
x2 : 0000000000000004 x1 : 0000000000000040 x0 : ffff0046cde7c000

Call trace:
  mte_clear_page_tags+0x14/0x24
  set_huge_pte_at+0x25c/0x280
  hugetlb_change_protection+0x220/0x430
  change_protection+0x5c/0x8c
  mprotect_fixup+0x10c/0x294
  do_mprotect_pkey.constprop.0+0x2e0/0x3d4
  __arm64_sys_mprotect+0x24/0x44
  invoke_syscall+0x50/0x160
  el0_svc_common+0x48/0x144
  do_el0_svc+0x30/0xe0
  el0_svc+0x30/0xf0
  el0t_64_sync_handler+0xc4/0x148
  el0t_64_sync+0x1a4/0x1a8

Soft lockup is not triggered with THP or base page because there is
cond_resched() called for each PMD size.

Although the soft lockup was triggered by MTE, it should be not MTE
specific.  The other processing which takes long time in the loop may
trigger soft lockup too.

So add cond_resched() for hugetlb to avoid soft lockup.

Link: https://lkml.kernel.org/r/20250929202402.1663290-1-yang@os.amperecomputing.com
Fixes: 8f860591ffb2 ("[PATCH] Enable mprotect on huge pages")
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
Tested-by: Carl Worth <carl@os.amperecomputing.com>
Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-avoid-soft-lockup-when-mprotect-to-large-memory-area
+++ a/mm/hugetlb.c
@@ -7222,6 +7222,8 @@ long hugetlb_change_protection(struct vm
 						psize);
 		}
 		spin_unlock(ptl);
+
+		cond_resched();
 	}
 	/*
 	 * Must flush TLB before releasing i_mmap_rwsem: x86's huge_pmd_unshare
_

Patches currently in -mm which might be from yang@os.amperecomputing.com are


