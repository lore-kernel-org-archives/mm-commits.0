Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3BE2F5A
	for <mm-commits@vger.kernel.org>; Fri, 11 Apr 2025 23:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744412846; cv=none; b=IAi6IVacGNpESxLt6PLE5W3tasLlQUx6M7kCtsjb/AEVAajjERt7d+z+gCq8tj9JRmf4thhQhuC9peIuE2RQi/Gw9iyqZR2Qpo8fv8fx0D4mDRIQFKhF43gwx+ujiWXEq6TPvNrpgXLdC/oC2OBfzqH9WxFO+EgkbC/HbEMOLBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744412846; c=relaxed/simple;
	bh=vPmKsUzFR5D15TL9cJAlXW2WyGY//Z1R0QnpheM950E=;
	h=Date:To:From:Subject:Message-Id; b=GNcc/ow/To52Y+t06xO6HRW9X5caVTBCpgo4OJvgPpSH0wafkPL2ONbWBNeyYIp2V5GpuNfz37pjXOrr+siCSM629/KUL7Lpn6/uH9M7AWBDcuDmDBAjseEpsVIbGQq+8WhhJWWKd4MWb4JLib/gDpWk9PyxEOISKexYA7CNsP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U+6xojzU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U+6xojzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6718C4CEE2;
	Fri, 11 Apr 2025 23:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744412846;
	bh=vPmKsUzFR5D15TL9cJAlXW2WyGY//Z1R0QnpheM950E=;
	h=Date:To:From:Subject:From;
	b=U+6xojzUd+ve6YovbHisAtbXVgERnavsxfq+PvN8iIggixp8LSKAJeNLAXrcvcUUK
	 8rxSqd8IIY0/3P51auH6/hj8jQ9JCaRFWlR4oLZzUVniZMXv866vPRo3PS7qO8m/M8
	 rPxjGW/xdyLCqMRC7maxexIrQ9kjBxMzfD9u5DMA=
Date: Fri, 11 Apr 2025 16:07:26 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,thomas.lendacky@amd.com,tglx@linutronix.de,skinsburskii@linux.microsoft.com,saravanak@google.com,rostedt@goodmis.org,robh@kernel.org,ptyadav@amazon.de,peterz@infradead.org,pbonzini@redhat.com,pasha.tatashin@soleen.com,mingo@redhat.com,mark.rutland@arm.com,luto@kernel.org,krzk@kernel.org,jgowans@amazon.com,jgg@nvidia.com,hpa@zytor.com,graf@amazon.com,ebiederm@xmission.com,dwmw2@infradead.org,corbet@lwn.net,changyuanl@google.com,catalin.marinas@arm.com,bp@alien8.de,benh@kernel.crashing.org,ashish.kalra@amd.com,arnd@arndb.de,anthony.yznaga@oracle.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-kho-add-memblock-bindings.patch added to mm-new branch
Message-Id: <20250411230726.A6718C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: KHO: add memblock bindings
has been added to the -mm mm-new branch.  Its filename is
     documentation-kho-add-memblock-bindings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-kho-add-memblock-bindings.patch

This patch will later appear in the mm-new branch at
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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: Documentation: KHO: add memblock bindings
Date: Thu, 10 Apr 2025 22:37:45 -0700

We introduced KHO into Linux: A framework that allows Linux to pass
metadata and memory across kexec from Linux to Linux.  KHO reuses fdt as
file format and shares a lot of the same properties of firmware-to- Linux
boot formats: It needs a stable, documented ABI that allows for forward
and backward compatibility as well as versioning.

As first user of KHO, we introduced memblock which can now preserve memory
ranges reserved with reserve_mem command line options contents across
kexec, so you can use the post-kexec kernel to read traces from the
pre-kexec kernel.

This patch adds memblock schemas similar to "device" device tree ones to a
new kho bindings directory.  This allows us to force contributors to
document the data that moves across KHO kexecs and catch breaking change
during review.

Link: https://lkml.kernel.org/r/20250411053745.1817356-15-changyuanl@google.com
Co-developed-by: Alexander Graf <graf@amazon.com>
Signed-off-by: Alexander Graf <graf@amazon.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Gowans <jgowans@amazon.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pratyush Yadav <ptyadav@amazon.de>
Cc: Rob Herring <robh@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>
Cc: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Thomas Lendacky <thomas.lendacky@amd.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/kho/bindings/memblock/memblock.yaml    |   39 +++++++++
 Documentation/core-api/kho/bindings/memblock/reserve-mem.yaml |   40 ++++++++++
 MAINTAINERS                                                   |    1 
 3 files changed, 80 insertions(+)

diff --git a/Documentation/core-api/kho/bindings/memblock/memblock.yaml a/Documentation/core-api/kho/bindings/memblock/memblock.yaml
new file mode 100644
--- /dev/null
+++ a/Documentation/core-api/kho/bindings/memblock/memblock.yaml
@@ -0,0 +1,39 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+title: Memblock reserved memory
+
+maintainers:
+  - Mike Rapoport <rppt@kernel.org>
+
+description: |
+  Memblock can serialize its current memory reservations created with
+  reserve_mem command line option across kexec through KHO.
+  The post-KHO kernel can then consume these reservations and they are
+  guaranteed to have the same physical address.
+
+properties:
+  compatible:
+    enum:
+      - reserve-mem-v1
+
+patternProperties:
+  "$[0-9a-f_]+^":
+    $ref: reserve-mem.yaml#
+    description: reserved memory regions
+
+required:
+  - compatible
+
+additionalProperties: false
+
+examples:
+  - |
+    memblock {
+      compatible = "memblock-v1";
+      n1 {
+        compatible = "reserve-mem-v1";
+        start = <0xc06b 0x4000000>;
+        size = <0x04 0x00>;
+      };
+    };
diff --git a/Documentation/core-api/kho/bindings/memblock/reserve-mem.yaml a/Documentation/core-api/kho/bindings/memblock/reserve-mem.yaml
new file mode 100644
--- /dev/null
+++ a/Documentation/core-api/kho/bindings/memblock/reserve-mem.yaml
@@ -0,0 +1,40 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+title: Memblock reserved memory regions
+
+maintainers:
+  - Mike Rapoport <rppt@kernel.org>
+
+description: |
+  Memblock can serialize its current memory reservations created with
+  reserve_mem command line option across kexec through KHO.
+  This object describes each such region.
+
+properties:
+  compatible:
+    enum:
+      - reserve-mem-v1
+
+  start:
+    description: |
+      physical address (u64) of the reserved memory region.
+
+  size:
+    description: |
+      size (u64) of the reserved memory region.
+
+required:
+  - compatible
+  - start
+  - size
+
+additionalProperties: false
+
+examples:
+  - |
+    n1 {
+      compatible = "reserve-mem-v1";
+      start = <0xc06b 0x4000000>;
+      size = <0x04 0x00>;
+    };
--- a/MAINTAINERS~documentation-kho-add-memblock-bindings
+++ a/MAINTAINERS
@@ -15429,6 +15429,7 @@ M:	Mike Rapoport <rppt@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/core-api/boot-time-mm.rst
+F:	Documentation/core-api/kho/bindings/memblock/*
 F:	include/linux/memblock.h
 F:	mm/memblock.c
 F:	mm/mm_init.c
_

Patches currently in -mm which might be from rppt@kernel.org are

memblock-add-memblock_rsrv_kern-flag.patch
memblock-introduce-memmap_init_kho_scratch.patch
kexec-enable-kho-support-for-memory-preservation.patch
x86-setup-use-memblock_reserve_kern-for-memory-used-by-kernel.patch
documentation-kho-add-memblock-bindings.patch

