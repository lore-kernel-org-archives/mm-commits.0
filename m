Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E5B135A55
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 22:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711059185; cv=none; b=JLDctOLJugo3V43psIH4C8gpPPmCYZHkjNGATKYAJNLdyXAGplxBJY0kstfWGRrG+uD0KHprQKZB2mGsw3guSVVoDoTxQBEuWnNXDISDVDVhForHi+WXcXz2pGfEmukyenOnJXaPC6Upu+19MRSIHep21hnuPTCgH0JRMDcswLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711059185; c=relaxed/simple;
	bh=mxCjPk86akjmhfjJfkq59wEs5csxaSWzzVGpIplMKlU=;
	h=Date:To:From:Subject:Message-Id; b=KgYOSmC+ZUV1hYNWtqO4SjDh/lHdqrr96U/WgWa6VauQwFMtcuQeIlK0OIbDUH3KJRvdIeVpV6ESCa1HtAH48O28eJ+axZFnO7pvt/+MN+s6cAhSM5f1vUrBcLdMDmXEU89GdwMmHdQN02LNNJ3UMOee2hGvHhk9PwvmALI36ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DNiH4QHl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DNiH4QHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A88C433F1;
	Thu, 21 Mar 2024 22:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711059184;
	bh=mxCjPk86akjmhfjJfkq59wEs5csxaSWzzVGpIplMKlU=;
	h=Date:To:From:Subject:From;
	b=DNiH4QHlKCI7pO/8BqaAIgTMq2gwASt7jn20rwy0JhI/19SZ72ZJBjsXBT2MUNiAi
	 8eWJLFJf9Ede5lZnpBvEXnqozEwW6dCFQusSrmbO500twU0R9PEtgxwEfmC8DV+4QK
	 0U3edzLfHSDIZZuuWh966qA4A8ijcVuykpsUB6Wo=
Date: Thu, 21 Mar 2024 15:13:03 -0700
To: mm-commits@vger.kernel.org,svens@linux.ibm.com,peterx@redhat.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,aarcange@redhat.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-dont-place-zeropages-when-zeropages-are-disallowed.patch added to mm-unstable branch
Message-Id: <20240321221304.A1A88C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/userfaultfd: don't place zeropages when zeropages are disallowed
has been added to the -mm mm-unstable branch.  Its filename is
     mm-userfaultfd-dont-place-zeropages-when-zeropages-are-disallowed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-dont-place-zeropages-when-zeropages-are-disallowed.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/userfaultfd: don't place zeropages when zeropages are disallowed
Date: Thu, 21 Mar 2024 22:59:53 +0100

Patch series "s390/mm: shared zeropage + KVM fix and optimization".

This series fixes one issue with uffd + shared zeropages on s390x and
optimizes "ordinary" KVM guests to make use of shared zeropages again.

userfaultfd could currently end up mapping shared zeropages into processes
that forbid shared zeropages.  This only apples to s390x, relevant for
handling PV guests and guests that use storage kets correctly.  Fix it by
placing a zeroed folio instead of the shared zeropage during
UFFDIO_ZEROPAGE instead.

I stumbled over this issue while looking into a customer scenario that
is using:

(1) Memory ballooning for dynamic resizing. Start a VM with, say, 100 GiB
    and inflate the balloon during boot to 60 GiB. The VM has ~40 GiB
    available and additional memory can be "fake hotplugged" to the VM
    later on demand by deflating the balloon. Actual memory overcommit is
    not desired, so physical memory would only be moved between VMs.

(2) Live migration of VMs between sites to evacuate servers in case of
    emergency.

Without the shared zeropage, during (2), the VM would suddenly consume 100
GiB on the migration source and destination.  On the migration source,
where we don't excpect memory overcommit, we could easilt end up crashing
the VM during migration.

Independent of that, memory handed back to the hypervisor using "free page
reporting" would end up consuming actual memory after the migration on the
destination, not getting freed up until reused+freed again.

While there might be ways to optimize parts of this in QEMU, we really
should just support the shared zeropage again for ordinary VMs.

We only expect legcy guests to make use of storage keys, so let's handle
zeropages again when enabling storage keys or when enabling PV.  To not
break userfaultfd like we did in the past, don't zap the shared zeropages,
but instead trigger unsharing faults, just like we do for unsharing KSM
pages in break_ksm().

Unsharing faults will simply replace the shared zeropage by a zeroed
anonymous folio.  We can already trigger the same fault path using GUP,
when trying to long-term pin a shared zeropage, but also when unmerging a
KSM-placed zeropages, so this is nothing new.


This patch (of 2):

s390x must disable shared zeropages for processes running VMs, because the
VMs could end up making use of "storage keys" or protected virtualization,
which are incompatible with shared zeropages.

Yet, with userfaultfd it is possible to insert shared zeropages into such
processes.  Let's fallback to simply allocating a fresh zeroed anonymous
folio and insert that instead.

mm_forbids_zeropage() was introduced in commit 593befa6ab74 ("mm:
introduce mm_forbids_zeropage function"), briefly before userfaultfd went
upstream.

Note that we don't want to fail the UFFDIO_ZEROPAGE request like we do for
hugetlb, it would be rather unexpected.  Further, we also cannot really
indicated "not supported" to user space ahead of time: it could be that
the MM disallows zeropages after userfaultfd was already registered.

Link: https://lkml.kernel.org/r/20240321215954.177730-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240321215954.177730-2-david@redhat.com
Fixes: c1a4de99fada ("userfaultfd: mcopy_atomic|mfill_zeropage: UFFDIO_COPY|UFFDIO_ZEROPAGE preparation")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

--- a/mm/userfaultfd.c~mm-userfaultfd-dont-place-zeropages-when-zeropages-are-disallowed
+++ a/mm/userfaultfd.c
@@ -316,6 +316,38 @@ out_release:
 	goto out;
 }
 
+static int mfill_atomic_pte_zeroed_folio(pmd_t *dst_pmd,
+		 struct vm_area_struct *dst_vma, unsigned long dst_addr)
+{
+	struct folio *folio;
+	int ret;
+
+	folio = vma_alloc_zeroed_movable_folio(dst_vma, dst_addr);
+	if (!folio)
+		return -ENOMEM;
+
+	ret = -ENOMEM;
+	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
+		goto out_put;
+
+	/*
+	 * The memory barrier inside __folio_mark_uptodate makes sure that
+	 * preceding stores to the page contents become visible before
+	 * the set_pte_at() write.
+	 */
+	__folio_mark_uptodate(folio);
+
+	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
+				       &folio->page, true, 0);
+	if (ret)
+		goto out_put;
+
+	return 0;
+out_put:
+	folio_put(folio);
+	return ret;
+}
+
 static int mfill_atomic_pte_zeropage(pmd_t *dst_pmd,
 				     struct vm_area_struct *dst_vma,
 				     unsigned long dst_addr)
@@ -324,6 +356,9 @@ static int mfill_atomic_pte_zeropage(pmd
 	spinlock_t *ptl;
 	int ret;
 
+	if (mm_forbids_zeropage(dst_vma->mm))
+		return mfill_atomic_pte_zeroed_folio(dst_pmd, dst_vma, dst_addr);
+
 	_dst_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
 					 dst_vma->vm_page_prot));
 	ret = -EAGAIN;
_

Patches currently in -mm which might be from david@redhat.com are

mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly.patch
mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch
mm-userfaultfd-dont-place-zeropages-when-zeropages-are-disallowed.patch
s390-mm-re-enable-the-shared-zeropage-for-pv-and-skeys-kvm-guests.patch

