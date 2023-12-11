Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F63C7493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fRLvJ1NZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69834C433C8;
	Mon, 11 Dec 2023 01:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257840;
	bh=n3a8UjJSN8HVich4kUpH1R/e8dETxHuNQA5gJ5h4fJM=;
	h=Date:To:From:Subject:From;
	b=fRLvJ1NZSGVG6GHzpxZyWC7qpCXtZvRxHlMzxN1pX2x9K3oG6oTntiNjpbdoCNFf+
	 fIfEISRRnom6+6tOHrX33YvmmU9Q/8iKATEkzR7xHSvLbWRjX/Sd+5EPE/nvnF1aR0
	 4KOGXkOmLcmEpa/AKKJH/uMce5j9P+b0YpeQlypo=
Date: Sun, 10 Dec 2023 17:23:59 -0800
To: mm-commits@vger.kernel.org,takahiro.akashi@linaro.org,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec_file-load-kernel-at-top-of-system-ram-if-required.patch removed from -mm tree
Message-Id: <20231211012400.69834C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec_file: load kernel at top of system RAM if required
has been removed from the -mm tree.  Its filename was
     kexec_file-load-kernel-at-top-of-system-ram-if-required.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: kexec_file: load kernel at top of system RAM if required
Date: Tue, 14 Nov 2023 17:16:58 +0800

Patch series "kexec_file: Load kernel at top of system RAM if required".

Justification:
==============

Kexec_load interface has been doing top down searching and loading
kernel/initrd/purgtory etc to prepare for kexec reboot.  In that way, the
benefits are that it avoids to consume and fragment limited low memory
which satisfy DMA buffer allocation and big chunk of continuous memory
during system init; and avoids to stir with BIOS/FW reserved or occupied
areas, or corner case handling/work around/quirk occupied areas when doing
system init.  By the way, the top-down searching and loading of kexec-ed
kernel is done in user space utility code.

For kexec_file loading, even if kexec_buf.top_down is 'true', it's simply
ignored.  It calls walk_system_ram_res() directly to go through all
resources of System RAM bottom up, to find an available memory region,
then call locate_mem_hole_callback() to allocate memory in that found
memory region from top to down.  This is not expected and inconsistent
with kexec_load.

Implementation
===============

In patch 1, introduce a new function walk_system_ram_res_rev() which is a
variant of walk_system_ram_res(), it walks through a list of all the
resources of System RAM in reversed order, i.e., from higher to lower.

In patch 2, check if kexec_buf.top_down is 'true' in
kexec_walk_resources(), if yes, call walk_system_ram_res_rev() to find
memory region of system RAM from top to down to load kernel/initrd etc.

Background information: ======================= And I ever tried this in
the past in a different way, please see below link.  In the post, I tried
to adjust struct sibling linking code, replace the the singly linked list
with list_head so that walk_system_ram_res_rev() can be implemented in a
much easier way.  Finally I failed. 
https://lore.kernel.org/all/20180718024944.577-4-bhe@redhat.com/

This time, I picked up the patch from AKASHI Takahiro's old post and made
some change to take as the current patch 1:
https://lists.infradead.org/pipermail/linux-arm-kernel/2017-September/531456.html


This patch (of 2):

Kexec_load interface has been doing top down searching and loading
kernel/initrd/purgtory etc to prepare for kexec reboot.  In that way, the
benefits are that it avoids to consume and fragment limited low memory
which satisfy DMA buffer allocation and big chunk of continuous memory
during system init; and avoids to stir with BIOS/FW reserved or occupied
areas, or corner case handling/work around/quirk occupied areas when doing
system init.  By the way, the top-down searching and loading of kexec-ed
kernel is done in user space utility code.

For kexec_file loading, even if kexec_buf.top_down is 'true', it's simply
ignored.  It calls walk_system_ram_res() directly to go through all
resources of System RAM bottom up, to find an available memory region,
then call locate_mem_hole_callback() to allocate memory in that found
memory region from top to down.  This is not expected and inconsistent
with kexec_load.

Here check if kexec_buf.top_down is 'true' in kexec_walk_resources(), if
yes, call the newly added walk_system_ram_res_rev() to find memory region
of system RAM from top to down to load kernel/initrd etc.

Link: https://lkml.kernel.org/r/20231114091658.228030-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20231114091658.228030-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_file.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/kexec_file.c~kexec_file-load-kernel-at-top-of-system-ram-if-required
+++ a/kernel/kexec_file.c
@@ -592,6 +592,8 @@ static int kexec_walk_resources(struct k
 					   IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY,
 					   crashk_res.start, crashk_res.end,
 					   kbuf, func);
+	else if (kbuf->top_down)
+		return walk_system_ram_res_rev(0, ULONG_MAX, kbuf, func);
 	else
 		return walk_system_ram_res(0, ULONG_MAX, kbuf, func);
 }
_

Patches currently in -mm which might be from bhe@redhat.com are

riscv-fix-vmallc_start-definition.patch
loongarch-kexec-change-dependency-of-object-files.patch
m68k-kexec-fix-the-incorrect-ifdeffery-and-build-dependency-of-config_kexec.patch
mips-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec.patch
sh-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec.patch
x86-kexec-fix-the-wrong-ifdeffery-config_kexec.patch
kexec_file-add-kexec_file-flag-to-control-debug-printing.patch
kexec_file-print-out-debugging-message-if-required.patch
kexec_file-x86-print-out-debugging-message-if-required.patch
kexec_file-arm64-print-out-debugging-message-if-required.patch
kexec_file-ricv-print-out-debugging-message-if-required.patch
kexec_file-power-print-out-debugging-message-if-required.patch
kexec_file-parisc-print-out-debugging-message-if-required.patch
riscv-kexec-fix-the-ifdeffery-for-aflags_kexec_relocateo.patch

