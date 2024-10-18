Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB13014900E
	for <mm-commits@vger.kernel.org>; Fri, 18 Oct 2024 22:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729289777; cv=none; b=JuHGgP/b1vWDDLhtTR79gzSHqcrD1xIBFUko3JMnVPe1nRJnnff4+OczbGpKMC8zRo2Y6y/cBdFk+O1fOFM3WhqADauol0B9L+hr7Z2odAO5hOrV7KVBSJNhtnqofAIqYM+MuoKwVKcUHY+m81o0mMylGDfSy3YgD8XMYf9Xl/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729289777; c=relaxed/simple;
	bh=ntpQumse17g8S9qVHAzIhSQTQ5cOXnLcz+CJduZJJ44=;
	h=Date:To:From:Subject:Message-Id; b=GuOYI2ZlpCdV6AfHkSVAhNeVjJoqa+PcckmLKq36onTEca8ahy6fTINLUN1KFE3g4+mQDCVY5abqOl+eGD8f2IXLjATjW+soSg4SJcq7kD1FawM1mR42qfFGr2xgCbcvBCxdTltAgUyoKpzFc1PEr/hp+FsfQmMhSBHLLi58Rgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YfL0SW8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YfL0SW8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625FAC4CEC3;
	Fri, 18 Oct 2024 22:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729289777;
	bh=ntpQumse17g8S9qVHAzIhSQTQ5cOXnLcz+CJduZJJ44=;
	h=Date:To:From:Subject:From;
	b=YfL0SW8PuDpHccqAPHqXfDWQ0lWwEjTtQfoSYHLgRKoH2dbk4QKdyvmDhw1STth8P
	 Bm7fwjYvcz/wD3SGSHNIXqyp8lUcyWZWfg+hHT2GLwXJed49BcAHsA7jGR1W/PqLVN
	 qGvetAqx1+0SP8Nb/bgnOoM+bx9UKJZq4nxAjk48=
Date: Fri, 18 Oct 2024 15:16:16 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,Liam.Howlett@Oracle.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-outdated-flag-name-in-comment.patch added to mm-unstable branch
Message-Id: <20241018221617.625FAC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: fix outdated flag name in comment
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-fix-outdated-flag-name-in-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-outdated-flag-name-in-comment.patch

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
From: Jann Horn <jannh@google.com>
Subject: maple_tree: fix outdated flag name in comment
Date: Mon, 07 Oct 2024 23:47:45 +0200

MAPLE_USE_RCU was renamed to MT_FLAGS_USE_RCU at some point, fix up the
comment.

Link: https://lkml.kernel.org/r/20241007-maple-tree-doc-fix-v1-1-6bbf89c1153d@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/maple_tree.h~maple_tree-fix-outdated-flag-name-in-comment
+++ a/include/linux/maple_tree.h
@@ -224,7 +224,7 @@ typedef struct { /* nothing */ } lockdep
  * (set at tree creation time) and dynamic information set under the spinlock.
  *
  * Another use of flags are to indicate global states of the tree.  This is the
- * case with the MAPLE_USE_RCU flag, which indicates the tree is currently in
+ * case with the MT_FLAGS_USE_RCU flag, which indicates the tree is currently in
  * RCU mode.  This mode was added to allow the tree to reuse nodes instead of
  * re-allocating and RCU freeing nodes when there is a single user.
  */
_

Patches currently in -mm which might be from jannh@google.com are

mm-mark-mas-allocation-in-vms_abort_munmap_vmas-as-__gfp_nofail.patch
maple_tree-fix-outdated-flag-name-in-comment.patch

