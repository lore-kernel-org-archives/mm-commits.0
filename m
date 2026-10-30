Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793392090;
	b=pQebbq/nimVL0r8KDDhrI4Ifz1azoH8UMVGW5I2RGiFNu6QSpH8OuLwnBmWrJY8bhUPK
	 X0560A8zERr6oDPyq1xc3U/WW+p7ywFh/rNhZAnxZEnkMBFV32Mm0xk0LzMghlmhG76mD
	 MtwJyh1TXB8TRdHD1jOtpYA/NH/SOaFeFws9pktnlTT+nQP72lomnpjBMn6QP0dwYwcAM
	 ij/D1JsBifbTgedO9cPOsSZnfUaneyYq48dahvyzk+TAOD2DP4zqiTQKqwWcnctQYfjmr
	 +BdqtVAo1sBu+tAv9KWXXNIL+y+bqbc0m4t9LAx8ao2qQEBWaD1Fj75MYPSvTHY0t8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793392090;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=RW+A8KUkPUW8u4ItKZ+MDfriOpwChwBjtfOxkA6GnU0=;
	b=QNXOAiSRDhv/bMkACcQSRLg2MJhO1owNLtWW/4BWN8QOa9JiFoxCg7sE9IYkbY1qaWCv
	 c9pROuH/Byzq6wo784XBVMvhVAFQRlVcspoxTkfd/tZC2D3MYB0FH5LPM1M00kBG1Qt+q
	 0mQYRLyFoi/uGf5crTPS2XKui5yFq/TLNTsRXF24xy91BzQrKNXd34l1Rr8ZODU/0wQYF
	 KhqNr/XmJ+Etk3RxcdNYMqEPF2PtwrNdEIN+P6PPNXpTlHiv2nIhvDC8PJ3N9wfe2PeyP
	 nZ/bXpX+aU0S0TMe7HHgajrmlX2XWYDop4/CDZqsyn6/uuSrTiZVi7DpI7g9W8fYWKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SZiS6f0G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2E6606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 20:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SZiS6f0G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256341F0093A;
	Fri, 30 Oct 2026 20:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793392089;
	bh=RW+A8KUkPUW8u4ItKZ+MDfriOpwChwBjtfOxkA6GnU0=;
	h=Date:To:From:Subject;
	b=SZiS6f0G/XDy1cz7vBGEcduR4uclr32V7Q4IFBU5+IJmKOBnM9WyeuTnOprBw8+pE
	 zqrXes9fIi80jAUqtAn6OkrXrk8/3oysBzbAri0Ai+NG1qxsp1RdfYTpFhGIpViLj5
	 HwgnOBSSKzzaELKPjXyXg6XFAgZLE2i8THSewRkg=
Date: Fri, 30 Oct 2026 13:28:08 -0700
To: mm-commits@vger.kernel.org,richard120310@gmail.com,
	handyhandyman.adam@gmail.com,nickolai@csail.mit.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-plist-add-a-plist_test-case-for-plist_requeue-on-the-last-priority-bucket.patch added to mm-nonmm-unstable branch
Message-Id: <20261030202809.256341F0093A@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: lib/plist: add a plist_test case for plist_requeue() on the last priority bucket
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-plist-add-a-plist_test-case-for-plist_requeue-on-the-last-priority-bucket.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-plist-add-a-plist_test-case-for-plist_requeue-on-the-last-priority-bucket.patch

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
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: lib/plist: add a plist_test case for plist_requeue() on the last priority bucket
Date: Sun, 11 Oct 2026 07:51:34 -0400

The plist_requeue() shortcut inserted the node at the head of the list
when the node was the first of the last priority bucket and had a
successor of the same priority, with an earlier bucket present (fixed by
43c91b152243 "lib/plist: fix plist_requeue() corrupting order in the last
bucket").

The CONFIG_DEBUG_PLIST self-test did not catch it: it only requeues nodes
it has just added, which are always the last of their bucket, so
plist_requeue() returned early every time.

Add a deterministic case for the failing shape: A(1) B(2) C(2), requeue B.
The expected result is A(1) C(2) B(2), with B at the end of the list; the
broken shortcut produced B(2) A(1) C(2).  Check it with a WARN() rather
than a BUG_ON(), and skip plist_test_check() when the warning fires, since
its BUG_ON()s would stop the boot on the misordered list; the node_list
and prio_list links of the result are still verified by plist_test_check()
when the order is right.

Boot-tested on QEMU virt with a riscv64 defconfig kernel plus
CONFIG_DEBUG_PLIST=y, built with LLVM=1.  With the fix applied the test
passes and the boot proceeds.  With the fix reverted the warning fires at
boot and the boot proceeds:

  [    0.864761] start plist test
  [    0.871849] ------------[ cut here ]------------
  [    0.871905] plist_requeue() put the node in front of the list
  [    0.872921] WARNING: lib/plist.c:295 at plist_test+0x33a/0x342, CPU#0: swapper/0/1
  ...
  [    0.885968] ---[ end trace 0000000000000000 ]---
  [    0.887060] end plist test

Link: https://lore.kernel.org/20261011115136.767838-1-nickolai@csail.mit.edu
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Adam Harshbarger <handyhandyman.adam@gmail.com>
Cc: I Hsin Cheng <richard120310@gmail.com>
---

 lib/plist.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/lib/plist.c~lib-plist-add-a-plist_test-case-for-plist_requeue-on-the-last-priority-bucket
+++ a/lib/plist.c
@@ -283,6 +283,27 @@ static int  __init plist_test(void)
 		plist_test_check(nr_expect);
 	}
 
+	/*
+	 * Requeue a node which is the first of the last priority run and has
+	 * a successor of the same priority, with an earlier run present: the
+	 * shortcut in plist_requeue() must append it at the end of the list,
+	 * not in front of the first run.  The random test above never
+	 * exercises this, since it only requeues nodes it has just added,
+	 * which are always the last of their run.  On failure warn and skip
+	 * plist_test_check(), which would BUG_ON() the misordered list.
+	 */
+	plist_head_init(&test_head);
+	for (i = 0; i < 3; i++) {
+		plist_node_init(test_node + i, i ? 2 : 1);
+		plist_add(test_node + i, &test_head);
+	}
+	plist_test_requeue(test_node + 1);
+	if (!WARN(plist_last(&test_head) != test_node + 1,
+		  "plist_requeue() put the node in front of the list\n"))
+		plist_test_check(3);
+	for (i = 0; i < 3; i++)
+		plist_del(test_node + i, &test_head);
+
 	printk(KERN_DEBUG "end plist test\n");
 
 	/* Worst case test for plist_add() */
_

Patches currently in -mm which might be from nickolai@csail.mit.edu are

xarray-clear-the-new-heads-parent-before-freeing-the-old-head.patch
panic-zero-the-dynamically-allocated-taint-buffer.patch
lib-plist-add-a-plist_test-case-for-plist_requeue-on-the-last-priority-bucket.patch

