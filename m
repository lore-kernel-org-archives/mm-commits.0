Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E46422F11
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836006; cv=none; b=pxuBryFHXuPeGKytymKpqSEWjZRwbwXR6WBFldq/GIt9K8ey5eckIuxED6nxO4tNIk+c1zExEadQKunIETHySlsXdwo8SDpc0KkyPg57zwuOl3HtzPPEXrt+zX0FgfcURaqbk34ooHqdN8GkUDt1PiMYAwC8FVMFEvFwymsCBe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836006; c=relaxed/simple;
	bh=8+cAAGyL/XsHxmOPQQukAkDR+DdntKWbkf/8xjTrj18=;
	h=Date:To:From:Subject:Message-Id; b=Cj2Lz+RUmNbreyps41aqSbxQ5pel/xrX4QlQyIqrbYLPamM/B7R8rwR/HHd5WYqQRpSiMCGdk+4E4UqTua2T389fSbzA8Z+dxhlChuywF0/oz8vaXVHUaxyqgi6EqGmNxzillidxJQYNcUVXyrEFk025oyxZAQywAHqPbD0pZpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MaJz6/er; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MaJz6/er"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBF8C4CEDD;
	Tue, 14 Jan 2025 06:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836005;
	bh=8+cAAGyL/XsHxmOPQQukAkDR+DdntKWbkf/8xjTrj18=;
	h=Date:To:From:Subject:From;
	b=MaJz6/erUrsvzeq6Fale6z/WC1ZubU3xiMuAnSR9i7L32mdam8Adkj4ALHrGedWIt
	 n4Lkq3tzTYjuWag4ohM5hiGeam+DwBTKlbRlzuSADELAYcqaUspC9mecvV49Haq+ef
	 XoxZd7Med9WdMZufvpqDJO3T0mynUcjWhxnLouhk=
Date: Mon, 13 Jan 2025 22:26:44 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,souravpanda@google.com,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch removed from -mm tree
Message-Id: <20250114062645.7CBF8C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-introduce-mmap_lock_speculate_try_beginretry-fix
has been removed from the -mm tree.  Its filename was
     mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch

This patch was dropped because it was folded into mm-introduce-mmap_lock_speculate_try_beginretry.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-introduce-mmap_lock_speculate_try_beginretry-fix
Date: Fri Dec  6 08:24:17 PM PST 2024

use read_seqcount_retry() in mmap_lock_speculate_retry(), per Wei Yang

Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mmap_lock.h~mm-introduce-mmap_lock_speculate_try_beginretry-fix
+++ a/include/linux/mmap_lock.h
@@ -101,7 +101,7 @@ static inline bool mmap_lock_speculate_t
 
 static inline bool mmap_lock_speculate_retry(struct mm_struct *mm, unsigned int seq)
 {
-	return do_read_seqcount_retry(&mm->mm_lock_seq, seq);
+	return read_seqcount_retry(&mm->mm_lock_seq, seq);
 }
 
 #else /* CONFIG_PER_VMA_LOCK */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-introduce-mmap_lock_speculate_try_beginretry.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
mm-huge_memoryc-rename-shadowed-local.patch
mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix.patch
ksm-add-ksm-involvement-information-for-each-process-fix.patch
documentation-filesystems-procrst-fix-possessive-form-of-process.patch

