Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FEA283138
	for <mm-commits@vger.kernel.org>; Fri, 26 Sep 2025 19:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758916547; cv=none; b=tXlW2UgusEfl/xLsS0uiMR/iT4ahp8JSqNzBdWPAz1E7ip4ro7SO6r4/ChO1DzQuvbUCbniHku7erOQxMzJATXj9PGSmIXuY6uRRlv901FylFmffxSIs5ak7Eu9psCJtJezucs37nAapY9y5ddL4fN2p2bW7Y6tcyXObVVS0C6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758916547; c=relaxed/simple;
	bh=vciGCxant8LYdRMeyyasOlHHsAZ0evr+c5PGWwV0aqA=;
	h=Date:To:From:Subject:Message-Id; b=iyXfOIfoRuz+JpFEqstJcUUKcglBkfbEIZY5hqnCjZkE2LDbKgHjH3DkBt5jw4kPnZfoQmnaVjmgvJm5wi0Ybp9te/FHUSi2YjpmRxn95lddDak47pWRiCbIXkDfFhkiFpfXBMAHs9ohywa1VwnZHesV5O4Zky55LHD8VVdskZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pcz+wdXQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pcz+wdXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4BEC113CF;
	Fri, 26 Sep 2025 19:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758916547;
	bh=vciGCxant8LYdRMeyyasOlHHsAZ0evr+c5PGWwV0aqA=;
	h=Date:To:From:Subject:From;
	b=pcz+wdXQRlfW9vPhc4gbaSaxxQTvRPbvleda3bd7eGUH8IBENfzA6SjxzLYEvUZHi
	 Td91TS0Bjuo3vCBn2BXTTu9F/Jx+KD6ACLAHD6crJw0pT87a/zGxcQwvV+hCGP3gXa
	 4UosIhyxInDsgKamMtkPhbFIEWeqgyo6XKWLKej8=
Date: Fri, 26 Sep 2025 12:55:46 -0700
To: mm-commits@vger.kernel.org,oleg@redhat.com,kees@kernel.org,david@redhat.com,eadavis@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] copy_process-fixed-jump-logic-error.patch removed from -mm tree
Message-Id: <20250926195547.1B4BEC113CF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: copy_process(): fix jump logic error
has been removed from the -mm tree.  Its filename was
     copy_process-fixed-jump-logic-error.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Edward Adam Davis <eadavis@qq.com>
Subject: copy_process(): fix jump logic error
Date: Wed, 24 Sep 2025 20:06:21 +0800

After futex_hash_allocate_default() fails, the logic should jump to
bad_fork_cancel_cgroup, not bad_fork_core_free.

Jumping to bad_fork_core_free would cause a siglock imbalance.

Link: https://lkml.kernel.org/r/tencent_5E4F978D9525A58D97925ADDBADDB2193107@qq.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fork.c~copy_process-fixed-jump-logic-error
+++ a/kernel/fork.c
@@ -2293,7 +2293,7 @@ __latent_entropy struct task_struct *cop
 	if (need_futex_hash_allocate_default(clone_flags)) {
 		retval = futex_hash_allocate_default();
 		if (retval)
-			goto bad_fork_core_free;
+			goto bad_fork_cancel_cgroup;
 		/*
 		 * If we fail beyond this point we don't free the allocated
 		 * futex hash map. We assume that another thread will be created
_

Patches currently in -mm which might be from eadavis@qq.com are


