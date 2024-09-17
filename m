Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8596136337
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560263; cv=none; b=liMYqX/rL0D8IVKg+ErtiqnbGymUuwxc68p6j8J3BjVJd7qgtaByjKWmL/IdlpS7Lo1bECAed81jLZq3q5v55eTU1t5vC4CsVf05Ov7GGKx4JCADEGU95bu/1ekdofmSsG80JfWeDAy0PCsFMXdaCv3+TBtZHThNjHudPbwZZ/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560263; c=relaxed/simple;
	bh=ZvbxQTZxEWJOf+blPfpwnAcyvIlzj5e1VX4c9JOiUxA=;
	h=Date:To:From:Subject:Message-Id; b=tQeSN6fRamFi9dPmCHMt0D9z6n4exPEQv/u7OxwDQKoz6LlAAKgZNsCl4A9cTMRwQqfvcMurfgIvjFNM47ZJ/IbIkq4TzqN3fNVAol/KuHPma/jjNO/j5VYjZ1DT8khJx21SG4nY6YpJkXvBM3OSSA2NyLz5rr5pV5ECr09KcPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eP8Oc3u3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eP8Oc3u3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C232EC4CEC6;
	Tue, 17 Sep 2024 08:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560263;
	bh=ZvbxQTZxEWJOf+blPfpwnAcyvIlzj5e1VX4c9JOiUxA=;
	h=Date:To:From:Subject:From;
	b=eP8Oc3u3Ki53T5vw0bb6sJC1vYY4OCatmRWtFLNgxKUq4JKtGSvw6zD7f6hncHFWx
	 8CsukTIc/0ewnySmxLWq2kZp2Ur/1NMSxwFFIp6l+4Wn+jI1V55CSmuCH7H/iH3OXI
	 7Z85nLxTTM1rNhBDLpKdM/LuX/pwhtNakPZSfzC4=
Date: Tue, 17 Sep 2024 01:04:20 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jiaqiyan@google.com,jane.chu@oracle.com,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-support-poison-recovery-from-do_cow_fault-fix.patch removed from -mm tree
Message-Id: <20240917080422.C232EC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: support poison recovery from do_cow_fault() fix
has been removed from the -mm tree.  Its filename was
     mm-support-poison-recovery-from-do_cow_fault-fix.patch

This patch was dropped because it was folded into mm-support-poison-recovery-from-do_cow_fault.patch

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
@@ -5089,11 +5089,12 @@ static vm_fault_t do_cow_fault(struct vm
 
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
mm-support-poison-recovery-from-copy_present_page.patch

