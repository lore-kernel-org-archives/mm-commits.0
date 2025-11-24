Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2842338D
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 22:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764023163; cv=none; b=dvtGXA9tZZRZWiMUPY7UTZDY69tNrnMeSkeUuPI8zIUOk1yF3fmwPhXMwH4/mjMGthxMJy99qNRlG/yOsCwJHLh7qFuwzcU0NZ13jbdKvgQ2cB22n4UA3CdkhVQtIln/wBRyLt2vWjPTXf9jGwV8FfvD4/fq3wm6ueBw7xSXeDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764023163; c=relaxed/simple;
	bh=0kZDRo4bVfsb89D0o4PcqbOsmug2qnikUl/pC5z6xQw=;
	h=Date:To:From:Subject:Message-Id; b=J58IKYd6FFx0Ns+2h72s+nV55O6P2H93HZ49r64agK6gW7uBHZvind3t5iFV7ad1dkig+rFBtsSr4fxyLSx7cxqAKLjwe6+EQrRCwA++QAKtd6zDY70v5OfNWexRYxBlb2ROPKasFdZZ5T7x4+TBCKmDZHy2/GyPpdTUOdjIU5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lVsj7sXo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lVsj7sXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7FBC4CEF1;
	Mon, 24 Nov 2025 22:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764023162;
	bh=0kZDRo4bVfsb89D0o4PcqbOsmug2qnikUl/pC5z6xQw=;
	h=Date:To:From:Subject:From;
	b=lVsj7sXoUx7YlUR8uDhqw/x0G5xBkubO3xBCeixhuoWZAXzSBwtBQvME6Ar6rDWS5
	 DzV5XbQiVO0wEG0FKkWRHRd/DnZwnbLiQhe4+0lfnCJwR/2qUf0X7g2YFM3ndECXpd
	 bk7cDlY8g7hf7dgzEm6axSkSfhCE7JNR/RsdKWe8=
Date: Mon, 24 Nov 2025 14:26:02 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,jannh@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mmap_lock-reset-maple-state-on-lock_vma_under_rcu-retry.patch removed from -mm tree
Message-Id: <20251124222602.AC7FBC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmap_lock: reset maple state on lock_vma_under_rcu() retry
has been removed from the -mm tree.  Its filename was
     mm-mmap_lock-reset-maple-state-on-lock_vma_under_rcu-retry.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Matthew Wilcox <willy@infradead.org>
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


