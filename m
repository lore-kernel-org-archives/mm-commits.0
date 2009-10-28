From: akpm@linux-foundation.org
Subject: + tpm-fix-header-for-modular-build.patch added to -mm tree
Date: Wed, 28 Oct 2009 12:26:39 -0700
Message-ID: <200910281926.n9SJQdTk030261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753660AbZJ1T1G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Oct 2009 15:27:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, eparis@redhat.com, jmorris@namei.org, srajiv@linux.vnet.ibm.com, zohar@linux.vnet.ibm.com, zohar@us.ibm.com


The patch titled
     tpm: fix header for modular build
has been added to the -mm tree.  Its filename is
     tpm-fix-header-for-modular-build.patch

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
Subject: tpm: fix header for modular build
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build for TCG_TPM=m.  Header file doesn't handle this
and incorrectly builds stubs.

drivers/char/tpm/tpm.c:720: error: redefinition of 'tpm_pcr_read'
include/linux/tpm.h:35: error:previous definition of 'tpm_pcr_read' was here
drivers/char/tpm/tpm.c:752: error: redefinition of 'tpm_pcr_extend'
include/linux/tpm.h:38: error:previous definition of 'tpm_pcr_extend' was here


Repairs linux-next's

commit d6ba452128178091dab7a04d54f7e66fdc32fb39
Author: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date:   Mon Oct 26 09:26:18 2009 -0400

    tpm add default function definitions

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: James Morris <jmorris@namei.org>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/tpm.h~tpm-fix-header-for-modular-build include/linux/tpm.h
--- a/include/linux/tpm.h~tpm-fix-header-for-modular-build
+++ a/include/linux/tpm.h
@@ -27,7 +27,7 @@
  */
 #define	TPM_ANY_NUM 0xFFFF
 
-#if defined(CONFIG_TCG_TPM)
+#if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
 
 extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
 extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
cpufreq-add-cpufreq_get-stub-for-config_cpu_freq=n.patch
linux-next.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-depends-on-acpi.patch
scsi-fix-func-names-in-kernel-doc.patch
readahead-add-blk_run_backing_dev.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
nodemask-make-nodemask_alloc-more-general.patch
hugetlb-rework-hstate_next_node_-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix.patch
hugetlb-factor-init_nodemask_of_node.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch
hugetlb-add-generic-definition-of-numa_no_node.patch
hugetlb-add-per-node-hstate-attributes.patch
hugetlb-update-hugetlb-documentation-for-numa-controls.patch
hugetlb-use-only-nodes-with-memory-for-huge-pages.patch
mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined.patch
hugetlb-handle-memory-hot-plug-events.patch
hugetlb-offload-per-node-attribute-registrations.patch
mm-add-gfp-flags-for-nodemask_alloc-slab-allocations.patch
tpm-fix-header-for-modular-build.patch
spi-add-pci-interface-driver-for-designware-spi-core-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

