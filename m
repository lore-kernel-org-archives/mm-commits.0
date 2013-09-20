From: akpm@linux-foundation.org
Subject: + sound-soc-atmel-atmel-pcmc-fix-warning.patch added to -mm tree
Date: Fri, 20 Sep 2013 14:56:48 -0700
Message-ID: <20130920225407.CD2D231C262@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:43495 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab3ITWyJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Sep 2013 18:54:09 -0400
Received: by mail-ve0-f201.google.com with SMTP id c14so118039vea.0
        for <mm-commits@vger.kernel.org>; Fri, 20 Sep 2013 15:54:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, broonie@kernel.org, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de


The patch titled
     Subject: sound/soc/atmel/atmel-pcm.c: fix warning
has been added to the -mm tree.  Its filename is
     sound-soc-atmel-atmel-pcmc-fix-warning.patch

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
Subject: sound/soc/atmel/atmel-pcm.c: fix warning

i386 allmodconfig:

sound/soc/atmel/atmel-pcm.c: In function 'atmel_pcm_preallocate_dma_buffer':
sound/soc/atmel/atmel-pcm.c:52: warning: cast to pointer from integer of different size

Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/soc/atmel/atmel-pcm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN sound/soc/atmel/atmel-pcm.c~sound-soc-atmel-atmel-pcmc-fix-warning sound/soc/atmel/atmel-pcm.c
--- a/sound/soc/atmel/atmel-pcm.c~sound-soc-atmel-atmel-pcmc-fix-warning
+++ a/sound/soc/atmel/atmel-pcm.c
@@ -50,7 +50,7 @@ static int atmel_pcm_preallocate_dma_buf
 	buf->area = dma_alloc_coherent(pcm->card->dev, size,
 			&buf->addr, GFP_KERNEL);
 	pr_debug("atmel-pcm: alloc dma buffer: area=%p, addr=%p, size=%zu\n",
-			(void *)buf->area, (void *)buf->addr, size);
+			(void *)buf->area, (void *)(long)buf->addr, size);
 
 	if (!buf->area)
 		return -ENOMEM;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
watchdog-update-watchdog_tresh-properly-fix.patch
revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
revert-memcg-track-all-children-over-limit-in-the-root.patch
revert-memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
revert-memcg-enhance-memcg-iterator-to-support-predicates.patch
revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch
revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
kernel-rebootc-re-enable-the-function-of-variable-reboot_default-fix.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
drivers-block-skd_mainc-fix-a-few-things-disable-on-32-bit.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
sound-soc-atmel-atmel-pcmc-fix-warning.patch

