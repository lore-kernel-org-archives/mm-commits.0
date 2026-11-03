Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672144;
	b=Z+KfrRLI6a7ZIbvnZsGKcm5EAW306462CYuEMyW1wYes1ZxA4KBWZ2jYdN826bpUXb5A
	 Mux5OHzzJPi1mMniy8c2gc+uEJzuERgpP5Cu392uP9y9cAWomqBopg7Beu6GTDRRd4sAw
	 8WfmVBPZYQmlvtnTdPRciTHVK2EUqL576BqQqOsdJ49xp9upbse/5eM8HqrU/4GZqSx+n
	 2C+Xfz3bDwcStZQ7qBsCv10v83SpMjYltAxfPQEqmI+BbD1mrcoIRHSuTkkdLS24uBCv2
	 G8gJFFAcWARG3rl9GLbXenTSaML8jUgGk33dxMZMAmpL1s2F8S05BaYhT0nnpHeeiew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672144;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=0hH4diZxkE9FYqMBlXHB0HpZuREEprMCduMPs/5JO+0=;
	b=yELMDDMzJC3NcehzyjZDYa8vdejyGOImw3gtJc9T9vpybWB92BRel4A2iLq5iPEQvt5N
	 sG+/ddizlvblrrJl7X+GujJGCaDoVSkSY//A+z1NNH4dIg+66AhIp8n0wt+/nnB26H3Wq
	 RuBPHATrXcmgV6lCpRds7KgF9Hxo8YxWqeOLwKYfUwbUmiVAitRdoSttOZAhFNDrc5Y4M
	 A7rbmB4DBnJH6aLeXMnyOu+GLVJ4bWcrVmzTRMjOlsHBZD9h0q9jpSyr0Ulx8cJZCWSj0
	 tb5alsHXYciH7t7wEtiBlanQ4OeOiLvObFXpkpBr2pf7zges+v7svgjvgXVOO8r1bwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zUsBBRll;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44760606A326;
	Tue,  3 Nov 2026 02:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zUsBBRll
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A0B1F00919;
	Tue,  3 Nov 2026 02:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672144;
	bh=0hH4diZxkE9FYqMBlXHB0HpZuREEprMCduMPs/5JO+0=;
	h=Date:To:From:Subject;
	b=zUsBBRllvN+l1ToWXDK2xF/7jMTJP+FrScis07yJS2ad7NlFrBaPrZPelGCd7omlB
	 bpVz5N37bQLUxWMXNbdbnWQXVCmnuuXyIVGD38XXM4L00ufA24ov143n+7GL4HAwYC
	 Mo3uvtPbwnYEde7ZPsFkra1U55aoMq8VZEYl+XhE=
Date: Mon, 02 Nov 2026 18:15:43 -0800
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,vineeth@bitbyteword.org,
	stable@vger.kernel.org,rafael.j.wysocki@intel.com,nphamcs@gmail.com,
	kelleynnn@gmail.com,kasong@tencent.com,hughd@google.com,
	huang.ying.caritas@gmail.com,chrisl@kernel.org,baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,baohua@kernel.org,chris@chrisdown.name,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-make-swapoff-interruptible-when-unusing-mms-shmem.patch removed from -mm tree
Message-Id: <20261103021544.00A0B1F00919@smtp.kernel.org>
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

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Chris Li <chrisl@kernel.org>
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


