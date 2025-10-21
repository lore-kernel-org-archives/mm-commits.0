Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785EF25B1DA
	for <mm-commits@vger.kernel.org>; Tue, 21 Oct 2025 19:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761075999; cv=none; b=CgjrJ/lek/LyyWLRMRacO689aiuzmWzpFlM9cMk0brASnVjQ56hOL4+h2sq4xejJVkZ8PmetL6rwqN51HB3bVSI3jPYM5QGcuZvf5gBS/eXvpMnHCzD81e6mQlO9ML7Zb95EP8I1DNHph9XodJ037UQEDRoiK3zIH2yN2Vyr8U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761075999; c=relaxed/simple;
	bh=7iaTCCcwDlvV+ovXuXD+uCdxdSM5/kuLdewzSDfQnSE=;
	h=Date:To:From:Subject:Message-Id; b=WL1YOIK5lwXmHtnOhGOjctdFjhbZGu7XDdAEmZzCbgcGGYBW1gbgTvmzgr5NuEoNaU1jQDjk24o7k117YIZhV1BEwR3LxzObg1AVWHwo8Ar3LszEt2o1cTonP25I8sxiAV6XmJye7rDH6edvQSUxh7TKs+SCWvIl4nnot4sJrsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qt13lAxf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qt13lAxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F29C4CEF1;
	Tue, 21 Oct 2025 19:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761075998;
	bh=7iaTCCcwDlvV+ovXuXD+uCdxdSM5/kuLdewzSDfQnSE=;
	h=Date:To:From:Subject:From;
	b=qt13lAxfUAdBY7+4n9/Ov3pPEreon38Y4A8QVBWXPpfTqxPSWsxIZLXziW90Puaui
	 6WqlkLB5RPByFevr0p2KQG4Gul5Qm4tY9LeSPbg7jkh+L5U+I8PwX0NwQB1mkqXZVd
	 SFOjy1fm7o7iPbgZFu4OgNUiddcV8dCJEdq/HxrY=
Date: Tue, 21 Oct 2025 12:46:37 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,donettom@linux.ibm.com,david@redhat.com,jingsusu@didiglobal.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-fix-indentation-in-fold_diff-function.patch added to mm-new branch
Message-Id: <20251021194637.E2F29C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmstat: fix indentation in fold_diff function
has been added to the -mm mm-new branch.  Its filename is
     mm-vmstat-fix-indentation-in-fold_diff-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-fix-indentation-in-fold_diff-function.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Jing Su <jingsusu@didiglobal.com>
Subject: mm/vmstat: fix indentation in fold_diff function
Date: Tue, 21 Oct 2025 15:37:07 +0800

Adjust misaligned braces in fold_diff() to improve code readability and
maintain consistent coding style.

Link: https://lkml.kernel.org/r/aPc4I/8zXCGyiapN@pilot-ThinkCentre-M930t-N000
Signed-off-by: Jing Su <jingsusu@didiglobal.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/vmstat.c~mm-vmstat-fix-indentation-in-fold_diff-function
+++ a/mm/vmstat.c
@@ -782,13 +782,14 @@ static int fold_diff(int *zone_diff, int
 		if (zone_diff[i]) {
 			atomic_long_add(zone_diff[i], &vm_zone_stat[i]);
 			changed = true;
-	}
+		}
 
 	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
 		if (node_diff[i]) {
 			atomic_long_add(node_diff[i], &vm_node_stat[i]);
 			changed = true;
-	}
+		}
+
 	return changed;
 }
 
_

Patches currently in -mm which might be from jingsusu@didiglobal.com are

mm-vmstat-fix-indentation-in-fold_diff-function.patch

