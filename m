Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2628617555;
	Tue,  5 Mar 2024 17:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709659584; cv=none; b=thBPSWGAYM4lo+fVzYn+tUhEHaBI6ReIn/Z4DxLMa0bont+kI3JO5cwPviDFBatmKDo1AyKiP1ZnoXCdtBgVsX5oigPggQyxwxdN3z8uK4Sy25HsvZRt+IlNM3raLTygF2SQe3SHjyQaNYL6LecyjX0KtAMySrRXbDJh6VRB1jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709659584; c=relaxed/simple;
	bh=s3xQATPhaGPeMRMcaOujC72dU7qB42j7gd97Xej9j6A=;
	h=Date:To:From:Subject:Message-Id; b=DOJUea5bcyH5rzQHJsR2cdBW+JPaILLOsTPtQCvYOGGh3dLNVQEGvNFU/FHHH+oeqMT+E2JtUAZK0WuVV7fUUlj8wsYf2VwTEizJt21GNuvRdURMs1GnbMWzxVd+ov8DfICfxv9TJCjqvwkH8RR3eJUSYZedeKXjeKrLnldzDBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fQmKaKSO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fQmKaKSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93794C433C7;
	Tue,  5 Mar 2024 17:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709659583;
	bh=s3xQATPhaGPeMRMcaOujC72dU7qB42j7gd97Xej9j6A=;
	h=Date:To:From:Subject:From;
	b=fQmKaKSOzY9lpoEo2dzNOOcW2E0yGnvUNWiApxyR2OWhvnbIgPDw8zekaHW79cyMk
	 9fh4KfltXO5Cmk3zbZWqwVhUUQF5s6/Lm83T56s4laceRX5WU0vpp+K624TcGhQabY
	 7TkxCS0Fu3vPqaKrOPabij4F4E91rFUU3s4vfyZk=
Date: Tue, 05 Mar 2024 09:26:23 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,stable@vger.kernel.org,david@redhat.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-fix-race-between-free_swap_and_cache-and-swapoff.patch added to mm-unstable branch
Message-Id: <20240305172623.93794C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: fix race between free_swap_and_cache() and swapoff()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-fix-race-between-free_swap_and_cache-and-swapoff.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-fix-race-between-free_swap_and_cache-and-swapoff.patch

This patch will later appear in the mm-unstable branch at
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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: swap: fix race between free_swap_and_cache() and swapoff()
Date: Tue, 5 Mar 2024 15:13:49 +0000

There was previously a theoretical window where swapoff() could run and
teardown a swap_info_struct while a call to free_swap_and_cache() was
running in another thread.  This could cause, amongst other bad
possibilities, swap_page_trans_huge_swapped() (called by
free_swap_and_cache()) to access the freed memory for swap_map.

This is a theoretical problem and I haven't been able to provoke it from a
test case.  But there has been agreement based on code review that this is
possible (see link below).

Fix it by using get_swap_device()/put_swap_device(), which will stall
swapoff().  There was an extra check in _swap_info_get() to confirm that
the swap entry was valid.  This wasn't present in get_swap_device() so
I've added it.  I couldn't find any existing get_swap_device() call sites
where this extra check would cause any false alarms.

Details of how to provoke one possible issue (thanks to David Hildenbrand
for deriving this):

--8<-----

__swap_entry_free() might be the last user and result in
"count == SWAP_HAS_CACHE".

swapoff->try_to_unuse() will stop as soon as soon as si->inuse_pages==0.

So the question is: could someone reclaim the folio and turn
si->inuse_pages==0, before we completed swap_page_trans_huge_swapped().

Imagine the following: 2 MiB folio in the swapcache. Only 2 subpages are
still references by swap entries.

Process 1 still references subpage 0 via swap entry.
Process 2 still references subpage 1 via swap entry.

Process 1 quits. Calls free_swap_and_cache().
-> count == SWAP_HAS_CACHE
[then, preempted in the hypervisor etc.]

Process 2 quits. Calls free_swap_and_cache().
-> count == SWAP_HAS_CACHE

Process 2 goes ahead, passes swap_page_trans_huge_swapped(), and calls
__try_to_reclaim_swap().

__try_to_reclaim_swap()->folio_free_swap()->delete_from_swap_cache()->
put_swap_folio()->free_swap_slot()->swapcache_free_entries()->
swap_entry_free()->swap_range_free()->
...
WRITE_ONCE(si->inuse_pages, si->inuse_pages - nr_entries);

What stops swapoff to succeed after process 2 reclaimed the swap cache
but before process1 finished its call to swap_page_trans_huge_swapped()?

--8<-----

Link: https://lkml.kernel.org/r/20240305151349.3781428-1-ryan.roberts@arm.com
Fixes: 7c00bafee87c ("mm/swap: free swap slots in batch")
Closes: https://lore.kernel.org/linux-mm/65a66eb9-41f8-4790-8db2-0c70ea15979f@redhat.com/
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swap-fix-race-between-free_swap_and_cache-and-swapoff
+++ a/mm/swapfile.c
@@ -1281,7 +1281,9 @@ struct swap_info_struct *get_swap_device
 	smp_rmb();
 	offset = swp_offset(entry);
 	if (offset >= si->max)
-		goto put_out;
+		goto bad_offset;
+	if (data_race(!si->swap_map[swp_offset(entry)]))
+		goto bad_free;
 
 	return si;
 bad_nofile:
@@ -1289,9 +1291,14 @@ bad_nofile:
 out:
 	return NULL;
 put_out:
-	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
 	percpu_ref_put(&si->users);
 	return NULL;
+bad_offset:
+	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
+	goto put_out;
+bad_free:
+	pr_err("%s: %s%08lx\n", __func__, Unused_offset, entry.val);
+	goto put_out;
 }
 
 static unsigned char __swap_entry_free(struct swap_info_struct *p,
@@ -1609,13 +1616,14 @@ int free_swap_and_cache(swp_entry_t entr
 	if (non_swap_entry(entry))
 		return 1;
 
-	p = _swap_info_get(entry);
+	p = get_swap_device(entry);
 	if (p) {
 		count = __swap_entry_free(p, entry);
 		if (count == SWAP_HAS_CACHE &&
 		    !swap_page_trans_huge_swapped(p, entry))
 			__try_to_reclaim_swap(p, swp_offset(entry),
 					      TTRS_UNMAPPED | TTRS_FULL);
+		put_swap_device(p);
 	}
 	return p != NULL;
 }
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-swap-fix-race-between-free_swap_and_cache-and-swapoff.patch

