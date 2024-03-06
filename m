Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1500E175AD
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759115; cv=none; b=eATFM2Hdqt8sw6RHqJs1xtAIpF/Yi8/MbtWw6GfNhROWr9bDrjepK9pUEF/su0g6CBwTat8mob729YE3fK8BQ8lmZhA4byf/+RdDtCYSW1s97UjbrWqwFOPOvrTUj/C/FLjIYzLJIBzdq5sdKxCVgym2NroQZH7IbbvPafpp5cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759115; c=relaxed/simple;
	bh=n9yWgq4MOLch6xMrYzSf4FY22cs1K/rZVe+IB+06pqo=;
	h=Date:To:From:Subject:Message-Id; b=BAqdYOQ3m3nNweKCdS09di1RxHXglKzzplRnGJG7Fj+nL+0jgKS499Sr4uG0fJPZEe9DIwz3+PquxmOgDNG/BIHiPxOHsn33jGGlZI/pe72PIxjq5iro8hKkBECovhHfG2ApZ//W8VcT+vZsQjvIXOzzgs3gvSJPPJ66LZOGggY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FhNdQ0sd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FhNdQ0sd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8AFC43390;
	Wed,  6 Mar 2024 21:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759114;
	bh=n9yWgq4MOLch6xMrYzSf4FY22cs1K/rZVe+IB+06pqo=;
	h=Date:To:From:Subject:From;
	b=FhNdQ0sdD/smoH0hGGv4lTZb65sjcIDJD6KBKyB0JOr6p0tacvQXF4QZBIUfrKP64
	 pMAdRGCWZYXdCAtJ5XGBZWuNv3pq2Y3UR5WFzWuu/VVODUeN3H+wC21PYlgnYNuOlh
	 QGeI0db32lZzYurXJ4Iq8FNdtVHe6DLf05hlbmPw=
Date: Wed, 06 Mar 2024 13:05:14 -0800
To: mm-commits@vger.kernel.org,samsun1006219@gmail.com,lstoakes@gmail.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-fix-shift-out-of-bounds-in-fault_around_bytes_set.patch removed from -mm tree
Message-Id: <20240306210514.DA8AFC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memory: fix shift-out-of-bounds in fault_around_bytes_set
has been removed from the -mm tree.  Its filename was
     mm-memory-fix-shift-out-of-bounds-in-fault_around_bytes_set.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: fix shift-out-of-bounds in fault_around_bytes_set
Date: Sat, 2 Mar 2024 14:43:12 +0800

The rounddown_pow_of_two(0) is undefined, so val = 0 is not allowed in the
fault_around_bytes_set(), and leads to shift-out-of-bounds,

UBSAN: shift-out-of-bounds in include/linux/log2.h:67:13
shift exponent 4294967295 is too large for 64-bit type 'long unsigned int'
CPU: 7 PID: 107 Comm: sh Not tainted 6.8.0-rc6-next-20240301 #294
Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
Call trace:
 dump_backtrace+0x94/0xec
 show_stack+0x18/0x24
 dump_stack_lvl+0x78/0x90
 dump_stack+0x18/0x24
 ubsan_epilogue+0x10/0x44
 __ubsan_handle_shift_out_of_bounds+0x98/0x134
 fault_around_bytes_set+0xa4/0xb0
 simple_attr_write_xsigned.isra.0+0xe4/0x1ac
 simple_attr_write+0x18/0x24
 debugfs_attr_write+0x4c/0x98
 vfs_write+0xd0/0x4b0
 ksys_write+0x6c/0xfc
 __arm64_sys_write+0x1c/0x28
 invoke_syscall+0x44/0x104
 el0_svc_common.constprop.0+0x40/0xe0
 do_el0_svc+0x1c/0x28
 el0_svc+0x34/0xdc
 el0t_64_sync_handler+0xc0/0xc4
 el0t_64_sync+0x190/0x194
---[ end trace ]---

Fix it by setting the minimum val to PAGE_SIZE.

Link: https://lkml.kernel.org/r/20240302064312.2358924-1-wangkefeng.wang@huawei.com
Fixes: 53d36a56d8c4 ("mm: prefer fault_around_pages to fault_around_bytes")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reported-by: Yue Sun <samsun1006219@gmail.com>
Closes: https://lore.kernel.org/all/CAEkJfYPim6DQqW1GqCiHLdh2-eweqk1fGyXqs3JM+8e1qGge8w@mail.gmail.com/
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-fix-shift-out-of-bounds-in-fault_around_bytes_set
+++ a/mm/memory.c
@@ -4776,7 +4776,8 @@ static int fault_around_bytes_set(void *
 	 * The minimum value is 1 page, however this results in no fault-around
 	 * at all. See should_fault_around().
 	 */
-	fault_around_pages = max(rounddown_pow_of_two(val) >> PAGE_SHIFT, 1UL);
+	val = max(val, PAGE_SIZE);
+	fault_around_pages = rounddown_pow_of_two(val) >> PAGE_SHIFT;
 
 	return 0;
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


