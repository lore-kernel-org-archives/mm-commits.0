Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794283583;
	b=yvzwEuvGc5aeT0oMWVvOJcQq2arh1tpV5ZFNgnRPLu8jWOCuD9IeYZEgb15xUMhliDZl
	 xnVv6L3PiEtz5K1P8G5rnz7w3n/uUIW0fRU0ujVn+QEVdn0NuF5wOQgOH9Yy9QxZT8Jik
	 KTd6Jg2lo+t26QsjOdGnWh167SfuMLJz0MjKb75i8HqcGEsPSTS5aHny03qDzut6vJpIu
	 C0fcHbwvpifl6ga12vJ+NRmTmkLzNwjcNuEer18VnwQVhDQU9uOKprU66Fxv6d4kfUcc8
	 hD6QV3vfjm9BHuBtaeiL9Srtc2YY2VoxtQFFFwpwuNOy9Hx4vHR7gNV32QRGOxwVuQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794283583;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Q4GUwGEdmLJ8KIH9FDp7ZR9keVwntaHQNsdJ6T2X/FM=;
	b=PoqYKvwiGYcEXiAnT4QNj2gBz9Rlygr+5hc3gffP1lsmzLut8Q+Ur+fkvrBR3yi+Pqg3
	 dgV5wVtQD3qvUQ5BN7c4SGCrb6jTgry3LdWHb/bRiCt+4STnD6NCEL0Xu63lXN/D9mzHf
	 iKNPczA9KzRARVxF53xr5+5j6zZInDI5fatdBZDviOISdVJTUWwgKyWdNizrTTCd+71u2
	 kmJesWWFlmWAp+dele8oK4ZvFadyNz4VyvA+8uzJGqa8CWO2Dt/Niy4nsSuPyMnO8S/zy
	 AYseJnlKoJ6FuNkvfOKvmG1HbLl6xDgVlEJa2Pj/lngXed8AcOCflMX0U6ciWI4QzWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=itR2wpnX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18C1606A31C;
	Tue, 10 Nov 2026 04:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=itR2wpnX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7A01F0089F;
	Tue, 10 Nov 2026 04:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794283582;
	bh=Q4GUwGEdmLJ8KIH9FDp7ZR9keVwntaHQNsdJ6T2X/FM=;
	h=Date:To:From:Subject;
	b=itR2wpnXu5qoC/pP5GxkV5mcg5WJ9+JghFyjztfC/zQ2qVJ/A3iMsc47njARxbDdQ
	 0MEe2OxxhIL66JS6KKm4k+7r2GhQS+Rpc3PmNF+Bra1XZfhv8HwZC2dMyx4i5Fz/rK
	 mr2lJsjO0LNEO7gLTi0WDLmne8HSVS/VEYQXd6G4=
Date: Mon, 09 Nov 2026 20:06:21 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,stable@vger.kernel.org,
	shubhang@os.amperecomputing.com,npiggin@gmail.com,dev.jain@arm.com,
	cl@gentwo.org,anshuman.khandual@arm.com,sh@gentwo.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-reject-overflowing-vm_map_ram-page-counts.patch added to mm-new branch
Message-Id: <20261110040622.5A7A01F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/vmalloc: reject overflowing vm_map_ram page counts
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-reject-overflowing-vm_map_ram-page-counts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-reject-overflowing-vm_map_ram-page-counts.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "Shubhang Kaushik (Ampere)" <sh@gentwo.org>
Subject: mm/vmalloc: reject overflowing vm_map_ram page counts
Date: Thu, 22 Oct 2026 23:43:47 -0700

vm_map_ram() accepts a page count and must either map that many pages or
fail.  It currently converts the count to a byte size with:

        (unsigned long)count << PAGE_SHIFT

On 32-bit kernels, this conversion overflows when count is greater than
ULONG_MAX >> PAGE_SHIFT.  vm_map_ram() then allocates and maps only the
wrapped byte size, but returns a non-NULL address to its caller.

For example, with 4 KiB pages, a count of 1048577 wraps to PAGE_SIZE. 
vm_map_ram() therefore returns a mapping containing one page instead of
the requested 1048577 pages.

If a caller uses the successful result as a mapping of all requested
pages, it can access beyond the allocated mapping.  Such an access can
fault.  If the accessed virtual address is occupied by another vmalloc
mapping, it can instead access and corrupt unrelated kernel memory.  In a
userspace-reachable call path, this can result in a failed operation, a
kernel oops or panic, or the effects of corrupted kernel data.

Return NULL before allocating or mapping anything when count * PAGE_SIZE
cannot be represented in an unsigned long.

Link: https://lore.kernel.org/20261022-vmalloc-reject-overflow-v2-1-0db7a20c53f0@gentwo.org
Fixes: db64fe02258f ("mm: rewrite vmap layer")
Signed-off-by: Shubhang Kaushik (Ampere) <sh@gentwo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Shubhang Kaushik <shubhang@os.amperecomputing.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: <stable@vger.kernel.org>
---

 mm/vmalloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-reject-overflowing-vm_map_ram-page-counts
+++ a/mm/vmalloc.c
@@ -3160,10 +3160,13 @@ EXPORT_SYMBOL(vm_unmap_ram);
  */
 void *vm_map_ram(struct page **pages, unsigned int count, int node)
 {
-	unsigned long size = (unsigned long)count << PAGE_SHIFT;
+	unsigned long size;
 	unsigned long addr;
 	void *mem;
 
+	if (check_mul_overflow((unsigned long)count, PAGE_SIZE, &size))
+		return NULL;
+
 	if (likely(count <= VMAP_MAX_ALLOC)) {
 		mem = vb_alloc(size, GFP_KERNEL);
 		if (IS_ERR(mem))
_

Patches currently in -mm which might be from sh@gentwo.org are

mm-damon-ops-common-align-mmu-notifier-range-when-clearing-pte-young-bit.patch
mm-vmalloc-reject-overflowing-vm_map_ram-page-counts.patch
ipc-msg-fix-msg_qbytes-truncation-in-ipc_set.patch

