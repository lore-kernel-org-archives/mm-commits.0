Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832503;
	b=P7bT1tmrCkQNgVuRC9G37Onat5GlgKApP+/WyGxn0+t2Vx57m/a7M6OyrKJafUAZ1+JR
	 3ixGNI0lUogW9Grsp8rB5LFFoHAllOLnHwO1oZkLXUlqcM1n5EctstuVhnjLk1J9CicaI
	 rPyCHll6D4hSmRccPvd17Eyai2LqmhO66+r/1E+sbef9n3kBUtuTU2NSNtt421kyXMH9K
	 RqrGgIKTPIXDyc+6JOmthgIV2F51/rkWkCaw3TN9rKhKa9JsOkhUE6m2GFYsKKNAghf+p
	 FSv1Yt9aXct1W0wEIksvZySJObCqyeU2mUgmkRSFb5ohaLk/r0cYQkeZRfyfMwGRZ/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832503;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Vz3q5S4A6UlGwFeHwDg5x+198c7jIzMe9xZxSRvF/oI=;
	b=yk19kSzIHOXZGGfA5dp6nE7IZlYRg97Po7hFDw4bf98sFYUuVOnk/shsIYWwZrVMm8t7
	 9rMiKlzNURhLMehSqMhlxIUY7iZKi7ODRRtRHI0P/GWKLj/TEVZlbSIVOPwwAlsmIZRT7
	 Lf5HBBEQJ6Lpe+Tu9Qd2uETXjzR7GjpDMw/DRC8hz2WdZs++Dp8VutnADGiHhmH0EG9rn
	 XhcIw8RCpO2yMAd+0a4AZb4o30bbiH1qospdEBLqRjMaEZTBn9mrfUWrwp9KYAVOPSYzs
	 TetqmCvRnK7o70xFJWfSbM8GxOsojXn2etr1OX+fXPrtJIvN0Mnpa2gShKMTfMJjz5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="Fd5M/4b/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2B8606A31B;
	Sat, 24 Oct 2026 09:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Fd5M/4b/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745C31F01825;
	Sat, 24 Oct 2026 09:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832502;
	bh=Vz3q5S4A6UlGwFeHwDg5x+198c7jIzMe9xZxSRvF/oI=;
	h=Date:To:From:Subject;
	b=Fd5M/4b/E0jhKLYCfwpctM5nrmsJ0wDC7H5GK5YTQxssvmLovO/TrRcrsw0DMKzKQ
	 fH6KkcH2LBY+1B0wPw02ely1d1tBREINSrIukV8oiZtuD5IEy7V7vRzofr4c24eMVx
	 XvoF7ZZ6FbxqLAIrbZcCdRuXL8mn3CbULL0NEiyY=
Date: Sat, 24 Oct 2026 02:01:42 -0700
To: mm-commits@vger.kernel.org,tgopinath@linux.microsoft.com,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,david@kernel.org,AutonomousCodeSecurity@microsoft.com,aarcange@redhat.com,cenzhang@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-fix-uffdio_move-livelock-on-large-folio-with-extra-references.patch removed from -mm tree
Message-Id: <20261024090142.745C31F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: userfaultfd: fix UFFDIO_MOVE livelock on large folio with extra references
has been removed from the -mm tree.  Its filename was
     userfaultfd-fix-uffdio_move-livelock-on-large-folio-with-extra-references.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>
Subject: userfaultfd: fix UFFDIO_MOVE livelock on large folio with extra references
Date: Mon, 12 Oct 2026 16:15:14 -0400

To move one page out of a large folio, move_pages_ptes() first has to
split the folio.  __folio_split() refuses if the folio has any reference
beyond its page table mappings and the caller's own, and it reports the
refusal as -EAGAIN.  move_pages() treats returned -EAGAIN as a transient
race and keeps retrying the same address, holding the VMA read locks the
whole time.  This is incorrect since in some cases userspace can hold such
a reference indefinitely, such as by registering the page as an io_uring
buffer.

An unprivileged user can trigger this with three threads: first holds such
a reference on a page of a THP, second calls UFFDIO_MOVE on another page
of the same THP and spins in the kernel forever holding the VMA read
locks, and third calls fork() or mprotect(), which takes mmap_lock for
writing and then waits forever for those read locks.  From then on every
mmap_lock user of that mm hangs, including other processes inspecting it
through /proc/<pid>/, until the process is SIGKILLed.  The hung task
detector reports the blocked tasks (third one), and with
kernel.hung_task_panic=1 the machine panics:

  INFO: task wedge:95 blocked for more than 122 seconds.
  task:wedge  state:D stack:12528 pid:95 tgid:95 ppid:94
  Call Trace:
   __schedule+0x596/0x1110
   schedule+0x36/0xf0
   __vma_start_exclude_readers+0x100/0x170
   __vma_start_write+0x51/0xd0
   __split_vma+0x208/0x3d0
   vma_modify+0x6a8/0x840
   vma_modify_flags+0xce/0x110
   mprotect_fixup+0xbe/0x480
   do_mprotect_pkey+0x2d9/0x580
   __x64_sys_mprotect+0x1a/0x30

Fix by returning -EBUSY instead of -EAGAIN in move_pages_ptes(), the
caller of split_folio(), when the split fails.  Thus, move_pages() does
not retry -EBUSY and the ioctl drops its locks and returns to userspace
instead of spinning.

Link: https://lore.kernel.org/20261012201514.97015-1-cenzhang@linux.microsoft.com
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <AutonomousCodeSecurity@microsoft.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <tgopinath@linux.microsoft.com>
Cc: <stable@vger.kernel.org>
---

 mm/userfaultfd.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/userfaultfd.c~userfaultfd-fix-uffdio_move-livelock-on-large-folio-with-extra-references
+++ a/mm/userfaultfd.c
@@ -1635,8 +1635,12 @@ retry:
 			pte_unmap(dst_pte);
 			src_pte = dst_pte = NULL;
 			ret = split_folio(src_folio);
-			if (ret)
+			if (ret) {
+				/* do not retry, extra refs may be held forever */
+				if (ret == -EAGAIN)
+					ret = -EBUSY;
 				goto out;
+			}
 			/* have to reacquire the folio after it got split */
 			folio_unlock(src_folio);
 			folio_put(src_folio);
_

Patches currently in -mm which might be from cenzhang@linux.microsoft.com are


