From: akpm@linux-foundation.org
Subject: + make-pnp_add_card_id-static.patch added to -mm tree
Date: Tue, 06 May 2008 11:36:19 -0700
Message-ID: <200805061836.m46IaJjq021195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754230AbYEFSgk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 14:36:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, bjorn.helgaas@hp.com, rene.herman@gmail.com


The patch titled
     make pnp_add_card_id() static
has been added to the -mm tree.  Its filename is
     make-pnp_add_card_id-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make pnp_add_card_id() static
From: Adrian Bunk <bunk@kernel.org>

pnp_add_card_id() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Rene Herman <rene.herman@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/base.h |    1 -
 drivers/pnp/card.c |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/pnp/base.h~make-pnp_add_card_id-static drivers/pnp/base.h
--- a/drivers/pnp/base.h~make-pnp_add_card_id-static
+++ a/drivers/pnp/base.h
@@ -14,7 +14,6 @@ struct pnp_id *pnp_add_id(struct pnp_dev
 int pnp_interface_attach_device(struct pnp_dev *dev);
 
 int pnp_add_card(struct pnp_card *card);
-struct pnp_id *pnp_add_card_id(struct pnp_card *card, char *id);
 void pnp_remove_card(struct pnp_card *card);
 int pnp_add_card_device(struct pnp_card *card, struct pnp_dev *dev);
 void pnp_remove_card_device(struct pnp_dev *dev);
diff -puN drivers/pnp/card.c~make-pnp_add_card_id-static drivers/pnp/card.c
--- a/drivers/pnp/card.c~make-pnp_add_card_id-static
+++ a/drivers/pnp/card.c
@@ -101,7 +101,7 @@ static int card_probe(struct pnp_card *c
  * @id: pointer to a pnp_id structure
  * @card: pointer to the desired card
  */
-struct pnp_id *pnp_add_card_id(struct pnp_card *card, char *id)
+static struct pnp_id *pnp_add_card_id(struct pnp_card *card, char *id)
 {
 	struct pnp_id *dev_id, *ptr;
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-udf.patch
nfs-make-nfs4_drop_state_owner-static.patch
show_schedstat-fix-memleak.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
reiser4.patch
remove-is_tty.patch
make-cgroup_seqfile_release-static.patch
make-kprobe_blacklist-static.patch
make-pnp_add_card_id-static.patch
mfd-sm501c-if-0-unused-functions.patch
pcmcia-kill-in_card_services.patch
video-sis-remove-compat-code.patch
make-struct-mpt_proc_root_dir-static.patch
make-parport_cs_release-static.patch
parport-sharec-proper-externs.patch
remove-include-asm-h8300-keyboardh.patch
proper-spawn_ksoftirqd-prototype.patch
proper-pidhashmap_init-prototypes.patch
mm-migratec-should-include-linux-syscallsh.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
minix-remove-no_truncate-code.patch
remove-the-v850-port.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
init-do_mountsc-should-include-linux-initrdh.patch
proper-prototype-for-acpi_processor_tstate_has_changed.patch
if-0-hpet_unregister.patch
tpm_biosc-make-2-structs-static.patch
proper-extern-for-mwave_s_mdd.patch
xtensa-remove-the-nonexisting-highmem-support.patch
serial-8250_gscc-add-module_license.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
unexport-proc_clear_tty.patch
unexport-uts_sem.patch

