Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FA718872F
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 22:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733350386; cv=none; b=svhE8LTw69GPYGdgzIDMcwhc7F0Pco3FVwd7ImKIAiUn8wgx/UBxEbceTArt0aPrQVcMYONi32rxgmnK7y9QbR6RvFlfRUhjo0Ne+Lr8uZ3nWCuQkcqLluMmSRy3vzDkKTAbjVUToGuIbEfDJ7Mmnj/chTUx8fCASfXCLlMOeT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733350386; c=relaxed/simple;
	bh=YAn+SbxRvo75Jjii5PWVqNXmyRSL3gjJMs6a1tAfgNw=;
	h=Date:To:From:Subject:Message-Id; b=Ie7Nbg2Hdw1uJoSBIYVp70/WwOZyw6arWM26iBW2GPk6pd+m3bgh1pPtswgh2atrA1btgz0No61lCiZ2SoJAuYQ6IOoWUw/Xkoe4npZi+xOCzy4CmSU7SoFcpFYRDD3ZAnoGzbTdbfKrAldh6jLDX+xAQIJXpXXp2dewPg7Tg5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LRSLOO/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LRSLOO/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89657C4CECD;
	Wed,  4 Dec 2024 22:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733350385;
	bh=YAn+SbxRvo75Jjii5PWVqNXmyRSL3gjJMs6a1tAfgNw=;
	h=Date:To:From:Subject:From;
	b=LRSLOO/nJt1fwmX9odKm+fV5ekhoSVeZYHLuyTse3UfoXxssAN9rWqeGPNT/ydZwV
	 ZJ0pxoQ1hsjLv2eFzBnlt0gR7sNptAhnuxzUikmHHTDzw2v1CTGLl0vse4pjOSH6J7
	 acfePZycwvOjuHa3ph7Z8H7cKBesm2Q+ZamVcBQk=
Date: Wed, 04 Dec 2024 14:13:04 -0800
To: mm-commits@vger.kernel.org,xuanzhuo@linux.alibaba.com,vgoyal@redhat.com,thuth@redhat.com,svens@linux.ibm.com,mst@redhat.com,jasowang@redhat.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,frankja@linux.ibm.com,farman@linux.ibm.com,eperezma@redhat.com,dyoung@redhat.com,cohuck@redhat.com,borntraeger@linux.ibm.com,bhe@redhat.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-vmcore-convert-vmcore_cb_lock-into-vmcore_mutex.patch added to mm-unstable branch
Message-Id: <20241204221305.89657C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/vmcore: convert vmcore_cb_lock into vmcore_mutex
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-vmcore-convert-vmcore_cb_lock-into-vmcore_mutex.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-vmcore-convert-vmcore_cb_lock-into-vmcore_mutex.patch

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
Subject: fs/proc/vmcore: convert vmcore_cb_lock into vmcore_mutex
Date: Wed, 4 Dec 2024 13:54:32 +0100

Patch series "fs/proc/vmcore: kdump support for virtio-mem on s390", v2.

The only "different than everything else" thing about virtio-mem on s390
is kdump: The crash (2nd) kernel allocates+prepares the elfcore hdr during
fs_init()->vmcore_init()->elfcorehdr_alloc().  Consequently, the kdump
kernel must detect memory ranges of the crashed kernel to include via
PT_LOAD in the vmcore.

On other architectures, all RAM regions (boot + hotplugged) can easily be
observed on the old (to crash) kernel (e.g., using /proc/iomem) to create
the elfcore hdr.

On s390, information about "ordinary" memory (heh, "storage") can be
obtained by querying the hypervisor/ultravisor via SCLP/diag260, and
that information is stored early during boot in the "physmem" memblock
data structure.

But virtio-mem memory is always detected by a device driver, which is
usually built as a module.  So in the crash kernel, this memory can only
be properly detected once the virtio-mem driver has started up.

The virtio-mem driver already supports the "kdump mode", where it won't
hotplug any memory but instead queries the device to implement the
pfn_is_ram() callback, to avoid reading unplugged memory holes when reading
the vmcore.

With this series, if the virtio-mem driver is included in the kdump
initrd -- which dracut already takes care of under Fedora/RHEL -- it will
now detect the device RAM ranges on s390 once it probes the devices, to add
them to the vmcore using the same callback mechanism we already have for
pfn_is_ram().

To add these device RAM ranges to the vmcore ("patch the vmcore"), we will
add new PT_LOAD entries that describe these memory ranges, and update
all offsets vmcore size so it is all consistent.

My testing when creating+analyzing crash dumps with hotplugged virtio-mem
memory (incl. holes) did not reveal any surprises.


This patch (of 12):

We want to protect vmcore modifications from concurrent opening of the
vmcore, and also serialize vmcore modification.

(a) We can currently modify the vmcore after it was opened. This can happen
    if a vmcoredd is added after the vmcore module was initialized and
    already opened by user space. We want to fix that and prepare for
    new code wanting to serialize against concurrent opening.

(b) To handle it cleanly we need to protect the modifications against
    concurrent opening. As the modifications end up allocating memory and
    can sleep, we cannot rely on the spinlock.

Let's convert the spinlock into a mutex to prepare for further changes.

Link: https://lkml.kernel.org/r/20241204125444.1734652-1-david@redhat.com
Link: https://lkml.kernel.org/r/20241204125444.1734652-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Eric Farman <farman@linux.ibm.com>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/fs/proc/vmcore.c~fs-proc-vmcore-convert-vmcore_cb_lock-into-vmcore_mutex
+++ a/fs/proc/vmcore.c
@@ -62,7 +62,8 @@ core_param(novmcoredd, vmcoredd_disabled
 /* Device Dump Size */
 static size_t vmcoredd_orig_sz;
 
-static DEFINE_SPINLOCK(vmcore_cb_lock);
+static DEFINE_MUTEX(vmcore_mutex);
+
 DEFINE_STATIC_SRCU(vmcore_cb_srcu);
 /* List of registered vmcore callbacks. */
 static LIST_HEAD(vmcore_cb_list);
@@ -72,7 +73,7 @@ static bool vmcore_opened;
 void register_vmcore_cb(struct vmcore_cb *cb)
 {
 	INIT_LIST_HEAD(&cb->next);
-	spin_lock(&vmcore_cb_lock);
+	mutex_lock(&vmcore_mutex);
 	list_add_tail(&cb->next, &vmcore_cb_list);
 	/*
 	 * Registering a vmcore callback after the vmcore was opened is
@@ -80,13 +81,13 @@ void register_vmcore_cb(struct vmcore_cb
 	 */
 	if (vmcore_opened)
 		pr_warn_once("Unexpected vmcore callback registration\n");
-	spin_unlock(&vmcore_cb_lock);
+	mutex_unlock(&vmcore_mutex);
 }
 EXPORT_SYMBOL_GPL(register_vmcore_cb);
 
 void unregister_vmcore_cb(struct vmcore_cb *cb)
 {
-	spin_lock(&vmcore_cb_lock);
+	mutex_lock(&vmcore_mutex);
 	list_del_rcu(&cb->next);
 	/*
 	 * Unregistering a vmcore callback after the vmcore was opened is
@@ -95,7 +96,7 @@ void unregister_vmcore_cb(struct vmcore_
 	 */
 	if (vmcore_opened)
 		pr_warn_once("Unexpected vmcore callback unregistration\n");
-	spin_unlock(&vmcore_cb_lock);
+	mutex_unlock(&vmcore_mutex);
 
 	synchronize_srcu(&vmcore_cb_srcu);
 }
@@ -120,9 +121,9 @@ static bool pfn_is_ram(unsigned long pfn
 
 static int open_vmcore(struct inode *inode, struct file *file)
 {
-	spin_lock(&vmcore_cb_lock);
+	mutex_lock(&vmcore_mutex);
 	vmcore_opened = true;
-	spin_unlock(&vmcore_cb_lock);
+	mutex_unlock(&vmcore_mutex);
 
 	return 0;
 }
_

Patches currently in -mm which might be from david@redhat.com are

mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm.patch
mm-filemap-dont-call-folio_test_locked-without-a-reference-in-next_uptodate_folio.patch
docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch
mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range.patch
mm-page_isolation-dont-pass-gfp-flags-to-isolate_single_pageblock.patch
mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range.patch
mm-page_alloc-make-__alloc_contig_migrate_range-static.patch
mm-page_alloc-sort-out-the-alloc_contig_range-gfp-flags-mess.patch
mm-page_alloc-forward-the-gfp-flags-from-alloc_contig_range-to-post_alloc_hook.patch
powernv-memtrace-use-__gfp_zero-with-alloc_contig_pages.patch
mm-hugetlb-dont-map-folios-writable-without-vm_write-when-copying-during-fork.patch
fs-proc-vmcore-convert-vmcore_cb_lock-into-vmcore_mutex.patch
fs-proc-vmcore-replace-vmcoredd_mutex-by-vmcore_mutex.patch
fs-proc-vmcore-disallow-vmcore-modifications-while-the-vmcore-is-open.patch
fs-proc-vmcore-prefix-all-pr_-with-vmcore.patch
fs-proc-vmcore-move-vmcore-definitions-out-of-kcoreh.patch
fs-proc-vmcore-factor-out-allocating-a-vmcore-range-and-adding-it-to-a-list.patch
fs-proc-vmcore-factor-out-freeing-a-list-of-vmcore-ranges.patch
fs-proc-vmcore-introduce-proc_vmcore_device_ram-to-detect-device-ram-ranges-in-2nd-kernel.patch
virtio-mem-mark-device-ready-before-registering-callbacks-in-kdump-mode.patch
virtio-mem-remember-usable-region-size.patch
virtio-mem-support-config_proc_vmcore_device_ram.patch
s390-kdump-virtio-mem-kdump-support-config_proc_vmcore_device_ram.patch

