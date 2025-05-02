Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122952E403
	for <mm-commits@vger.kernel.org>; Fri,  2 May 2025 00:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746146645; cv=none; b=df/0WkZFA8TA5nV0r4CTFVFqUf1v0WltZSih1vqbF5dRVhhCMeJwe7ElKlCoC2YljPoUgIAmN7DbBuQODdG1RQJznf5P3tIOwOI3ltw5WaQk4rJs7K4zykS5Bo60WLa7E96HKadGmW6sUq3KF8Zf2UiSDYoHXvTOCHFH6VNZ8fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746146645; c=relaxed/simple;
	bh=j/8dPFe95OUPTCulv459NecYOynhnqCJQdB2NdiIJYE=;
	h=Date:To:From:Subject:Message-Id; b=mItqA5mqrN5Mpw8EaoF5JIgU4KZGcN22poGWIEVtgP4xxgs//4LK20hc5f8/0PhpDeDM5EFbJeCD9+nQbgVIMRgYPe8G1GUJJuangKVBDkTWGGbmserkQrwgJnNnrZ6q/RAad/lTU8m10sFEj1ccV3lQC5NKKeY2r3YFzmPlYEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HiocB7/F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HiocB7/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DF5C4CEE3;
	Fri,  2 May 2025 00:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746146644;
	bh=j/8dPFe95OUPTCulv459NecYOynhnqCJQdB2NdiIJYE=;
	h=Date:To:From:Subject:From;
	b=HiocB7/FPCW+irFE5JmVQWR3hVvQORnrgDeuAtJHbyFv+H0tIuEcJ2+8kHhAOzaCy
	 OZNNhHT/N3arQAF2An3Eq0oG+O3Y/0CG3zq5G6nupdwyIbGv0PN9VpMygkip8R9U0S
	 XYCKK435ZmOFADrDSoR+zf5ev8jMlXz0DOCr/UAA=
Date: Thu, 01 May 2025 17:44:03 -0700
To: mm-commits@vger.kernel.org,graf@amazon.com,changyuanl@google.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-kho-add-memblock-bindings.patch added to mm-unstable branch
Message-Id: <20250502004404.71DF5C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: KHO: add memblock bindings
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-kho-add-memblock-bindings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-kho-add-memblock-bindings.patch

This patch will later appear in the mm-unstable branch at
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
Date: Thu, 1 May 2025 15:54:25 -0700

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

Link: https://lkml.kernel.org/r/20250501225425.635167-19-changyuanl@google.com
Co-developed-by: Alexander Graf <graf@amazon.com>
Signed-off-by: Alexander Graf <graf@amazon.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
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
@@ -15433,6 +15433,7 @@ M:	Mike Rapoport <rppt@kernel.org>
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
execmem-enforce-allocation-size-aligment-to-page_size.patch

