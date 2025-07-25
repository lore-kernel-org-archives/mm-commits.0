Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552C715E90
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409714; cv=none; b=CDY2iqd+6SUOz8IRkzgGbB2Sn6v9h1n3raQ9JlGFFg04xkkDjLC2PSlVZwa5KrUj09pPs3VhnZMjhSMF5Oh3NNx0CwKtYjnzV8yY6kwj1tLDUmZCDqNMYHndbCIE92bbRg+Kc0jbUFVCegRQxq5z3pFlBCXakeZTQ0thijkWeKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409714; c=relaxed/simple;
	bh=K+5P7e4NXAAN3Fwvi/IijEOEXLrOCzPhti94yjxZkCg=;
	h=Date:To:From:Subject:Message-Id; b=XOB6daAELANKoSDheQYtvUUKYNURtzg8so9n4/kGWeM2LE377uLb+c3jFdIczHW1cGd1kv28gNI+XPVan2kljIbS7UVbqhZwFH37qrGQNFWS39OkNeor4llFN1+9Fpy49/l0PKarvthRpQpP70WLU2H0+Lo0knvsMMLDDkSvrpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KaXd0KRQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KaXd0KRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C07C4CEED;
	Fri, 25 Jul 2025 02:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409714;
	bh=K+5P7e4NXAAN3Fwvi/IijEOEXLrOCzPhti94yjxZkCg=;
	h=Date:To:From:Subject:From;
	b=KaXd0KRQvMGVeyPU2if+0IWlbpUr1hNBD7GJpdlhRm0t5SN4ns2zPrZW9PORbjoEm
	 Z1ofM7wYQLgVXwZX8YzUKqscbqI3cmfc98ZE+RdZo+eSlxQxzfQYNUn1DJILpnG57J
	 /F3Pyz6W2UnrrJYO+pe52nEMBY/FphGbJzFN3Lg8=
Date: Thu, 24 Jul 2025 19:15:13 -0700
To: mm-commits@vger.kernel.org,yebin10@huawei.com,willy@infradead.org,vbabka@suse.cz,tjmercier@google.com,shuah@kernel.org,ryan.roberts@arm.com,peterx@redhat.com,paulmck@kernel.org,osalvador@suse.de,mhocko@kernel.org,lorenzo.stoakes@oracle.com,linux@weissschuh.net,liam.howlett@oracle.com,kaleshsingh@google.com,josef@toxicpanda.com,jannh@google.com,hannes@cmpxchg.org,david@redhat.com,christophe.leroy@csgroup.eu,brauner@kernel.org,andrii@kernel.org,aha310510@gmail.com,adobriyan@gmail.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-task_mmu-remove-conversion-of-seq_file-position-to-unsigned.patch removed from -mm tree
Message-Id: <20250725021514.27C07C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: remove conversion of seq_file position to unsigned
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-remove-conversion-of-seq_file-position-to-unsigned.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: fs/proc/task_mmu: remove conversion of seq_file position to unsigned
Date: Sat, 19 Jul 2025 11:28:53 -0700

Back in 2.6 era, last_addr used to be stored in seq_file->version
variable, which was unsigned long.  As a result, sentinels to represent
gate vma and end of all vmas used unsigned values.  In more recent kernels
we don't used seq_file->version anymore and therefore conversion from
loff_t into unsigned type is not needed.  Similarly, sentinel values don't
need to be unsigned.  Remove type conversion for set_file position and
change sentinel values to signed.  While at it, change the hardcoded
sentinel values with named definitions for better documentation.

Link: https://lkml.kernel.org/r/20250719182854.3166724-6-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Jann Horn <jannh@google.com>
Cc: Jeongjun Park <aha310510@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Cc: T.J. Mercier <tjmercier@google.com>
Cc: Ye Bin <yebin10@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-remove-conversion-of-seq_file-position-to-unsigned
+++ a/fs/proc/task_mmu.c
@@ -29,6 +29,9 @@
 #include <asm/tlbflush.h>
 #include "internal.h"
 
+#define SENTINEL_VMA_END	-1
+#define SENTINEL_VMA_GATE	-2
+
 #define SEQ_PUT_DEC(str, val) \
 		seq_put_decimal_ull_width(m, str, (val) << (PAGE_SHIFT-10), 8)
 void task_mem(struct seq_file *m, struct mm_struct *mm)
@@ -135,7 +138,7 @@ static struct vm_area_struct *proc_get_v
 	if (vma) {
 		*ppos = vma->vm_start;
 	} else {
-		*ppos = -2UL;
+		*ppos = SENTINEL_VMA_GATE;
 		vma = get_gate_vma(priv->mm);
 	}
 
@@ -145,11 +148,11 @@ static struct vm_area_struct *proc_get_v
 static void *m_start(struct seq_file *m, loff_t *ppos)
 {
 	struct proc_maps_private *priv = m->private;
-	unsigned long last_addr = *ppos;
+	loff_t last_addr = *ppos;
 	struct mm_struct *mm;
 
 	/* See m_next(). Zero at the start or after lseek. */
-	if (last_addr == -1UL)
+	if (last_addr == SENTINEL_VMA_END)
 		return NULL;
 
 	priv->task = get_proc_task(priv->inode);
@@ -170,9 +173,9 @@ static void *m_start(struct seq_file *m,
 		return ERR_PTR(-EINTR);
 	}
 
-	vma_iter_init(&priv->iter, mm, last_addr);
+	vma_iter_init(&priv->iter, mm, (unsigned long)last_addr);
 	hold_task_mempolicy(priv);
-	if (last_addr == -2UL)
+	if (last_addr == SENTINEL_VMA_GATE)
 		return get_gate_vma(mm);
 
 	return proc_get_vma(priv, ppos);
@@ -180,8 +183,8 @@ static void *m_start(struct seq_file *m,
 
 static void *m_next(struct seq_file *m, void *v, loff_t *ppos)
 {
-	if (*ppos == -2UL) {
-		*ppos = -1UL;
+	if (*ppos == SENTINEL_VMA_GATE) {
+		*ppos = SENTINEL_VMA_END;
 		return NULL;
 	}
 	return proc_get_vma(m->private, ppos);
_

Patches currently in -mm which might be from surenb@google.com are


