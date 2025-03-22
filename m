Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629772E3399;
	Sat, 22 Mar 2025 05:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619857; cv=none; b=NrbHXyRFzNuZhLC/HELifVu5QAcYJzmconxp04DLuHuO4ruiZW9mj2r0SN8CvoFFI+r55JDY5uwGpTA8GqhaDmwvR0gBJWjIlokpM6sj50i3o1b/ZkCOzKfIokz0TR4Y2rI434Y1RJtODcuWlywoa+gMNUzHfbcI0eDo4aqHAog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619857; c=relaxed/simple;
	bh=G1kR16i0WPBXDl4XrxJLRIBi/M4vnioh6QnO8XlAHus=;
	h=Date:To:From:Subject:Message-Id; b=Tk4DSLyusTFa9rqDu0daJXjPfYqtcBupVGTBGfB1+A0wXwtKVZ8hPnPlQVbX3HjwD8nLubJ/YMTcSALq4isYzivq6q+jDgrvEIJLsekY9ZUqkKy04BouMRs8l15g0QGwL22COdhDPiuTEwDyDLjqYcll7+x4wCucdXAcsYGZGn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v/WOnUPq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v/WOnUPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37309C4CEDD;
	Sat, 22 Mar 2025 05:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619857;
	bh=G1kR16i0WPBXDl4XrxJLRIBi/M4vnioh6QnO8XlAHus=;
	h=Date:To:From:Subject:From;
	b=v/WOnUPqTU+/aYTsbouY4szc3zCxlX3XWUARIg+9P+cy6FbWrdLOqfmoMnzmBXCLs
	 f+NF1tEGCFgcZ6/iZT+1GWqdfoiDY5EgyRcCAqswCsE099UTxNZ/MLS9EYUOtPOxRv
	 1YJgh7sDZYHOxAqJoU/aifD3+HPftp+SfcWhcV3o=
Date: Fri, 21 Mar 2025 22:04:16 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,kernel.org,stable@vger,nao.horiguchi@gmail.com,linmiaohe@huawei.com,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-dont-try-to-reclaim-hwpoison-folio.patch removed from -mm tree
Message-Id: <20250322050417.37309C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: don't try to reclaim hwpoison folio
has been removed from the -mm tree.  Its filename was
     mm-vmscan-dont-try-to-reclaim-hwpoison-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/vmscan: don't try to reclaim hwpoison folio
Date: Tue, 18 Mar 2025 16:39:39 +0800

Syzkaller reports a bug as follows:

Injecting memory failure for pfn 0x18b00e at process virtual address 0x20ffd000
Memory failure: 0x18b00e: dirty swapcache page still referenced by 2 users
Memory failure: 0x18b00e: recovery action for dirty swapcache page: Failed
page: refcount:2 mapcount:0 mapping:0000000000000000 index:0x20ffd pfn:0x18b00e
memcg:ffff0000dd6d9000
anon flags: 0x5ffffe00482011(locked|dirty|arch_1|swapbacked|hwpoison|node=0|zone=2|lastcpupid=0xfffff)
raw: 005ffffe00482011 dead000000000100 dead000000000122 ffff0000e232a7c9
raw: 0000000000020ffd 0000000000000000 00000002ffffffff ffff0000dd6d9000
page dumped because: VM_BUG_ON_FOLIO(!folio_test_uptodate(folio))
------------[ cut here ]------------
kernel BUG at mm/swap_state.c:184!
Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
Modules linked in:
CPU: 0 PID: 60 Comm: kswapd0 Not tainted 6.6.0-gcb097e7de84e #3
Hardware name: linux,dummy-virt (DT)
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : add_to_swap+0xbc/0x158
lr : add_to_swap+0xbc/0x158
sp : ffff800087f37340
x29: ffff800087f37340 x28: fffffc00052c0380 x27: ffff800087f37780
x26: ffff800087f37490 x25: ffff800087f37c78 x24: ffff800087f377a0
x23: ffff800087f37c50 x22: 0000000000000000 x21: fffffc00052c03b4
x20: 0000000000000000 x19: fffffc00052c0380 x18: 0000000000000000
x17: 296f696c6f662865 x16: 7461646f7470755f x15: 747365745f6f696c
x14: 6f6621284f494c4f x13: 0000000000000001 x12: ffff600036d8b97b
x11: 1fffe00036d8b97a x10: ffff600036d8b97a x9 : dfff800000000000
x8 : 00009fffc9274686 x7 : ffff0001b6c5cbd3 x6 : 0000000000000001
x5 : ffff0000c25896c0 x4 : 0000000000000000 x3 : 0000000000000000
x2 : 0000000000000000 x1 : ffff0000c25896c0 x0 : 0000000000000000
Call trace:
 add_to_swap+0xbc/0x158
 shrink_folio_list+0x12ac/0x2648
 shrink_inactive_list+0x318/0x948
 shrink_lruvec+0x450/0x720
 shrink_node_memcgs+0x280/0x4a8
 shrink_node+0x128/0x978
 balance_pgdat+0x4f0/0xb20
 kswapd+0x228/0x438
 kthread+0x214/0x230
 ret_from_fork+0x10/0x20

I can reproduce this issue with the following steps:

1) When a dirty swapcache page is isolated by reclaim process and the
   page isn't locked, inject memory failure for the page. 
   me_swapcache_dirty() clears uptodate flag and tries to delete from lru,
   but fails.  Reclaim process will put the hwpoisoned page back to lru.

2) The process that maps the hwpoisoned page exits, the page is deleted
   the page will never be freed and will be in the lru forever.

3) If we trigger a reclaim again and tries to reclaim the page,
   add_to_swap() will trigger VM_BUG_ON_FOLIO due to the uptodate flag is
   cleared.

To fix it, skip the hwpoisoned page in shrink_folio_list().  Besides, the
hwpoison folio may not be unmapped by hwpoison_user_mappings() yet, unmap
it in shrink_folio_list(), otherwise the folio will fail to be unmaped by
hwpoison_user_mappings() since the folio isn't in lru list.

Link: https://lkml.kernel.org/r/20250318083939.987651-3-tujinjiang@huawei.com
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: <stable@vger,kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/vmscan.c~mm-vmscan-dont-try-to-reclaim-hwpoison-folio
+++ a/mm/vmscan.c
@@ -1127,6 +1127,13 @@ retry:
 		if (!folio_trylock(folio))
 			goto keep;
 
+		if (folio_contain_hwpoisoned_page(folio)) {
+			unmap_poisoned_folio(folio, folio_pfn(folio), false);
+			folio_unlock(folio);
+			folio_put(folio);
+			continue;
+		}
+
 		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
 
 		nr_pages = folio_nr_pages(folio);
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-contig_alloc-fix-alloc_contig_range-when-__gfp_comp-and-order-max_order.patch

