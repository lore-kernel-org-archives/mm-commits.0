Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED6E152E0C
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560536; cv=none; b=LQu39pe/K7mQ5HNT6DGEyfa/K9tfHnZ+D9ylND/r+W7RUMxwNVU7lrbV++bq8CXU5RPxXAMCZSO9rnn+UbersCW0m9tBjUD8m7mjGKBCBNbNncG7Kzs8kwQ48Y5+p1XrqnY89kMOmZSBdMlqbLO405QllkOOZzNp+GvqqxgAP14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560536; c=relaxed/simple;
	bh=jSlIiPp7ECndcOcHodyg/1CBSCGO4H7P0qfXT5WI+fc=;
	h=Date:To:From:Subject:Message-Id; b=AUjaRz18Bt7DTL5sTcnV7DIzDtVLcN0sbgJ52Z0Fuqw8juLHprLrIaA5StLRJU+huJAM2cW2CLt62qfDCJC5H21LZv0FfRmAZ9Hh1lPsC2h1PENL8OhCeyvpfrMkQFPuaSmZhSn//vlOni5viLn3P+7LJbwAWqILDJQbU/ZsTwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jp6WA3Wp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jp6WA3Wp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434D9C4CEC6;
	Tue, 17 Sep 2024 08:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560536;
	bh=jSlIiPp7ECndcOcHodyg/1CBSCGO4H7P0qfXT5WI+fc=;
	h=Date:To:From:Subject:From;
	b=Jp6WA3WpjNA0qRphTJ3eLgLmFkaquTo+N3xhH2lMGhtiaEIwVDIkyiN0T0IQP+asl
	 H5yVGDTFx/JUO0YI+2HlPIxKooSlt89x+rizHKqesgLzzqZAmJsa+M/oEF5L7OU6oH
	 FEJ0QKkZmlLL5KvFbgBLsWD9sGiMKa5FLQbmUiF8=
Date: Tue, 17 Sep 2024 01:08:53 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jiaqiyan@google.com,jane.chu@oracle.com,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-support-poison-recovery-from-do_cow_fault.patch removed from -mm tree
Message-Id: <20240917080856.434D9C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: support poison recovery from do_cow_fault()
has been removed from the -mm tree.  Its filename was
     mm-support-poison-recovery-from-do_cow_fault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: support poison recovery from do_cow_fault()
Date: Fri, 6 Sep 2024 10:42:00 +0800

Patch series "mm: hwpoison: two more poison recovery".

One more CoW path to support poison recorvery in do_cow_fault(), and the
last copy_user_highpage() user is replaced to copy_mc_user_highpage() from
copy_present_page() during fork to support poison recorvery too.


This patch (of 2):

Like commit a873dfe1032a ("mm, hwpoison: try to recover from copy-on
write faults"), there is another path which could crash because it does
not have recovery code where poison is consumed by the kernel in
do_cow_fault(), a crash calltrace shown below on old kernel, but it
could be happened in the lastest mainline code,

  CPU: 7 PID: 3248 Comm: mpi Kdump: loaded Tainted: G           OE     5.10.0 #1
  pc : copy_page+0xc/0xbc
  lr : copy_user_highpage+0x50/0x9c
  Call trace:
    copy_page+0xc/0xbc
    do_cow_fault+0x118/0x2bc
    do_fault+0x40/0x1a4
    handle_pte_fault+0x154/0x230
    __handle_mm_fault+0x1a8/0x38c
    handle_mm_fault+0xf0/0x250
    do_page_fault+0x184/0x454
    do_translation_fault+0xac/0xd4
    do_mem_abort+0x44/0xbc

Fix it by using copy_mc_user_highpage() to handle this case and return
VM_FAULT_HWPOISON for cow fault.

[wangkefeng.wang@huawei.com: unlock/put vmf->page, per Miaohe]
  Link: https://lkml.kernel.org/r/20240910021541.234300-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20240906024201.1214712-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20240906024201.1214712-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-support-poison-recovery-from-do_cow_fault
+++ a/mm/memory.c
@@ -5089,10 +5089,14 @@ static vm_fault_t do_cow_fault(struct vm
 	if (ret & VM_FAULT_DONE_COW)
 		return ret;
 
-	copy_user_highpage(vmf->cow_page, vmf->page, vmf->address, vma);
+	if (copy_mc_user_highpage(vmf->cow_page, vmf->page, vmf->address, vma)) {
+		ret = VM_FAULT_HWPOISON;
+		goto unlock;
+	}
 	__folio_mark_uptodate(folio);
 
 	ret |= finish_fault(vmf);
+unlock:
 	unlock_page(vmf->page);
 	put_page(vmf->page);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


