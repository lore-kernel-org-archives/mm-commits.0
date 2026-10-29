Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793236510;
	b=ISVKM9W95gnIlJQff4XM15wQ4vVfqQdAFeVo7vbs+hH8i4zNsEe3S0k1XjOXzwLjuhw0
	 +vXz7P9fANeWX8YyqnWIAnw1av+hYRFu7shbmViUb4be8/PB4YkME74tVRX8caxdD0HAx
	 uRW54NEONZAhFzuQnOA0NHarSRi9HknRZ0MBDXNtHYK3kJfdfN5DYpKk3zAlDGCmQ1leD
	 ANd52l24x7R0ZtM3R7mkU9L7YMPKp/aXodkgNsQ6AwUGyuw6y51/+UHvKvmAUOss8OTyE
	 jNwKlLB2A071LGkbwfZGhj84YHDugxTFUhyQ5uQer9lU945zE3qIGv2yy05W0Z4KF4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793236510;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=fWZs2a0p8OxZhg0dWtEVAe6ZdhWNBF0uqVrm/x0mUdk=;
	b=vD6S73exZ9/uHd6JTF2Rr5AXqBtrZUKkSQCcedjAojfwgcgSkCcW6KpTIU3Ba5R9dRxi
	 LuGSYPrNoygw04oG2LDYWPkpssTUqJaS0/HFgS5SZCIrgVJl7ZvECrF5i+JuelNHCJbKL
	 qwn5W9bmtU6wFIgqBhq2VDBKMjBjqlsBhEMdToDr8J0xzHNQ/I48OGSWfHevudd0NJStd
	 c2RyFyEEh17X4vV/QiDA575kW9fVRhubaB5OMfQE1R/RevMk20Mzns35cLp6ujnZo+sf6
	 EVA1+0QSmvlN71t2cvb4+emblPA8ycp3EsEkLYRSYKKYYRAxtEDvebSW8B6ReCzZwjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XPFvycbc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB22606A322;
	Thu, 29 Oct 2026 01:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XPFvycbc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6005D1F01825;
	Thu, 29 Oct 2026 01:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793236509;
	bh=fWZs2a0p8OxZhg0dWtEVAe6ZdhWNBF0uqVrm/x0mUdk=;
	h=Date:To:From:Subject;
	b=XPFvycbcEtnfRaJiYjYmxPx67JC8WviwLMaN5c7OaxeuFStd3SuKA2p2/RUkoe9ni
	 sXFkTaUnewitiKZhoHXZbNWLsP7edutbYNFfwXh8vFgAjy08Gv221QNQGr9teOJ4p8
	 cf0JmcYvcc/dV6LGkk+zfsUvwLdCC0v0bBuX0ado=
Date: Wed, 28 Oct 2026 18:15:08 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,
	manfred@colorfullife.com,dave@stgolabs.net,david.laight.linux@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-msg-fix-saturation-of-percpu-counts-in-msgctl_info.patch added to mm-nonmm-unstable branch
Message-Id: <20261029011509.6005D1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ipc/msg: fix saturation of percpu counts in msgctl_info()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-msg-fix-saturation-of-percpu-counts-in-msgctl_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-msg-fix-saturation-of-percpu-counts-in-msgctl_info.patch

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
From: David Laight <david.laight.linux@gmail.com>
Subject: ipc/msg: fix saturation of percpu counts in msgctl_info()
Date: Wed, 19 Nov 2025 22:41:01 +0000

While the percpu_counter_sum() values are unlikely to be large the code
tries to saturate them using min_t(int, percpu_counter_sum(), INT_MAX)
This just doesn't work since the high bits are all masked and then the
(possibly negative) value assigned.

When aggregate System V message queue usage exceeds INT_MAX, MSG_INFO
returns wrapped statistics instead of saturating them.  At 2 GiB of queued
data the byte count becomes negative, and at 4 GiB it becomes zero. 
Consequently, ipcs -q -u can display an enormous used-space value or
report no queued data despite substantial usage.  Monitoring programs
using this interface can therefore substantially underreport or overreport
resource consumption.  The bug affects statistics; it does not corrupt
queued messages or alter queue-limit enforcement.

Replace the min_t() with a plain min().

Link: https://lore.kernel.org/20251119224140.8616-6-david.laight.linux@gmail.com
Fixes: 72d1e611082e ("ipc/msg: mitigate the lock contention with percpu counter")
Signed-off-by: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: <stable@vger.kernel.org>
---

 ipc/msg.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/ipc/msg.c~ipc-msg-fix-saturation-of-percpu-counts-in-msgctl_info
+++ a/ipc/msg.c
@@ -501,11 +501,9 @@ static int msgctl_info(struct ipc_namesp
 	max_idx = ipc_get_maxidx(&msg_ids(ns));
 	up_read(&msg_ids(ns).rwsem);
 	if (cmd == MSG_INFO) {
-		msginfo->msgmap = min_t(int,
-				     percpu_counter_sum(&ns->percpu_msg_hdrs),
+		msginfo->msgmap = min(percpu_counter_sum(&ns->percpu_msg_hdrs),
 				     INT_MAX);
-		msginfo->msgtql = min_t(int,
-		                     percpu_counter_sum(&ns->percpu_msg_bytes),
+		msginfo->msgtql = min(percpu_counter_sum(&ns->percpu_msg_bytes),
 				     INT_MAX);
 	} else {
 		msginfo->msgmap = MSGMAP;
_

Patches currently in -mm which might be from david.laight.linux@gmail.com are

ipc-msg-fix-saturation-of-percpu-counts-in-msgctl_info.patch

