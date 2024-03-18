Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5FE58AAA
	for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2024 20:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710794563; cv=none; b=BheSxFzx2vDcwsTufZ8UBfu804GXDu0JRLtHTbpTF6hib4Ghyg4H+bUIem4RbSy+VBYZdALEtb2gQUqt52xuWsPYW3OwHSupfcZY7fQnJ41xp5BXkVNWXnc7f+kD2LTTi8lxBjIxPjq53VMOTW4+cN818Xy7wmkEkSY7x5n9Xb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710794563; c=relaxed/simple;
	bh=GW9EC7K/+zadrM5uIetJ4E0QF7E17egQ7Wm+ESkZX6Q=;
	h=Date:To:From:Subject:Message-Id; b=GLbcoB3mu7pnkNu6oE9HCotVIdao86N6U6SS7/HpjTfqCg5uFp4DVrqG1BhAislb+ym7Ocp9GHb4G4WjM8JdvyfJalu3/HJg+Ssmx42D3CPo+0QZVD1Me/NmpFR9YceGQQcTwxbhtuFmCkr608szLGSuhPzPHGb9DNCXSGOJk+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d6TCe9jo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d6TCe9jo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FF0C43390;
	Mon, 18 Mar 2024 20:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710794563;
	bh=GW9EC7K/+zadrM5uIetJ4E0QF7E17egQ7Wm+ESkZX6Q=;
	h=Date:To:From:Subject:From;
	b=d6TCe9joHhQCk2NZANkD9ZR3R2tfyMzW0AQlqNP3JIChMyjK39vzKEPR2jl9VL5eK
	 TIhcrH18zGsO68LOTJJ2X4KL6mt4UF6JfbDS9luT94FdFZ+VteKYlkiSz0gIbqUM35
	 zaf9arA/6hhgudrkXRa8bydOa0XNsw0MG7xF00+g=
Date: Mon, 18 Mar 2024 13:42:42 -0700
To: mm-commits@vger.kernel.org,sdf@google.com,ddrokosov@salutedevices.com,liucong2@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-makefile-remove-cgroup-target.patch added to mm-hotfixes-unstable branch
Message-Id: <20240318204243.15FF0C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/Makefile: remove cgroup target
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-makefile-remove-cgroup-target.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-makefile-remove-cgroup-target.patch

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

tools-makefile-remove-cgroup-target.patch

