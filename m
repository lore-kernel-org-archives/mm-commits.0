From: akpm@linux-foundation.org
Subject: - git-ia64.patch removed from -mm tree
Date: Fri, 24 Aug 2007 20:26:53 -0700
Message-ID: <200708250326.l7P3Qrrd028107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57074 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752935AbXHYD1U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 23:27:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tony.luck@intel.com, akpm@linux-foundation.org, eranian@hpl.hp.com, horms@verge.net.au, khalid.aziz@hp.com, khalid_aziz@hp.com, maeda.naoaki@jp.fujitsu.com, michal.k.k.piotrowski@gmail


The patch titled
     git-ia64.patch
has been removed from the -mm tree.  Its filename was
     git-ia64.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: git-ia64.patch

GIT 33b3db771d7e95ed4e6ebc9ef11b7139a3c13a36 git+ssh://master.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6.git#test

commit 3c3344ca815487568d617860894898737677600a
Author: Tony Luck <tony.luck@intel.com>
Date:   Fri May 11 15:18:45 2007 -0700

    [IA64] s/scalibility/scalability/
    
    Previous spelling patch from Simon Arlott broke one spot that
    didn't need fixing (reported by Simon within 35 minutes of the
    patch ... but not until after I'd applied to GIT and pushed :-(
    
    Signed-off-by: Tony Luck <tony.luck@intel.com>

commit a19d4e1a15544a12b811c161039212a2cf63e70c
Author: Tony Luck <tony.luck@intel.com>
Date:   Tue Mar 6 15:41:24 2007 -0800

    Revert "[IA64] add idle loop entry/exit notifier"
    
    By request from Stephane:
    This reverts commit 041be4f00312683016c49362f4575aa4cbc264b3.
    
    He has an alternative way to do this.
    
    Signed-off-by: Tony Luck <tony.luck@intel.com>

commit 041be4f00312683016c49362f4575aa4cbc264b3
Author: Stephane Eranian <eranian@hpl.hp.com>
Date:   Wed Nov 15 14:23:34 2006 -0800

    [IA64] add idle loop entry/exit notifier
    
    - add a notifier to the idle loop to get called when entering/leaving the
      lowest level of the idle loop
    - migrate SGI LED acitvity over to using the idle notifier
    
    Signed-off-by: stephane eranian <eranian@hpl.hp.com>
    Signed-off-by: Tony Luck <tony.luck@intel.com>

commit 7ab62884069d6d300812fc2b07f1c2332e0882c6
Author: Maeda Naoaki <maeda.naoaki@jp.fujitsu.com>
Date:   Thu Oct 26 14:50:43 2006 -0700

    [IA64] Kdump don't clear vector in kexec_disable_iosapic
    
    Mask IOSAPIC will make the following EOI write to IOSAPIC fail because
    IOSAPIC will not be able to find RTE entry.  However move EOI write
    before IOSAPIC mask will leave a small racy windows between them for
    interrupts. So mask IOSAPIC but leave the vector field.
    
    Signed-off-by: Zou Nan hai <nanhai.zou@intel.com>
    Signed-off-by: Tony Luck <tony.luck@intel.com>

commit 1050658418ee3d0d385b8679edd1c86941860ab2
Author: Zou Nan hai <nanhai.zou@intel.com>
Date:   Wed Oct 25 12:25:59 2006 +0800

    [IA64] Kdump Fix fc.i offset in relocate_kernel.S
    
    There is 8 byte wrong offset in icache flush instruction in
    relocate_kernel.S. Which may cause normal Kexec(not kdump)
    fail on Montecito Box.
    
    Signed-off-by: Zou Nan hai <nanhai.zou@intel.com>
    Signed-off-by: Tony Luck <tony.luck@intel.com>

commit 40eee8ab3441cc4d4fcb7cfbdbd339e7b583f846
Author: Khalid Aziz <khalid_aziz@hp.com>
Date:   Thu Oct 12 13:19:45 2006 -0600

    [IA64] Fix compile failure with CONFIG_KEXEC but not CONFIG_CRASH_DUMP
    
    2.6.18 kernel patched with kexec/kdump patch from Tony's test tree fails
    to compile if CONFIG_KEXEC is turned on but CONFIG_CRASH_DUMP is not.
    Following patch fixes this.
    
    Signed-off-by: Khalid Aziz <khalid.aziz@hp.com>
    Acked-by: Simon Horman <horms@verge.net.au>
    Signed-off-by: Tony Luck <tony.luck@intel.com>

commit e1983ff22209e0de0595abe9b61d30078ef3ccb9
Author: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Date:   Tue Oct 10 14:25:29 2006 -0700

    [IA64] kill #include "linux/config.h"
    
    config.h is obsolete. This patch removes all #include "linux/config.h".
    (specifically the one in arch/ia64/kernel/relocate_kernel.S)
    
    Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
    Cc: "Luck, Tony" <tony.luck@intel.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Tony Luck <tony.luck@intel.com>

commit dc52454505ea87f0e6d4dab534acdd29ef33e7df
Author: Zou Nan hai <nanhai.zou@intel.com>
Date:   Mon Oct 2 13:51:30 2006 -0700

    [IA64] Kexec/Kdump for Itanium
    
    Distillation of work largely by Zou Nan hai (who gets Author credit
    because 'git' only seems to support one author) but also inspired by
    Khalid Aziz, Simon Horman, and a few others whom I'm too lazy to look
    up in the mailing list archives, but whose support I appreciate.
    
    Signed-off-by: Tony Luck <tony.luck@intel.com>

Patches currently in -mm which might be from tony.luck@intel.com are

origin.patch
double-hpet-clocksource-hard-freeze.patch
cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
git-dma.patch
ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix-update.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
kconfig-make-instrumentation-support-non-experimental.patch
report-the-per-irq-statistics-on-allarches.patch
add-linux-elfcore-compath.patch
x86_64-use-linux-elfcore-compath.patch
powerpc-use-linux-elfcore-compath.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
