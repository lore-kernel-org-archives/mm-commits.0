Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0099426430;
	Tue,  4 Aug 2026 04:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816302; cv=none; b=f+uQA4aBddfakLK4lP6cpkHv+zipO0YantSI1QzLXWhU6vnkVr+iObSJgIB+XCvKDFpdP+YLVmzNdZht5Mtr50Nd5wM7kxxT/4FAxE3iTWR/UZv89r544GWQ8CRj+qVRLh7PAoKzKLOyaxHanlZB9PdjaRf6UGcsFhHl6dwLNJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816302; c=relaxed/simple;
	bh=sLefSD6AHFuj6s/LNrTT8ZbGwL9xusyNNdH3PTPjtwA=;
	h=Date:To:From:Subject:Message-Id; b=QVeMpjbZeti76tLLKjJ9hHPUT5YEhvlo3IRbgsC4Akj8Y75DFAcnwgRAmrhl5JnBynWM6Uy6/yAInI16Q1X4882Qcb7qryA/Vtyu0hZVcDgFwjU3QCRRpqeS2UnM5+RIC9L9s8ro+Qgg7XAN4oJijotlT4zpQ6PQs0nWbx9VXTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0vVe65pI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0vVe65pI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A84E1F000E9;
	Tue,  4 Aug 2026 04:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816300;
	bh=TQBm/Ox2rUiiXp+n8tHIrxQFevf9olXyjWUxvRgSVcY=;
	h=Date:To:From:Subject;
	b=0vVe65pIkDYB7SCd3WxckQ3p3S7yOskskKxLTAfpUJJSswPZSiIh5ddYV1f7zmMN/
	 mRTKiD1hcqI3vWwYBRbyVaOUhOgu04xBAVB+UUu3GW+95omfVJsgq9t/mUXHu9Tj+j
	 ldl2Sdqp2mQS81vluR7GmQRCCCbKbFjZat+VAoj0=
Date: Mon, 03 Aug 2026 21:04:59 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,hexlabsecurity@proton.me,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-bound-namelen-in-dlm_migrate_request_handler.patch removed from -mm tree
Message-Id: <20260804040500.7A84E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: bound namelen in dlm_migrate_request_handler
has been removed from the -mm tree.  Its filename was
     ocfs2-bound-namelen-in-dlm_migrate_request_handler.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


