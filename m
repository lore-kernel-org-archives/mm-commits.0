Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75AC22F15E
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 17:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747849755; cv=none; b=qQ4Yr6LCoF8jIwfxOg9M5VgQRUZtZpqp5ViXVxZg6WpH8LMvE9jn0Ay2LMpJer0l3Nl7mexwPPnbWiyJQudSwDVYKASpZ54OmahXmcWw/yVKDpC+zU8+lfQHI9vROaSVwVr8C9IkEHNAYtBofoVHFMpe7m4FWqOqbcFi2dJvCjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747849755; c=relaxed/simple;
	bh=Sms8AqMe5KmYOzGgapjgzFk6AM5R18bTOhKYyB/BXgQ=;
	h=Date:To:From:Subject:Message-Id; b=NpXyZvJ46kA1XlBaC6kmh4+vt3A+aRDfc8LGySALLXOCxNVGhrcUfg8ft9eks7Ook6ifDbp5XRjl6KKtGafhANEpLP2Ga2n/hv9TufmblCRIWcvcVEIw8+Lztrjf90GGCJDyjrbzwSL7JZZ9WjpkeNpg34CtBriGIZuwV6Ea2wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TnHwxuu4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TnHwxuu4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777C4C4CEE4;
	Wed, 21 May 2025 17:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747849755;
	bh=Sms8AqMe5KmYOzGgapjgzFk6AM5R18bTOhKYyB/BXgQ=;
	h=Date:To:From:Subject:From;
	b=TnHwxuu45oUfKRXOzVOOfIUrwLFyn13jyD3pguulyxqE8DK1bHM70qRYCu/8Jv0cM
	 4I1v2evAsYMjniqxvNUGHGk5WCEbchAvB31syu+IAbv8n0Up5DIykvn4ANPZGZpN2k
	 XrMAL/435/1I1r3ewynzrDxs49t8ipkO9MP6a7QU=
Date: Wed, 21 May 2025 10:49:14 -0700
To: mm-commits@vger.kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,hca@linux.ibm.com,gor@linux.ibm.com,agordeev@linux.ibm.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-symbols-determine-kaslr-offset-on-s390-during-early-boot.patch removed from -mm tree
Message-Id: <20250521174915.777C4C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb/symbols: determine KASLR offset on s390 during early boot
has been removed from the -mm tree.  Its filename was
     scripts-gdb-symbols-determine-kaslr-offset-on-s390-during-early-boot.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: scripts/gdb/symbols: determine KASLR offset on s390 during early boot
Date: Thu, 15 May 2025 17:52:13 +0200

Using lx-symbols during s390 early boot fails with:

    Error occurred in Python: 'utf-8' codec can't decode byte 0xcb in position 0: invalid continuation byte

The reason is that s390 decompressor's startup_kernel() does not create
vmcoreinfo note, and sets vmcore_info to kernel's physical base.  This
confuses get_vmcore_s390().

Fix by handling this special case.  Extract vm_layout.kaslr_offset from
the kernel image in physical memory, which is placed there by the
decompressor using the __bootdata_preserved mechanism, and generate a
synthetic vmcoreinfo note from it.

Link: https://lkml.kernel.org/r/20250515155811.114392-4-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/symbols.py |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/scripts/gdb/linux/symbols.py~scripts-gdb-symbols-determine-kaslr-offset-on-s390-during-early-boot
+++ a/scripts/gdb/linux/symbols.py
@@ -54,6 +54,18 @@ def get_vmcore_s390():
         vmcore_info = 0x0e0c
         paddr_vmcoreinfo_note = gdb.parse_and_eval("*(unsigned long long *)" +
                                                    hex(vmcore_info))
+        if paddr_vmcoreinfo_note == 0 or paddr_vmcoreinfo_note & 1:
+            # In the early boot case, extract vm_layout.kaslr_offset from the
+            # vmlinux image in physical memory.
+            if paddr_vmcoreinfo_note == 0:
+                kaslr_offset_phys = 0
+            else:
+                kaslr_offset_phys = paddr_vmcoreinfo_note - 1
+            with utils.pagination_off():
+                gdb.execute("symbol-file {0} -o {1}".format(
+                    utils.get_vmlinux(), hex(kaslr_offset_phys)))
+            kaslr_offset = gdb.parse_and_eval("vm_layout.kaslr_offset")
+            return "KERNELOFFSET=" + hex(kaslr_offset)[2:]
         inferior = gdb.selected_inferior()
         elf_note = inferior.read_memory(paddr_vmcoreinfo_note, 12)
         n_namesz, n_descsz, n_type = struct.unpack(">III", elf_note)
_

Patches currently in -mm which might be from iii@linux.ibm.com are


