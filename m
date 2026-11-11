Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794434993;
	b=Inq5qALiozFPJgYLI3Z46xLyDpGmAkAG7qjeHfvG+3j7qN/FEphzx0wBTc65YqL4qSZS
	 SJriqUWV1Slp8MZ0QGImIyIQyr8NcXAmTI9sXkN+uo3TgtNlBd5LXOmk8SOCza/N1/NBF
	 amwOj1IEumB/JPFX1/MiEdnFC5D/ky2ueijDuwgVXeVPnpX3RVlniEgOweItN13+YkJpv
	 Z10TMEgSiHQgLhZAh9qHzXPIu1ZtZjK05HKmQA/OONyJoQwDpAdB9F5RZZADz/iEuC/HP
	 r/CBuX4rkbej6hKCM97GZF1L5h4Ip0hkAQcimbYHrd5eed67r1gY7TcnH2uM9cJoH0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794434993;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=aV6/OyN4Y/zhBMtJhzeIbASSk68Kg1E+PiA2L1niL7Y=;
	b=EeLgs7/E4eAV1Z5LH9S9qLAMZ8rHqZTh1/+QOKJrNkxY6kc9HduuiRsrRsvF32V+ls/i
	 cfMGnHlsmS3KLouZke4HZRGmYTRM/vfM9BABF6C0yXQ2fIMWzSkPi/4cTFxPJaMb4lBfb
	 nJI0FwT6f6TOnDkbsiSGZ5DB4VQDlPBA9M8HVmD5oo1efegYtaqJIMIMLxqGEHClk7X9j
	 I+AZLFSvaxc/ZG9Af5L/k/xE3H6RQBIkLlfVRrX7BIj3wBPRSTSqYo3dVvBWQogqpH/fp
	 LAXPHcD+pn4SUqElLzIYB0yEHC6I95Ck6bHcU6jj7v90YtaIbyoYhRfJ6v3Q2a1h/wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bcRGedr3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BBD606A31C
	for <mm-commits@vger.kernel.org>; Wed, 11 Nov 2026 22:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bcRGedr3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DEA1F00A05;
	Wed, 11 Nov 2026 22:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794434992;
	bh=aV6/OyN4Y/zhBMtJhzeIbASSk68Kg1E+PiA2L1niL7Y=;
	h=Date:To:From:Subject;
	b=bcRGedr3IquLejLpQf+NbURyqUg9OJbpEVatmRvkT1qBFgSjTq4bicNve9tnhBcMh
	 9JwdY8U8VonQecsmsP3Rnsji6M3yeyXTocWveaFnTuwE835jKAk1vWNJj+6dp9prB8
	 Ia51SOikML43cz++To38tnlsBeJSYtsqQCexq74U=
Date: Wed, 11 Nov 2026 14:09:51 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,
	liam@infradead.org,dchar@cslab.ece.ntua.gr,andrewjballance@gmail.com,
	aliceryhl@google.com,florian.schmaus@codasip.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + test_maple_tree-test-maple_range_64-node-below-the-root-in-rcu-mode.patch added to mm-new branch
Message-Id: <20261111220952.B4DEA1F00A05@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: test_maple_tree: test maple_range_64 node below the root in RCU mode
has been added to the -mm mm-new branch.  Its filename is
     test_maple_tree-test-maple_range_64-node-below-the-root-in-rcu-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/test_maple_tree-test-maple_range_64-node-below-the-root-in-rcu-mode.patch

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
From: Florian Schmaus <florian.schmaus@codasip.com>
Subject: test_maple_tree: test maple_range_64 node below the root in RCU mode
Date: Mon, 02 Nov 2026 10:14:10 +0100

Commit baed735a956f ("maple_tree: fix maple_range_64 crashes in RCU mode")
fixed mt_free_walk() taking the metadata in the last slot of a
maple_range_64 node with 15 children for a child node.  The bug only
affects nodes at least two levels above the leaves.  The test added along
with the fix, check_range64_in_rcu(), uses a height 3 tree, in which the
root is the only such node.

The height 3 tree only exposes the bug because the same commit also
removed mt_clear_meta(), which used to clear the metadata of the root.  On
the code before that commit, the bug is only reachable below the root, and
the height 3 tree is destroyed without a crash.  If the metadata of the
root were cleared again, the existing test would no longer detect the bug.

Add a height 4 tree in which a child of the root has 15 children and keeps
its metadata in the last slot.  5191 insertions produce such a tree on a
64-bit build.  Destroying it crashes without the mt_free_walk() fix, with
or without mt_clear_meta().  For example, on the code before the fix, the
userspace test harness reports:

  lib/maple_tree.c:4755:27: runtime error: member access within
  misaligned address 0x00000000000e for type 'struct maple_node'

Link: https://lore.kernel.org/20261102-maple-tree-fix-slab-corruption-v2-1-d0037f04ecd6@codasip.com
Signed-off-by: Florian Schmaus <florian.schmaus@codasip.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
---

 lib/test_maple_tree.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/lib/test_maple_tree.c~test_maple_tree-test-maple_range_64-node-below-the-root-in-rcu-mode
+++ a/lib/test_maple_tree.c
@@ -3738,6 +3738,19 @@ static noinline void __init check_range6
 
 	mtree_destroy(mt);
 	rcu_barrier();
+
+	nr_entries = 5191; /* Height 4. Root child has 15 children + metadata */
+
+	MT_BUG_ON(mt, !mtree_empty(mt));
+	mt_init_flags(mt, MT_FLAGS_USE_RCU);
+
+	for (i = 0; i < nr_entries; i++) {
+		MT_BUG_ON(mt, mtree_test_insert_range(mt, i*10, i*10 + 9,
+						      xa_mk_value(i)));
+	}
+
+	mtree_destroy(mt);
+	rcu_barrier();
 }
 
 /*
_

Patches currently in -mm which might be from florian.schmaus@codasip.com are

test_maple_tree-test-maple_range_64-node-below-the-root-in-rcu-mode.patch

