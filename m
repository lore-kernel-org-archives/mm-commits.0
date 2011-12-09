From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 09 Dec 2011 11:57:48 -0800
Message-ID: <201112091957.pB9Jvm8E016461@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:54147 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab1LIT5t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 14:57:49 -0500
Received: by ggnv2 with SMTP id v2so66296ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 09 Dec 2011 11:57:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c            |   15 ---------------
 sound/pci/hda/patch_realtek.c |    6 ------
 sound/pci/sis7019.c           |    9 ---------
 3 files changed, 30 deletions(-)

diff -puN drivers/md/raid5.c~linux-next-git-rejects drivers/md/raid5.c
--- a/drivers/md/raid5.c~linux-next-git-rejects
+++ a/drivers/md/raid5.c
@@ -3160,9 +3160,6 @@ static void analyse_stripe(struct stripe
 		}
 		if (dev->written)
 			s->written++;
-<<<<<<< HEAD
-		rdev = rcu_dereference(conf->disks[i].rdev);
-=======
 		/* Prefer to use the replacement for reads, but only
 		 * if it is recovered enough and has no bad blocks.
 		 */
@@ -3178,7 +3175,6 @@ static void analyse_stripe(struct stripe
 			rdev = rcu_dereference(conf->disks[i].rdev);
 			clear_bit(R5_ReadRepl, &dev->flags);
 		}
->>>>>>> linux-next/akpm-end
 		if (rdev && test_bit(Faulty, &rdev->flags))
 			rdev = NULL;
 		if (rdev) {
@@ -3213,11 +3209,6 @@ static void analyse_stripe(struct stripe
 			if (sh->sector + STRIPE_SECTORS <= rdev->recovery_offset)
 				set_bit(R5_Insync, &dev->flags);
 		}
-<<<<<<< HEAD
-		if (rdev && test_bit(R5_WriteError, &dev->flags)) {
-			clear_bit(R5_Insync, &dev->flags);
-			if (!test_bit(Faulty, &rdev->flags)) {
-=======
 		if (test_bit(R5_WriteError, &dev->flags)) {
 			/* This flag does not apply to '.replacement'
 			 * only to .rdev, so make sure to check that*/
@@ -3226,23 +3217,17 @@ static void analyse_stripe(struct stripe
 			if (rdev2 == rdev)
 				clear_bit(R5_Insync, &dev->flags);
 			if (!test_bit(Faulty, &rdev2->flags)) {
->>>>>>> linux-next/akpm-end
 				s->handle_bad_blocks = 1;
 				atomic_inc(&rdev2->nr_pending);
 			} else
 				clear_bit(R5_WriteError, &dev->flags);
 		}
-<<<<<<< HEAD
-		if (rdev && test_bit(R5_MadeGood, &dev->flags)) {
-			if (!test_bit(Faulty, &rdev->flags)) {
-=======
 		if (test_bit(R5_MadeGood, &dev->flags)) {
 			/* This flag does not apply to '.replacement'
 			 * only to .rdev, so make sure to check that*/
 			struct md_rdev *rdev2 = rcu_dereference(
 				conf->disks[i].rdev);
 			if (rdev2 && !test_bit(Faulty, &rdev2->flags)) {
->>>>>>> linux-next/akpm-end
 				s->handle_bad_blocks = 1;
 				atomic_inc(&rdev2->nr_pending);
 			} else
diff -puN sound/pci/hda/patch_realtek.c~linux-next-git-rejects sound/pci/hda/patch_realtek.c
--- a/sound/pci/hda/patch_realtek.c~linux-next-git-rejects
+++ a/sound/pci/hda/patch_realtek.c
@@ -3045,11 +3045,8 @@ static int alc_auto_fill_dac_nids(struct
 {
 	struct alc_spec *spec = codec->spec;
 	struct auto_pin_cfg *cfg = &spec->autocfg;
-<<<<<<< HEAD
-=======
 	unsigned int location, defcfg;
 	int num_pins;
->>>>>>> linux-next/akpm-end
 	bool redone = false;
 	int i;
 
@@ -3140,8 +3137,6 @@ static int alc_auto_fill_dac_nids(struct
 			goto again;
 		}
 	}
-<<<<<<< HEAD
-=======
 
 	if (!spec->multi_ios &&
 	    cfg->line_out_type == AUTO_PIN_SPEAKER_OUT &&
@@ -3157,7 +3152,6 @@ static int alc_auto_fill_dac_nids(struct
 			spec->multiout.num_dacs = num_pins + 1;
 		}
 	}
->>>>>>> linux-next/akpm-end
 
 	return 0;
 }
diff -puN sound/pci/sis7019.c~linux-next-git-rejects sound/pci/sis7019.c
--- a/sound/pci/sis7019.c~linux-next-git-rejects
+++ a/sound/pci/sis7019.c
@@ -1142,22 +1142,13 @@ static int sis_chip_init(struct sis7019 
 	/* All done, check for errors.
 	 */
 	if (!sis->codecs_present) {
-<<<<<<< HEAD
-		printk(KERN_ERR "sis7019: could not find any codecs\n");
-=======
 		dev_err(&sis->pci->dev, "could not find any codecs\n");
->>>>>>> linux-next/akpm-end
 		return -EIO;
 	}
 
 	if (sis->codecs_present != codecs) {
-<<<<<<< HEAD
-		printk(KERN_WARNING "sis7019: missing codecs, found %0x, expected %0x\n",
-		       sis->codecs_present, codecs);
-=======
 		dev_warn(&sis->pci->dev, "missing codecs, found %0x, expected %0x\n",
 					 sis->codecs_present, codecs);
->>>>>>> linux-next/akpm-end
 	}
 
 	/* Let the hardware know that the audio driver is alive,
_
Subject: Subject: linux-next-git-rejects

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-checkpatch-fixes.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-v2-checkpatch-fixes.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
mm-more-intensive-memory-corruption-debug-fix.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
leds-add-driver-for-tca6507-led-controller-checkpatch-fixes.patch
checkpatch-improve-memset-and-min-max-with-cast-checking-fix.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch
drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3-checkpatch-fixes.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
kexec-remove-kmsg_dump_kexec.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

