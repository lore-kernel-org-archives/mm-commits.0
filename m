Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1007D1FE47B;
	Fri, 22 May 2026 02:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779415628; cv=none; b=pvnUrYlC8Z9xhJKSUmm/qo+SyjpVTyQamzMhxf6S80llkt+/8Mpfq4Fwr7wOykml2cYrt0khLg37i1yBw/PPW95MlpYFPfRAHuZUwFyTFJeXLMZtaOY2El51qlyt6mEs3C/qnywz8mqOn5iYr9Wr6/3i2WyWoEnqLSk4kOvjy/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779415628; c=relaxed/simple;
	bh=J82F+S/ib+mJjVxwYZqJuv7nMMAOHyN1q2KS/tRm7Ck=;
	h=Date:To:From:Subject:Message-Id; b=YcvbeXyW+e8kRSTIzLoBFRDGlnzhoMdTaM7wl7GbY7fINEjy2WrGS8oBk1/943aswS+WaQMLwoNaphfzKSy9wj9SuuXQVoiV8uUUhYvnn0SqV8lUimrYbWUW9oUFpwLV9S0AFTCvwEOfRQi4cWBFJHPXxP0FyJKjlymPQUwHZ+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=duXbEwSH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="duXbEwSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75761F00A3D;
	Fri, 22 May 2026 02:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779415627;
	bh=bQ8jYZmbxlVEAKywPoIoYmbSwMsPvLw2bo3hGlcuqZE=;
	h=Date:To:From:Subject;
	b=duXbEwSHUn3uAW5jdkZgVi4+13OH2qYVFDN9ht/VAYLvleqW8Y3tiOXJ2O9duHQv8
	 onIkl42Ds+Ic2m/jTWPjSp4ZTr6j8KITRJF8YvUgbXmjGxEWPP3yWgdhFGHmeNsiuW
	 HwylaFuSd82SKoxJ3c7JZ3EF8xeie5pJabZE/kv4=
Date: Thu, 21 May 2026 19:07:06 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,idosch@nvidia.com,baoquan.he@linux.dev,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmalloc-do-not-trigger-bug-on-bh-disabled-context.patch removed from -mm tree
Message-Id: <20260522020706.D75761F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: do not trigger BUG() on BH disabled context
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-do-not-trigger-bug-on-bh-disabled-context.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
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


