Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0292A282EE
	for <mm-commits@vger.kernel.org>; Sat, 26 Apr 2025 01:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745629747; cv=none; b=jGH2JXjvRBlj+ZJQF+4fdcXFENf0bkxGxVt2K82zHztp6TL/kUOjDrJCjjj1SfOr1Aa/VDkYAxBZjRgM44cOBJ8S9EWht7Z6mKX2iiNl7xAp/9DOiQ9Tyx9ZCh3uUkgPN6HWXUgP+EQnGCU/DDdFZLctgMyB25bNeDBHNiJl1e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745629747; c=relaxed/simple;
	bh=+jpXxqpfBD7ryXVej2QzIh8YlLoRQeM+XSYxX7I4x4Q=;
	h=Date:To:From:Subject:Message-Id; b=F0+Ey/l/C/B9jKBGhFoM8aJW6roFsPHijhJ9kqH7gCHaw89R5BeWu7Sxlananb9jevl663YmzimInzY5HRqO7FIE+SlPOvBwEREmq78pgUGsc/xWULrr0DDwkFVb7lo0zaATz/9cAfwq0AX7FPDortKt57j/9K3DOKZuwbxTTOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rf8G6JYc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rf8G6JYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B68C4CEE4;
	Sat, 26 Apr 2025 01:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745629746;
	bh=+jpXxqpfBD7ryXVej2QzIh8YlLoRQeM+XSYxX7I4x4Q=;
	h=Date:To:From:Subject:From;
	b=Rf8G6JYcHuDib5njLId6wympwf8noZEoHGsZi4rdR2V75rtrGmMh24Bf3wLt01/9Y
	 kFd/i+fT6H/58yTvP2fPmEhQTbgR7u1fEU2eUdXgYb99ofvdQ9GFx5rRUqp6HXdjk7
	 JQ7KGUuT2zIlyJSCXGon0lkM2ZPhfIQde/Aqvy28=
Date: Fri, 25 Apr 2025 18:09:06 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-fix-mapcount-refcount-sanity-check-for-mthp-reuse.patch added to mm-hotfixes-unstable branch
Message-Id: <20250426010906.C1B68C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: fix mapcount / refcount sanity check for mTHP reuse
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-fix-mapcount-refcount-sanity-check-for-mthp-reuse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-fix-mapcount-refcount-sanity-check-for-mthp-reuse.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/memory: fix mapcount / refcount sanity check for mTHP reuse
Date: Fri, 25 Apr 2025 15:43:25 +0800

The following WARNING was triggered during swap stress test with mTHP
enabled:

[ 6609.335758] ------------[ cut here ]------------
[ 6609.337758] WARNING: CPU: 82 PID: 755116 at mm/memory.c:3794 do_wp_page+0x1084/0x10e0
[ 6609.340922] Modules linked in: zram virtiofs
[ 6609.342699] CPU: 82 UID: 0 PID: 755116 Comm: sh Kdump: loaded Not tainted 6.15.0-rc1+ #1429 PREEMPT(voluntary)
[ 6609.347620] Hardware name: Red Hat KVM/RHEL-AV, BIOS 0.0.0 02/06/2015
[ 6609.349909] RIP: 0010:do_wp_page+0x1084/0x10e0
[ 6609.351532] Code: ff ff 48 c7 c6 80 ba 49 82 4c 89 ef e8 95 fd fe ff 0f 0b bd f5 ff ff ff e9 43 fb ff ff 41 83 a9 bc 12 00 00 01 e9 5c fb ff ff <0f> 0b e9 a6 fc ff ff 65 ff 00 f0 48 0f b
a 6d 00 1f 0f 83 82 fc ff
[ 6609.357959] RSP: 0000:ffffc90002273d40 EFLAGS: 00010287
[ 6609.359915] RAX: 000000000000000f RBX: 0000000000000000 RCX: 000fffffffe00000
[ 6609.362606] RDX: 0000000000000010 RSI: 000055a119ac1000 RDI: ffffea000ae6ec00
[ 6609.365143] RBP: ffffea000ae6ec68 R08: 84000002b9bb1025 R09: 000055a119ab6000
[ 6609.367569] R10: ffff8881caa2ad80 R11: 0000000000000000 R12: ffff8881caa2ad80
[ 6609.370255] R13: ffffea000ae6ec00 R14: 000055a119ac1c9c R15: ffffc90002273dd8
[ 6609.373007] FS:  00007f08e467f740(0000) GS:ffff88a07c214000(0000) knlGS:0000000000000000
[ 6609.375999] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6609.377946] CR2: 000055a119ac1c9c CR3: 00000001adfd6005 CR4: 0000000000770eb0
[ 6609.380376] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6609.382853] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 6609.385216] PKRU: 55555554
[ 6609.386141] Call Trace:
[ 6609.387017]  <TASK>
[ 6609.387718]  ? ___pte_offset_map+0x1b/0x110
[ 6609.389056]  __handle_mm_fault+0xa51/0xf00
[ 6609.390363]  ? exc_page_fault+0x6a/0x140
[ 6609.391629]  handle_mm_fault+0x13d/0x360
[ 6609.392856]  do_user_addr_fault+0x2f2/0x7f0
[ 6609.394160]  ? sigprocmask+0x77/0xa0
[ 6609.395375]  exc_page_fault+0x6a/0x140
[ 6609.396735]  asm_exc_page_fault+0x26/0x30
[ 6609.398224] RIP: 0033:0x55a1050bc18b
[ 6609.399567] Code: 8b 3f 4d 85 ff 74 40 41 39 5f 18 75 f2 49 8b 7f 08 44 38 27 75 e9 4c 89 c6 4c 89 45 c8 e8 bd 83 fa ff 4c 8b 45 c8 85 c0 75 d5 <41> 83 47 1c 01 48 83 c4 28 4c 89 f8 5b 4
1 5c 41 5d 41 5e 41 5f 5d
[ 6609.405971] RSP: 002b:00007ffcf5f37d90 EFLAGS: 00010246
[ 6609.407737] RAX: 0000000000000000 RBX: 00000000182768fa RCX: 0000000000000000
[ 6609.410151] RDX: 00000000000000fa RSI: 000055a105175c7b RDI: 000055a119ac1c60
[ 6609.412606] RBP: 00007ffcf5f37de0 R08: 000055a105175c7b R09: 0000000000000000
[ 6609.414998] R10: 000000004d2dfb5a R11: 0000000000000246 R12: 0000000000000050
[ 6609.417193] R13: 00000000000000fa R14: 000055a119abaf60 R15: 000055a119ac1c80
[ 6609.419268]  </TASK>
[ 6609.419928] ---[ end trace 0000000000000000 ]---

The WARN_ON here is simply incorrect.  The refcount here must be at least
the mapcount, not the opposite.  Each mapcount must have a corresponding
refcount, but the refcount may increase if other components grab the
folio, which is acceptable.  Meanwhile, having a mapcount larger than
refcount is a real problem.

So fix the WARN_ON condition.

Link: https://lkml.kernel.org/r/20250425074325.61833-1-ryncsn@gmail.com
Fixes: 1da190f4d0a6 ("mm: Copy-on-Write (COW) reuse support for PTE-mapped THP")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reported-by: Kairui Song <kasong@tencent.com>
Closes: https://lore.kernel.org/all/CAMgjq7D+ea3eg9gRCVvRnto3Sv3_H3WVhupX4e=k8T5QAfBHbw@mail.gmail.com/
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-fix-mapcount-refcount-sanity-check-for-mthp-reuse
+++ a/mm/memory.c
@@ -3751,7 +3751,7 @@ static bool __wp_can_reuse_large_anon_fo
 
 	/* Stabilize the mapcount vs. refcount and recheck. */
 	folio_lock_large_mapcount(folio);
-	VM_WARN_ON_ONCE(folio_large_mapcount(folio) < folio_ref_count(folio));
+	VM_WARN_ON_ONCE_FOLIO(folio_large_mapcount(folio) > folio_ref_count(folio), folio);
 
 	if (folio_test_large_maybe_mapped_shared(folio))
 		goto unlock;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memory-fix-mapcount-refcount-sanity-check-for-mthp-reuse.patch

