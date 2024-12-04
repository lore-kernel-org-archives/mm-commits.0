Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5539918872F
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 22:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733350390; cv=none; b=Xh7Qgda2Wnz8txzAkfA4Q2Olz6jmF1mklsAJDb+hxqBaJmPNLxfx7NJ+2Thyup+0JDt9E3aOtSkRZsCjpB1vaGiTwH9k3BR6gQady/KUVENMWWZIOD1XII7vFNhky7Qb5zF7hKSgUj0JePPlk8QFqIofQ0O2LifLKAIqUuZ2Bfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733350390; c=relaxed/simple;
	bh=5HrEwZ3zs8KQYgyadaSuhr7CBBxc65Pne7mbQF4fFqQ=;
	h=Date:To:From:Subject:Message-Id; b=qaam0LZ6wvh4vjR1HrxAYb3gpcwb0dVWQLzsAUDen9wIO+vm+ysRjH+EKeisqd+doNqP2UOhdlYXvrj/aGcaWjqjzEEfiflwGLjNILgweo9g6W3K3ZHGqm6XX9+Gd5qHVfNaIT7EIbcZI4+pgGA8G358nnnu92HeWGqXxdodhmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QdfhcJfy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QdfhcJfy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D04C4CECD;
	Wed,  4 Dec 2024 22:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733350389;
	bh=5HrEwZ3zs8KQYgyadaSuhr7CBBxc65Pne7mbQF4fFqQ=;
	h=Date:To:From:Subject:From;
	b=QdfhcJfyZlUIEiJYzd1s2Q7jt4XdG9A2wYrXrwI6hwxzkNLSHgkPJn17cK3bRslni
	 GbWiz3kTODU5bfs70RtY8bVSf/AupRYqKUahZqPW6OCdR+sw/CMxuQatoMCvsSetvC
	 zCP5QsvNbYvsbw5/Ke086B5OQvrzUqZvlWdF47to=
Date: Wed, 04 Dec 2024 14:13:09 -0800
To: mm-commits@vger.kernel.org,xuanzhuo@linux.alibaba.com,vgoyal@redhat.com,thuth@redhat.com,svens@linux.ibm.com,mst@redhat.com,jasowang@redhat.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,frankja@linux.ibm.com,farman@linux.ibm.com,eperezma@redhat.com,dyoung@redhat.com,cohuck@redhat.com,borntraeger@linux.ibm.com,bhe@redhat.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-vmcore-prefix-all-pr_-with-vmcore.patch added to mm-unstable branch
Message-Id: <20241204221309.C2D04C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/vmcore: prefix all pr_* with "vmcore:"
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-vmcore-prefix-all-pr_-with-vmcore.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-vmcore-prefix-all-pr_-with-vmcore.patch

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
Subject: fs/proc/vmcore: prefix all pr_* with "vmcore:"
Date: Wed, 4 Dec 2024 13:54:35 +0100

Let's use "vmcore: " as a prefix, converting the single "Kdump: vmcore not
initialized" one to effectively be "vmcore: not initialized".

Link: https://lkml.kernel.org/r/20241204125444.1734652-5-david@redhat.com
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

 fs/proc/vmcore.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/proc/vmcore.c~fs-proc-vmcore-prefix-all-pr_-with-vmcore
+++ a/fs/proc/vmcore.c
@@ -8,6 +8,8 @@
  *
  */
 
+#define pr_fmt(fmt) "vmcore: " fmt
+
 #include <linux/mm.h>
 #include <linux/kcore.h>
 #include <linux/user.h>
@@ -1580,7 +1582,7 @@ static int __init vmcore_init(void)
 	rc = parse_crash_elf_headers();
 	if (rc) {
 		elfcorehdr_free(elfcorehdr_addr);
-		pr_warn("Kdump: vmcore not initialized\n");
+		pr_warn("not initialized\n");
 		return rc;
 	}
 	elfcorehdr_free(elfcorehdr_addr);
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

