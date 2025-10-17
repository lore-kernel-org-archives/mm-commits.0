Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9442494F0
	for <mm-commits@vger.kernel.org>; Fri, 17 Oct 2025 23:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760743654; cv=none; b=XYnaFqo2D8B9rv/sRFjfxSJlNDDoBFVYglUJUKV1zi6VbBeIrwi76NYOHog3JAAYz85zxUQ0gQCRPy0Zv3D+4ieYqDFjuZHy0ffFlQwMRkCuqbdnaU9kU48LPMWhravwkpZOKhzPjPuMPsygS/XZwGVs7pisUoTstYOAtemz+SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760743654; c=relaxed/simple;
	bh=V3y5T5YjaemRP1SLJzmAe+QMT/tvL4mM35BFzO6m8P4=;
	h=Date:To:From:Subject:Message-Id; b=ciZYPMh0fvLZDm9WcoMB/54DI5lj0HZaEFTQ3mVJOu/OPUkPnHw23izi5jRG0haO0irLyvJ2BRgmqAobTNau1UGzkYpcK63bNgIPkVLOiNxecoJqAG+GcrfF9O8OU+wOgJbbS3QNJ0psyySmIT7SFCNu/432Yezp09WkqKeID5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rSrjXoZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rSrjXoZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E618C4CEE7;
	Fri, 17 Oct 2025 23:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760743654;
	bh=V3y5T5YjaemRP1SLJzmAe+QMT/tvL4mM35BFzO6m8P4=;
	h=Date:To:From:Subject:From;
	b=rSrjXoZXlCBNbJPSzNqycuWha/dkFNtmF7G1ojTdiGvvFq9zm8coec6JioTDTEToy
	 Q0WU4TLQfmWQwHpAD78uyiOD2qJ1LVm7Q4sLtPqQJmGcmbsibKkIrEE737yNgJtRfe
	 O66nDuv2TcjtnFO/bCf2LuRENTPgHLv0bFZ500d8=
Date: Fri, 17 Oct 2025 16:27:33 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-base-node-fold-unregister_node-into-unregister_one_node-fix.patch added to mm-unstable branch
Message-Id: <20251017232734.0E618C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers-base-node-fold-unregister_node-into-unregister_one_node-fix
has been added to the -mm mm-unstable branch.  Its filename is
     drivers-base-node-fold-unregister_node-into-unregister_one_node-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-base-node-fold-unregister_node-into-unregister_one_node-fix.patch

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
From: Donet Tom<donettom@linux.ibm.com>
Subject: drivers-base-node-fold-unregister_node-into-unregister_one_node-fix
Date: Fri, 17 Oct 2025 10:27:54 +0530

removes extra spaces before @nid and "All".

Link: https://lkml.kernel.org/r/cff01514-9074-4c97-bcf1-d4e3594e48b0@linux.ibm.com
Signed-off-by: Donet Tom<donettom@linux.ibm.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/node.c~drivers-base-node-fold-unregister_node-into-unregister_one_node-fix
+++ a/drivers/base/node.c
@@ -911,7 +911,7 @@ int register_node(int nid)
  * unregister_node - unregister a node device
  * @nid: nid of the node going away
  *
- * Unregisters the node device at node id  @nid.  All the devices on the
+ * Unregisters the node device at node id @nid. All the devices on the
  * node must be unregistered before calling this function.
  */
 void unregister_node(int nid)
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

drivers-base-node-fold-register_node-into-register_one_node.patch
drivers-base-node-fold-unregister_node-into-unregister_one_node.patch
drivers-base-node-fold-unregister_node-into-unregister_one_node-fix.patch

