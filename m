Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793292960;
	b=PzO9digIU9M8jlPLsXanTUBJ4cCEk+JG9RCUVV9yJtpedfuX8x19XAMu3+kylIq0bUaZ
	 Dd1j8i8kL0ZYMQ2AHKo0J+OKkm9zBj37Dn1uMkJap6W4xwfSjgmqS1YWVp4ppReR64Ets
	 up9UzC0Ug6QGl6mniCDjXyzXO9NdVp2SJ2/nmcjIyt8Vni0Sr8UwN2RSSUqZliUniCssr
	 9MSC/174xlVb5VBXyd90ceMzdmICI+lh/m1DjQpkaP6e2FxHe2jx+xjIO52WrkTco+VH/
	 86QNLohlAxF1lEhPEWapk7DOYXszyxNS9IKSvZ2ChPj9ifH9fsl5I7w1Rmt5aF6jUhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793292960;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=fKvoRFx+zKw//nZlgv4hjRXcDNa9rUsZtEbw0zBtXWM=;
	b=OGgGS8f1MDs9ZAbT/1xBdgL17+qIW7sJy8Nx1f1mEJaP+t//pzaLiUTkI3ioifZ9xxQi
	 Eu07xOrBIqRXrktZDW7YgnS57E/zLj0e2tKFfokHh25EoY3Alu6qhKj5R37yZ6hBAuK+g
	 rxp7+6ykgY0z+Iw2XSAeS/1jGHxtfSNcTxThJBNCdlxwk39G97ZDDRI1v4s1K1hBHhrUL
	 +RmdbI62eEHRCkgMk501ASF4ZALrgTzz8gNB/EQJZm/K9a0/0UUmKuKplq56+ZK8RLbJO
	 UhlUEvEkFPeqKHsO3v7b4YToTBFNCMjwWgGj/Up8V5UUkU1bB3QGr/3n+w4RrCBHEKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=TwY4t7NP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32331606A31C;
	Thu, 29 Oct 2026 16:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=TwY4t7NP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51291F01816;
	Thu, 29 Oct 2026 16:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793292959;
	bh=fKvoRFx+zKw//nZlgv4hjRXcDNa9rUsZtEbw0zBtXWM=;
	h=Date:To:From:Subject;
	b=TwY4t7NPHduXi3gVOz39ENsLjKQ1JgHpf54Sb35Xuw+RdjVLXcKkQlRibLFybFUxN
	 /iXChb/BCAiHEqoklro/X5wqCpp3XLcosMjfoDIVa/lm0pRJBkoFqPXS8/TbDNoklm
	 O7jxN+AHNY0BFS3jlOKOfeeKp6rjsb8OIQqlO2Vs=
Date: Thu, 29 Oct 2026 09:55:59 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,
	manfred@colorfullife.com,david.laight.linux@gmail.com,dave@stgolabs.net,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-msg-clamp-negative-msg_info-usage-counts.patch added to mm-nonmm-unstable branch
Message-Id: <20261029165559.B51291F01816@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ipc/msg: clamp negative MSG_INFO usage counts
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-msg-clamp-negative-msg_info-usage-counts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-msg-clamp-negative-msg_info-usage-counts.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc/msg: clamp negative MSG_INFO usage counts
Date: Thu, 29 Oct 2026 01:43:24 +0000

MSG_INFO can report negative usage during ordinary queue traffic.  For
example, ipcs -q -u prints negative header counts and converts negative
byte counts into enormous unsigned used-space values.

percpu_counter_sum() can sample the sending CPU before an enqueue and the
receiving CPU after the matching dequeue, yielding a negative total. 
Clamp both counts to [0, INT_MAX] before converting to int.  The
statistics remain an approximate, non-atomic snapshot.

Fixes: 72d1e611082e ("ipc/msg: mitigate the lock contention with percpu counter")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: <stable@vger.kernel.org>
---

 ipc/msg.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/ipc/msg.c~ipc-msg-clamp-negative-msg_info-usage-counts
+++ a/ipc/msg.c
@@ -501,10 +501,10 @@ static int msgctl_info(struct ipc_namesp
 	max_idx = ipc_get_maxidx(&msg_ids(ns));
 	up_read(&msg_ids(ns).rwsem);
 	if (cmd == MSG_INFO) {
-		msginfo->msgmap = min(percpu_counter_sum(&ns->percpu_msg_hdrs),
-				     INT_MAX);
-		msginfo->msgtql = min(percpu_counter_sum(&ns->percpu_msg_bytes),
-				     INT_MAX);
+		msginfo->msgmap = clamp(percpu_counter_sum(&ns->percpu_msg_hdrs),
+					0, INT_MAX);
+		msginfo->msgtql = clamp(percpu_counter_sum(&ns->percpu_msg_bytes),
+					0, INT_MAX);
 	} else {
 		msginfo->msgmap = MSGMAP;
 		msginfo->msgpool = MSGPOOL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

openrisc-export-mulsi3.patch
maintainers-add-ipc-maintainers.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

