From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 02 Jun 2015 11:26:34 -0700
Message-ID: <556df55a.rhOJ8LpPqOauPLTE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbbFBS0f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2015 14:26:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/topology_64.h |    4 ----
 include/net/mac80211.h               |    4 ----
 net/ipv4/esp4.c                      |   18 ------------------
 net/ipv6/esp6.c                      |   18 ------------------
 4 files changed, 44 deletions(-)

diff -puN arch/sparc/include/asm/topology_64.h~linux-next-git-rejects arch/sparc/include/asm/topology_64.h
--- a/arch/sparc/include/asm/topology_64.h~linux-next-git-rejects
+++ a/arch/sparc/include/asm/topology_64.h
@@ -41,11 +41,7 @@ static inline int pcibus_to_node(struct
 #define topology_physical_package_id(cpu)	(cpu_data(cpu).proc_id)
 #define topology_core_id(cpu)			(cpu_data(cpu).core_id)
 #define topology_core_cpumask(cpu)		(&cpu_core_sib_map[cpu])
-<<<<<<< HEAD
-#define topology_thread_cpumask(cpu)		(&per_cpu(cpu_sibling_map, cpu))
-=======
 #define topology_sibling_cpumask(cpu)		(&per_cpu(cpu_sibling_map, cpu))
->>>>>>> linux-next/akpm-base
 #endif /* CONFIG_SMP */
 
 extern cpumask_t cpu_core_map[NR_CPUS];
diff -puN include/net/mac80211.h~linux-next-git-rejects include/net/mac80211.h
--- a/include/net/mac80211.h~linux-next-git-rejects
+++ a/include/net/mac80211.h
@@ -422,12 +422,8 @@ struct ieee80211_ba_event {
  * @type: The event itself. See &enum ieee80211_event_type.
  * @rssi: relevant if &type is %RSSI_EVENT
  * @mlme: relevant if &type is %AUTH_EVENT
-<<<<<<< HEAD
- * @u:    union holding the above two fields
-=======
  * @ba: relevant if &type is %BAR_RX_EVENT or %BA_FRAME_TIMEOUT
  * @u:union holding the fields above
->>>>>>> linux-next/akpm-base
  */
 struct ieee80211_event {
 	enum ieee80211_event_type type;
diff -puN net/ipv4/esp4.c~linux-next-git-rejects net/ipv4/esp4.c
--- a/net/ipv4/esp4.c~linux-next-git-rejects
+++ a/net/ipv4/esp4.c
@@ -260,23 +260,6 @@ static int esp_output(struct xfrm_state
 		     (unsigned char *)esph - skb->data,
 		     assoclen + ivlen + clen + alen);
 
-<<<<<<< HEAD
-	if ((x->props.flags & XFRM_STATE_ESN)) {
-		sg_init_table(asg, 3);
-		sg_set_buf(asg, &esph->spi, sizeof(__be32));
-		*seqhi = htonl(XFRM_SKB_CB(skb)->seq.output.hi);
-		sg_set_buf(asg + 1, seqhi, seqhilen);
-		sg_set_buf(asg + 2, &esph->seq_no, sizeof(__be32));
-	} else
-		sg_init_one(asg, esph, sizeof(*esph));
-
-	aead_givcrypt_set_callback(req, 0, esp_output_done, skb);
-	aead_givcrypt_set_crypt(req, sg, sg, clen, iv);
-	aead_givcrypt_set_assoc(req, asg, assoclen);
-	aead_givcrypt_set_giv(req, esph->enc_data,
-			      XFRM_SKB_CB(skb)->seq.output.low +
-			      ((u64)XFRM_SKB_CB(skb)->seq.output.hi << 32));
-=======
 	aead_request_set_crypt(req, sg, sg, ivlen + clen, iv);
 	aead_request_set_ad(req, assoclen);
 
@@ -286,7 +269,6 @@ static int esp_output(struct xfrm_state
 	memset(iv, 0, ivlen);
 	memcpy(iv + ivlen - min(ivlen, 8), (u8 *)&seqno + 8 - min(ivlen, 8),
 	       min(ivlen, 8));
->>>>>>> linux-next/akpm-base
 
 	ESP_SKB_CB(skb)->tmp = tmp;
 	err = crypto_aead_encrypt(req);
diff -puN net/ipv6/esp6.c~linux-next-git-rejects net/ipv6/esp6.c
--- a/net/ipv6/esp6.c~linux-next-git-rejects
+++ a/net/ipv6/esp6.c
@@ -252,23 +252,6 @@ static int esp6_output(struct xfrm_state
 		     (unsigned char *)esph - skb->data,
 		     assoclen + ivlen + clen + alen);
 
-<<<<<<< HEAD
-	if ((x->props.flags & XFRM_STATE_ESN)) {
-		sg_init_table(asg, 3);
-		sg_set_buf(asg, &esph->spi, sizeof(__be32));
-		*seqhi = htonl(XFRM_SKB_CB(skb)->seq.output.hi);
-		sg_set_buf(asg + 1, seqhi, seqhilen);
-		sg_set_buf(asg + 2, &esph->seq_no, sizeof(__be32));
-	} else
-		sg_init_one(asg, esph, sizeof(*esph));
-
-	aead_givcrypt_set_callback(req, 0, esp_output_done, skb);
-	aead_givcrypt_set_crypt(req, sg, sg, clen, iv);
-	aead_givcrypt_set_assoc(req, asg, assoclen);
-	aead_givcrypt_set_giv(req, esph->enc_data,
-			      XFRM_SKB_CB(skb)->seq.output.low +
-			      ((u64)XFRM_SKB_CB(skb)->seq.output.hi << 32));
-=======
 	aead_request_set_crypt(req, sg, sg, ivlen + clen, iv);
 	aead_request_set_ad(req, assoclen);
 
@@ -278,7 +261,6 @@ static int esp6_output(struct xfrm_state
 	memset(iv, 0, ivlen);
 	memcpy(iv + ivlen - min(ivlen, 8), (u8 *)&seqno + 8 - min(ivlen, 8),
 	       min(ivlen, 8));
->>>>>>> linux-next/akpm-base
 
 	ESP_SKB_CB(skb)->tmp = tmp;
 	err = crypto_aead_encrypt(req);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
fs-userfaultfdc-work-around-i386-build-error.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch
frontswap-allow-multiple-backends-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
prctl-more-prctlpr_set_mm_-checks-fix.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
init-do_mounts-add-create_dev-failure-log-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
ipcshm-move-bug_on-check-into-shm_lock-fix-2.patch
ipcshm-move-bug_on-check-into-shm_lock-fix.patch
scsi-resolve-sg-buffer-const-ness-issue-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-block-nvme-corec-fix-build-with-gcc-444.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

