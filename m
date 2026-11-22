Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795373487;
	b=snjch2Lx/a0VmEz20owsAAwqyzkjWdsUjApEcrzzOo+AGGINKoEZ+2MOhI2Rp8DLH/dM
	 I21UY6w6PReF35VQD7LWbTEObIWHIvbrGbIBpo2xNHr2zgEjL54iARR8PfsakHGG9eFQd
	 Eqr5LPmsutJJ2gfLQXa3kQyX/tPFpVa45BSLSuMsmUvBo+XR/82Ousa4waA5+UOadJS+G
	 ris/T9qi/BcfcUCLgS0OESugfoK3QrDeCn48o10kEoQrz7x7IYq7bUUz0U4vSx5cQL4wp
	 WrJOOUPyI3aLXRVBaJJaWcLooNIcDopdVyy7s6EMdohswpOVADxNQz3QfGjI2JZg8rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795373487;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=+LVSlYU3dkwwrxH51NX50Ss4EjFZNkCeLTJwD4+akng=;
	b=OzwFfYk50L7FSkBhNymNqcoLaqMLuB59P2srhCOIdPjm3Hbg7FrGHMxHVCtX0jdN37pw
	 FJClEDFO3kFYxoM2/7eYPf0B9qAuV1SW6Fj8Hvr4eUmjzyGAw35C8Rj0+bg+lWevCaOrY
	 EXEM4lX7OS5FtZZQ4ywbXwcNrgVPpx7/pSRhObJ7Q0Uy+eF8H8T3kzpu0Plop2FvsOF4Y
	 O+h+TdFQJagDwQXB3juPd/YPwj4UYA3d59N4EswefG9dG2o4gOlXo7eHpDo4mo9/P5IjS
	 71QF85ymkwfqXnRCnlSPA01RbDTzwkcVWqhIsUpPXlZQqiie0gN8DIpfC8Ged9dmnJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fBTi1KE+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AC9606A32A
	for <mm-commits@vger.kernel.org>; Sun, 22 Nov 2026 18:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fBTi1KE+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820861F000ED;
	Sun, 22 Nov 2026 18:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795373486;
	bh=+LVSlYU3dkwwrxH51NX50Ss4EjFZNkCeLTJwD4+akng=;
	h=Date:To:From:Subject;
	b=fBTi1KE+tnr+dt/pjHGJKk+O7+xKTY790AMjSEmV3Nv6IvhpW/b34Wby5kcFnUL6P
	 d33Fyf0d/ocJ22mmt09fipWk8Fl8eDCZDzPyMe9hMXNyn8FjdmkrNNcwmqvq6zirwd
	 8brxRwoEPEqjMBgiGZti/XM7RtJey6i3o0LjbwBc=
Date: Sun, 22 Nov 2026 10:51:26 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,rppt@kernel.org,
	mhocko@suse.com,matt@bobrowski.net,ljs@kernel.org,liam@infradead.org,
	josef@toxicpanda.com,jack@suse.cz,david@kernel.org,amir73il@gmail.com,
	18670333770@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-prevent-pre-content-bypass-through-mremap-and-remap_file_pages.patch added to mm-unstable branch
Message-Id: <20261122185126.820861F000ED@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: prevent pre-content bypass through mremap and remap_file_pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-prevent-pre-content-bypass-through-mremap-and-remap_file_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-prevent-pre-content-bypass-through-mremap-and-remap_file_pages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm: prevent pre-content bypass through mremap and remap_file_pages
Date: Sat, 21 Nov 2026 20:26:34 -0800

On files watched by a pre-content fanotify handler, which uses the
kernel's fsnotify framework, a process that can open the file can expose a
new range without notifying the handler.  It can then read zeroes before
the handler fills that range, or read bytes the handler would deny.  This
can silently give applications wrong data or defeat a range-specific
denial.  Ordinary file-opening permissions still apply.  Files without a
pre-content handler do not acquire a new permission denial.

mmap() sends the handler a FAN_PRE_ACCESS event for the initial file
range.  mremap() can grow the mapping beyond that range, and
remap_file_pages() can select a different range, without sending one.

Notify the handler about the newly exposed range before mremap() growth. 
Hold a file reference and drop mmap_write_lock while waiting for the
response.  After reacquiring the lock, repeat the VMA checks; if the file
or required range changed, request permission for the current range. 
Growth within the range covered by mmap() needs no additional event.

Also notify the handler about the replacement range before
remap_file_pages() acquires mmap_write_lock.

These calls can now wait while the handler fills or approves the range. 
Denial returns the handler's error without performing the remap; approval
still permits growth.  A file with only an ordinary FAN_ACCESS_PERM watch
still permits mremap() growth.  The handler may receive an event for a
remap that later fails for another reason, or another event if the mapping
changes while it is responding.

Fixes: 066e053fe208 ("fsnotify: add pre-content hooks on mmap()")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: n3rd <18670333770@163.com>
Closes: https://lore.kernel.org/r/4f296d67.bbe3e.1a1c54655f8.Coremail.18670333770@163.com
Cc: Jan Kara <jack@suse.cz>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Matt Bobrowski <matt@bobrowski.net>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
---
On x86-64 QEMU guests, I tested this patch alone against an otherwise
identical A kernel. Both kernels had FANOTIFY access permissions enabled.
A privileged FAN_CLASS_PRE_CONTENT/FAN_PRE_ACCESS watcher marked an ext4
file before an unprivileged process opened it. The file's three pages
contained distinct bytes, and the watcher denied access to selected
page ranges.

On A, in-place, moving and MREMAP_FIXED growth exposed the second page
without a permission event for it. remap_file_pages() selected the third
page without an event for that page. Direct mmap() spanning a denied
page did generate an event and failed with EPERM.

On B, each growth operation generated FAN_PRE_ACCESS for the new page.
Allowing access succeeded and returned the expected byte; denying it
returned EPERM and left the original page readable. remap_file_pages()
likewise generated an event for the newly selected page: allowing it
returned the expected byte, while denial returned EPERM and retained
the original mapping.

Growth with an ordinary FAN_ACCESS_PERM watcher and no pre-content mark
succeeded on B; the earlier EOPNOTSUPP compatibility problem did not
recur. Unwatched, anonymous, already-mapped-range and shrinking
controls succeeded on both kernels.

I also changed the source mapping while a B permission event was
pending. When another file replaced the mapping, B requested permission
for that file's page before exposing it. When the mapped range changed,
B requested permission for the newly needed page. Denial returned
EPERM in both cases, and the denied page remained unmapped.

Neither guest logged a kernel warning. Both logged the existing
remap_file_pages() deprecation notice.

 mm/mmap.c   |    4 ++++
 mm/mremap.c |   46 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 49 insertions(+), 1 deletion(-)

--- a/mm/mmap.c~mm-prevent-pre-content-bypass-through-mremap-and-remap_file_pages
+++ a/mm/mmap.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/fsnotify.h>
 #include <linux/personality.h>
 #include <linux/security.h>
 #include <linux/hugetlb.h>
@@ -1156,6 +1157,9 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 
 	/* Call outside mmap_lock to be consistent with other callers. */
 	ret = security_mmap_file(file, prot, flags);
+	if (!ret)
+		ret = fsnotify_mmap_perm(file, prot,
+					(loff_t)pgoff << PAGE_SHIFT, size);
 	if (ret) {
 		fput(file);
 		return ret;
--- a/mm/mremap.c~mm-prevent-pre-content-bypass-through-mremap-and-remap_file_pages
+++ a/mm/mremap.c
@@ -17,6 +17,7 @@
 #include <linux/swap.h>
 #include <linux/capability.h>
 #include <linux/fs.h>
+#include <linux/fsnotify.h>
 #include <linux/leafops.h>
 #include <linux/highmem.h>
 #include <linux/security.h>
@@ -2028,6 +2029,9 @@ static unsigned long remap_move(struct v
 static unsigned long do_mremap(struct vma_remap_struct *vrm)
 {
 	struct mm_struct *mm = current->mm;
+	struct file *notified_file = NULL;
+	loff_t notified_off = 0;
+	size_t notified_len = 0;
 	unsigned long res;
 	bool failed;
 
@@ -2038,23 +2042,61 @@ static unsigned long do_mremap(struct vm
 	if (res)
 		return res;
 
-	if (mmap_write_lock_killable(mm))
+retry:
+	if (mmap_write_lock_killable(mm)) {
+		if (notified_file)
+			fput(notified_file);
 		return -EINTR;
+	}
 	vrm->mmap_locked = true;
 
 	if (!check_map_count_against_split_early(vrm)) {
 		mmap_write_unlock(mm);
+		if (notified_file)
+			fput(notified_file);
 		return -ENOMEM;
 	}
 
 	if (vrm_move_only(vrm)) {
 		res = remap_move(vrm);
 	} else {
+		struct vm_area_struct *vma;
+		loff_t off;
+		size_t len;
+
+		vrm->populate_expand = false;
 		vrm->vma = vma_lookup(current->mm, vrm->addr);
 		res = check_prep_vma(vrm);
 		if (res)
 			goto out;
 
+		vma = vrm->vma;
+		if (vma->vm_file &&
+		    FMODE_FSNOTIFY_HSM(vma->vm_file->f_mode) &&
+		    vrm->new_len > vma->vm_end - vrm->addr) {
+			off = (loff_t)linear_page_index(vma, vma->vm_end)
+				<< PAGE_SHIFT;
+			len = vrm->new_len - (vma->vm_end - vrm->addr);
+			if (notified_file != vma->vm_file ||
+			    notified_off != off || notified_len != len) {
+				struct file *file = get_file(vma->vm_file);
+
+				notified_off = off;
+				notified_len = len;
+				mmap_write_unlock(mm);
+				vrm->mmap_locked = false;
+				if (notified_file)
+					fput(notified_file);
+				notified_file = file;
+				/* The pre-content hook does not use prot. */
+				res = fsnotify_mmap_perm(notified_file, 0, off,
+							len);
+				if (res)
+					goto out;
+				goto retry;
+			}
+		}
+
 		/* Actually execute mremap. */
 		res = vrm_implies_new_addr(vrm) ? mremap_to(vrm) : mremap_at(vrm);
 	}
@@ -2064,6 +2106,8 @@ out:
 
 	if (vrm->mmap_locked)
 		mmap_write_unlock(mm);
+	if (notified_file)
+		fput(notified_file);
 
 	/* VMA mlock'd + was expanded, so populated expanded region. */
 	if (!failed && vrm->populate_expand)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-page_exth-to-memory-management-page-allocator.patch
kselftest-mm-rename-read_pmd_pagesize-to-pmd_psize-fix.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
selftests-mm-allocate-nr_pages-based-on-pmd-size-for-uffd-pmd_move-tests-fix.patch
selftests-mm-retain-move-pmd-coverage-and-verify-huge-pmds.patch
lib-test_xarray-check-unused-spare-node-after-range-creation.patch
mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio-fix.patch
lib-test_hmm-invalidate-all-mirrors-on-device-private-migration.patch
mm-prevent-pre-content-bypass-through-mremap-and-remap_file_pages.patch
selinux-recheck-backing-file-permissions-on-remap_file_pages.patch
mm-madvise-notify-userfaultfd-when-installing-guard-regions.patch
mm-highmem-reject-previously-poisoned-pages-in-machine-check-copies.patch
ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
squashfs-sanity-check-directory-metadata-block-location-fix.patch
squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix.patch
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch
jfs-validate-xattr-entry-bounds-before-replacing-an-attribute.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

