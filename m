Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D827314533C
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291717; cv=none; b=Q9Hnv+iWnWCylh11FmQEjJ6owk+ZHgmfvHgM/x+nNOAQruIDj0hbryKbQveqPpgDhyfImSQ7wTXEBJgtKCH7Akx6bGAteG6ORfc0isZ4oBqQ2Dbs6C8V1H4ErJrFfOe90gMvEB3V9cbX38uzesutpMkpFMMS87Yw4UpQtXwgd5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291717; c=relaxed/simple;
	bh=1tdp5jINaRiPq3vDeQOgK0ApzZvQIMqDNRtkPIrb5eA=;
	h=Date:To:From:Subject:Message-Id; b=kJPUuxeYZ7wa4IxVt9tEfjP3k7v3IvmK0Pnqv4Z9rWoM7gGEWBi4FFjML+qzQcyppvQJ6MxF35NOOqEed6SwjFzFwluCddNL1t6gcBQrViGEi29eYV4MaEmYMeanfcL2u0Wtt9i/b68bc9Oe3Jhssg4gnWlcf/kYWdn8YLqxQP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2hV5OO/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2hV5OO/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF98C32782;
	Tue, 25 Jun 2024 05:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291717;
	bh=1tdp5jINaRiPq3vDeQOgK0ApzZvQIMqDNRtkPIrb5eA=;
	h=Date:To:From:Subject:From;
	b=2hV5OO/M2KiQ5McC3URj2Ji4LmM3nvgo9/haj8vjuux61GwEwk0F2YdMiK+6UMnuF
	 wNj14aC6Mah5tDMadX9/crxifkRCZe8VpQ3y+XPmpI1oFPTyFsSkZkNHhib5QXEteq
	 ijZDoas1MlUDe3mTyb6+HMQP/Ya0zo3wmSEAydaQ=
Date: Mon, 24 Jun 2024 22:01:57 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-remove-obsolete-comment-in-kill_proc.patch removed from -mm tree
Message-Id: <20240625050157.AEF98C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: remove obsolete comment in kill_proc()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-remove-obsolete-comment-in-kill_proc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


