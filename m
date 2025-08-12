Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21442D2398;
	Tue, 12 Aug 2025 06:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754978486; cv=none; b=D76/raBnQfzT5X7Fr65Q2uQpnEUGvLQpC0o9FwDR6SW45BajuoqBm9xA58Iil1NrpqCj3afPbGxVRRI0//h5myoIafe1s2nt2Q8sn83/eW0gGgBLWKWbqsabu9nht7iTBmyADU+gW051HoWS+kptpsY7LdRpo7sy0PcquxIlcWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754978486; c=relaxed/simple;
	bh=dUZxxbghhnPxpoxwe3WugKrFrejjzumMUPTmvJoixVY=;
	h=Date:To:From:Subject:Message-Id; b=tkpVp9xC6BwOnfOyYpoYoBRL0Wv2pclHIHdET/10cW8AIQjkOLvZFIakxpNobe5unVmmhaadzT131tkRQmkAxP0xbx0zXCjeARgttOWIOb8PIP4zFVVPwXXEVs+YVKI/Fl7+BT/al5KPhIQuy+3dbgj55Wa04XT21PDs/218jjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X1wAZwZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X1wAZwZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F551C4CEF0;
	Tue, 12 Aug 2025 06:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754978486;
	bh=dUZxxbghhnPxpoxwe3WugKrFrejjzumMUPTmvJoixVY=;
	h=Date:To:From:Subject:From;
	b=X1wAZwZTNcb3A38eCJbXWKgrsLUAF9p01p1Dh8b7+HB9nCxuaTBZj2eFjEnRT3Wpn
	 SeOSPNX0TU4HVO+qZ6hBRB63UpLqJxu4x7nzylZa54W3D0xdw7Nhre1mm6t2SlPtSV
	 EThLseTNKVT6qj7WTXhsgKGGCtjZtBsDj4zNnp/s=
Date: Mon, 11 Aug 2025 23:01:25 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,peterx@redhat.com,lokeshgidra@google.com,david@redhat.com,aarcange@redhat.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry.patch removed from -mm tree
Message-Id: <20250812060126.1F551C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: fix a crash in UFFDIO_MOVE when PMD is a migration entry
has been removed from the -mm tree.  Its filename was
     userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: userfaultfd: fix a crash in UFFDIO_MOVE when PMD is a migration entry
Date: Wed, 6 Aug 2025 15:00:22 -0700

When UFFDIO_MOVE encounters a migration PMD entry, it proceeds with
obtaining a folio and accessing it even though the entry is swp_entry_t. 
Add the missing check and let split_huge_pmd() handle migration entries. 
While at it also remove unnecessary folio check.

[surenb@google.com: remove extra folio check, per David]
  Link: https://lkml.kernel.org/r/20250807200418.1963585-1-surenb@google.com
Link: https://lkml.kernel.org/r/20250806220022.926763-1-surenb@google.com
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@google.com/
Reviewed-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-fix-a-crash-in-uffdio_move-when-pmd-is-a-migration-entry
+++ a/mm/userfaultfd.c
@@ -1821,13 +1821,16 @@ ssize_t move_pages(struct userfaultfd_ct
 			/* Check if we can move the pmd without splitting it. */
 			if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
 			    !pmd_none(dst_pmdval)) {
-				struct folio *folio = pmd_folio(*src_pmd);
+				/* Can be a migration entry */
+				if (pmd_present(*src_pmd)) {
+					struct folio *folio = pmd_folio(*src_pmd);
 
-				if (!folio || (!is_huge_zero_folio(folio) &&
-					       !PageAnonExclusive(&folio->page))) {
-					spin_unlock(ptl);
-					err = -EBUSY;
-					break;
+					if (!is_huge_zero_folio(folio) &&
+					    !PageAnonExclusive(&folio->page)) {
+						spin_unlock(ptl);
+						err = -EBUSY;
+						break;
+					}
 				}
 
 				spin_unlock(ptl);
_

Patches currently in -mm which might be from surenb@google.com are

mm-limit-the-scope-of-vma_start_read.patch
mm-change-vma_start_read-to-drop-rcu-lock-on-failure.patch
selftests-proc-test-procmap_query-ioctl-while-vma-is-concurrently-modified.patch
fs-proc-task_mmu-factor-out-proc_maps_private-fields-used-by-procmap_query.patch
fs-proc-task_mmu-execute-procmap_query-ioctl-under-per-vma-locks.patch

