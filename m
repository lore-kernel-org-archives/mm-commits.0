Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365D3A31
	for <mm-commits@vger.kernel.org>; Sun,  8 Sep 2024 04:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725769281; cv=none; b=B95mA3nyTmRWv+QiCEi3ftUiy6B3dzGFcrRfIV4fk5YiOr6l7fcBa9Au7MXXEXKBTNUEGAvMBzgSFGiG/qB9CUkHrN8YJ6LtTONdPXye+vivncwmmlh5HgduGha7/aOplyEZcptt8PB9X1Ge+DrBOhPOYh4u7GhMgjqw++tXwNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725769281; c=relaxed/simple;
	bh=dXnw4y24yM3u0I8O8CMCcTNHiukMAOpwYGh1gKhjMRU=;
	h=Date:To:From:Subject:Message-Id; b=LoHTCJUVhRpD009isjco2lC6twsbPmf71XpCPXO7fnWZyvgeYYk/i0TJ1eoN8XhDNOyK/cc2Wnl1oMP+7mmxR0RrPkFX9dcWQBLaZoG2GtWznzuVay/h+Jccezy96sChYcu/FTPS4mzApR6Jt206q1KkrG4hVm5wId26e90sakQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xfOgW11B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xfOgW11B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9980DC4CEC3;
	Sun,  8 Sep 2024 04:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725769280;
	bh=dXnw4y24yM3u0I8O8CMCcTNHiukMAOpwYGh1gKhjMRU=;
	h=Date:To:From:Subject:From;
	b=xfOgW11BTKlEcxJsFj/ovCM2FTfSJ2VMVl//pQAk6ISY1x18t3NfS2GgQUg+tAZMI
	 IqbtymeZE217z+Z3j7Ir7mjcK8MNyEi9qBmFDYL48mxANct7xrCAergiIsUfd4nsV7
	 TOxOlunW7n4R9NlaMrqVKOZveBS/qL/Xd68N9RwI=
Date: Sat, 07 Sep 2024 21:21:20 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jiaqiyan@google.com,jane.chu@oracle.com,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-support-poison-recovery-from-do_cow_fault.patch added to mm-unstable branch
Message-Id: <20240908042120.9980DC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: support poison recovery from do_cow_fault()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-support-poison-recovery-from-do_cow_fault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-support-poison-recovery-from-do_cow_fault.patch

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

Link: https://lkml.kernel.org/r/20240906024201.1214712-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20240906024201.1214712-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-support-poison-recovery-from-do_cow_fault
+++ a/mm/memory.c
@@ -5089,7 +5089,10 @@ static vm_fault_t do_cow_fault(struct vm
 	if (ret & VM_FAULT_DONE_COW)
 		return ret;
 
-	copy_user_highpage(vmf->cow_page, vmf->page, vmf->address, vma);
+	if (copy_mc_user_highpage(vmf->cow_page, vmf->page, vmf->address, vma)) {
+		ret = VM_FAULT_HWPOISON;
+		goto uncharge_out;
+	}
 	__folio_mark_uptodate(folio);
 
 	ret |= finish_fault(vmf);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-migrate_device-convert-to-migrate_device_coherent_folio.patch
mm-migrate_device-use-a-folio-in-migrate_device_range.patch
mm-migrate_device-use-more-folio-in-migrate_device_unmap.patch
mm-migrate_device-use-more-folio-in-migrate_device_finalize.patch
mm-remove-isolate_lru_page.patch
mm-remove-isolate_lru_page-fix.patch
mm-remove-putback_lru_page.patch
mm-migrate-remove-unused-includes.patch
mm-support-poison-recovery-from-do_cow_fault.patch
mm-support-poison-recovery-from-copy_present_page.patch

