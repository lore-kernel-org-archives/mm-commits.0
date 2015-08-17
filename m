From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 17 Aug 2015 14:16:19 -0700
Message-ID: <55d24f23.lxt5sbdtzxcRhuT1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46778 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbbHQVQU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Aug 2015 17:16:20 -0400
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

 crypto/authencesn.c |   80 ------------------------------------------
 1 file changed, 80 deletions(-)

diff -puN crypto/authencesn.c~linux-next-git-rejects crypto/authencesn.c
--- a/crypto/authencesn.c~linux-next-git-rejects
+++ a/crypto/authencesn.c
@@ -193,48 +193,6 @@ static int crypto_authenc_esn_encrypt(st
 {
 	struct crypto_aead *authenc_esn = crypto_aead_reqtfm(req);
 	struct authenc_esn_request_ctx *areq_ctx = aead_request_ctx(req);
-<<<<<<< HEAD
-	struct scatterlist *dst = req->dst;
-	struct scatterlist *assoc = req->assoc;
-	struct scatterlist *cipher = areq_ctx->cipher;
-	struct scatterlist *hsg = areq_ctx->hsg;
-	struct scatterlist *tsg = areq_ctx->tsg;
-	unsigned int ivsize = crypto_aead_ivsize(authenc_esn);
-	unsigned int cryptlen = req->cryptlen;
-	struct page *dstp;
-	u8 *vdst;
-	u8 *hash;
-
-	dstp = sg_page(dst);
-	vdst = PageHighMem(dstp) ? NULL : page_address(dstp) + dst->offset;
-
-	if (ivsize) {
-		sg_init_table(cipher, 2);
-		sg_set_buf(cipher, iv, ivsize);
-		scatterwalk_crypto_chain(cipher, dst, vdst == iv + ivsize, 2);
-		dst = cipher;
-		cryptlen += ivsize;
-	}
-
-	if (assoc->length < 12)
-		return -EINVAL;
-
-	sg_init_table(hsg, 2);
-	sg_set_page(hsg, sg_page(assoc), 4, assoc->offset);
-	sg_set_page(hsg + 1, sg_page(assoc), 4, assoc->offset + 8);
-
-	sg_init_table(tsg, 1);
-	sg_set_page(tsg, sg_page(assoc), 4, assoc->offset + 4);
-
-	areq_ctx->cryptlen = cryptlen;
-	areq_ctx->headlen = 8;
-	areq_ctx->trailen = 4;
-	areq_ctx->sg = dst;
-
-	areq_ctx->complete = authenc_esn_geniv_ahash_done;
-	areq_ctx->update_complete = authenc_esn_geniv_ahash_update_done;
-	areq_ctx->update_complete2 = authenc_esn_geniv_ahash_update_done2;
-=======
 	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
 	struct ablkcipher_request *abreq = (void *)(areq_ctx->tail
 						    + ctx->reqoff);
@@ -243,7 +201,6 @@ static int crypto_authenc_esn_encrypt(st
 	unsigned int cryptlen = req->cryptlen;
 	struct scatterlist *src, *dst;
 	int err;
->>>>>>> linux-next/akpm-base
 
 	sg_init_table(areq_ctx->src, 2);
 	src = scatterwalk_ffwd(areq_ctx->src, req->src, assoclen);
@@ -320,42 +277,6 @@ static int crypto_authenc_esn_decrypt(st
 {
 	struct crypto_aead *authenc_esn = crypto_aead_reqtfm(req);
 	struct authenc_esn_request_ctx *areq_ctx = aead_request_ctx(req);
-<<<<<<< HEAD
-	struct scatterlist *src = req->src;
-	struct scatterlist *assoc = req->assoc;
-	struct scatterlist *cipher = areq_ctx->cipher;
-	struct scatterlist *hsg = areq_ctx->hsg;
-	struct scatterlist *tsg = areq_ctx->tsg;
-	unsigned int ivsize = crypto_aead_ivsize(authenc_esn);
-	struct page *srcp;
-	u8 *vsrc;
-
-	srcp = sg_page(src);
-	vsrc = PageHighMem(srcp) ? NULL : page_address(srcp) + src->offset;
-
-	if (ivsize) {
-		sg_init_table(cipher, 2);
-		sg_set_buf(cipher, iv, ivsize);
-		scatterwalk_crypto_chain(cipher, src, vsrc == iv + ivsize, 2);
-		src = cipher;
-		cryptlen += ivsize;
-	}
-
-	if (assoc->length < 12)
-		return -EINVAL;
-
-	sg_init_table(hsg, 2);
-	sg_set_page(hsg, sg_page(assoc), 4, assoc->offset);
-	sg_set_page(hsg + 1, sg_page(assoc), 4, assoc->offset + 8);
-
-	sg_init_table(tsg, 1);
-	sg_set_page(tsg, sg_page(assoc), 4, assoc->offset + 4);
-
-	areq_ctx->cryptlen = cryptlen;
-	areq_ctx->headlen = 8;
-	areq_ctx->trailen = 4;
-	areq_ctx->sg = src;
-=======
 	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
 	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ctx->reqoff);
 	unsigned int authsize = crypto_aead_authsize(authenc_esn);
@@ -382,7 +303,6 @@ static int crypto_authenc_esn_decrypt(st
 
 	if (!authsize)
 		goto tail;
->>>>>>> linux-next/akpm-base
 
 	/* Move high-order bits of sequence number to the end. */
 	scatterwalk_map_and_copy(tmp, dst, 0, 8, 0);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
mm-make-page-pfmemalloc-check-more-robust-fix.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
ocfs2-sysfile-interfaces-for-online-file-check-fix.patch
fs-create-and-use-seq_show_option-for-escaping-fix.patch
watchdog-introduce-watchdog_suspend-and-watchdog_resume-fix.patch
watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
dax-revert-userfaultfd-change.patch
thp-prepare-for-dax-huge-pages-fix.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch
pagemap-update-documentation-fix.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
mm-srcu-ify-shrinkers-fix-fix.patch
x86-use-generic-early-mem-copy-fix.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-fix-2.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
proc-add-kpageidle-file-fix-6-fix.patch
proc-add-kpageidle-file-fix-6-fix-2-fix.patch
proc-export-idle-flag-via-kpageflags-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zswap-dynamic-pool-creation-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2.patch
kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch
a.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

