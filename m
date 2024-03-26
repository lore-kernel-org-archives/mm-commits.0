Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A6E1B59A
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 18:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711476496; cv=none; b=WMaSm3h4Nty9pFWPtu57X/cp/GHM1qYa/0B1TNwEy519NRnnAUlUaO3gL3TZ5BvxkpG7r8lOy522PSxuhN4P/gWUPpuU8ME8A0liRqP5maJvxJKvVJZcbnI5XKkIOKK7yxq2Z7pGxXdIpTtjnDlfxLJVCCA+Z+jo2prYdI0FXy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711476496; c=relaxed/simple;
	bh=b1GrouVGTDZN6wQGgmj2XL9U7KZLrW1Ze5avGkqHi3Y=;
	h=Date:To:From:Subject:Message-Id; b=sLDX3smgGSDNfYi4pvytSHIOI6ZKqN+FwsjCNkMjuv5P2Sl0dsU6PzPgKArnW3N6K7rp4pXOBCS0y5QWVe+jEPPA9NplXukaLoV+DOB3/fR9hiBLfcHtVe05ciN1F6K5KyiywaiEks7rLjAwn/x4gdSFFJSEB+Uy9pwEVLxX1ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pqNSwpaR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pqNSwpaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11A4C433F1;
	Tue, 26 Mar 2024 18:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711476495;
	bh=b1GrouVGTDZN6wQGgmj2XL9U7KZLrW1Ze5avGkqHi3Y=;
	h=Date:To:From:Subject:From;
	b=pqNSwpaRUQkYOhGmPmYT7gWOX0ieIuEQI+d/pRuKxu6ASGaUmq7mWGc3eVijVrUVC
	 knJn3d1gTgFM5EDSbetdq3Zl7gc3gyI6tjDpki3mM2LgR2ukcQ6vOdk0pQ25RS1lK3
	 EB89IqA8CdyBQYt2Y5LlI5jntBQsR+DuGGOEKegU=
Date: Tue, 26 Mar 2024 11:08:15 -0700
To: mm-commits@vger.kernel.org,sdf@google.com,ddrokosov@salutedevices.com,liucong2@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] tools-makefile-remove-cgroup-target.patch removed from -mm tree
Message-Id: <20240326180815.A11A4C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/Makefile: remove cgroup target
has been removed from the -mm tree.  Its filename was
     tools-makefile-remove-cgroup-target.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Cong Liu <liucong2@kylinos.cn>
Subject: tools/Makefile: remove cgroup target
Date: Fri, 15 Mar 2024 09:22:48 +0800

The tools/cgroup directory no longer contains a Makefile.  This patch
updates the top-level tools/Makefile to remove references to building and
installing cgroup components.  This change reflects the current structure
of the tools directory and fixes the build failure when building tools in
the top-level directory.

linux/tools$ make cgroup
  DESCEND cgroup
make[1]: *** No targets specified and no makefile found.  Stop.
make: *** [Makefile:73: cgroup] Error 2

Link: https://lkml.kernel.org/r/20240315012249.439639-1-liucong2@kylinos.cn
Signed-off-by: Cong Liu <liucong2@kylinos.cn>
Acked-by: Stanislav Fomichev <sdf@google.com>
Reviewed-by: Dmitry Rokosov <ddrokosov@salutedevices.com>
Cc: Cong Liu <liucong2@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/Makefile |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/tools/Makefile~tools-makefile-remove-cgroup-target
+++ a/tools/Makefile
@@ -11,7 +11,6 @@ help:
 	@echo ''
 	@echo '  acpi                   - ACPI tools'
 	@echo '  bpf                    - misc BPF tools'
-	@echo '  cgroup                 - cgroup tools'
 	@echo '  counter                - counter tools'
 	@echo '  cpupower               - a tool for all things x86 CPU power'
 	@echo '  debugging              - tools for debugging'
@@ -69,7 +68,7 @@ acpi: FORCE
 cpupower: FORCE
 	$(call descend,power/$@)
 
-cgroup counter firewire hv guest bootconfig spi usb virtio mm bpf iio gpio objtool leds wmi pci firmware debugging tracing: FORCE
+counter firewire hv guest bootconfig spi usb virtio mm bpf iio gpio objtool leds wmi pci firmware debugging tracing: FORCE
 	$(call descend,$@)
 
 bpf/%: FORCE
@@ -116,7 +115,7 @@ freefall: FORCE
 kvm_stat: FORCE
 	$(call descend,kvm/$@)
 
-all: acpi cgroup counter cpupower gpio hv firewire \
+all: acpi counter cpupower gpio hv firewire \
 		perf selftests bootconfig spi turbostat usb \
 		virtio mm bpf x86_energy_perf_policy \
 		tmon freefall iio objtool kvm_stat wmi \
@@ -128,7 +127,7 @@ acpi_install:
 cpupower_install:
 	$(call descend,power/$(@:_install=),install)
 
-cgroup_install counter_install firewire_install gpio_install hv_install iio_install perf_install bootconfig_install spi_install usb_install virtio_install mm_install bpf_install objtool_install wmi_install pci_install debugging_install tracing_install:
+counter_install firewire_install gpio_install hv_install iio_install perf_install bootconfig_install spi_install usb_install virtio_install mm_install bpf_install objtool_install wmi_install pci_install debugging_install tracing_install:
 	$(call descend,$(@:_install=),install)
 
 selftests_install:
@@ -155,7 +154,7 @@ freefall_install:
 kvm_stat_install:
 	$(call descend,kvm/$(@:_install=),install)
 
-install: acpi_install cgroup_install counter_install cpupower_install gpio_install \
+install: acpi_install counter_install cpupower_install gpio_install \
 		hv_install firewire_install iio_install \
 		perf_install selftests_install turbostat_install usb_install \
 		virtio_install mm_install bpf_install x86_energy_perf_policy_install \
@@ -169,7 +168,7 @@ acpi_clean:
 cpupower_clean:
 	$(call descend,power/cpupower,clean)
 
-cgroup_clean counter_clean hv_clean firewire_clean bootconfig_clean spi_clean usb_clean virtio_clean mm_clean wmi_clean bpf_clean iio_clean gpio_clean objtool_clean leds_clean pci_clean firmware_clean debugging_clean tracing_clean:
+counter_clean hv_clean firewire_clean bootconfig_clean spi_clean usb_clean virtio_clean mm_clean wmi_clean bpf_clean iio_clean gpio_clean objtool_clean leds_clean pci_clean firmware_clean debugging_clean tracing_clean:
 	$(call descend,$(@:_clean=),clean)
 
 libapi_clean:
@@ -209,7 +208,7 @@ freefall_clean:
 build_clean:
 	$(call descend,build,clean)
 
-clean: acpi_clean cgroup_clean counter_clean cpupower_clean hv_clean firewire_clean \
+clean: acpi_clean counter_clean cpupower_clean hv_clean firewire_clean \
 		perf_clean selftests_clean turbostat_clean bootconfig_clean spi_clean usb_clean virtio_clean \
 		mm_clean bpf_clean iio_clean x86_energy_perf_policy_clean tmon_clean \
 		freefall_clean build_clean libbpf_clean libsubcmd_clean \
_

Patches currently in -mm which might be from liucong2@kylinos.cn are


