Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3835F185E77
	for <mm-commits@vger.kernel.org>; Wed,  3 Jul 2024 18:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720031635; cv=none; b=pZ7lvgko1tAezcXMlhatKHC6GunKjEJcoAg53hzgoOXC+9KrQduhMXKfT2bbYeGfW90ozAo0GDndkQQtkXW3T7fkmuzy1vrwXcDtt63Ta6Lewc3Ss7ZqUaynrd4vq5eAukLu9pvhgNrSaRhfGUHeQ14sDWjADaMEv9l+AzsLg7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720031635; c=relaxed/simple;
	bh=x8t0JDYoM7kp/cbynCjE9sOZzogmLwOOOSZxVN9MQpI=;
	h=Date:To:From:Subject:Message-Id; b=U/uOSN7Z8cmDTiDRBgDGvqAhMpFF2nyscA4vF7NQSBZ4V6Zw0SCLmuanQVgeVpCQjJQwa8g2din9KZVujZiozwe1zk20cycIGomS9iI+ABA2Ck07NskXMcoC6ZHqb5lGPGWEqQUo5rgblsb7No2dF1OhPpp4UcUCyYmDB0VJeh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bIhnGrjR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bIhnGrjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA735C2BD10;
	Wed,  3 Jul 2024 18:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720031634;
	bh=x8t0JDYoM7kp/cbynCjE9sOZzogmLwOOOSZxVN9MQpI=;
	h=Date:To:From:Subject:From;
	b=bIhnGrjRXk7944OABQpdu6PIc461J+eVdrMnQx+AEsfiNnMy7632KO963gVYTkQo8
	 8pdox0N8GB4E4y8c9wtqTL2ea8f2KduJtFubiHpBpXYoqz37BsNPmjcmisb0ky16rg
	 3lgYMDWLKJiAA52c29SkFtR83VDWv9g89FFKyl50=
Date: Wed, 03 Jul 2024 11:33:54 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,nicolas@fjasle.eu,nathan@kernel.org,masahiroy@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] modpost-meminit-is-not-in-init-section-when-config_memory_hotplug-set.patch removed from -mm tree
Message-Id: <20240703183354.BA735C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: modpost: .meminit.* is not in init section when CONFIG_MEMORY_HOTPLUG set
has been removed from the -mm tree.  Its filename was
     modpost-meminit-is-not-in-init-section-when-config_memory_hotplug-set.patch

This patch was dropped because it was nacked

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
mm-page_alloc-put-__free_pages_core-in-__meminit-section.patch

