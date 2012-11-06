From: akpm@linux-foundation.org
Subject: + slub-slub-specific-propagation-changes-fix.patch added to -mm tree
Date: Tue, 06 Nov 2012 11:25:47 -0800
Message-ID: <20121106192549.01D7B100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:39926 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab2KFTZv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2012 14:25:51 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so82228vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Nov 2012 11:25:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, cl@linux.com, fweisbec@redhat.com, glommer@parallels.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org


The patch titled
     Subject: slub-slub-specific-propagation-changes-fix
has been added to the -mm tree.  Its filename is
     slub-slub-specific-propagation-changes-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: slub-slub-specific-propagation-changes-fix

tweak code to avoid __maybe_unused

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: JoonSoo Kim <js1304@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff -puN mm/slub.c~slub-slub-specific-propagation-changes-fix mm/slub.c
--- a/mm/slub.c~slub-slub-specific-propagation-changes-fix
+++ a/mm/slub.c
@@ -5175,7 +5175,6 @@ static ssize_t slab_attr_store(struct ko
 	struct slab_attribute *attribute;
 	struct kmem_cache *s;
 	int err;
-	int i __maybe_unused;
 
 	attribute = to_slab_attr(attr);
 	s = to_slab(kobj);
@@ -5185,23 +5184,24 @@ static ssize_t slab_attr_store(struct ko
 
 	err = attribute->store(s, buf, len);
 #ifdef CONFIG_MEMCG_KMEM
-	if (slab_state < FULL)
-		return err;
+	if (slab_state >= FULL && err >= 0 && is_root_cache(s)) {
+		int i;
 
-	if ((err < 0) || !is_root_cache(s))
-		return err;
-
-	mutex_lock(&slab_mutex);
-	if (s->max_attr_size < len)
-		s->max_attr_size = len;
-
-	for_each_memcg_cache_index(i) {
-		struct kmem_cache *c = cache_from_memcg(s, i);
-		if (c)
-			/* return value determined by the parent cache only */
-			attribute->store(c, buf, len);
+		mutex_lock(&slab_mutex);
+		if (s->max_attr_size < len)
+			s->max_attr_size = len;
+
+		for_each_memcg_cache_index(i) {
+			struct kmem_cache *c = cache_from_memcg(s, i);
+			/*
+			 * This function's return value is determined by the
+			 * parent cache only
+			 */
+			if (c)
+				attribute->store(c, buf, len);
+		}
+		mutex_unlock(&slab_mutex);
 	}
-	mutex_unlock(&slab_mutex);
 #endif
 	return err;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-tools-testing-selftests-epoll-test_epollc-fix-build.patch
revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
mm-introduce-mm_find_pmd-fix.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty-fix.patch
slub-slub-specific-propagation-changes-fix.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

