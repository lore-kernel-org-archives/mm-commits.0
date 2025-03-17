Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C90215F43
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188331; cv=none; b=NIiYbDxYCg30gQfhUIpLCuaspvFiV7sCXjT/mF3ECpfP0cvtmb1Uw3Y220Xs9bluYssb38hjMVjaosWTvfUlU0HpbwWYnvRRvWSZq32K7QyVMOhKYAhE3WUqd2LFoAcuDhIZGCV2poYtdeHbVlkkQyHuANxjQAF8yWqmuEhmyno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188331; c=relaxed/simple;
	bh=a1URQI2mG3o3FmBfMnBdA02lKNPt+QV0RSRlliyhJ/E=;
	h=Date:To:From:Subject:Message-Id; b=JGa6AsOt+PX5XHQ5AhDaPKO0XzAbqeV/Zy9/twirz9kQty7Kq46DXOqAuL0WpbbdMz/OxYCGnf41xPGuFiz0PyTkgInAY66q3Pm27hfy5sofSpoM8g8hg4T6WVtw7dLGxeWtc9Urq5GPtcbeL3h4qkDi+6Gca7bx8fbtSOlLNPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1SdKB1z2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1SdKB1z2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85527C4CEEC;
	Mon, 17 Mar 2025 05:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188331;
	bh=a1URQI2mG3o3FmBfMnBdA02lKNPt+QV0RSRlliyhJ/E=;
	h=Date:To:From:Subject:From;
	b=1SdKB1z2RSNWFMTj6+aOqHF6dbjtbBhaVzN3KNZqHA2ANw/iIP/fM7FPMxsFdgIMP
	 mrc0VFOxdsEWJdEQgZdNXlvano7Q1UT6BkgZd2h+lXnJJ2VQxQ/EQ4zm9SAdaKFURQ
	 oVnF9FPfvkMXVgUxuJaQyiLVaFoAs7DZGvoGY+Ec=
Date: Sun, 16 Mar 2025 22:12:10 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,souravpanda@google.com,shivankg@amd.com,shakeel.butt@linux.dev,sfr@canb.auug.org.au,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hca@linux.ibm.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch removed from -mm tree
Message-Id: <20250317051211.85527C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/debug: print vm_refcnt state when dumping the vma
has been removed from the -mm tree.  Its filename was
     mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/debug: print vm_refcnt state when dumping the vma
Date: Thu, 13 Feb 2025 14:46:51 -0800

vm_refcnt encodes a number of useful states:
- whether vma is attached or detached
- the number of current vma readers
- presence of a vma writer
Let's include it in the vma dump.

Link: https://lkml.kernel.org/r/20250213224655.1680278-15-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Shivank Garg <shivankg@amd.com>
  Link: https://lkml.kernel.org/r/5e19ec93-8307-47c2-bb13-3ddf7150624e@amd.com
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/debug.c~mm-debug-print-vm_refcnt-state-when-dumping-the-vma
+++ a/mm/debug.c
@@ -181,11 +181,17 @@ void dump_vma(const struct vm_area_struc
 	pr_emerg("vma %px start %px end %px mm %px\n"
 		"prot %lx anon_vma %px vm_ops %px\n"
 		"pgoff %lx file %px private_data %px\n"
+#ifdef CONFIG_PER_VMA_LOCK
+		"refcnt %x\n"
+#endif
 		"flags: %#lx(%pGv)\n",
 		vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->vm_mm,
 		(unsigned long)pgprot_val(vma->vm_page_prot),
 		vma->anon_vma, vma->vm_ops, vma->vm_pgoff,
 		vma->vm_file, vma->vm_private_data,
+#ifdef CONFIG_PER_VMA_LOCK
+		refcount_read(&vma->vm_refcnt),
+#endif
 		vma->vm_flags, &vma->vm_flags);
 }
 EXPORT_SYMBOL(dump_vma);
_

Patches currently in -mm which might be from surenb@google.com are


