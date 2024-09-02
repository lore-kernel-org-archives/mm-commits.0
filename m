Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84384A0F;
	Mon,  2 Sep 2024 00:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725238786; cv=none; b=euUIm/ovr4IuQsoezluALJr8ilgIvYv3XJMPPJTpI3x7iT2eyNUF2yAlk3N6gRl5SBHk31wDqeG5e4YFR23MwaSI8PNSuxRF0KLAk9KOFE5XsXkjNY3Kbdk0h9T8FBXHSWQ/ApC4TpQrDo9QfS3p5GYMVrWYe0gm7dp5B27juB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725238786; c=relaxed/simple;
	bh=1jn4TGDHWfYKXirAXT27VjoHje+4G/jU/u9G17bPcw4=;
	h=Date:To:From:Subject:Message-Id; b=C6+lI2t8PdnMBz6oAXZ9u6zMLHEszvDknfEy6dCoYt1cFhH/ylVUYW1T16ob3qsipulet2wZv2J8RBobs7EyXWURZ0zfWPPWxu9Poftno1ZTNpb2LnIy2S2U2ZbEZdlIDBP3qgBzy3MkJ6AYdE5jcbmu4sHaPvo0zmCwzxaZK30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BsHBOHns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BsHBOHns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7DCC4CEC3;
	Mon,  2 Sep 2024 00:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725238786;
	bh=1jn4TGDHWfYKXirAXT27VjoHje+4G/jU/u9G17bPcw4=;
	h=Date:To:From:Subject:From;
	b=BsHBOHnssm+t5ja13LbdXH9zpd4tkkNmnzkkypSVhz9wjsUv7npNg7/BQMhgLWA/4
	 P5uKelCGwGVvLlPzhpL5EtP1Sguje63tg3U45F++v+u/mNmEwOAmXdR8CMJAGX4JL1
	 3D4zUKgTSgIDtfUPYaHC47oQ9raZOPysZHzfj5Kg=
Date: Sun, 01 Sep 2024 17:59:46 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,pasha.tatashin@soleen.com,nao.horiguchi@gmail.com,linmiaohe@huawei.com,kent.overstreet@linux.dev,david@redhat.com,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] codetag-debug-mark-codetags-for-poisoned-page-as-empty.patch removed from -mm tree
Message-Id: <20240902005946.9D7DCC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: codetag: debug: mark codetags for poisoned page as empty
has been removed from the -mm tree.  Its filename was
     codetag-debug-mark-codetags-for-poisoned-page-as-empty.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Ge <gehao@kylinos.cn>
Subject: codetag: debug: mark codetags for poisoned page as empty
Date: Mon, 26 Aug 2024 00:36:49 +0800

When PG_hwpoison pages are freed they are treated differently in
free_pages_prepare() and instead of being released they are isolated.

Page allocation tag counters are decremented at this point since the page
is considered not in use.  Later on when such pages are released by
unpoison_memory(), the allocation tag counters will be decremented again
and the following warning gets reported:

[  113.930443][ T3282] ------------[ cut here ]------------
[  113.931105][ T3282] alloc_tag was not set
[  113.931576][ T3282] WARNING: CPU: 2 PID: 3282 at ./include/linux/alloc_tag.h:130 pgalloc_tag_sub.part.66+0x154/0x164
[  113.932866][ T3282] Modules linked in: hwpoison_inject fuse ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ebtable_nat ebtable_broute ip6table_nat ip6table_man4
[  113.941638][ T3282] CPU: 2 UID: 0 PID: 3282 Comm: madvise11 Kdump: loaded Tainted: G        W          6.11.0-rc4-dirty #18
[  113.943003][ T3282] Tainted: [W]=WARN
[  113.943453][ T3282] Hardware name: QEMU KVM Virtual Machine, BIOS unknown 2/2/2022
[  113.944378][ T3282] pstate: 40400005 (nZcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  113.945319][ T3282] pc : pgalloc_tag_sub.part.66+0x154/0x164
[  113.946016][ T3282] lr : pgalloc_tag_sub.part.66+0x154/0x164
[  113.946706][ T3282] sp : ffff800087093a10
[  113.947197][ T3282] x29: ffff800087093a10 x28: ffff0000d7a9d400 x27: ffff80008249f0a0
[  113.948165][ T3282] x26: 0000000000000000 x25: ffff80008249f2b0 x24: 0000000000000000
[  113.949134][ T3282] x23: 0000000000000001 x22: 0000000000000001 x21: 0000000000000000
[  113.950597][ T3282] x20: ffff0000c08fcad8 x19: ffff80008251e000 x18: ffffffffffffffff
[  113.952207][ T3282] x17: 0000000000000000 x16: 0000000000000000 x15: ffff800081746210
[  113.953161][ T3282] x14: 0000000000000000 x13: 205d323832335420 x12: 5b5d353031313339
[  113.954120][ T3282] x11: ffff800087093500 x10: 000000000000005d x9 : 00000000ffffffd0
[  113.955078][ T3282] x8 : 7f7f7f7f7f7f7f7f x7 : ffff80008236ba90 x6 : c0000000ffff7fff
[  113.956036][ T3282] x5 : ffff000b34bf4dc8 x4 : ffff8000820aba90 x3 : 0000000000000001
[  113.956994][ T3282] x2 : ffff800ab320f000 x1 : 841d1e35ac932e00 x0 : 0000000000000000
[  113.957962][ T3282] Call trace:
[  113.958350][ T3282]  pgalloc_tag_sub.part.66+0x154/0x164
[  113.959000][ T3282]  pgalloc_tag_sub+0x14/0x1c
[  113.959539][ T3282]  free_unref_page+0xf4/0x4b8
[  113.960096][ T3282]  __folio_put+0xd4/0x120
[  113.960614][ T3282]  folio_put+0x24/0x50
[  113.961103][ T3282]  unpoison_memory+0x4f0/0x5b0
[  113.961678][ T3282]  hwpoison_unpoison+0x30/0x48 [hwpoison_inject]
[  113.962436][ T3282]  simple_attr_write_xsigned.isra.34+0xec/0x1cc
[  113.963183][ T3282]  simple_attr_write+0x38/0x48
[  113.963750][ T3282]  debugfs_attr_write+0x54/0x80
[  113.964330][ T3282]  full_proxy_write+0x68/0x98
[  113.964880][ T3282]  vfs_write+0xdc/0x4d0
[  113.965372][ T3282]  ksys_write+0x78/0x100
[  113.965875][ T3282]  __arm64_sys_write+0x24/0x30
[  113.966440][ T3282]  invoke_syscall+0x7c/0x104
[  113.966984][ T3282]  el0_svc_common.constprop.1+0x88/0x104
[  113.967652][ T3282]  do_el0_svc+0x2c/0x38
[  113.968893][ T3282]  el0_svc+0x3c/0x1b8
[  113.969379][ T3282]  el0t_64_sync_handler+0x98/0xbc
[  113.969980][ T3282]  el0t_64_sync+0x19c/0x1a0
[  113.970511][ T3282] ---[ end trace 0000000000000000 ]---

To fix this, clear the page tag reference after the page got isolated
and accounted for.

Link: https://lkml.kernel.org/r/20240825163649.33294-1-hao.ge@linux.dev
Fixes: d224eb0287fb ("codetag: debug: mark codetags for reserved pages as empty")
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hao Ge <gehao@kylinos.cn>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: <stable@vger.kernel.org>	[6.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/page_alloc.c~codetag-debug-mark-codetags-for-poisoned-page-as-empty
+++ a/mm/page_alloc.c
@@ -1054,6 +1054,13 @@ __always_inline bool free_pages_prepare(
 		reset_page_owner(page, order);
 		page_table_check_free(page, order);
 		pgalloc_tag_sub(page, 1 << order);
+
+		/*
+		 * The page is isolated and accounted for.
+		 * Mark the codetag as empty to avoid accounting error
+		 * when the page is freed by unpoison_memory().
+		 */
+		clear_page_tag_ref(page);
 		return false;
 	}
 
_

Patches currently in -mm which might be from gehao@kylinos.cn are

mm-cma-change-the-addition-of-totalcma_pages-in-the-cma_init_reserved_mem.patch

