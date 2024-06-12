Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7878B823AF
	for <mm-commits@vger.kernel.org>; Wed, 12 Jun 2024 19:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718218908; cv=none; b=Xz8Zl/+ioXmTSbdLmpI3NHyz0ORV6yBr2lPYn3rzrvr/CGA7XGPOyL++XW6Zj3sRMkT6DevABV++1lhfxNz/Ri73o6NOHe4RLK8cKDBPQW0Yx4bJgMXkejxkqY+myeeeYH4wwCgfzCXPv2iJQzbxrYDJ0r5xn5Fvorl1ZL+stnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718218908; c=relaxed/simple;
	bh=U+gPCQPWSW60b1YYwqzyCInIso4b34M8dzeAeWPAQQA=;
	h=Date:To:From:Subject:Message-Id; b=uZEUsuJAcdT6PudD9WwYcrDhAe2QC/kZFLWeB2JGRUjIi9D1/4LYtBMlt3DbHKWXv23b0FevSjK8nvZYgdfthpGV+EM78gBLF17IkQrDKRIEfZX8WLXyyzs89euzbTluipeAuOHsBSo8FNZvQDKD3kgOb2KLUsAHz2MUP4rWmOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h5dmXI+s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h5dmXI+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6EDC116B1;
	Wed, 12 Jun 2024 19:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718218908;
	bh=U+gPCQPWSW60b1YYwqzyCInIso4b34M8dzeAeWPAQQA=;
	h=Date:To:From:Subject:From;
	b=h5dmXI+sqOz3+VN/0toAhBnTY1SofPGm/bCAz2KhG3VrzTguRvvAhlCGPmO11xUMJ
	 wkMLiHnxVU2k9F03rMef5fGGE1ape6K9JXCREF4hdhcfYC8w2Q0KXlwa8IOb9t/xiR
	 YKFqQ+FU9TgjgSrMlwRgcZlnl2l83MSgqTzRGdHI=
Date: Wed, 12 Jun 2024 12:01:47 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-remove-obsolete-comment-in-kill_proc.patch added to mm-unstable branch
Message-Id: <20240612190148.4B6EDC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: remove obsolete comment in kill_proc()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-remove-obsolete-comment-in-kill_proc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-remove-obsolete-comment-in-kill_proc.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: remove obsolete comment in kill_proc()
Date: Wed, 12 Jun 2024 15:18:34 +0800

When user sets SIGBUS to SIG_IGN, it won't cause loop now.  For action
required mce error, SIGBUS cannot be blocked.  Also when a hwpoisoned page
is re-accessed, kill_accessing_process() will be called to kill the
process.

Link: https://lkml.kernel.org/r/20240612071835.157004-13-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-remove-obsolete-comment-in-kill_proc
+++ a/mm/memory-failure.c
@@ -354,8 +354,6 @@ static int kill_proc(struct to_kill *tk,
 		 * PF_MCE_EARLY set.
 		 * Don't use force here, it's convenient if the signal
 		 * can be temporarily blocked.
-		 * This could cause a loop when the user sets SIGBUS
-		 * to SIG_IGN, but hopefully no one will do that?
 		 */
 		ret = send_sig_mceerr(BUS_MCEERR_AO, (void __user *)tk->addr,
 				      addr_lsb, t);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-simplify-put_ref_page.patch
mm-memory-failure-remove-mf_msg_slab.patch
mm-memory-failure-add-macro-get_page_max_retry_num.patch
mm-memory-failure-save-some-page_folio-calls.patch
mm-memory-failure-remove-unneeded-empty-string.patch
mm-memory-failure-remove-confusing-initialization-to-count.patch
mm-memory-failure-dont-export-hwpoison_filter-when-config_hwpoison_inject.patch
mm-memory-failure-use-helper-macro-task_pid_nr.patch
mm-memory-failure-remove-obsolete-comment-in-unpoison_memory.patch
mm-memory-failure-move-some-function-declarations-into-internalh.patch
mm-memory-failure-fix-comment-of-get_hwpoison_page.patch
mm-memory-failure-remove-obsolete-comment-in-kill_proc.patch
mm-memory-failure-correct-comment-in-me_swapcache_dirty.patch

