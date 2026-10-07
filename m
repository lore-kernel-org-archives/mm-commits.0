Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23EE2931EF;
	Wed,  7 Oct 2026 02:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338646; cv=none; b=TT/uYVbnW6ADqcHnDhCCCPHIu+9JAN7tPPatjEwCxWsDew4T3V3ODwoP5ERDkbGcXzUo9p4ejeWukKOljUhaxrm9gWLDge/tMPdw+gzar1ASVA/GV2KuXcpQ0k473kd22fpxExg8Op+6xLwbiY6FEsX6bCpJXaltIndMJY7iubQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338646; c=relaxed/simple;
	bh=R1HkqTkcVYeG3xZEgukXca333Rwbar7s8qp52jIH7zo=;
	h=Date:To:From:Subject:Message-Id; b=H80PmdJ33/T0KXpJCAhqkSujumytG/NrcERSj4EwvB5nEEFS9w+GVlgNyMrdTGCjPt8mVYug9s9vbHrGkBPq6EXLwbzq/wy5XqlaLqIf7jyvSUgx0hz84zS2Sxd40WnamaNRHLM0PmfLwePCTITGkibvq4I4JziYlR9XEV85G5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FCj8Zw15; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FCj8Zw15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABE61F0089B;
	Wed,  7 Oct 2026 02:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338644;
	bh=lqf6p774oMOY4A/J4F7XEHue4SMb/RdPV2sAnKLY8WY=;
	h=Date:To:From:Subject;
	b=FCj8Zw15MbtfyRZLxt8Lf7V+BGcb2FgV5NoATsnN3S2MkkJ4Ide67BOU4hYPr7732
	 oI9x3QmDO9M7s4l9zMrZVXcbtFxNB9cFKjpw6RzLE4kENMYAS2Z+Aw1zWcsdZWvRU2
	 drktslIG2G0gKfIZrckBh3M6xrCX6ae2Ft8PzUus=
Date: Tue, 06 Oct 2026 19:04:04 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,neil@brown.name,manfred@colorfullife.com,jack@suse.cz,dave@stgolabs.net,brauner@kernel.org,4ncienth@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ipc-mqueue-release-notification-resources-during-inode-eviction.patch removed from -mm tree
Message-Id: <20261007020404.6ABE61F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ipc/mqueue: release notification resources during inode eviction
has been removed from the -mm tree.  Its filename was
     ipc-mqueue-release-notification-resources-during-inode-eviction.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Daehyeon Ko <4ncienth@gmail.com>
Subject: ipc/mqueue: release notification resources during inode eviction
Date: Mon, 24 Aug 2026 13:23:59 +0900

mqueue_flush_file() removes an mq_notify() registration only when the
closing task belongs to the thread group stored in notify_owner.

A task in a separate thread group created with CLONE_FILES can register
SIGEV_THREAD notification and exit without closing the shared file table. 
If another thread group then unlinks and last-closes the queue, ->flush()
skips the registration and inode eviction loses the only pointers to its
resources.

The orphaned registration permanently retains the notification skb, its
netlink socket, a pid reference and a user namespace reference.  An
unprivileged process can repeat the sequence with new queues and sockets.

No inode users remain during eviction.  Remove any stale registration
there after dropping info->lock, since netlink_sendskb() may release the
final socket reference.

This bug creates an unkillable kernel resource leak by failing to free
netlink socket, PID, and user namespace references when a POSIX message
queue is evicted.  An unprivileged process can exploit this leak
repeatedly to cause kernel memory exhaustion and lead to a DoS.

Link: https://lore.kernel.org/20260824042359.925145-1-4ncienth@gmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: NeilBrown <neil@brown.name>
Cc: <stable@vger.kernel.org>
---

 ipc/mqueue.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/ipc/mqueue.c~ipc-mqueue-release-notification-resources-during-inode-eviction
+++ a/ipc/mqueue.c
@@ -528,6 +528,13 @@ static void mqueue_evict_inode(struct in
 		list_add_tail(&msg->m_list, &tmp_msg);
 	kfree(info->node_cache);
 	spin_unlock(&info->lock);
+	/*
+	 * A shared file table can let the notification owner exit without
+	 * running ->flush(). No users of the inode remain during eviction, so
+	 * tear down any stale notification after dropping info->lock because
+	 * netlink_sendskb() may release the final socket reference.
+	 */
+	remove_notification(info);
 
 	list_for_each_entry_safe(msg, nmsg, &tmp_msg, m_list) {
 		list_del(&msg->m_list);
_

Patches currently in -mm which might be from 4ncienth@gmail.com are

assoc_array-discard-shortcut-when-collapsing-a-leaf-only-node.patch

