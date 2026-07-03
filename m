Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895EE1A6816;
	Fri,  3 Jul 2026 01:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783043227; cv=none; b=f21g3nOMt+s4yjTqUrVztGelTj2dk8+GsYtPfFAwN3n+5lq2VTDR+4FHm/3epWgxSN/mJ+DWaBfwaUauHNYav63+EamA06xfx5Ku4GSc5nR1CfcPI/hHRGNGxPVKxVe0cguEhdB80FRuGPziv2u771O4IbWfoCLaRsu0Kd/NEe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783043227; c=relaxed/simple;
	bh=d6+f6GcFY/2apG7Zx6B+FrFlOf9s5ByKshuTkguZrSQ=;
	h=Date:To:From:Subject:Message-Id; b=qwyB35U6gc3pzybQL70Jeik/kp7JFhaLQ98PJgrBiTkq62Z3QVZWy0Nx0QuoavmPEbs5kb12GVDYnXDgHGYsuEN2eWzPYkuNdfyu0IpYiN/oV3Oy1Xet3x09MaBAuBmCSIHHmA7n6+SGqJfycfmpPs8XHPcdfO/BZkVLXnqsSCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tkzj8Y7z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tkzj8Y7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB131F000E9;
	Fri,  3 Jul 2026 01:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783043225;
	bh=A8wITDBYl52eY9vK+nDryhThfpP3zFMVcFkCt85hTWo=;
	h=Date:To:From:Subject;
	b=tkzj8Y7z29oFGKVL87gYtr7Iw3cS0GcDT6hKZ3MC3Xrtxpk9vIouW5b6VYKq+FqdW
	 5Df5yH4qIMraWwzyhxnCjINnykPLrRi3E+GtejJqMjuYrddzKqSGC4TwnTa99JSiiE
	 E9LvGpL9BCpLQbTETjlw9la3TKMtMKG60xaShSDo=
Date: Thu, 02 Jul 2026 18:47:04 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,hexlabsecurity@proton.me,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-bound-namelen-in-dlm_migrate_request_handler.patch added to mm-new branch
Message-Id: <20260703014704.EDB131F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: bound namelen in dlm_migrate_request_handler
has been added to the -mm mm-new branch.  Its filename is
     ocfs2-bound-namelen-in-dlm_migrate_request_handler.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-bound-namelen-in-dlm_migrate_request_handler.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Bryam Vargas <hexlabsecurity@proton.me>
Subject: ocfs2: bound namelen in dlm_migrate_request_handler
Date: Mon, 29 Jun 2026 00:01:43 -0500

Patch series "ocfs2/dlm: bound peer-controlled lengths in the o2dlm".

The o2dlm receive handlers trust u8 length and count fields from the wire
without bounding them, so a node in a DLM domain can corrupt or panic any
other node with a malformed message.  Three defects:

  - dlm_migrate_request_handler() passes migrate->namelen unchecked to
    dlm_init_mle(), which memcpy()s it into the 32-byte mname[] of an
    o2dlm_mle slab object: a heap out-of-bounds write of up to ~215
    attacker-controlled bytes.

  - dlm_mig_lockres_handler() passes mres->lockname_len unchecked to
    dlm_init_lockres(), which memcpy()s it into the 32-byte o2dlm_lockname
    slab object: a heap out-of-bounds write of up to ~223 bytes.

  - the same handler trusts mres->num_locks without checking that the
    message is large enough to hold that many entries, so
    dlm_process_recovery_data() walks mres->ml[] past the kmalloc(data_len)
    copy and trips a BUG_ON (an out-of-bounds read ending in a panic).

The other o2dlm receive handlers already reject an oversized name; the
migration and recovery handlers have omitted it since the DLM was added
(see the Fixes tags).  Patch 1 bounds namelen; patch 2 validates
lockname_len, num_locks, and the payload size.  Conforming recovery and
migration traffic is unaffected.

o2net authenticates peers only by the DLM domain key, so any node that has
joined the domain -- including a compromised or malicious member -- can
send these messages.  There is no local trigger; the attacker must already
be a member of the cluster.

Each sink was confirmed under KASAN with an out-of-tree module mirroring
it exactly -- a kmem_cache/kmalloc of the real destination size, then the
same unclamped memcpy/loop: slab-out-of-bounds Write for the two writes,
Read for the recovery walk, and a panic.  A userspace AddressSanitizer
build faults identically under -m32 and -m64.  Scrubbed logs are available
on request.

I reported this privately to security@kernel.org and the ocfs2 maintainers
on 2026-06-20; with no response after the standard embargo period I am
posting the fix publicly.  I have no embargo requirement.


This patch (of 2):

A node receiving a DLM_MIGRATE_REQUEST message trusts the peer-supplied
name length (migrate->namelen) without bounding it.  dlm_init_mle() then
copies that many bytes into the fixed DLM_LOCKID_NAME_MAX-byte mname[]
array of an o2dlm_mle slab object, so a malformed message from a cluster
peer overflows the slab object by up to ~215 bytes: a heap out-of-bounds
write of attacker-controlled data, reachable by any node in the domain.

Reject an oversized name, the way dlm_master_request_handler() and the
other o2dlm receive handlers already do; the migration handler omits the
check entirely.  Conforming messages are unaffected.

Link: https://lore.kernel.org/20260629-b4-disp-94fb6521-v1-0-6953bcc0421f@proton.me
Link: https://lore.kernel.org/20260629-b4-disp-94fb6521-v1-1-6953bcc0421f@proton.me
Fixes: 6714d8e86bf4 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-bound-namelen-in-dlm_migrate_request_handler
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -3099,6 +3099,12 @@ int dlm_migrate_request_handler(struct o
 
 	name = migrate->name;
 	namelen = migrate->namelen;
+	if (namelen > DLM_LOCKID_NAME_MAX) {
+		mlog(ML_ERROR, "%s: invalid name length %u in migrate request\n",
+		     dlm->name, namelen);
+		ret = -EINVAL;
+		goto leave;
+	}
 	hash = dlm_lockid_hash(name, namelen);
 
 	/* preallocate.. if this fails, abort */
_

Patches currently in -mm which might be from hexlabsecurity@proton.me are

ocfs2-bound-namelen-in-dlm_migrate_request_handler.patch
ocfs2-validate-lengths-in-dlm_mig_lockres_handler.patch

