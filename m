Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596418C08
	for <mm-commits@vger.kernel.org>; Wed, 24 Jan 2024 10:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706091430; cv=none; b=J2DwstDz2AsFx10k5DQuxoZRyrUuluu5nvsFZbmyn+Fo3xjqetArvtNUB+lul5asYzL2T5h5EJG+uJ2JXS62ChxkfylRV9oHaZ2sjF84zQm2a9R0Wao3CruhXrL1Wa2YEcjzCAR1w/vSHINxvCqM8LEsdpLMD+zXiRpPE6UtelU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706091430; c=relaxed/simple;
	bh=jdPXvL9uwjQg+I/Tp1HtUrD+IBx+K3pLirPHMriVCr8=;
	h=Date:To:From:Subject:Message-Id; b=lD5+DIAi0QPxfSwUEBGo3aonq/ai+TNKHTMwLL1vfCjtMWF86kHwwKpgvPR0MqDfrBehGaq2NTzkS6Cuc58HiC2q0s9FBDZrT3Gq8OyKC1g1hOuMaaNA4MXrYC/ojB9Z3Sjoaj3lSqfcwU3jMtMFT6Pq8UPBuy4rKOESVYV4hNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PW5RVn8e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PW5RVn8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AB2C43394;
	Wed, 24 Jan 2024 10:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706091429;
	bh=jdPXvL9uwjQg+I/Tp1HtUrD+IBx+K3pLirPHMriVCr8=;
	h=Date:To:From:Subject:From;
	b=PW5RVn8efH16AGqDBA1lDv1fmVam3LlQle6Ujo9xMYS3fy5nWB55KYLQHOTeb09Ty
	 9XeSztFRHifN1YqyGt7y7mbkVLHmo6RqKN9AwzNLVFMqTzDMTdQwMGeyvEb2dHIM51
	 iyChsLW1EcUtzGRJYw06GadtUv6JQNdIYztiqwNw=
Date: Wed, 24 Jan 2024 02:17:07 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yangxingui@huawei.com,willy@infradead.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,usama.anjum@collabora.com,talumbau@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,ryan.roberts@arm.com,peterx@redhat.com,paulmck@kernel.org,mgorman@techsingularity.net,mathieu.desnoyers@efficios.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,keescook@chromium.org,jhubbard@nvidia.com,jgg@ziepe.ca,jack@suse.cz,hughd@google.com,dhowells@redhat.com,dchinner@redhat.com,david@redhat.com,casey@schaufler-ca.com,brauner@kernel.org,ben.wolsieffer@hefring.com,axelrasmussen@google.com,avagin@google.com,andriy.shevchenko@linux.intel.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-vm_area_struct-anon_name-field-rcu-safe.patch added to mm-unstable branch
Message-Id: <20240124101709.07AB2C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make vm_area_struct anon_name field RCU-safe
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-vm_area_struct-anon_name-field-rcu-safe.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-vm_area_struct-anon_name-field-rcu-safe.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: make vm_area_struct anon_name field RCU-safe
Date: Tue, 23 Jan 2024 15:10:12 -0800

For lockless /proc/pid/maps reading we have to ensure all the fields used
when generating the output are RCU-safe.  The only pointer fields in
vm_area_struct which are used to generate that file's output are vm_file
and anon_name.  vm_file is RCU-safe but anon_name is not.  Make anon_name
RCU-safe as well.

Link: https://lkml.kernel.org/r/20240123231014.3801041-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrei Vagin <avagin@google.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Ben Wolsieffer <ben.wolsieffer@hefring.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: T.J. Alumbaugh <talumbau@google.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xingui Yang <yangxingui@huawei.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   10 +++++++++-
 include/linux/mm_types.h  |    3 ++-
 mm/madvise.c              |   30 ++++++++++++++++++++++++++----
 3 files changed, 37 insertions(+), 6 deletions(-)

--- a/include/linux/mm_inline.h~mm-make-vm_area_struct-anon_name-field-rcu-safe
+++ a/include/linux/mm_inline.h
@@ -389,7 +389,7 @@ static inline void dup_anon_vma_name(str
 	struct anon_vma_name *anon_name = anon_vma_name(orig_vma);
 
 	if (anon_name)
-		new_vma->anon_name = anon_vma_name_reuse(anon_name);
+		rcu_assign_pointer(new_vma->anon_name, anon_vma_name_reuse(anon_name));
 }
 
 static inline void free_anon_vma_name(struct vm_area_struct *vma)
@@ -411,6 +411,8 @@ static inline bool anon_vma_name_eq(stru
 		!strcmp(anon_name1->name, anon_name2->name);
 }
 
+struct anon_vma_name *anon_vma_name_get_rcu(struct vm_area_struct *vma);
+
 #else /* CONFIG_ANON_VMA_NAME */
 static inline void anon_vma_name_get(struct anon_vma_name *anon_name) {}
 static inline void anon_vma_name_put(struct anon_vma_name *anon_name) {}
@@ -424,6 +426,12 @@ static inline bool anon_vma_name_eq(stru
 	return true;
 }
 
+static inline
+struct anon_vma_name *anon_vma_name_get_rcu(struct vm_area_struct *vma)
+{
+	return NULL;
+}
+
 #endif  /* CONFIG_ANON_VMA_NAME */
 
 static inline void init_tlb_flush_pending(struct mm_struct *mm)
--- a/include/linux/mm_types.h~mm-make-vm_area_struct-anon_name-field-rcu-safe
+++ a/include/linux/mm_types.h
@@ -545,6 +545,7 @@ struct vm_userfaultfd_ctx {};
 
 struct anon_vma_name {
 	struct kref kref;
+	struct rcu_head rcu;
 	/* The name needs to be at the end because it is dynamically sized. */
 	char name[];
 };
@@ -699,7 +700,7 @@ struct vm_area_struct {
 	 * terminated string containing the name given to the vma, or NULL if
 	 * unnamed. Serialized by mmap_lock. Use anon_vma_name to access.
 	 */
-	struct anon_vma_name *anon_name;
+	struct anon_vma_name __rcu *anon_name;
 #endif
 #ifdef CONFIG_SWAP
 	atomic_long_t swap_readahead_info;
--- a/mm/madvise.c~mm-make-vm_area_struct-anon_name-field-rcu-safe
+++ a/mm/madvise.c
@@ -88,14 +88,15 @@ void anon_vma_name_free(struct kref *kre
 {
 	struct anon_vma_name *anon_name =
 			container_of(kref, struct anon_vma_name, kref);
-	kfree(anon_name);
+	kfree_rcu(anon_name, rcu);
 }
 
 struct anon_vma_name *anon_vma_name(struct vm_area_struct *vma)
 {
 	mmap_assert_locked(vma->vm_mm);
 
-	return vma->anon_name;
+	return rcu_dereference_protected(vma->anon_name,
+		rwsem_is_locked(&vma->vm_mm->mmap_lock));
 }
 
 /* mmap_lock should be write-locked */
@@ -105,7 +106,7 @@ static int replace_anon_vma_name(struct
 	struct anon_vma_name *orig_name = anon_vma_name(vma);
 
 	if (!anon_name) {
-		vma->anon_name = NULL;
+		rcu_assign_pointer(vma->anon_name, NULL);
 		anon_vma_name_put(orig_name);
 		return 0;
 	}
@@ -113,11 +114,32 @@ static int replace_anon_vma_name(struct
 	if (anon_vma_name_eq(orig_name, anon_name))
 		return 0;
 
-	vma->anon_name = anon_vma_name_reuse(anon_name);
+	rcu_assign_pointer(vma->anon_name, anon_vma_name_reuse(anon_name));
 	anon_vma_name_put(orig_name);
 
 	return 0;
 }
+
+/*
+ * Returned anon_vma_name is stable due to elevated refcount but not guaranteed
+ * to be assigned to the original VMA after the call.
+ */
+struct anon_vma_name *anon_vma_name_get_rcu(struct vm_area_struct *vma)
+{
+	struct anon_vma_name __rcu *anon_name;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
+	anon_name = rcu_dereference(vma->anon_name);
+	if (!anon_name)
+		return NULL;
+
+	if (unlikely(!kref_get_unless_zero(&anon_name->kref)))
+		return NULL;
+
+	return anon_name;
+}
+
 #else /* CONFIG_ANON_VMA_NAME */
 static int replace_anon_vma_name(struct vm_area_struct *vma,
 				 struct anon_vma_name *anon_name)
_

Patches currently in -mm which might be from surenb@google.com are

mm-make-vm_area_struct-anon_name-field-rcu-safe.patch
mm-add-mm_struct-sequence-number-to-detect-write-locks.patch
mm-maps-read-proc-pid-maps-under-rcu.patch

