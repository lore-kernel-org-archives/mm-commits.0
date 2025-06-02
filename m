Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5030C253F11
	for <mm-commits@vger.kernel.org>; Mon,  2 Jun 2025 23:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748905841; cv=none; b=s5PpGemrFfUMxx4hnb9+OT0BBJIbMnuv1sexChmolXd8WoSmN5xxWpBFKMtG6oAWdeuZoyKlP9rXyVCfFfdPKdJ6TouSzsmPCtOt4d2R/DHuIFgJ0gF9P3gvhQP1wPTRR+dDYcuYKaSUpQkXpr1uB3muw8Brt98+zwR4vKNh330=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748905841; c=relaxed/simple;
	bh=QAZEfTD9/rSR+ioHimhkM8i1kI+lPNkQQ7d0JatK0zM=;
	h=Date:To:From:Subject:Message-Id; b=RdEjn8B3zNUqQA1MNyELBXDC/UkZki+omNvJHRqGCDUoPdHvXUrOSshs2NVYiKTAkC/7K61HnhDy38ltqb21ufMxnlnMnQEVDrYJOCjJTLgJcl97eO1EV7xzJKgfyf7pzFUZmaW/LIhnyE2OWdlNFecG310IP93d8ei6MaYCq+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H/z6C1Nm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H/z6C1Nm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA38EC4CEEB;
	Mon,  2 Jun 2025 23:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748905840;
	bh=QAZEfTD9/rSR+ioHimhkM8i1kI+lPNkQQ7d0JatK0zM=;
	h=Date:To:From:Subject:From;
	b=H/z6C1NmLKkf6/DS2/5QlER+j39sG2Zfz2Q/cbwi/VBhQDJQqJ02HJF56/UFykz/G
	 PQbckdPN7B0mo1QwiGVJURXxIXZnpkuVu6aQUNQr3vpkPGShNHsiD3PD04T1uiT1dB
	 YYjlzlX+NiXfODdTclFvSNvjxw+Cg8jsSh+NofMU=
Date: Mon, 02 Jun 2025 16:10:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,lkp@intel.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,apopple@nvidia.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-fix-incorrect-freeing-of-wi_kobj.patch added to mm-hotfixes-unstable branch
Message-Id: <20250602231040.AA38EC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: fix incorrect freeing of wi_kobj
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mempolicy-fix-incorrect-freeing-of-wi_kobj.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-fix-incorrect-freeing-of-wi_kobj.patch

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
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm/mempolicy: fix incorrect freeing of wi_kobj
Date: Mon, 2 Jun 2025 09:23:39 -0700

We should not free wi_group->wi_kobj here.  In the error path of
add_weighted_interleave_group() where this snippet is called from,
kobj_{del, put} is immediately called right after this section.  Thus, it
is not only unnecessary but also incorrect to free it here.

Link: https://lkml.kernel.org/r/20250602162345.2595696-1-joshua.hahnjy@gmail.com
Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506011545.Fduxqxqj-lkp@intel.com/
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-incorrect-freeing-of-wi_kobj
+++ a/mm/mempolicy.c
@@ -3708,15 +3708,13 @@ static void wi_state_free(void)
 			lockdep_is_held(&wi_state_lock));
 	if (!old_wi_state) {
 		mutex_unlock(&wi_state_lock);
-		goto out;
+		return;
 	}
 
 	rcu_assign_pointer(wi_state, NULL);
 	mutex_unlock(&wi_state_lock);
 	synchronize_rcu();
 	kfree(old_wi_state);
-out:
-	kfree(&wi_group->wi_kobj);
 }
 
 static struct kobj_attribute wi_auto_attr =
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mm-mempolicy-fix-incorrect-freeing-of-wi_kobj.patch
mm-mempolicy-skip-unnecessary-synchronize_rcu.patch

