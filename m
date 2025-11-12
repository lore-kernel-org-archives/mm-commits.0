Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0233B1C84BC
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 20:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762979143; cv=none; b=QZbk8cDF/+1v0NCYmVPMAzMHrTNPv9vbSeAnoVzOpzuE/n4mqT1sFJCdB/U+sDwgqpl8L2Kh2eaqnpYXTeXkfMKWq9C6oEx7soViEBhJ7BWOB/KNWLzNpvSZGRjyTAaM7JD5D80yw5kBOKneRQaZbNruoSLnCgoppESK4cthPYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762979143; c=relaxed/simple;
	bh=Ja0j8wnfsy3nCFdWq0wchJm3HnsxDteadKT6L+yN4Es=;
	h=Date:To:From:Subject:Message-Id; b=OaTR5wCZJgkYzXjrx/a1nhZdGY+ZzGH+99jttXVcqrIZshUiQR0YFgYq5x2M5yOEQx+Shh2nvKL9EiU1BCA+LAYMLsw5eKx0y6Y/a23YsoUTkuHFwSnqthIRbcvvoiYITCeAitC2Bn8rxvVpHebO3tVZQ0pl+Ih/rY/ouoqqDvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qw83P0tX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qw83P0tX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504ADC4CEF8;
	Wed, 12 Nov 2025 20:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762979142;
	bh=Ja0j8wnfsy3nCFdWq0wchJm3HnsxDteadKT6L+yN4Es=;
	h=Date:To:From:Subject:From;
	b=qw83P0tXPfzPKZ8LxQG3dmkwO3gEMfwdiZWptf3rMWHSvaSLGnzOsja3xIyL80Ow8
	 CXZ69zisjj+r6TXoQkkj4I5sACb3CzcD+AsGfVUJp2FrZ5Tpc+DcU6XwW+p4CnfwbL
	 fUyfy8QJNL0ujmTCBJgpZQikTvedcuh5ChAVZWP4=
Date: Wed, 12 Nov 2025 12:25:41 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,jannh@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap_lock-reset-maple-state-on-lock_vma_under_rcu-retry.patch added to mm-hotfixes-unstable branch
Message-Id: <20251112202542.504ADC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmap_lock: reset maple state on lock_vma_under_rcu() retry
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mmap_lock-reset-maple-state-on-lock_vma_under_rcu-retry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap_lock-reset-maple-state-on-lock_vma_under_rcu-retry.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/mmap_lock: reset maple state on lock_vma_under_rcu() retry
Date: Tue, 11 Nov 2025 16:56:05 -0500

The retry in lock_vma_under_rcu() drops the rcu read lock before
reacquiring the lock and trying again.  This may cause a use-after-free if
the maple node the maple state was using was freed.

The maple state is protected by the rcu read lock.  When the lock is
dropped, the state cannot be reused as it tracks pointers to objects that
may be freed during the time where the lock was not held.

Any time the rcu read lock is dropped, the maple state must be
invalidated.  Resetting the address and state to MA_START is the safest
course of action, which will result in the next operation starting from
the top of the tree.

Prior to commit 0b16f8bed19c ("mm: change vma_start_read() to drop RCU
lock on failure"), vma_start_read() would drop rcu read lock and return
NULL, so the retry would not have happened.  However, now that
vma_start_read() drops rcu read lock on failure followed by a retry, we
may end up using a freed maple tree node cached in the maple state.

[surenb@google.com: changelog alteration]
  Link: https://lkml.kernel.org/r/CAJuCfpEWMD-Z1j=nPYHcQW4F7E2Wka09KTXzGv7VE7oW1S8hcw@mail.gmail.com
Link: https://lkml.kernel.org/r/20251111215605.1721380-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Fixes: 0b16f8bed19c ("mm: change vma_start_read() to drop RCU lock on failure")
Reported-by: syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=131f9eb2b5807573275c
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap_lock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mmap_lock.c~mm-mmap_lock-reset-maple-state-on-lock_vma_under_rcu-retry
+++ a/mm/mmap_lock.c
@@ -241,6 +241,7 @@ retry:
 		if (PTR_ERR(vma) == -EAGAIN) {
 			count_vm_vma_lock_event(VMA_LOCK_MISS);
 			/* The area was replaced with another one */
+			mas_set(&mas, address);
 			goto retry;
 		}
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mmap_lock-reset-maple-state-on-lock_vma_under_rcu-retry.patch

