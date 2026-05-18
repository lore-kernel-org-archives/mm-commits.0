Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAB1405C5C;
	Mon, 18 May 2026 23:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779145817; cv=none; b=MCihO8MPGF7kDbg5AmljMVa8tbhof80+7pzo6DX7UENjfEAT+2nc5zdbCeXwRv2f+7lcEYZRpMWgALhIQaUldvCB8bi7uoINOHf2HZJkWMBxpBuUOnWYJxAt/lSwe+JAB6hWs7cZ1B3cM0rk89xEiyk1i4yr4KyV8SIuSknvOKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779145817; c=relaxed/simple;
	bh=Ggop+AadGbYRpouxOB7pbRxCzKBwMzIjzlRPmKrbAvc=;
	h=Date:To:From:Subject:Message-Id; b=ec3xPEmQ7MgJqi3xAPOoseS/9xycVc55IeZXwqTpGDwVJrgRywjiX3StCvkd0wbHM9gPHmh6kyMJLzThY/12saJbRcmnBmXAwJTm9v3W48Lpri4eUH/eIQ193mVU7L+JLJaa5ktQjAClPNvDEJAVVmzVf60wVrk0L8IqqAfU6Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P3qVFo2I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P3qVFo2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158A4C2BCB7;
	Mon, 18 May 2026 23:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779145817;
	bh=Ggop+AadGbYRpouxOB7pbRxCzKBwMzIjzlRPmKrbAvc=;
	h=Date:To:From:Subject:From;
	b=P3qVFo2IZoiziPK8sF5WOa6IxIVCsd8Tezmgkl83HX0BmjVzqpnWubeXQuoQhH8Cc
	 h7RxOxlLWTCbcCtgCcTT+wfaFK/brGtNBh4a5xLVZV3Kvkq/un224XOLiUioQ18RdG
	 t96/trmm76D2sVE+ERadWT328624PBkF5APkNciE=
Date: Mon, 18 May 2026 16:10:16 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,idosch@nvidia.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-do-not-trigger-bug-on-bh-disabled-context.patch added to mm-hotfixes-unstable branch
Message-Id: <20260518231017.158A4C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: do not trigger BUG() on BH disabled context
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmalloc-do-not-trigger-bug-on-bh-disabled-context.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-do-not-trigger-bug-on-bh-disabled-context.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: do not trigger BUG() on BH disabled context
Date: Fri, 15 May 2026 17:30:09 +0200

__get_vm_area_node() currently triggers a BUG() if in_interrupt() returns
true.  However, in_interrupt() also reports true when BH are disabled.

The bridge code can call rhashtable_lookup_insert_fast() with bottom
halves disabled:

__vlan_add()
 -> br_fdb_add_local()
  spin_lock_bh(&br->hash_lock); <-- Disable BH
   -> fdb_add_local()
    -> fdb_create()
     -> rhashtable_lookup_insert_fast()
      -> kvmalloc()
       -> vmalloc()
        -> __get_vm_area_node()
         -> BUG_ON(in_interrupt())
  spin_unlock_bh(&br->hash_lock)

this triggers the BUG() despite the caller not being in NMI or
hard IRQ context.

Replace the in_interrupt() check with in_nmi() || in_hardirq().

Link: https://lore.kernel.org/20260515153009.2296191-1-urezki@gmail.com
Fixes: c6307674ed82 ("mm: kvmalloc: add non-blocking support for vmalloc")
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Ido Schimmel <idosch@nvidia.com>
Reported-by: syzbot+8b12fc6e0fb139765b58@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69ff8c7c.050a0220.1036b8.000b.GAE@google.com/
Cc: Baoquan He <bhe@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-do-not-trigger-bug-on-bh-disabled-context
+++ a/mm/vmalloc.c
@@ -3203,7 +3203,7 @@ struct vm_struct *__get_vm_area_node(uns
 	struct vm_struct *area;
 	unsigned long requested_size = size;
 
-	BUG_ON(in_interrupt());
+	BUG_ON(in_nmi() || in_hardirq());
 	size = ALIGN(size, 1ul << shift);
 	if (unlikely(!size))
 		return NULL;
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-do-not-trigger-bug-on-bh-disabled-context.patch

