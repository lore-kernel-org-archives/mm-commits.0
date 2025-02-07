Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D616C2E0
	for <mm-commits@vger.kernel.org>; Fri,  7 Feb 2025 00:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738888224; cv=none; b=abvwxHSD0FS64ZdtYNhI+sz1v0gKfgfKPIaDLo+yFUoVO86zG4mnj7A4VhmkNh1ck2YhUGtUrscmsZA8j9aKG5Sz6queiQPQTmQUWu2AtW9tJSjlqMs+0vqDA03ymtMwpac3uBBTjO7rNTFm2mEzL7qZCz9UhcvgHCfp+9CmKdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738888224; c=relaxed/simple;
	bh=rSDFnkPDNtUbhM4CTBfBxCvVEAEhhyxnCZygLihdApo=;
	h=Date:To:From:Subject:Message-Id; b=H7lQrMkG1XjIg5CuTN38ZskhGUtlfGZU4ihKytUW1jyKoz7HYj++opaFXOOixKvDXX6OuudASpnj6vFTSKXZXvyrNq275a/u4v16EUp0YJwqaU7690iaeDSGhv3bpMur2B/9bA3Ve5NCqBIDplwmkrw5s+TKFvIxCk3P1uvr+Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EYpArl4s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EYpArl4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9021C4CEDD;
	Fri,  7 Feb 2025 00:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738888223;
	bh=rSDFnkPDNtUbhM4CTBfBxCvVEAEhhyxnCZygLihdApo=;
	h=Date:To:From:Subject:From;
	b=EYpArl4sVtgqYszvce2r37oAd5WSSqxjoAoilAkaHWBHcUqx97IQUZA4LLZcrKiN/
	 gYgNsPvSYrCZs78AcG1zEfOYkUMECZhTqfwNam68Kja6XNVVb87995RA0dl/++umHq
	 sc54uDv7FTwgB83rsvlfWI2cdJjcAQkicXEEaLQg=
Date: Thu, 06 Feb 2025 16:30:23 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,usama.arif@bytedance.com,thomas.lendacky@amd.com,tglx@linutronix.de,skinsburskii@linux.microsoft.com,saravanak@google.com,rostedt@goodmis.org,robh@kernel.org,robh+dt@kernel.org,ptyadav@amazon.de,peterz@infradead.org,pbonzini@redhat.com,pasha.tatashin@soleen.com,mingo@redhat.com,mark.rutland@arm.com,luto@kernel.org,krzk@kernel.org,jgowans@amazon.com,hpa@zytor.com,graf@amazon.com,ebiederm@xmission.com,dwmw2@infradead.org,dave.hansen@linux.intel.com,corbet@lwn.net,catalin.marinas@arm.com,bp@alien8.de,benh@kernel.crashing.org,ashish.kalra@amd.com,arnd@arndb.de,anthony.yznaga@oracle.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-kho-add-memblock-bindings.patch added to mm-nonmm-unstable branch
Message-Id: <20250207003023.C9021C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: KHO: add memblock bindings
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     documentation-kho-add-memblock-bindings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-kho-add-memblock-bindings.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Date: Thu, 6 Feb 2025 15:27:54 +0200

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

Link: https://lkml.kernel.org/r/20250206132754.2596694-15-rppt@kernel.org
Co-developed-by: Alexander Graf <graf@amazon.com>
Signed-off-by: Alexander Graf <graf@amazon.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Gowans <jgowans@amazon.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Pratyush Yadav <ptyadav@amazon.de>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>
Cc: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Usama Arif <usama.arif@bytedance.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kho/bindings/memblock/reserve_mem.yaml     |   41 +++++++++
 Documentation/kho/bindings/memblock/reserve_mem_map.yaml |   42 ++++++++++
 2 files changed, 83 insertions(+)

diff --git a/Documentation/kho/bindings/memblock/reserve_mem_map.yaml a/Documentation/kho/bindings/memblock/reserve_mem_map.yaml
new file mode 100644
--- /dev/null
+++ a/Documentation/kho/bindings/memblock/reserve_mem_map.yaml
@@ -0,0 +1,42 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/memblock/reserve_mem_map.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
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
+      - reserve_mem_map-v1
+
+  mem:
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+    description: |
+      Array of { u64 phys_addr, u64 len } elements that describe a list of
+      memory ranges.
+
+required:
+  - compatible
+  - mem
+
+additionalProperties: false
+
+examples:
+  - |
+    reserve_mem {
+      compatible = "reserve_mem-v1";
+        r1 {
+          compatible = "reserve_mem_map-v1";
+          mem = <0xc07c 0x2000000 0x01 0x00>;
+        };
+    };
diff --git a/Documentation/kho/bindings/memblock/reserve_mem.yaml a/Documentation/kho/bindings/memblock/reserve_mem.yaml
new file mode 100644
--- /dev/null
+++ a/Documentation/kho/bindings/memblock/reserve_mem.yaml
@@ -0,0 +1,41 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/memblock/reserve_mem.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
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
+      - reserve_mem-v1
+
+patternProperties:
+  "$[0-9a-f_]+^":
+    $ref: reserve_mem_map.yaml#
+    description: reserved memory regions
+
+required:
+  - compatible
+
+additionalProperties: false
+
+examples:
+  - |
+    reserve_mem {
+      compatible = "reserve_mem-v1";
+        r1 {
+          compatible = "reserve_mem_map-v1";
+          mem = <0xc07c 0x2000000 0x01 0x00>;
+        };
+    };
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-mm_init-rename-init_reserved_page-to-init_deferred_page.patch
memblock-add-memblock_rsrv_kern-flag.patch
memblock-introduce-memmap_init_kho_scratch.patch
x86-setup-use-memblock_reserve_kern-for-memory-used-by-kernel.patch
documentation-kho-add-memblock-bindings.patch

