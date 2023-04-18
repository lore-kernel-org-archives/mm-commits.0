Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35632C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 21:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbjDRVXE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 17:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232924AbjDRVW5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 17:22:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73663AF04
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 14:22:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DBA563931
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 21:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E2AC4339B;
        Tue, 18 Apr 2023 21:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681852961;
        bh=xEXYyzklCIU0Y74Fd1r3Hm6tE/skac/XelK+aFxFbvI=;
        h=Date:To:From:Subject:From;
        b=18Jln7GA02NnfnEF/BnEV+Jm9YqKjqZP1R4K+vOcBm7r12JDPNQTXAVUpy0fnFcV9
         ht3Iyxym5dD4oeJffNDYhJliayN1099kyaqE26yYeaCcPGQvtTAqaqc4KC0LSBP1/d
         dGTRybmEDH5MrwsTQveF2g06QotYhXWaPRGlXmh8=
Date:   Tue, 18 Apr 2023 14:22:41 -0700
To:     mm-commits@vger.kernel.org, ricardo@pardini.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] tools-makefile-do-missed-s-vm-mm.patch removed from -mm tree
Message-Id: <20230418212241.97E2AC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tools/Makefile: do missed s/vm/mm/
has been removed from the -mm tree.  Its filename was
     tools-makefile-do-missed-s-vm-mm.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: tools/Makefile: do missed s/vm/mm/
Date: Sat, 15 Apr 2023 20:31:10 +0000

Commit 799fb82aa132 ("tools/vm: rename tools/vm to tools/mm") missed
renaming 'vm' in 'tools/Makefile' to 'mm'.  As a result, 'make clean'
under 'tools/' directory fails as below:

    $ make -C tools clean
      DESCEND vm
    make[1]: Entering directory '/linux/tools/vm'
    make[1]: *** No rule to make target 'clean'.  Stop.
    make[1]: Leaving directory '/linux/tools/vm'
    make: *** [Makefile:173: vm_clean] Error 2
    make: Leaving directory '/linux/tools'

Do the missed rename.

Link: https://lkml.kernel.org/r/20230415203110.13858-1-sj@kernel.org
Fixes: 799fb82aa132 ("tools/vm: rename tools/vm to tools/mm")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Ricardo Pardini <ricardo@pardini.net>
  Link: https://lore.kernel.org/linux-mm/20230415202454.13558-1-sj@kernel.org/
Tested-by: Ricardo Pardini <ricardo@pardini.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/Makefile |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/tools/Makefile~tools-makefile-do-missed-s-vm-mm
+++ a/tools/Makefile
@@ -39,7 +39,7 @@ help:
 	@echo '  turbostat              - Intel CPU idle stats and freq reporting tool'
 	@echo '  usb                    - USB testing tools'
 	@echo '  virtio                 - vhost test module'
-	@echo '  vm                     - misc vm tools'
+	@echo '  mm                     - misc mm tools'
 	@echo '  wmi			- WMI interface examples'
 	@echo '  x86_energy_perf_policy - Intel energy policy tool'
 	@echo ''
@@ -69,7 +69,7 @@ acpi: FORCE
 cpupower: FORCE
 	$(call descend,power/$@)
 
-cgroup counter firewire hv guest bootconfig spi usb virtio vm bpf iio gpio objtool leds wmi pci firmware debugging tracing: FORCE
+cgroup counter firewire hv guest bootconfig spi usb virtio mm bpf iio gpio objtool leds wmi pci firmware debugging tracing: FORCE
 	$(call descend,$@)
 
 bpf/%: FORCE
@@ -118,7 +118,7 @@ kvm_stat: FORCE
 
 all: acpi cgroup counter cpupower gpio hv firewire \
 		perf selftests bootconfig spi turbostat usb \
-		virtio vm bpf x86_energy_perf_policy \
+		virtio mm bpf x86_energy_perf_policy \
 		tmon freefall iio objtool kvm_stat wmi \
 		pci debugging tracing thermal thermometer thermal-engine
 
@@ -128,7 +128,7 @@ acpi_install:
 cpupower_install:
 	$(call descend,power/$(@:_install=),install)
 
-cgroup_install counter_install firewire_install gpio_install hv_install iio_install perf_install bootconfig_install spi_install usb_install virtio_install vm_install bpf_install objtool_install wmi_install pci_install debugging_install tracing_install:
+cgroup_install counter_install firewire_install gpio_install hv_install iio_install perf_install bootconfig_install spi_install usb_install virtio_install mm_install bpf_install objtool_install wmi_install pci_install debugging_install tracing_install:
 	$(call descend,$(@:_install=),install)
 
 selftests_install:
@@ -158,7 +158,7 @@ kvm_stat_install:
 install: acpi_install cgroup_install counter_install cpupower_install gpio_install \
 		hv_install firewire_install iio_install \
 		perf_install selftests_install turbostat_install usb_install \
-		virtio_install vm_install bpf_install x86_energy_perf_policy_install \
+		virtio_install mm_install bpf_install x86_energy_perf_policy_install \
 		tmon_install freefall_install objtool_install kvm_stat_install \
 		wmi_install pci_install debugging_install intel-speed-select_install \
 		tracing_install thermometer_install thermal-engine_install
@@ -169,7 +169,7 @@ acpi_clean:
 cpupower_clean:
 	$(call descend,power/cpupower,clean)
 
-cgroup_clean counter_clean hv_clean firewire_clean bootconfig_clean spi_clean usb_clean virtio_clean vm_clean wmi_clean bpf_clean iio_clean gpio_clean objtool_clean leds_clean pci_clean firmware_clean debugging_clean tracing_clean:
+cgroup_clean counter_clean hv_clean firewire_clean bootconfig_clean spi_clean usb_clean virtio_clean mm_clean wmi_clean bpf_clean iio_clean gpio_clean objtool_clean leds_clean pci_clean firmware_clean debugging_clean tracing_clean:
 	$(call descend,$(@:_clean=),clean)
 
 libapi_clean:
@@ -211,7 +211,7 @@ build_clean:
 
 clean: acpi_clean cgroup_clean counter_clean cpupower_clean hv_clean firewire_clean \
 		perf_clean selftests_clean turbostat_clean bootconfig_clean spi_clean usb_clean virtio_clean \
-		vm_clean bpf_clean iio_clean x86_energy_perf_policy_clean tmon_clean \
+		mm_clean bpf_clean iio_clean x86_energy_perf_policy_clean tmon_clean \
 		freefall_clean build_clean libbpf_clean libsubcmd_clean \
 		gpio_clean objtool_clean leds_clean wmi_clean pci_clean firmware_clean debugging_clean \
 		intel-speed-select_clean tracing_clean thermal_clean thermometer_clean thermal-engine_clean
_

Patches currently in -mm which might be from sj@kernel.org are


