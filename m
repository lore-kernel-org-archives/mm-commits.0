Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B8D37883C;
	Tue, 31 Mar 2026 19:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774983793; cv=none; b=QrJcOAOShy3FdpwyGT5QP7GdztnRJcdRl7lr52su376iTzjllpURziGa5iC/dCS81wYK6khPN6JakcAh/xcuiCrWBqnp2wsMKNg6RCellGZP03tWeDr5sEpWfCSsr9hw67dlIy47s2J6npS1uSq/waHq6Q84/D3pjtJxR9xBI+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774983793; c=relaxed/simple;
	bh=lHpNuvAMhCX6p3T7a7BazybaLrtSomcuIRgu8XwxmiA=;
	h=Date:To:From:Subject:Message-Id; b=J8V4VIzAgBEsDCJQV5LWhhnjDtuYJyUrhfXk1FMn+IeoxqAJAcX8lie+Fl3JRh5YzAUNCCbMJ/YWERLr8XvP2ctmJqDMMuhFt47k5fwpIN1kdW5O8shGzRHHnp6bkJxvsXWqatJnqe4qvjASP43Z05ZkVnHO6bf3ehQ/i71F0k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q12YdEwn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q12YdEwn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923C7C19423;
	Tue, 31 Mar 2026 19:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774983792;
	bh=lHpNuvAMhCX6p3T7a7BazybaLrtSomcuIRgu8XwxmiA=;
	h=Date:To:From:Subject:From;
	b=q12YdEwnG9xZnkFna1+NhJFv+gLlZ0cjoa0+ObbOAJ32OvkJ2TrJigxMTEZJrfcrs
	 nlQvvg/5eIlXGb8Hdicg0jqg1neri7jZJQ1nwt8Gw1MFNlez+UPeraJwpVDCfE4rVu
	 ltKtWk42lZpkn7fLyq57D+xW1iNRXIq7+L7i/kO8=
Date: Tue, 31 Mar 2026 12:03:12 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,liuyun01@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-fix-memory-leak-in-weighted_interleave_auto_store.patch added to mm-unstable branch
Message-Id: <20260331190312.923C7C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: fix memory leak in weighted_interleave_auto_store()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-fix-memory-leak-in-weighted_interleave_auto_store.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-fix-memory-leak-in-weighted_interleave_auto_store.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Jackie Liu <liuyun01@kylinos.cn>
Subject: mm/mempolicy: fix memory leak in weighted_interleave_auto_store()
Date: Tue, 31 Mar 2026 18:07:40 +0800

Add the missing kfree(new_wi_state) when the auto mode is already set to
the requested value.  When a user writes "false" to the auto sysfs
interface and the current mode is already manual (mode_auto == false), the
function returns early without freeing new_wi_state allocated at the
beginning of the function.  This can be triggered repeatedly from
userspace, leaking memory on each write.

Link: https://lkml.kernel.org/r/20260331100740.84906-1-liu.yun@linux.dev
Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mempolicy.c~mm-mempolicy-fix-memory-leak-in-weighted_interleave_auto_store
+++ a/mm/mempolicy.c
@@ -3707,6 +3707,7 @@ static ssize_t weighted_interleave_auto_
 			goto update_wi_state;
 		if (input == old_wi_state->mode_auto) {
 			mutex_unlock(&wi_state_lock);
+			kfree(new_wi_state);
 			return count;
 		}
 
_

Patches currently in -mm which might be from liuyun01@kylinos.cn are

mm-mempolicy-fix-memory-leak-in-weighted_interleave_auto_store.patch

