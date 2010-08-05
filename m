From: akpm@linux-foundation.org
Subject: + documentation-padatatxt-fix-typos-etc.patch added to -mm tree
Date: Thu, 05 Aug 2010 13:47:41 -0700
Message-ID: <201008052047.o75Klf7X003763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933205Ab0HEU4Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Aug 2010 16:56:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, herbert@gondor.hengli.com.au, steffen.klassert@secunet.com


The patch titled
     Documentation/padata.txt: fix typos etc.
has been added to the -mm tree.  Its filename is
     documentation-padatatxt-fix-typos-etc.patch

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
Subject: Documentation/padata.txt: fix typos etc.
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix typos & grammar.
Use CPU instead of cpu in text.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/padata.txt |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN Documentation/padata.txt~documentation-padatatxt-fix-typos-etc Documentation/padata.txt
--- a/Documentation/padata.txt~documentation-padatatxt-fix-typos-etc
+++ a/Documentation/padata.txt
@@ -19,7 +19,7 @@ overall control of how tasks are to be r
 
 The pcpumask describes which processors will be used to execute work
 submitted to this instance in parallel. The cbcpumask defines which
-processors are allowed to use as the serialization callback processor.
+processors are allowed to be used as the serialization callback processor.
 The workqueue wq is where the work will actually be done; it should be
 a multithreaded queue, naturally.
 
@@ -30,10 +30,10 @@ cpumasks this helper function can be use
 
 Note: Padata maintains two kinds of cpumasks internally. The user supplied
 cpumasks, submitted by padata_alloc/padata_alloc_possible and the 'usable'
-cpumasks. The usable cpumasks are always the subset of active cpus in the
-user supplied cpumasks, these are the cpumasks padata actually use. So
-it is legal to supply a cpumask to padata that contains offline cpus.
-Once a offline cpu in the user supplied cpumask comes online, padata
+cpumasks. The usable cpumasks are always a subset of active CPUs in the
+user supplied cpumasks; these are the cpumasks padata actually uses. So
+it is legal to supply a cpumask to padata that contains offline CPUs.
+Once an offline CPU in the user supplied cpumask comes online, padata
 is going to use it.
 
 There are functions for enabling and disabling the instance:
@@ -44,7 +44,7 @@ There are functions for enabling and dis
 These functions are setting or clearing the "PADATA_INIT" flag;
 if that flag is not set, other functions will refuse to work.
 padata_start returns zero on success (flag set) or -EINVAL if the
-padata cpumask contains no active cpu (flag not set).
+padata cpumask contains no active CPU (flag not set).
 padata_stop clears the flag and blocks until the padata instance
 is unused.
 
@@ -63,11 +63,11 @@ done with great frequency.
 
 It's possible to change both cpumasks of a padata instance with
 padata_set_cpumasks by specifying the cpumasks for parallel execution (pcpumask)
-and for the serial callback function (cbcpumask). padata_set_cpumask is to
+and for the serial callback function (cbcpumask). padata_set_cpumask is used to
 change just one of the cpumasks. Here cpumask_type is one of PADATA_CPU_SERIAL,
 PADATA_CPU_PARALLEL and cpumask specifies the new cpumask to use.
-To simply add or remove one cpu from a certain cpumask the functions
-padata_add_cpu/padata_remove_cpu are used. cpu specifies the cpu to add or
+To simply add or remove one CPU from a certain cpumask the functions
+padata_add_cpu/padata_remove_cpu are used. cpu specifies the CPU to add or
 remove and mask is one of PADATA_CPU_SERIAL, PADATA_CPU_PARALLEL.
 
 If a user is interested in padata cpumask changes, he can register to
@@ -82,7 +82,7 @@ To unregister from that notifier:
 					   struct notifier_block *nblock);
 
 The padata cpumask change notifier notifies about changes of the usable
-cpumasks, i.e. the subset of active cpus in the user supplied cpumask.
+cpumasks, i.e. the subset of active CPUs in the user supplied cpumask.
 
 Padata calls the notifier chain with:
 
@@ -92,7 +92,7 @@ Padata calls the notifier chain with:
 
 Here cpumask_change_notifier is registered notifier, notification_mask
 is one of PADATA_CPU_SERIAL, PADATA_CPU_PARALLEL and cpumask is a pointer
-to a struct padata_cpumask that contains the new cpumask informations.
+to a struct padata_cpumask that contains the new cpumask information.
 
 Actually submitting work to the padata instance requires the creation of a
 padata_priv structure:
@@ -104,7 +104,7 @@ padata_priv structure:
     };
 
 This structure will almost certainly be embedded within some larger
-structure specific to the work to be done.  Most its fields are private to
+structure specific to the work to be done.  Most of its fields are private to
 padata, but the structure should be zeroed at initialisation time, and the
 parallel() and serial() functions should be provided.  Those functions will
 be called in the process of getting the work done as we will see
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
backlight-fix-88pm860x_bl-macro-collision.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
scsi-fix-pmcraid-build-errors.patch
scsi-fix-bnx2i-build-errors.patch
virtio_9ph-include-linux-typesh.patch
submittingpatches-add-more-about-patch-descriptions.patch
fusion-fix-kernel-doc-warnings.patch
timerc-fix-kernel-doc-warning.patch
mtd-nand_base-fix-kernel-doc-warnings-typos.patch
docbook-need-xmldoclinks-for-all-doc-types.patch
documentation-padatatxt-fix-typos-etc.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

