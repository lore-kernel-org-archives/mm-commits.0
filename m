Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795368886;
	b=GI1aHKi1B3J0yzb6WKWSU+FnTC7WKF0N6AE90NbpdcCctJ/cS7034FucVggfeNXsLKiH
	 Gx6SEx/cmUY0izQzjrthwvf1spvL4knYxxo/daRMkxjcawjOpNQgtgtmKWzmRLWlYYWzb
	 dMCCA7tRZ0Ia0ZxlU9uCcD2IIwt/SkSHdqPDiBywycj+g9038RgQiTxVpyhOkGOT5iYPz
	 Hf7cu5NZcj2EcR1qbrtQt9FfjCfpg1qkq48BFcGMb7yBbUNjeigTOGxMLklwKpQ4DsBNo
	 8dzbD/d0HKD/QgpaiFpznAd3lNRcB9rUM2ozoPC8OyO6G+J1+tWne7XDGVIaSHpbl9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795368886;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Ov38FvGCEd76A+gpVfHWrpgkrbXPuTyqxUKbZ42BdFQ=;
	b=fF1rd7cTpdnq8uZb0paTs/RoZIwWxXHwH9u/a37bnITxrJyvGX8LVxTboPF9pkemy68P
	 cdpSrLf7ZvsqeSM5YRbBynZ+eMR3lCXHjdomsLm1sdYuoPSlT7GOQBi7FLTtZxXd8aQeb
	 uND0o6fhEMDfLIttg64Js6b3gFlNFthXkL+obT/2+NXw82b/6LC2XbZVk7bpAm6lY06oB
	 DCW2vkHltJZ2YCPZryJsGmEuWxK6+kzZFekDe2QScnhXdJ70obi1yQw1NvWeAPIfOAI21
	 +ehHBd1Ut1JgfiCkzZh2jR0Djto/K0lJr5EaXpLb6CXT46Yh3eQ2u4+0Nt+WmHnmsAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qcIoiV+D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CE0606A332;
	Sun, 22 Nov 2026 17:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qcIoiV+D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0528F1F000C4;
	Sun, 22 Nov 2026 17:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795368886;
	bh=Ov38FvGCEd76A+gpVfHWrpgkrbXPuTyqxUKbZ42BdFQ=;
	h=Date:To:From:Subject;
	b=qcIoiV+DmlN/743uwHeq/EkkR+mdAm5iXFUzNGx1nfftuHh27m/WrJLV2eXHcyZ1K
	 WNzKTsIo6yJfw2mKBn0yx+uQAjQ+zdjR08KmvofPmzBE0xC0o0H6UmljN+GkqFLxN5
	 l8vD0vk2NJRaOzzOd80xNl1aLZg2fVFGiQ5eXfM4=
Date: Sun, 22 Nov 2026 09:34:45 -0800
To: mm-commits@vger.kernel.org,zzzccc427@gmail.com,tytso@mit.edu,
	syzbot+38fdbb551940270021f1@syzkaller.appspotmail.com,stable@vger.kernel.org,
	mark@fasheh.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jack@suse.cz,
	heming.zhao@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown.patch added to mm-nonmm-hotfixes-unstable branch
Message-Id: <20261122173446.0528F1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: unregister the JBD2 shrinker before journal shutdown
has been added to the -mm mm-nonmm-hotfixes-unstable branch.  Its filename is
     ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown.patch

This patch will later appear in the mm-nonmm-hotfixes-unstable branch at
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
Subject: ocfs2: unregister the JBD2 shrinker before journal shutdown
Date: Sat, 21 Nov 2026 19:34:56 -0800

sysbot reports a lockdep cycle through shrinker_mutex, filesystem reclaim
and osb->journal_shutdown_sem.  Unmount holds the superblock's s_umount
exclusively, while the OCFS2 reclaim path must first get its read side
with super_trylock_shared().  That excludes the two paths for the same
superblock; the report does not establish a runtime deadlock.  Still, the
lock ordering is visible to lockdep and produces the warning.

The write side of journal_shutdown_sem must cover all of
jbd2_journal_destroy(): ocfs2_clear_inode() can otherwise release a JBD2
inode through a journal that is being destroyed.  Move only the JBD2
shrinker unregister operation before taking the semaphore. 
shrinker_free() waits for active shrinker users, so the journal and its
checkpoint counter remain alive while they finish.  A successfully
initialized JBD2 journal always has a checkpoint counter.  Destroy it
after unregistering the shrinker, whether unregistering happened here or
before taking the OCFS2 semaphore.  The semaphore continues to protect
JBD2 destruction, removal of osb->journal and freeing the OCFS2 journal.

The userspace-visible result is removal of this lockdep warning during
OCFS2 unmount; the report does not demonstrate a hung unmount.

Fixes: f277230d002d ("ocfs2: serialize inode journal access with shutdown")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+38fdbb551940270021f1@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=38fdbb551940270021f1
Link: https://lore.kernel.org/6b0257ca.6ccd1e40.868ea.001a.GAE@google.com
Tested-by: Andrew Morton <akpm@linux-foundation.org>
  Link: https://lore.kernel.org/20261122093400.b726ecddf154f493dec1c892@linux-foundation.org
Cc: Cen Zhang <zzzccc427@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
---
Tested with CONFIG_PROVE_LOCKING=y in x86-64 QEMU guests. A omitted
this patch; B added it alone. OCFS2 and JBD2 were built in.

Syzbot's C reproducer mounted a local OCFS2 image, accessed 200 files,
exercised reclaim and unmounted it. A reproduced the reported circular
locking warning: shrinker_free() ran from jbd2_journal_destroy() while
ocfs2_journal_shutdown() held journal_shutdown_sem. The unmount
completed; this test did not show a runtime deadlock.

B completed the same sequence without a warning. Three further
mount/reclaim/unmount cycles on B also completed without warnings.
An ext4 read/write/unmount control passed on both kernels.

Both builds needed the same temporary correction for an unrelated
mm/util.c compile error in another queued patch. The correction was
removed after testing. The test did not force an active JBD2 shrinker
callback to overlap unmount or exercise failed-mount cleanup.

 fs/jbd2/journal.c    |   17 +++++++++++++----
 fs/ocfs2/journal.c   |    1 +
 include/linux/jbd2.h |    1 +
 3 files changed, 15 insertions(+), 4 deletions(-)

--- a/fs/jbd2/journal.c~ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown
+++ a/fs/jbd2/journal.c
@@ -75,6 +75,7 @@ EXPORT_SYMBOL(jbd2_journal_check_availab
 EXPORT_SYMBOL(jbd2_journal_set_features);
 EXPORT_SYMBOL(jbd2_journal_load);
 EXPORT_SYMBOL(jbd2_journal_destroy);
+EXPORT_SYMBOL(jbd2_journal_unregister_shrinker);
 EXPORT_SYMBOL(jbd2_journal_abort);
 EXPORT_SYMBOL(jbd2_journal_errno);
 EXPORT_SYMBOL(jbd2_journal_ack_err);
@@ -2100,6 +2101,16 @@ int jbd2_journal_load(journal_t *journal
 	return 0;
 }
 
+void jbd2_journal_unregister_shrinker(journal_t *journal)
+{
+	struct shrinker *shrinker = journal->j_shrinker;
+
+	if (!shrinker)
+		return;
+	journal->j_shrinker = NULL;
+	shrinker_free(shrinker);
+}
+
 /**
  * jbd2_journal_destroy() - Release a journal_t structure.
  * @journal: Journal to act on.
@@ -2173,10 +2184,8 @@ int jbd2_journal_destroy(journal_t *jour
 		brelse(journal->j_sb_buffer);
 	}
 
-	if (journal->j_shrinker) {
-		percpu_counter_destroy(&journal->j_checkpoint_jh_count);
-		shrinker_free(journal->j_shrinker);
-	}
+	jbd2_journal_unregister_shrinker(journal);
+	percpu_counter_destroy(&journal->j_checkpoint_jh_count);
 	if (journal->j_proc_entry)
 		jbd2_stats_proc_exit(journal);
 	iput(journal->j_inode);
--- a/fs/ocfs2/journal.c~ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown
+++ a/fs/ocfs2/journal.c
@@ -1119,6 +1119,7 @@ void ocfs2_journal_shutdown(struct ocfs2
 	 * Exclude the final JBD2 inode cleanup in ocfs2_clear_inode() while
 	 * the journal is destroyed and freed.
 	 */
+	jbd2_journal_unregister_shrinker(journal->j_journal);
 	down_write(&osb->journal_shutdown_sem);
 
 	/* Shutdown the kernel journal system */
--- a/include/linux/jbd2.h~ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown
+++ a/include/linux/jbd2.h
@@ -1566,6 +1566,7 @@ extern void	   jbd2_journal_clear_featur
 		   (journal_t *, unsigned long, unsigned long, unsigned long);
 extern int	   jbd2_journal_load       (journal_t *journal);
 extern int	   jbd2_journal_destroy    (journal_t *);
+extern void	   jbd2_journal_unregister_shrinker(journal_t *);
 extern int	   jbd2_journal_recover    (journal_t *journal);
 extern int	   jbd2_journal_wipe       (journal_t *, int);
 extern int	   jbd2_journal_skip_recovery	(journal_t *);
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

