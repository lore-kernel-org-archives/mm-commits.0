Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6C8195B1A
	for <mm-commits@vger.kernel.org>; Tue, 10 Sep 2024 19:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725995099; cv=none; b=uHmDNBSsL7SxdqlRou28JasB3DmWyGFUha4V+EQtbKtHVF2nbHGIcBtIB8aK/EVsxxXcP4WZcT0WIPBfj2xkLpPnDl2moodz9gperXmRuVMY/cheThZgfCbecyqYVBKAjMnF5siC9E1xCVie+hb8k8uBp8UQdrNdhx3dYswBxrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725995099; c=relaxed/simple;
	bh=1JF3wWlsGe+HGqqjiXCdhBHutusjybjC/vTSQHUth2Q=;
	h=Date:To:From:Subject:Message-Id; b=Vc+atsSe7fajPhHJvONFsbmV9hLte//FY6hOUhSBsfFuoMEOo5j5N+9GgvaKxs88DBIuKmLqaejT0m8qwNtg83gFxl+DTrN9ZzF1uX74uje4/iC/HrMxVsG4/RQ1WFi4C4Rl+j7TeNjEItW8f6P21F6cmHDQKD8608xTZU9s+IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jHKzQ7EI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jHKzQ7EI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFD5C4CECD;
	Tue, 10 Sep 2024 19:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725995098;
	bh=1JF3wWlsGe+HGqqjiXCdhBHutusjybjC/vTSQHUth2Q=;
	h=Date:To:From:Subject:From;
	b=jHKzQ7EIn2yHxadHCcw8pGJrTcFPrhulCxlYEz8HwG1amOd5yKLWS72D1t2/Ohg7m
	 logsxz/VMQPdEh3/UzAUVITVwHngfCtMe9A2/jOp/Gtyn56+fpw5BEyrl+7I38LejV
	 TZhdAJQngghf1fwqMeL/HjOt+1YrOG48B8ee09kI=
Date: Tue, 10 Sep 2024 12:04:58 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jiaqiyan@google.com,jane.chu@oracle.com,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-support-poison-recovery-from-do_cow_fault-fix.patch added to mm-unstable branch
Message-Id: <20240910190458.BDFD5C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: support poison recovery from do_cow_fault() fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-support-poison-recovery-from-do_cow_fault-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-support-poison-recovery-from-do_cow_fault-fix.patch

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
Subject: mm: support poison recovery from do_cow_fault() fix
Date: Tue, 10 Sep 2024 10:15:41 +0800

unlock/put vmf->page, per Miaohe

Link: https://lkml.kernel.org/r/20240910021541.234300-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-support-poison-recovery-from-do_cow_fault-fix
+++ a/mm/memory.c
@@ -5091,11 +5091,12 @@ static vm_fault_t do_cow_fault(struct vm
 
 	if (copy_mc_user_highpage(vmf->cow_page, vmf->page, vmf->address, vma)) {
 		ret = VM_FAULT_HWPOISON;
-		goto uncharge_out;
+		goto unlock;
 	}
 	__folio_mark_uptodate(folio);
 
 	ret |= finish_fault(vmf);
+unlock:
 	unlock_page(vmf->page);
 	put_page(vmf->page);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-support-poison-recovery-from-do_cow_fault.patch
mm-support-poison-recovery-from-do_cow_fault-fix.patch
mm-support-poison-recovery-from-copy_present_page.patch

