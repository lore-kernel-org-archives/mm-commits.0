Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775CA1A725A;
	Mon, 12 May 2025 00:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011375; cv=none; b=Mz9G5bfN1Y3GvINovlHUiz42v1UyQUdV0xuCplTyVzlJ2MiCpJb+La98RqoNFEEY9yT72DIBb4Zx1qeUDO+NS/s/046N9AnIpMnTyNgnNpRA2RW1DWyDHYeytApOF0sB7AIMkrnboZtDsN4eql5qrrGwDWg24ln3s4mh2P0HJUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011375; c=relaxed/simple;
	bh=BQlWKE9oMnECkAXh8bCbYknBZUOUd0KCWfuMmXuhCTQ=;
	h=Date:To:From:Subject:Message-Id; b=ui1rxyQwaEBlh3ilbhDzYYObOodBbLzb8bTcI4KJVeJK1xwHleiO9GgSZs4IKQVqKq1iPODfdSpJL5dlhADLehY1wiUlBz9iE8NEOfml5SfNDSLSE+JJL2LFI9npCVcqDgouVBOG7Mm9jv8M7JRPNfXx+SpdlVeRDMxzYoaVZfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cNRudEoB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cNRudEoB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BAF2C4CEE4;
	Mon, 12 May 2025 00:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011375;
	bh=BQlWKE9oMnECkAXh8bCbYknBZUOUd0KCWfuMmXuhCTQ=;
	h=Date:To:From:Subject:From;
	b=cNRudEoBcrre21UbX3nMRNhae40zrszmaDuF52OpiYEFYbA3dvMBXSkBM2zYpwXX2
	 8A1AV77uBeu75Vg5H5BNzDDrW1fGAa/4HP21ph1qX1OMKi2/fgt0+SlByupAFEvIQp
	 SH+DzM6WdNMe3OvK8uWEO4ywxSRMD2a+hyNk8yYo=
Date: Sun, 11 May 2025 17:56:14 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,segoon@openwall.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,aha310510@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ipc-fix-to-protect-ipcs-lookups-using-rcu.patch removed from -mm tree
Message-Id: <20250512005615.4BAF2C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ipc: fix to protect IPCS lookups using RCU
has been removed from the -mm tree.  Its filename was
     ipc-fix-to-protect-ipcs-lookups-using-rcu.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeongjun Park <aha310510@gmail.com>
Subject: ipc: fix to protect IPCS lookups using RCU
Date: Thu, 24 Apr 2025 23:33:22 +0900

syzbot reported that it discovered a use-after-free vulnerability, [0]

[0]: https://lore.kernel.org/all/67af13f8.050a0220.21dd3.0038.GAE@google.com/

idr_for_each() is protected by rwsem, but this is not enough.  If it is
not protected by RCU read-critical region, when idr_for_each() calls
radix_tree_node_free() through call_rcu() to free the radix_tree_node
structure, the node will be freed immediately, and when reading the next
node in radix_tree_for_each_slot(), the already freed memory may be read.

Therefore, we need to add code to make sure that idr_for_each() is
protected within the RCU read-critical region when we call it in
shm_destroy_orphaned().

Link: https://lkml.kernel.org/r/20250424143322.18830-1-aha310510@gmail.com
Fixes: b34a6b1da371 ("ipc: introduce shm_rmid_forced sysctl")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Reported-by: syzbot+a2b84e569d06ca3a949c@syzkaller.appspotmail.com
Cc: Jeongjun Park <aha310510@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/ipc/shm.c~ipc-fix-to-protect-ipcs-lookups-using-rcu
+++ a/ipc/shm.c
@@ -431,8 +431,11 @@ static int shm_try_destroy_orphaned(int
 void shm_destroy_orphaned(struct ipc_namespace *ns)
 {
 	down_write(&shm_ids(ns).rwsem);
-	if (shm_ids(ns).in_use)
+	if (shm_ids(ns).in_use) {
+		rcu_read_lock();
 		idr_for_each(&shm_ids(ns).ipcs_idr, &shm_try_destroy_orphaned, ns);
+		rcu_read_unlock();
+	}
 	up_write(&shm_ids(ns).rwsem);
 }
 
_

Patches currently in -mm which might be from aha310510@gmail.com are

mm-vmalloc-fix-data-race-in-show_numa_info.patch

