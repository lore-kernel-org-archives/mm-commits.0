Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BB52F0C78;
	Mon, 22 Sep 2025 22:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758578824; cv=none; b=rhFijZeLxIrWeUqXfDUDWoLhizcqclPBE2Me5FfDj6mLa/BWAF22XMrLUPAcTwJDZH/WKSON3HqTEvPbSbavL9kCNIwulKR/UVXDmVNvGo470iC5Elizy4AylD1StzCiZzwsZ49WDjg8xGglo5aK2ySZ+KiMP7W/UgO/O1FhFw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758578824; c=relaxed/simple;
	bh=hi+17J+o2mONkoE3CGSvOksR/o9zi2ueZLj6pvXsxTE=;
	h=Date:To:From:Subject:Message-Id; b=RZqzJgbE4TsYBVkMr9RJlmAC2pecJ/MSGh9GG3GvPBoxhMy5ijHkO/KA6AZZi2MClmnz6ruyih0fuu6RCEV9gj/XSwBVIlrP99eAgmY4hiil+PNsQWE2CVlSkMPB1ZiBEfq7W/rtClI+dqR14IWKjeSovUgVt1mhDVdwmw5ebrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GpKsQtwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GpKsQtwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1342C4CEF0;
	Mon, 22 Sep 2025 22:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758578821;
	bh=hi+17J+o2mONkoE3CGSvOksR/o9zi2ueZLj6pvXsxTE=;
	h=Date:To:From:Subject:From;
	b=GpKsQtwjwPMSEuatt0SNybb/nU3UWtyhLXNpRIOdeJaTLvnFKZnyqs/PRSiq5iQI+
	 WuFAJYmPxlcR8IHMM9AshehB4bJnMuJqxQqoQ/5IIvuU8UETEcOGiGDoxgvXVSYdXz
	 R2styw1Dnc8fiIKuAvoCAH+WllhhkxW3Dr26BheQ=
Date: Mon, 22 Sep 2025 15:07:00 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,usama.anjum@collabora.com,tujinjiang@huawei.com,surenb@google.com,superman.xpt@gmail.com,stable@vger.kernel.org,sfr@canb.auug.org.au,ryan.roberts@arm.com,mirq-linux@rere.qmqm.pl,lorenzo.stoakes@oracle.com,david@redhat.com,broonie@kernel.org,baolin.wang@linux.alibaba.com,avagin@gmail.com,acsjakub@amazon.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-check-p-vec_buf-for-null.patch added to mm-hotfixes-unstable branch
Message-Id: <20250922220700.E1342C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: check p->vec_buf for NULL
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-task_mmu-check-p-vec_buf-for-null.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-check-p-vec_buf-for-null.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Jakub Acs <acsjakub@amazon.de>
Subject: fs/proc/task_mmu: check p->vec_buf for NULL
Date: Mon, 22 Sep 2025 08:22:05 +0000

When the PAGEMAP_SCAN ioctl is invoked with vec_len = 0 reaches
pagemap_scan_backout_range(), kernel panics with null-ptr-deref:

[   44.936808] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN NOPTI
[   44.937797] KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
[   44.938391] CPU: 1 UID: 0 PID: 2480 Comm: reproducer Not tainted 6.17.0-rc6 #22 PREEMPT(none)
[   44.939062] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[   44.939935] RIP: 0010:pagemap_scan_thp_entry.isra.0+0x741/0xa80

<snip registers, unreliable trace>

[   44.946828] Call Trace:
[   44.947030]  <TASK>
[   44.949219]  pagemap_scan_pmd_entry+0xec/0xfa0
[   44.952593]  walk_pmd_range.isra.0+0x302/0x910
[   44.954069]  walk_pud_range.isra.0+0x419/0x790
[   44.954427]  walk_p4d_range+0x41e/0x620
[   44.954743]  walk_pgd_range+0x31e/0x630
[   44.955057]  __walk_page_range+0x160/0x670
[   44.956883]  walk_page_range_mm+0x408/0x980
[   44.958677]  walk_page_range+0x66/0x90
[   44.958984]  do_pagemap_scan+0x28d/0x9c0
[   44.961833]  do_pagemap_cmd+0x59/0x80
[   44.962484]  __x64_sys_ioctl+0x18d/0x210
[   44.962804]  do_syscall_64+0x5b/0x290
[   44.963111]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

vec_len = 0 in pagemap_scan_init_bounce_buffer() means no buffers are
allocated and p->vec_buf remains set to NULL.

This breaks an assumption made later in pagemap_scan_backout_range(), that
page_region is always allocated for p->vec_buf_index.

Fix it by explicitly checking p->vec_buf for NULL before dereferencing.

Other sites that might run into same deref-issue are already (directly or
transitively) protected by checking p->vec_buf.

Note:
From PAGEMAP_SCAN man page, it seems vec_len = 0 is valid when no output
is requested and it's only the side effects caller is interested in,
hence it passes check in pagemap_scan_get_args().

This issue was found by syzkaller.

Link: https://lkml.kernel.org/r/20250922082206.6889-1-acsjakub@amazon.de
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Jakub Acs <acsjakub@amazon.de>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Penglei Jiang <superman.xpt@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: "Michał Mirosław" <mirq-linux@rere.qmqm.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-check-p-vec_buf-for-null
+++ a/fs/proc/task_mmu.c
@@ -2417,6 +2417,9 @@ static void pagemap_scan_backout_range(s
 {
 	struct page_region *cur_buf = &p->vec_buf[p->vec_buf_index];
 
+	if (!p->vec_buf)
+		return;
+
 	if (cur_buf->start != addr)
 		cur_buf->end = addr;
 	else
_

Patches currently in -mm which might be from acsjakub@amazon.de are

fs-proc-task_mmu-check-p-vec_buf-for-null.patch

