Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACF5DC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 01:26:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjDRB0B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Apr 2023 21:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjDRB0A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Apr 2023 21:26:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696D649D7
        for <mm-commits@vger.kernel.org>; Mon, 17 Apr 2023 18:25:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0619662BAE
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 01:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C92CC4339B;
        Tue, 18 Apr 2023 01:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681781157;
        bh=mR/TvNVqOTQMKyEIuOHd1NIJeU1HsW2V9n1wrmpeYvg=;
        h=Date:To:From:Subject:From;
        b=U/gsVUica0pHLrWWb0DPi7CZ2JwNX4Ji+OVKcYoAvguG6prZjPT8vjfIPPt6vgtGg
         Lw+Qzb2+7eBOwgL5jpDicQKA/e113oXvvQFO8pzGBHmutVPZpskxOuYzzc9oo+0epp
         ofj8vkayLD3WHBsbs2B2AS2Cvd5Qg8G/q/NaQz1Y=
Date:   Mon, 17 Apr 2023 18:25:56 -0700
To:     mm-commits@vger.kernel.org, ricardo@pardini.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-makefile-do-missed-s-vm-mm.patch added to mm-hotfixes-unstable branch
Message-Id: <20230418012557.5C92CC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/Makefile: do missed s/vm/mm/
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-makefile-do-missed-s-vm-mm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-makefile-do-missed-s-vm-mm.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

tools-makefile-do-missed-s-vm-mm.patch

