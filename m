Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8553F215F52
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188312; cv=none; b=Q9tGFZJTT3yigoiOVWJIkfnSixMVBGjIGxeICiShzKWsd6H7PFlNiwdBkr7gRYmfPQA1227aFCcit74eaJ+ftyO950WiAYtkga3u4Yxb8lqHU3tya1mQ7Wnu88rgm9/lXAKPcFr1DaPMd2pY3GZlS+yHHNm+hg3Lzj4W8jxEboQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188312; c=relaxed/simple;
	bh=CmyHooQcm4k3CAYNQ6p5NA8tP/7wvdbNj/t//cRh5mM=;
	h=Date:To:From:Subject:Message-Id; b=FQD4TkbQuWWJB4P5pAhUS9B2nIFOXIVfOir3g0eSdIfXSi2FyBzZe+1Y4pGQMwO5Yumf6zrd1CLcbiC3HmSH9kQC/ilvA6PUZI0TkXwOZP/G0U5m3qDpy1t6W88FG7Z5JS65sf+Qbfd40bmbwUddzrQQlv+Nhw0vTYvalBgUsWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gt+3M6pR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gt+3M6pR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5238BC4CEEC;
	Mon, 17 Mar 2025 05:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188312;
	bh=CmyHooQcm4k3CAYNQ6p5NA8tP/7wvdbNj/t//cRh5mM=;
	h=Date:To:From:Subject:From;
	b=Gt+3M6pRBIOCsNYAMrlLRjVd1kMbzECiHgFkGtiVOhpbatEQMvstiJV90gUSJFxPA
	 Ch9IG7xBdE7Q3KSEOlnIVPjXyZaPFh/LHJnIERf5S1vfRmaxEZNXwMrtiSjc9Xibyz
	 ni8wboNRTJQtGXxZOslgUIWASobtAVTcR40qZN3c=
Date: Sun, 16 Mar 2025 22:11:51 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,souravpanda@google.com,shivankg@amd.com,shakeel.butt@linux.dev,sfr@canb.auug.org.au,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hca@linux.ibm.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mark-vmas-detached-upon-exit.patch removed from -mm tree
Message-Id: <20250317051152.5238BC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mark vmas detached upon exit
has been removed from the -mm tree.  Its filename was
     mm-mark-vmas-detached-upon-exit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: mark vmas detached upon exit
Date: Thu, 13 Feb 2025 14:46:42 -0800

When exit_mmap() removes vmas belonging to an exiting task, it does not
mark them as detached since they can't be reached by other tasks and they
will be freed shortly.  Once we introduce vma reuse, all vmas will have to
be in detached state before they are freed to ensure vma when reused is in
a consistent state.  Add missing vma_mark_detached() before freeing the
vma.

Link: https://lkml.kernel.org/r/20250213224655.1680278-6-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Tested-by: Shivank Garg <shivankg@amd.com>
  Link: https://lkml.kernel.org/r/5e19ec93-8307-47c2-bb13-3ddf7150624e@amd.com
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
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

 mm/vma.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/vma.c~mm-mark-vmas-detached-upon-exit
+++ a/mm/vma.c
@@ -427,10 +427,12 @@ void remove_vma(struct vm_area_struct *v
 	if (vma->vm_file)
 		fput(vma->vm_file);
 	mpol_put(vma_policy(vma));
-	if (unreachable)
+	if (unreachable) {
+		vma_mark_detached(vma);
 		__vm_area_free(vma);
-	else
+	} else {
 		vm_area_free(vma);
+	}
 }
 
 /*
_

Patches currently in -mm which might be from surenb@google.com are


