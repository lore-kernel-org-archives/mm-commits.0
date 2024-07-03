Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43351184E
	for <mm-commits@vger.kernel.org>; Wed,  3 Jul 2024 01:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719971597; cv=none; b=BdjcwTjoc92LAogs9Z7Z+B0lkYlSdY6r7PuMFVmfOenoMOp1QDwhDSaZQY34+ZNXlDSRUbpIWqguTyVIgozHZT3/P0HO+Opp3RMZJ7ouVnESyS94yHlsjysbPTptBFUNq9SFYn5IlCpGZRrm2QD7/2YuHuunhpWLoP4qQJ3sSzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719971597; c=relaxed/simple;
	bh=S9gyZPtZmq8rrN1CoSMJ5L1IYGw7/tUN10mQGj+/fxE=;
	h=Date:To:From:Subject:Message-Id; b=f6HXOymU5wWz5J27lwzRmQET+QQpZ4ojGhdiBISaB9h4yozP032UVuDmttSCDBfMM9pecOIa5Uq64eJqxJNbDQN7EMgz3nTLdlMhemNsYXJGzHuRd0EfIy9Lh3D5h/PvI08giu+5cyQOT9Q7dll+eNmPKypvbMAXe49IV6jcOMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cFRddNIN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cFRddNIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB20C116B1;
	Wed,  3 Jul 2024 01:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719971596;
	bh=S9gyZPtZmq8rrN1CoSMJ5L1IYGw7/tUN10mQGj+/fxE=;
	h=Date:To:From:Subject:From;
	b=cFRddNINtcE7jxz1Vj8OT2kFtvy+L4wPJDmGzFCxFPWiDrcw7C4Ejh0ROLTNgPwVE
	 QMDWyNFTbIf4aUN3nMpcOvTvUMLpEbEXKGi6iEHTsPVx6vjb2M1qJ4IQaEmAe5aSH8
	 swupXldZoUO9R6nzkUW3no65Vvr7BGLaUO2Uhrfk=
Date: Tue, 02 Jul 2024 18:53:16 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,nicolas@fjasle.eu,nathan@kernel.org,masahiroy@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + modpost-meminit-is-not-in-init-section-when-config_memory_hotplug-set.patch added to mm-unstable branch
Message-Id: <20240703015316.BAB20C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: modpost: .meminit.* is not in init section when CONFIG_MEMORY_HOTPLUG set
has been added to the -mm mm-unstable branch.  Its filename is
     modpost-meminit-is-not-in-init-section-when-config_memory_hotplug-set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/modpost-meminit-is-not-in-init-section-when-config_memory_hotplug-set.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: modpost: .meminit.* is not in init section when CONFIG_MEMORY_HOTPLUG set
Date: Tue, 2 Jul 2024 23:40:07 +0000

.meminit.* is not put into init section when CONFIG_MEMORY_HOTPLUG is set,
since we define MEM_KEEP()/MEM_DISCARD() according to
CONFIG_MEMORY_HOTPLUG.

Link: https://lkml.kernel.org/r/20240702234008.19101-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mod/modpost.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/scripts/mod/modpost.c~modpost-meminit-is-not-in-init-section-when-config_memory_hotplug-set
+++ a/scripts/mod/modpost.c
@@ -22,6 +22,7 @@
 #include <errno.h>
 #include "modpost.h"
 #include "../../include/linux/license.h"
+#include "../../include/generated/autoconf.h"
 
 static bool module_enabled;
 /* Are we using CONFIG_MODVERSIONS? */
@@ -775,9 +776,14 @@ static void check_section(const char *mo
 
 
 
+#if defined(CONFIG_MEMORY_HOTPLUG)
+#define ALL_INIT_DATA_SECTIONS \
+	".init.setup", ".init.rodata", ".init.data"
+#else
 #define ALL_INIT_DATA_SECTIONS \
 	".init.setup", ".init.rodata", ".meminit.rodata", \
 	".init.data", ".meminit.data"
+#endif
 
 #define ALL_PCI_INIT_SECTIONS	\
 	".pci_fixup_early", ".pci_fixup_header", ".pci_fixup_final", \
@@ -786,7 +792,11 @@ static void check_section(const char *mo
 
 #define ALL_XXXINIT_SECTIONS ".meminit.*"
 
+#if defined(CONFIG_MEMORY_HOTPLUG)
+#define ALL_INIT_SECTIONS INIT_SECTIONS
+#else
 #define ALL_INIT_SECTIONS INIT_SECTIONS, ALL_XXXINIT_SECTIONS
+#endif
 #define ALL_EXIT_SECTIONS ".exit.*"
 
 #define DATA_SECTIONS ".data", ".data.rel"
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

kernel-forkc-get-totalram_pages-from-memblock-to-calculate-max_threads.patch
kernel-forkc-put-set_max_threads-task_struct_whitelist-in-__init-section.patch
mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system.patch
mm-use-zonelist_zone-to-get-zone.patch
modpost-meminit-is-not-in-init-section-when-config_memory_hotplug-set.patch
mm-page_alloc-put-__free_pages_core-in-__meminit-section.patch

