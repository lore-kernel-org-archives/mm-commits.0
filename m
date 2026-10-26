Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793032455;
	b=PFnQi+A1rdfOEGj+Az/Y0ar62eQqStnnukonVpQKbZXHVCQCuRRMjAy+M3AyH8xx9p+Y
	 a1pLhayqzp9zLzkImF0DM7kyJRFRxFsezAVuHxXpJ33H6fZ4cUVEnamr5Ut1YE1dpYkD7
	 FqsDd05YpeM9Vh1yy7+TgNkTPGQHCxZ7Ud/Q6B644tkokFP7KHZMqbHdV2qyCsP70wmtP
	 /GTR9sO7bUPYNXJikeCkXmFsWNzpJ3BZeubQ+Ljtk+F3bulAxAa9NTXZ+o6kc7bGYVUrs
	 v66KA5Lq9aPXJhNtIALyttXSc17wPXWd2PQH3+gPzh8Zu9YmZ2blJq2CXsD4jbghDrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793032455;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=eWt0zO4FIEpNCxPbARY7hsSEE/JUtBJIPu6Hlw0RxH0=;
	b=pOdsn2OITpBbdh3LG+dr4Ups9F+xHqc9bXgPZks7NAFWK2r8FEePCJ7tWqjVS0TVQMl9
	 2RtJ38AI+lqOv893lSJj5zuNdvzgb+F2wzkfOSgoXCyq7gA0/cYOi/QSk4cBQXr0A3ZXD
	 hk85/uWT5DnEO9LAt0xyNY3mtUxJd0TYwEUh5RdGe3iavCzy5u1LMbeFLHM0whUhInsdC
	 vkP2vEXcbJi746FDUGb3d4iSRGaWi3CG/ttNtO3ecHwpQy6Swpk3uF69F7fojQRK4x108
	 zm2v8Ia4X5r+Nj7NaPzAmeZn5BQ9V7BZTXv9cfE78qG1a1Gz7qu9Pc1onfERVQksT2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="qMBbmr/t";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4819E606A31A;
	Mon, 26 Oct 2026 16:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qMBbmr/t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C352F1F031E0;
	Mon, 26 Oct 2026 16:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793032454;
	bh=eWt0zO4FIEpNCxPbARY7hsSEE/JUtBJIPu6Hlw0RxH0=;
	h=Date:To:From:Subject;
	b=qMBbmr/tV8T2nwO2jSQKmH372uEnA//Xjg62B6PYZ6u2Cun0GljONYbv5PaQFl0yP
	 mGDnD79DYI4oBDMinixFIKq/94PTDs6TO0UCYgweaLs9uqvrPHnk8g2al8soAG1VMD
	 qzdHK+vYXZXW3jdscIQErepT9Gak8gAyEvIF6E5w=
Date: Mon, 26 Oct 2026 09:34:14 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,vineeth@bitbyteword.org,
	stable@vger.kernel.org,rafael.j.wysocki@intel.com,nphamcs@gmail.com,
	kelleynnn@gmail.com,kasong@tencent.com,hughd@google.com,
	huang.ying.caritas@gmail.com,chrisl@kernel.org,baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,baohua@kernel.org,chris@chrisdown.name,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-swapoff-interruptible-when-unusing-mms-shmem.patch added to mm-unstable branch
Message-Id: <20261026163414.C352F1F031E0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: make swapoff interruptible when unusing mms/shmem
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-swapoff-interruptible-when-unusing-mms-shmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-swapoff-interruptible-when-unusing-mms-shmem.patch

This patch will later appear in the mm-unstable branch at
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
From: Chris Down <chris@chrisdown.name>
Subject: mm: make swapoff interruptible when unusing mms/shmem
Date: Mon, 26 Oct 2026 22:31:03 +0800

try_to_unuse() only checks for a pending signal between mms, and
shmem_unuse() doesn't check at all.  That means that once swapoff gets to
a process or a shmem file with a lot swapped out, nothing can interrupt it
until every last page of it has been read back in.

Just as one example of where this can concretely show up, freezing tasks
for suspend or hibernation has to wait for swapoff to notice the freezer's
fake signal, and gives up after freeze_timeout_msecs (20 seconds by
default).

Here's a facetious example where one swaps out 2GiB of one process to a
swap file on ext4, starts swapoff, and half a second later tries to freeze
with pm_test=freezer.  Writing to /sys/power/state then fails with EBUSY
and this in dmesg:

    Freezing user space processes failed after 20.003 seconds (1 tasks refusing to freeze, wq_busy=0):
    task:swapoff         state:D stack:0     pid:3175  tgid:3175  ppid:2955   task_flags:0x400100 flags:0x00000419
    Call trace:
     [...]
     io_schedule+0x44/0x70
     folio_wait_bit_common+0x1ec/0x3d0
     __folio_lock+0x24/0x40
     unuse_pte_range+0x2d0/0x348
     unuse_vma+0x158/0x248
     unuse_mm+0xfc/0x150
     try_to_unuse+0x104/0x3f8
     __do_sys_swapoff+0x220/0x5d8
     [...]

The same goes for anything else that wants swapoff to stop, like an admin
hitting ^C in a panic, of course.

Prior to commit b56a2d8af914 ("mm: rid swapoff of quadratic complexity")
try_to_unuse() was driven by find_next_to_unuse() which checks for a
signal before every entry, so let's restore that behaviour.

Just as an example of the improvements, here's how long freezing takes
in the same test while swapoff is happening on my computer:

                      before                  after
    400MiB anon       8.925s                  0.028s
    400MiB shmem      1.639s                  0.003s
    2GiB anon         failed after 20.003s    0.011s

Link: https://lore.kernel.org/at9kJwdGkHPsWwgG@chrisdown.name
Fixes: b56a2d8af914 ("mm: rid swapoff of quadratic complexity")
Signed-off-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Ying Huang <huang.ying.caritas@gmail.com>
Cc: Kelley Nielsen <kelleynnn@gmail.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: <stable@vger.kernel.org>
---

 mm/shmem.c    |    4 ++++
 mm/swapfile.c |    4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~mm-make-swapoff-interruptible-when-unusing-mms-shmem
+++ a/mm/shmem.c
@@ -1742,6 +1742,10 @@ static int shmem_unuse_inode(struct inod
 		if (ret < 0)
 			break;
 
+		if (signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
 		start = indices[folio_batch_count(&fbatch) - 1];
 	} while (true);
 
--- a/mm/swapfile.c~mm-make-swapoff-interruptible-when-unusing-mms-shmem
+++ a/mm/swapfile.c
@@ -2689,6 +2689,8 @@ static inline int unuse_pmd_range(struct
 	pmd = pmd_offset(pud, addr);
 	do {
 		cond_resched();
+		if (signal_pending(current))
+			return -ERESTARTSYS;
 		next = pmd_addr_end(addr, end);
 		ret = unuse_pte_range(vma, pmd, addr, next, type);
 		if (ret)
@@ -2922,7 +2924,7 @@ retry:
 	if (swap_usage_in_pages(si)) {
 		if (!signal_pending(current))
 			goto retry;
-		return -EINTR;
+		return -ERESTARTSYS;
 	}
 
 success:
_

Patches currently in -mm which might be from chris@chrisdown.name are

mm-make-swapoff-interruptible-when-unusing-mms-shmem.patch

