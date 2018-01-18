From: akpm@linux-foundation.org
Subject: + fs-crypto-hooksc-fix-build-with-gcc-444.patch added to -mm tree
Date: Thu, 18 Jan 2018 15:51:15 -0800
Message-ID: <5a6132f3.CzlRFckHd7ySTlRc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47350 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932166AbeARXvR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Jan 2018 18:51:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiggers@google.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/crypto/hooks.c: fix build with gcc-4.4.4
has been added to the -mm tree.  Its filename is
     fs-crypto-hooksc-fix-build-with-gcc-444.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-crypto-hooksc-fix-build-with-gcc-444.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-crypto-hooksc-fix-build-with-gcc-444.patch

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
Subject: fs/crypto/hooks.c: fix build with gcc-4.4.4

gcc-4.4.4 has issues with anon union initializers.  Work around this.

fs/crypto/hooks.c: In function '__fscrypt_encrypt_symlink':
fs/crypto/hooks.c:161: error: unknown field 'len' specified in initializer
fs/crypto/hooks.c:161: warning: excess elements in struct initializer
fs/crypto/hooks.c:161: warning: (near initialization for 'iname')

Fixes: 76e81d6d50 ("fscrypt: new helper functions for ->symlink()")
Cc: Eric Biggers <ebiggers@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/crypto/hooks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/crypto/hooks.c~fs-crypto-hooksc-fix-build-with-gcc-444 fs/crypto/hooks.c
--- a/fs/crypto/hooks.c~fs-crypto-hooksc-fix-build-with-gcc-444
+++ a/fs/crypto/hooks.c
@@ -158,7 +158,7 @@ int __fscrypt_encrypt_symlink(struct ino
 			      unsigned int len, struct fscrypt_str *disk_link)
 {
 	int err;
-	struct qstr iname = { .name = target, .len = len };
+	struct qstr iname = { { .hash_len = len, }, .name = target, };
 	struct fscrypt_symlink_data *sd;
 	unsigned int ciphertext_len;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch
mm-page_owner-clean-up-init_pages_in_zone-v3-fix.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch
kasan-clean-up-kasan_shadow_scale_shift-usage-checkpatch-fixes.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
fs-crypto-hooksc-fix-build-with-gcc-444.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

