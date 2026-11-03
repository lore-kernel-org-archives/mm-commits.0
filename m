Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675986;
	b=b/uyTd87i/JlIV97gY7+cHTdcYnOXR5B29SQM+ALa32FL/dX6t6cj/Uw7tQQXnDKpqnM
	 RDs7CaHPvPPR/iG3OlUfqLLxaVsiIMmeRpXRGYsFofvhWnxR7wDFLbwXDUS3g6kZeyDVB
	 K8a69IjqreywyK4zrodH2KVCxSpj1dC8e8b10WlC617890JlvEeon5L1hIAqHnzD9qGQX
	 ul2Zv4x2vgXhYjFUrM3bq6IPpmomhK9EB2q4b27bO4e1vUhESi6wWe3kBwkh/pgnm3max
	 RPzIICahvvebvXFMbToqtS1RPwJv1iFZSVJ4xaiJmeeojeI/VwM6lTtNrKIjw9a+GUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675986;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=7UG+xb093KvRm8QqGe9CSSwlCo+14SIzkI07ttcPZwQ=;
	b=O5Z6Og97y8A/VOEnqMjj85EfvPhn2qUeq7xxWURhEnHo3onxYQ9KT4/6Ep9PBxrYRyBL
	 xQLjaqg3eZfURMWtrwoyvLH2gBS3fBiPL1/1O6FT/BxN+lZ5VzNQo0AHEDhY69SLbj4GV
	 lMFALdobsjrFOdWD97LydTLfhvmMLuys7R+hcJHyqIm17LXGTUgxTjrRTXkPDumrzLCZq
	 mENlLWFocsRbAAzfeLEAHq3gG0+sCUh7EXyK7PMmQTqBZ8la34thYwJO/vkboqrpTQpIm
	 dxgtYjSk3SsO/wW8YSNCmwnDz8GDGiwCw8lojRA2Ste4ayn79WKjrVG/pXDzhUJAKnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="g/3yUGg+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A65606A33B
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 03:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=g/3yUGg+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9DA1F000C1;
	Tue,  3 Nov 2026 03:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793675986;
	bh=7UG+xb093KvRm8QqGe9CSSwlCo+14SIzkI07ttcPZwQ=;
	h=Date:To:From:Subject;
	b=g/3yUGg+ae1tlZXAwBfaPWkJ5YRorRCN8MyemeoO+Bz4wQI5p/g3+rFqQaMLpyj2r
	 py5eSNEWAQDEhpanK/3jJPQtjjg5M8sT4rfTazvpSGCmZfNmhthWZp3z3m0mDvalJa
	 Tg2TwicerBcqS1cv4xzyZChzF3QFel0/eMiKfulQ=
Date: Mon, 02 Nov 2026 19:19:46 -0800
To: mm-commits@vger.kernel.org,manfred@colorfullife.com,dave@stgolabs.net,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] maintainers-add-ipc-maintainers.patch removed from -mm tree
Message-Id: <20261103031946.6F9DA1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: MAINTAINERS: add an IPC entry
has been removed from the -mm tree.  Its filename was
     maintainers-add-ipc-maintainers.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: MAINTAINERS: add an IPC entry
Date: Tue, 27 Oct 2026 21:09:52 -0700

Add an entry covering ipc/ and its IPC and POSIX message queue selftests,
with Andrew Morton as maintainer and Manfred Spraul and Davidlohr Bueso as
reviewers.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Manfred Spraul <manfred@colorfullife.com>
---

 MAINTAINERS |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/MAINTAINERS~maintainers-add-ipc-maintainers
+++ a/MAINTAINERS
@@ -14070,6 +14070,16 @@ S:	Maintained
 F:	io_uring/bpf-ops.*
 F:	io_uring/loop.*
 
+IPC
+M:	Andrew Morton <akpm@linux-foundation.org>
+R:	Manfred Spraul <manfred@colorfullife.com>
+R:	Davidlohr Bueso <dave@stgolabs.net>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	ipc/
+F:	tools/testing/selftests/ipc/
+F:	tools/testing/selftests/mqueue/
+
 IPMI SUBSYSTEM
 M:	Corey Minyard <corey@minyard.net>
 L:	openipmi-developer@lists.sourceforge.net (moderated for non-subscribers)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mempolicy-use-one-node-set-for-interleave-weights.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

