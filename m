From: akpm@linux-foundation.org
Subject: + alpha-titan-and-marvel-build-fixes.patch added to -mm tree
Date: Fri, 24 Apr 2009 13:12:33 -0700
Message-ID: <200904242012.n3OKCgw7006327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753542AbZDXUPM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Apr 2009 16:15:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, rth@twiddle.net, viro@ZenIV.linux.org.uk


The patch titled
     alpha: titan and marvel build fixes
has been added to the -mm tree.  Its filename is
     alpha-titan-and-marvel-build-fixes.patch

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
Subject: alpha: titan and marvel build fixes
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

These platforms got broken after u64 => 'long long' conversion.

Apparently that change was compile-tested with 'make allmodconfig', but it
doesn't include systems that depend on !ALPHA_LEGACY_START_ADDRESS.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Richard Henderson <rth@twiddle.net
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/err_ev6.c    |    2 +-
 arch/alpha/kernel/err_ev7.c    |    4 ++--
 arch/alpha/kernel/err_impl.h   |   10 +++++-----
 arch/alpha/kernel/err_marvel.c |    2 +-
 arch/alpha/kernel/err_titan.c  |    4 ++--
 arch/alpha/kernel/proto.h      |    5 ++---
 6 files changed, 13 insertions(+), 14 deletions(-)

diff -puN arch/alpha/kernel/err_ev6.c~alpha-titan-and-marvel-build-fixes arch/alpha/kernel/err_ev6.c
--- a/arch/alpha/kernel/err_ev6.c~alpha-titan-and-marvel-build-fixes
+++ a/arch/alpha/kernel/err_ev6.c
@@ -229,7 +229,7 @@ ev6_process_logout_frame(struct el_commo
 }
 
 void
-ev6_machine_check(u64 vector, u64 la_ptr)
+ev6_machine_check(unsigned long vector, unsigned long la_ptr)
 {
 	struct el_common *mchk_header = (struct el_common *)la_ptr;
 
diff -puN arch/alpha/kernel/err_ev7.c~alpha-titan-and-marvel-build-fixes arch/alpha/kernel/err_ev7.c
--- a/arch/alpha/kernel/err_ev7.c~alpha-titan-and-marvel-build-fixes
+++ a/arch/alpha/kernel/err_ev7.c
@@ -117,7 +117,7 @@ ev7_collect_logout_frame_subpackets(stru
 }
 
 void
-ev7_machine_check(u64 vector, u64 la_ptr)
+ev7_machine_check(unsigned long vector, unsigned long la_ptr)
 {
 	struct el_subpacket *el_ptr = (struct el_subpacket *)la_ptr;
 	char *saved_err_prefix = err_print_prefix;
@@ -246,7 +246,7 @@ ev7_process_pal_subpacket(struct el_subp
 
 	switch(header->type) {
 	case EL_TYPE__PAL__LOGOUT_FRAME:
-		printk("%s*** MCHK occurred on LPID %ld (RBOX %llx)\n",
+		printk("%s*** MCHK occurred on LPID %lld (RBOX %llx)\n",
 		       err_print_prefix,
 		       packet->by_type.logout.whami, 
 		       packet->by_type.logout.rbox_whami);
diff -puN arch/alpha/kernel/err_impl.h~alpha-titan-and-marvel-build-fixes arch/alpha/kernel/err_impl.h
--- a/arch/alpha/kernel/err_impl.h~alpha-titan-and-marvel-build-fixes
+++ a/arch/alpha/kernel/err_impl.h
@@ -60,26 +60,26 @@ extern struct ev7_lf_subpackets *
 ev7_collect_logout_frame_subpackets(struct el_subpacket *,
 				    struct ev7_lf_subpackets *);
 extern void ev7_register_error_handlers(void);
-extern void ev7_machine_check(u64, u64);
+extern void ev7_machine_check(unsigned long, unsigned long);
 
 /*
  * err_ev6.c
  */
 extern void ev6_register_error_handlers(void);
 extern int ev6_process_logout_frame(struct el_common *, int);
-extern void ev6_machine_check(u64, u64);
+extern void ev6_machine_check(unsigned long, unsigned long);
 
 /*
  * err_marvel.c
  */
-extern void marvel_machine_check(u64, u64);
+extern void marvel_machine_check(unsigned long, unsigned long);
 extern void marvel_register_error_handlers(void);
 
 /*
  * err_titan.c
  */
 extern int titan_process_logout_frame(struct el_common *, int);
-extern void titan_machine_check(u64, u64);
+extern void titan_machine_check(unsigned long, unsigned long);
 extern void titan_register_error_handlers(void);
 extern int privateer_process_logout_frame(struct el_common *, int);
-extern void privateer_machine_check(u64, u64);
+extern void privateer_machine_check(unsigned long, unsigned long);
diff -puN arch/alpha/kernel/err_marvel.c~alpha-titan-and-marvel-build-fixes arch/alpha/kernel/err_marvel.c
--- a/arch/alpha/kernel/err_marvel.c~alpha-titan-and-marvel-build-fixes
+++ a/arch/alpha/kernel/err_marvel.c
@@ -1042,7 +1042,7 @@ marvel_process_logout_frame(struct ev7_l
 }
 
 void
-marvel_machine_check(u64 vector, u64 la_ptr)
+marvel_machine_check(unsigned long vector, unsigned long la_ptr)
 {
 	struct el_subpacket *el_ptr = (struct el_subpacket *)la_ptr;
 	int (*process_frame)(struct ev7_lf_subpackets *, int) = NULL;
diff -puN arch/alpha/kernel/err_titan.c~alpha-titan-and-marvel-build-fixes arch/alpha/kernel/err_titan.c
--- a/arch/alpha/kernel/err_titan.c~alpha-titan-and-marvel-build-fixes
+++ a/arch/alpha/kernel/err_titan.c
@@ -380,7 +380,7 @@ titan_process_logout_frame(struct el_com
 }
 
 void
-titan_machine_check(u64 vector, u64 la_ptr)
+titan_machine_check(unsigned long vector, unsigned long la_ptr)
 {
 	struct el_common *mchk_header = (struct el_common *)la_ptr;
 	struct el_TITAN_sysdata_mcheck *tmchk =
@@ -702,7 +702,7 @@ privateer_process_logout_frame(struct el
 }
 
 void
-privateer_machine_check(u64 vector, u64 la_ptr)
+privateer_machine_check(unsigned long vector, unsigned long la_ptr)
 {
 	struct el_common *mchk_header = (struct el_common *)la_ptr;
 	struct el_TITAN_sysdata_mcheck *tmchk =
diff -puN arch/alpha/kernel/proto.h~alpha-titan-and-marvel-build-fixes arch/alpha/kernel/proto.h
--- a/arch/alpha/kernel/proto.h~alpha-titan-and-marvel-build-fixes
+++ a/arch/alpha/kernel/proto.h
@@ -36,7 +36,6 @@ extern void cia_pci_tbi(struct pci_contr
 extern struct pci_ops irongate_pci_ops;
 extern int irongate_pci_clr_err(void);
 extern void irongate_init_arch(void);
-extern void irongate_machine_check(u64, u64);
 #define irongate_pci_tbi ((void *)0)
 
 /* core_lca.c */
@@ -49,7 +48,7 @@ extern void lca_pci_tbi(struct pci_contr
 extern struct pci_ops marvel_pci_ops;
 extern void marvel_init_arch(void);
 extern void marvel_kill_arch(int);
-extern void marvel_machine_check(u64, u64);
+extern void marvel_machine_check(unsigned long, unsigned long);
 extern void marvel_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 extern int marvel_pa_to_nid(unsigned long);
 extern int marvel_cpuid_to_nid(int);
@@ -86,7 +85,7 @@ extern void t2_pci_tbi(struct pci_contro
 extern struct pci_ops titan_pci_ops;
 extern void titan_init_arch(void);
 extern void titan_kill_arch(int);
-extern void titan_machine_check(u64, u64);
+extern void titan_machine_check(unsigned long, unsigned long);
 extern void titan_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 extern struct _alpha_agp_info *titan_agp_info(void);
 
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

linux-next.patch
time-create-arch_gettimeoffset-infrastructure-for-use-in-the-generic-timekeeping-core.patch
alpha-titan-and-marvel-build-fixes.patch
alpha-exception-table-sorting.patch
alpha-futex-implementation.patch
alpha-binfmt_aout-fix.patch
kmap_types-make-most-arches-use-generic-header-file.patch
make-sure-nobodys-leaking-resources.patch

