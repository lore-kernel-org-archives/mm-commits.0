From: akpm@linux-foundation.org
Subject: + rtc-add-pcf85063-support-fix.patch added to -mm tree
Date: Tue, 22 Jul 2014 13:54:17 -0700
Message-ID: <53cecf79.me9K1eFvm/PFOFEd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:49511 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbaGVUyS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jul 2014 16:54:18 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so79001oac.3
        for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2014 13:54:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, san@rosetechnology.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-add-pcf85063-support-fix
has been added to the -mm tree.  Its filename is
     rtc-add-pcf85063-support-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-add-pcf85063-support-f=
ix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-add-pcf85063-support-f=
ix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-add-pcf85063-support-fix

fix comment typo, tweak conding style

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: S=F8ren Andersen <san@rosetechnology.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf85063.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-pcf85063.c~rtc-add-pcf85063-support-fix drive=
rs/rtc/rtc-pcf85063.c
--- a/drivers/rtc/rtc-pcf85063.c~rtc-add-pcf85063-support-fix
+++ a/drivers/rtc/rtc-pcf85063.c
@@ -36,7 +36,7 @@ static struct i2c_driver pcf85063_driver
 struct pcf85063 {
 	struct rtc_device *rtc;
 	int c_polarity;	/* 0: MO_C=3D1 means 19xx, otherwise MO_C=3D1 means 2=
0xx */
-	int voltage_low; /* incicates if a low_voltage was detected */
+	int voltage_low; /* indicates if a low_voltage was detected */
 };
=20
 /*
@@ -47,7 +47,6 @@ static int pcf85063_get_datetime(struct
 {
 	struct pcf85063 *pcf85063 =3D i2c_get_clientdata(client);
 	unsigned char buf[13] =3D { PCF85063_REG_CTRL1 };
-
 	struct i2c_msg msgs[] =3D {
 		{/* setup read ptr */
 			.addr =3D client->addr,
@@ -61,6 +60,7 @@ static int pcf85063_get_datetime(struct
 			.buf =3D buf
 		},
 	};
+
 	/* read registers */
 	if ((i2c_transfer(client->adapter, msgs, 2)) !=3D 2) {
 		dev_err(&client->dev, "%s: read error\n", __func__);
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
revert-fs-seq_file-fallback-to-vmalloc-allocation.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
kbuild-explain-stack-protector-strong-config-logic.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.pa=
tch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
rtc-add-pcf85063-support-fix.patch
fs-isofs-logging-clean-up-fix.patch
proc-remove-proc_tty_ldisc-variable-fix.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.pa=
tch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
