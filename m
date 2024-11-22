Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8228215688C;
	Fri, 22 Nov 2024 06:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732256409; cv=none; b=WLof5BePZyUUyuxFgjykvd7DAloRTONZgd7Sf5jxe67u7HLY2+jV1POgoJZwhCwrtuMqqxLlZTWcQAX/C58uawf1E+eO7iUVmW3TFcbUqe5K0CMvM6gVKqwgJn8mUr2vwymtOaDJViKD2XVxtuJ4Ollv8zMdhsONEbszGNyGsFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732256409; c=relaxed/simple;
	bh=faZCg7QNYZVCkfc5FqyfjhfHD5IKD9wmVRaisy99XRY=;
	h=Date:To:From:Subject:Message-Id; b=jyuqIdl8qgQ54mwxEDvb1razTBvqhw87w5VQ4B7H157m1PP7hoafWJDuDCVdN28Qw0Gbpsm1+gK2nfyCIDoDSANr4jxOOJN064K7o6GOO0ZU2rq3nj7cnXl6xtZaSI9d5Gol0AwU4epwlZkzlY27djOVE+mUJvHtSG/3SzadsQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qvIL+JG9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qvIL+JG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6BDFC4CECF;
	Fri, 22 Nov 2024 06:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732256409;
	bh=faZCg7QNYZVCkfc5FqyfjhfHD5IKD9wmVRaisy99XRY=;
	h=Date:To:From:Subject:From;
	b=qvIL+JG9qSOh8N8egxJvepI/ny8RFlf1heE0XKzgIFy0OtU4iiZXGNIEEMZzG4A1q
	 ZGlrmHaDJti4+9oYgSd/sxUI3slmzD0EXnKXsn3gqQS9OUBlnCQ/iBaNw25jwuQT42
	 k2Ggk+obdk57a82/uqTfGeETrxJ8Jed5ERU1sivM=
Date: Thu, 21 Nov 2024 22:20:06 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,Liam.Howlett@Oracle.com,cl@linux.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm.patch added to mm-hotfixes-unstable branch
Message-Id: <20241122062008.A6BDFC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: fix migrate_to_node() assuming there is at least one VMA in a MM
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/mempolicy: fix migrate_to_node() assuming there is at least one VMA in a MM
Date: Wed, 20 Nov 2024 21:11:51 +0100

We currently assume that there is at least one VMA in a MM, which isn't
true.

So we might end up having find_vma() return NULL, to then de-reference
NULL.  So properly handle find_vma() returning NULL.

This fixes the report:

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 UID: 0 PID: 6021 Comm: syz-executor284 Not tainted 6.12.0-rc7-syzkaller-00187-gf868cd251776 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
RIP: 0010:migrate_to_node mm/mempolicy.c:1090 [inline]
RIP: 0010:do_migrate_pages+0x403/0x6f0 mm/mempolicy.c:1194
Code: ...
RSP: 0018:ffffc9000375fd08 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffc9000375fd78 RCX: 0000000000000000
RDX: ffff88807e171300 RSI: dffffc0000000000 RDI: ffff88803390c044
RBP: ffff88807e171428 R08: 0000000000000014 R09: fffffbfff2039ef1
R10: ffffffff901cf78f R11: 0000000000000000 R12: 0000000000000003
R13: ffffc9000375fe90 R14: ffffc9000375fe98 R15: ffffc9000375fdf8
FS:  00005555919e1380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005555919e1ca8 CR3: 000000007f12a000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kernel_migrate_pages+0x5b2/0x750 mm/mempolicy.c:1709
 __do_sys_migrate_pages mm/mempolicy.c:1727 [inline]
 __se_sys_migrate_pages mm/mempolicy.c:1723 [inline]
 __x64_sys_migrate_pages+0x96/0x100 mm/mempolicy.c:1723
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Link: https://lkml.kernel.org/r/20241120201151.9518-1-david@redhat.com
Fixes: 39743889aaf7 ("[PATCH] Swap Migration V5: sys_migrate_pages interface")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: syzbot+3511625422f7aa637f0d@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/673d2696.050a0220.3c9d61.012f.GAE@google.com/T/
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/mempolicy.c~mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm
+++ a/mm/mempolicy.c
@@ -1080,6 +1080,10 @@ static long migrate_to_node(struct mm_st
 
 	mmap_read_lock(mm);
 	vma = find_vma(mm, 0);
+	if (!vma) {
+		mmap_read_unlock(mm);
+		return 0;
+	}
 
 	/*
 	 * This does not migrate the range, but isolates all pages that
_

Patches currently in -mm which might be from david@redhat.com are

mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm.patch

