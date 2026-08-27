Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDE929B79B;
	Thu, 27 Aug 2026 04:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787803886; cv=none; b=aAVbs4jiTMBIXvDCd/LaKjAit4FtvA4B3/aD1xr9q/L7Z8HRKRQAT71GHsCCvMVEt+m1cGKQbj790TR76enm1YeU/MSbd6Rd0ALc2CECZe9PfHHKnHACpY9Jy7H13lkNiczHx9L2/gEUWcQ6iOSDRAgEfCb1gj0Kr3l769bsaKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787803886; c=relaxed/simple;
	bh=3BmwK8qB1JCaMvqoduBTInZdYWmthBfiUYl0IYaWZLY=;
	h=Date:To:From:Subject:Message-Id; b=qCICQHi/p9zR03/zhb97/JyTSIgZOIrBs2VwhjFXd+/CXVlDTt/5jNgdIUrcV6nbEcPbD5a10MXtiCyZp034DHKK86hN+FBFgFoKEPg02umrX48Hg8QNga1exMpjYfRO+Tmkpeb8INbOkKPrStROUrpEjSd8jycFhIyH7vBKnQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gxdvkjfy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gxdvkjfy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0869A1F00A3A;
	Thu, 27 Aug 2026 04:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787803885;
	bh=BN79+VBM70goSpS3Nnox0ErCOmTUZ1duH3qWeYLMnlY=;
	h=Date:To:From:Subject;
	b=Gxdvkjfyv2peDF5xfylMQgtL10msSsIVGSqRKRsqo88YLzj8xzJ1PrrfBubmt4ycM
	 VhYBUWT1SbCJUsbr+4UdzpLXt3mwqOthjoWWp3RcWLkp+6B5pUU8xHZAZHuwMESlDS
	 uHXwudVeKTaxgjwOofx4OGSXVb1qIh0/hH8O49Ks=
Date: Wed, 26 Aug 2026 21:11:24 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,neil@brown.name,manfred@colorfullife.com,jack@suse.cz,dave@stgolabs.net,brauner@kernel.org,4ncienth@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-mqueue-release-notification-resources-during-inode-eviction.patch added to mm-nonmm-unstable branch
Message-Id: <20260827041125.0869A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ipc/mqueue: release notification resources during inode eviction
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-mqueue-release-notification-resources-during-inode-eviction.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-mqueue-release-notification-resources-during-inode-eviction.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Assisted-by: LLM
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: NeilBrown <neil@brown.name>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

ipc-mqueue-release-notification-resources-during-inode-eviction.patch

