Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793032395;
	b=BMHim4o7i+MM4aiNKS33rmqfK12XbLplUkKZhn5fEmbtkJyu4F11DwEvoS8CDMIuAqF/
	 f9xDNh8dofMli3eS54X9j1JNbv5vsxwzsjGVDXgN0BDc/kY+5Eq+4xLQm8lG6xCMklAZ/
	 mAonpo8rUUDati/SH9Orzl6plcQ5KTbUBj3Vi0aoQtcpUCHwHLRncQHZGt6TkzNaJTwya
	 7MSsp7faPb7lpcBVn9rkkJ5HZkiVokZxRgWOeF4oxg8gDzjhyHNwPuwdpMOnofq9OgsuH
	 oA9byY1tkzwyQGmRRXbKrRjIqz0mvNVzW/NVANiHPonnVv+m52u1WrMcAO7xKdiWnZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793032395;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=1VCZwIPwamlvsTk1sP/k2i2Si0s/9A++E/qyvuavR3w=;
	b=yOuv204c71o8IMLdh8a5LDWEAPiGIu3WdhPwJw4cygtg5WWYTY3QGL3KIDJtKUMqLMCS
	 qqnx7WvghBDfy5rPadTYgSp4Xi3m1Zlaw3ewmmRVZXVSVxJwFE9Artw8p1NL6M9lParhw
	 93VDyEREn9cLNaFZrTRgNxD4dFTyx1rjp1weonYOgY4/8C6m3DN7nHriDJcTWk6MBkQAP
	 VlNkbw41bb6cGIG1FGdYss4hei3gAmCGpHWPCBCP5WXbms7n+K25vO20MHFRT3BVeele7
	 H4P3d9FrwLFlDmb+tpWdu9V8QVYl+UkgcRxYZKwRQvrAnea0GUz5FhF2FtxAv0EhF1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NIfB1+5f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110FD606A31D
	for <mm-commits@vger.kernel.org>; Mon, 26 Oct 2026 16:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NIfB1+5f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA561F031E3;
	Mon, 26 Oct 2026 16:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793032394;
	bh=1VCZwIPwamlvsTk1sP/k2i2Si0s/9A++E/qyvuavR3w=;
	h=Date:To:From:Subject;
	b=NIfB1+5fTXo/SLbzBn5rI0bt8a/0iUTlfcoTmRQrYSNE0uH37URTWW4MTpA2onebx
	 4khCJz3XtNz6yuxy2916spamJym6UjxDtPcnEuzFCB5D46xX9knRQaY/PyAal9Y/UR
	 LtFlFQnT5WIcRoypU+RqAXdIXyi6BwYxKYubns9Q=
Date: Mon, 26 Oct 2026 09:33:14 -0700
To: mm-commits@vger.kernel.org,chris@chrisdown.name,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-make-swapoff-interruptible-when-unusing-mms-shmem.patch removed from -mm tree
Message-Id: <20261026163314.AAA561F031E3@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: make swapoff interruptible when unusing mms/shmem
has been removed from the -mm tree.  Its filename was
     mm-make-swapoff-interruptible-when-unusing-mms-shmem.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Chris Down <chris@chrisdown.name>
Subject: mm: make swapoff interruptible when unusing mms/shmem
Date: Thu, 1 Oct 2026 01:17:40 +0200

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

Link: https://lore.kernel.org/ar2YlFYjYUZ49ZA5@chrisdown.name
Fixes: b56a2d8af914 ("mm: rid swapoff of quadratic complexity")
Signed-off-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Ying Huang <huang.ying.caritas@gmail.com>
Cc: Kelley Nielsen <kelleynnn@gmail.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
---

 mm/shmem.c    |    4 ++++
 mm/swapfile.c |    2 ++
 2 files changed, 6 insertions(+)

--- a/mm/shmem.c~mm-make-swapoff-interruptible-when-unusing-mms-shmem
+++ a/mm/shmem.c
@@ -1742,6 +1742,10 @@ static int shmem_unuse_inode(struct inod
 		if (ret < 0)
 			break;
 
+		if (signal_pending(current)) {
+			ret = -EINTR;
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
+			return -EINTR;
 		next = pmd_addr_end(addr, end);
 		ret = unuse_pte_range(vma, pmd, addr, next, type);
 		if (ret)
_

Patches currently in -mm which might be from chris@chrisdown.name are


