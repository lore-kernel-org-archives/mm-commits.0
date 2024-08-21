Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADB313A3E8
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 21:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724276426; cv=none; b=jQ84ThBkfK43LnZeS+8SD3D9OhMpq0wdrtdS1+FP5UShf4pJN4dVxanql9IRZ3DRD/GnTXkmMtxb5Et6Yz2jWhKqagLdTCVAyjSdiXgVIN89B0+YvQJ59Dv6QSpfmUJ6glnfunMM1OU1f/tXAc5FRbaN+smFc18c6qCxAiSu1UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724276426; c=relaxed/simple;
	bh=VrMG7NfOlYit9gkoGby23Aevlniuc3UKhnw5qybRy3c=;
	h=Date:To:From:Subject:Message-Id; b=fnmd8Mbf7kFY8o3JQXo/1Ew3vmexbKs6eqPDaroHH3BNIpeSz4M5TC3KYm436wk8DaXVpmHZvKoOhTP6xIVp7xOWAzjY1GiYN6+EOU3mpkXh0GtnVSuzvOvOVGNM/U0OVQoeMbCj7DFVInEC1ilxI7RG5srcBWXOA+KgAwR5k6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G31RsWHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G31RsWHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0BFC4AF0E;
	Wed, 21 Aug 2024 21:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724276425;
	bh=VrMG7NfOlYit9gkoGby23Aevlniuc3UKhnw5qybRy3c=;
	h=Date:To:From:Subject:From;
	b=G31RsWHo/qYc75cif35uu6w0eySC1TSjOl+6rx6p0Y1XV343ogclgRz+jPuuqP0Cv
	 /xISKHU91s+JNw/pWq4lQ98N9XxQSDkKsFAilQCKUw7ypMAjiW+Mg/1WQp1tnx4ALI
	 /laH+YbeQPNnNHAo+sDKg6p8hE1jXIQMeCqbPxks=
Date: Wed, 21 Aug 2024 14:40:24 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,ghe@suse.com,gechangwei@live.cn,lizhi.xu@windriver.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-possible-null-ptr-deref-in-ocfs2_set_buffer_uptodate.patch added to mm-hotfixes-unstable branch
Message-Id: <20240821214025.7F0BFC4AF0E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix possible null-ptr-deref in ocfs2_set_buffer_uptodate
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-fix-possible-null-ptr-deref-in-ocfs2_set_buffer_uptodate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-possible-null-ptr-deref-in-ocfs2_set_buffer_uptodate.patch

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
From: Lizhi Xu <lizhi.xu@windriver.com>
Subject: ocfs2: fix possible null-ptr-deref in ocfs2_set_buffer_uptodate
Date: Wed, 21 Aug 2024 14:14:50 +0800

When doing cleanup, if flags without OCFS2_BH_READAHEAD, it may trigger
NULL pointer dereference in the following ocfs2_set_buffer_uptodate() if
bh is NULL.

Link: https://lkml.kernel.org/r/20240821061450.3478602-1-lizhi.xu@windriver.com
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Reported-by: Heming Zhao <heming.zhao@suse.com>
Suggested-by: Heming Zhao <heming.zhao@suse.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/buffer_head_io.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/buffer_head_io.c~ocfs2-fix-possible-null-ptr-deref-in-ocfs2_set_buffer_uptodate
+++ a/fs/ocfs2/buffer_head_io.c
@@ -388,7 +388,8 @@ read_failure:
 		/* Always set the buffer in the cache, even if it was
 		 * a forced read, or read-ahead which hasn't yet
 		 * completed. */
-		ocfs2_set_buffer_uptodate(ci, bh);
+		if (bh)
+			ocfs2_set_buffer_uptodate(ci, bh);
 	}
 	ocfs2_metadata_cache_io_unlock(ci);
 
_

Patches currently in -mm which might be from lizhi.xu@windriver.com are

ocfs2-remove-unreasonable-unlock.patch
ocfs2-fix-possible-null-ptr-deref-in-ocfs2_set_buffer_uptodate.patch

