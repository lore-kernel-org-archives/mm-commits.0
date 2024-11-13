Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2044915A8
	for <mm-commits@vger.kernel.org>; Wed, 13 Nov 2024 00:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731456120; cv=none; b=ZZf9SBg4ffOK8hGHJQDuALDyxceddiihUTM2LXx10/QNddBa11aMnj4jQFCf86SO8nBFzljQVKmd/+IfOBRzvq/TWXCWKJYHabk6GAmT+Goc66eYGlGVkIW1MiNjMFk+NjNBKaAyY/9uNVUdk1H8PqlE+dZfnAPNu8UtfWPWt74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731456120; c=relaxed/simple;
	bh=Sv1hgN0UqGLSkqYvQtbkoLO9gzy0kmo4K1C2Ixn5vO0=;
	h=Date:To:From:Subject:Message-Id; b=CXz+3qrAUzR3rDK7z4/mi6lD4PBi4vcvaugXmcipI6CbybdZmsgMRgZZlgI/rYbMNRV1fMPRkoOLT52jZKL4NTSgFj+7CGAyfeBNJMvGCUKaY5vaud8bzS6rtN9P+gA+rWpi2tokNSzglaMEg907sYkCeZPg7aBMtIQ+ANN+uhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NRhQOBCX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NRhQOBCX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BB5C4CED0;
	Wed, 13 Nov 2024 00:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731456119;
	bh=Sv1hgN0UqGLSkqYvQtbkoLO9gzy0kmo4K1C2Ixn5vO0=;
	h=Date:To:From:Subject:From;
	b=NRhQOBCXYp/18B5123Tzx4u5gUJMJRC43HBU6KoK2XnNL57Gy0y/90YwsnqlcfUrl
	 2zTo8sWzD6wHL1vtfV7Z9qPBA+frULzyXfZnvivE4UHBlKN6A0k7sASYG+FZalVx5m
	 mx9L9uJQBVrSC5jbdjK85lKKhst7zkVKq6I+1TLo=
Date: Tue, 12 Nov 2024 16:01:58 -0800
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,daan.j.demeyer@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-swapfile-fix-cluster-reclaim-work-crash-on-rotational-devices.patch removed from -mm tree
Message-Id: <20241113000159.79BB5C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swapfile: fix cluster reclaim work crash on rotational devices
has been removed from the -mm tree.  Its filename was
     mm-swapfile-fix-cluster-reclaim-work-crash-on-rotational-devices.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: swapfile: fix cluster reclaim work crash on rotational devices
Date: Thu, 7 Nov 2024 09:08:36 -0500

syzbot and Daan report a NULL pointer crash in the new full swap cluster
reclaim work:

> Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> CPU: 1 UID: 0 PID: 51 Comm: kworker/1:1 Not tainted 6.12.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
> Workqueue: events swap_reclaim_work
> RIP: 0010:__list_del_entry_valid_or_report+0x20/0x1c0 lib/list_debug.c:49
> Code: 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 48 89 fe 48 83 c7 08 48 83 ec 18 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 19 01 00 00 48 89 f2 48 8b 4e 08 48 b8 00 00 00
> RSP: 0018:ffffc90000bb7c30 EFLAGS: 00010202
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffff88807b9ae078
> RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000008
> RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000001 R11: 000000000000004f R12: dffffc0000000000
> R13: ffffffffffffffb8 R14: ffff88807b9ae000 R15: ffffc90003af1000
> FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fffaca68fb8 CR3: 00000000791c8000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  __list_del_entry_valid include/linux/list.h:124 [inline]
>  __list_del_entry include/linux/list.h:215 [inline]
>  list_move_tail include/linux/list.h:310 [inline]
>  swap_reclaim_full_clusters+0x109/0x460 mm/swapfile.c:748
>  swap_reclaim_work+0x2e/0x40 mm/swapfile.c:779

The syzbot console output indicates a virtual environment where swapfile
is on a rotational device.  In this case, clusters aren't actually used,
and si->full_clusters is not initialized.  Daan's report is from qemu, so
likely rotational too.

Make sure to only schedule the cluster reclaim work when clusters are
actually in use.

Link: https://lkml.kernel.org/r/20241107142335.GB1172372@cmpxchg.org
Link: https://lore.kernel.org/lkml/672ac50b.050a0220.2edce.1517.GAE@google.com/
Link: https://github.com/systemd/systemd/issues/35044
Fixes: 5168a68eb78f ("mm, swap: avoid over reclaim of full clusters")
Reported-by: syzbot+078be8bfa863cb9e0c6b@syzkaller.appspotmail.com
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Daan De Meyer <daan.j.demeyer@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swapfile-fix-cluster-reclaim-work-crash-on-rotational-devices
+++ a/mm/swapfile.c
@@ -929,7 +929,7 @@ static void swap_range_alloc(struct swap
 		si->highest_bit = 0;
 		del_from_avail_list(si);
 
-		if (vm_swap_full())
+		if (si->cluster_info && vm_swap_full())
 			schedule_work(&si->reclaim_work);
 	}
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


