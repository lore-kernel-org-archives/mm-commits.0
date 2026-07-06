Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFCB372B24
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 17:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783359941; cv=none; b=K3V/bqGMylvnFKeLACikjgzRIDbDcM1kS9RWBY5TOp1eSiEf77/fUAkYaHovizFeZHKazdDNutfSUedP1zmq/lXi7MmSSYisZa9q5uBpscNm8J5hwyTQqtkPud3cNWhQbzJyPYRmbpvdEnfN4od7fVBi8h6tRIRubK2qW6wUCWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783359941; c=relaxed/simple;
	bh=qdi1+pCnpuOeELpaZd+4r7KcNIZxz8V8Dfwm7vw/iKM=;
	h=Date:To:From:Subject:Message-Id; b=PRGyjpq5bt5vN4ml5m1ILalOL1J9/92cuNhgLkfEwLzwMmJlMyxKLuAXPeiuxBMgGANjOj/y2Wt+j/Sn6EQlyMjSAVtyKp5d81Bbn6cgtbynGVco3SVbu0n050yPGkA6bCH16n1+cTKs4luQREchWozaJ/VAOPLeCIn8w6J+0E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HNhYTMQ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HNhYTMQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75051F00A3A;
	Mon,  6 Jul 2026 17:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783359939;
	bh=cno84OxYGsCu9MO6qatRRIWYDvQCDg+BqvN4Zsp2DaQ=;
	h=Date:To:From:Subject;
	b=HNhYTMQ9UBfLn8/1cepghpsgM+t/JxLBTE5mtbiZUQg6YvPQ+q4vwWEXRA2sgd6/+
	 0mBZSS3IN0m4NeLm0VNc6tr5HHYbUWjgsaCiz4ByTZRfYyLEJAG/ETmKk+ogOyOBW9
	 nObht4qVtiRu28YhQk+O4ykKZwlpXhSA/OiYo/XE=
Date: Mon, 06 Jul 2026 10:45:39 -0700
To: mm-commits@vger.kernel.org,kees@kernel.org,akpm@linux-foundation.org,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + reboot-use-lookup-tables-for-sysfs-mode-and-type-strings.patch added to mm-nonmm-unstable branch
Message-Id: <20260706174539.B75051F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: reboot: use lookup tables for sysfs mode and type strings
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     reboot-use-lookup-tables-for-sysfs-mode-and-type-strings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/reboot-use-lookup-tables-for-sysfs-mode-and-type-strings.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Bradley Morgan <include@grrlz.net>
Subject: reboot: use lookup tables for sysfs mode and type strings
Date: Mon, 6 Jul 2026 12:28:11 +0000

Replace switch and if else chains in the mode and type sysfs handlers with
lookup tables, removing duplicated string macros.

Link: https://lore.kernel.org/20260706122811.6695-1-include@grrlz.net
Signed-off-by: Bradley Morgan <include@grrlz.net>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/reboot.c |  136 +++++++++++++++++-----------------------------
 1 file changed, 51 insertions(+), 85 deletions(-)

--- a/kernel/reboot.c~reboot-use-lookup-tables-for-sysfs-mode-and-type-strings
+++ a/kernel/reboot.c
@@ -1177,68 +1177,43 @@ __setup("reboot=", reboot_setup);
 
 #ifdef CONFIG_SYSFS
 
-#define REBOOT_COLD_STR		"cold"
-#define REBOOT_WARM_STR		"warm"
-#define REBOOT_HARD_STR		"hard"
-#define REBOOT_SOFT_STR		"soft"
-#define REBOOT_GPIO_STR		"gpio"
 #define REBOOT_UNDEFINED_STR	"undefined"
 
-#define BOOT_TRIPLE_STR		"triple"
-#define BOOT_KBD_STR		"kbd"
-#define BOOT_BIOS_STR		"bios"
-#define BOOT_ACPI_STR		"acpi"
-#define BOOT_EFI_STR		"efi"
-#define BOOT_PCI_STR		"pci"
+static const char *const reboot_mode_strs[] = {
+	[REBOOT_COLD]	= "cold",
+	[REBOOT_WARM]	= "warm",
+	[REBOOT_HARD]	= "hard",
+	[REBOOT_SOFT]	= "soft",
+	[REBOOT_GPIO]	= "gpio",
+};
 
 static ssize_t mode_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
 {
-	const char *val;
+	const char *val = REBOOT_UNDEFINED_STR;
 
-	switch (reboot_mode) {
-	case REBOOT_COLD:
-		val = REBOOT_COLD_STR;
-		break;
-	case REBOOT_WARM:
-		val = REBOOT_WARM_STR;
-		break;
-	case REBOOT_HARD:
-		val = REBOOT_HARD_STR;
-		break;
-	case REBOOT_SOFT:
-		val = REBOOT_SOFT_STR;
-		break;
-	case REBOOT_GPIO:
-		val = REBOOT_GPIO_STR;
-		break;
-	default:
-		val = REBOOT_UNDEFINED_STR;
-	}
+	if ((unsigned int)reboot_mode < ARRAY_SIZE(reboot_mode_strs))
+		val = reboot_mode_strs[reboot_mode];
 
 	return sysfs_emit(buf, "%s\n", val);
 }
 static ssize_t mode_store(struct kobject *kobj, struct kobj_attribute *attr,
 			  const char *buf, size_t count)
 {
+	unsigned int i;
+
 	if (!capable(CAP_SYS_BOOT))
 		return -EPERM;
 
-	if (!strncmp(buf, REBOOT_COLD_STR, strlen(REBOOT_COLD_STR)))
-		reboot_mode = REBOOT_COLD;
-	else if (!strncmp(buf, REBOOT_WARM_STR, strlen(REBOOT_WARM_STR)))
-		reboot_mode = REBOOT_WARM;
-	else if (!strncmp(buf, REBOOT_HARD_STR, strlen(REBOOT_HARD_STR)))
-		reboot_mode = REBOOT_HARD;
-	else if (!strncmp(buf, REBOOT_SOFT_STR, strlen(REBOOT_SOFT_STR)))
-		reboot_mode = REBOOT_SOFT;
-	else if (!strncmp(buf, REBOOT_GPIO_STR, strlen(REBOOT_GPIO_STR)))
-		reboot_mode = REBOOT_GPIO;
-	else
-		return -EINVAL;
-
-	reboot_default = 0;
+	for (i = 0; i < ARRAY_SIZE(reboot_mode_strs); i++) {
+		if (!strncmp(buf, reboot_mode_strs[i],
+			     strlen(reboot_mode_strs[i]))) {
+			reboot_mode = i;
+			reboot_default = 0;
+			return count;
+		}
+	}
 
-	return count;
+	return -EINVAL;
 }
 static struct kobj_attribute reboot_mode_attr = __ATTR_RW(mode);
 
@@ -1265,31 +1240,28 @@ static ssize_t force_store(struct kobjec
 }
 static struct kobj_attribute reboot_force_attr = __ATTR_RW(force);
 
+static const struct {
+	enum reboot_type type;
+	const char *str;
+} reboot_type_strs[] = {
+	{ BOOT_TRIPLE,		"triple" },
+	{ BOOT_KBD,		"kbd" },
+	{ BOOT_BIOS,		"bios" },
+	{ BOOT_ACPI,		"acpi" },
+	{ BOOT_EFI,		"efi" },
+	{ BOOT_CF9_FORCE,	"pci" },
+};
+
 static ssize_t type_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
 {
-	const char *val;
+	const char *val = REBOOT_UNDEFINED_STR;
+	unsigned int i;
 
-	switch (reboot_type) {
-	case BOOT_TRIPLE:
-		val = BOOT_TRIPLE_STR;
-		break;
-	case BOOT_KBD:
-		val = BOOT_KBD_STR;
-		break;
-	case BOOT_BIOS:
-		val = BOOT_BIOS_STR;
-		break;
-	case BOOT_ACPI:
-		val = BOOT_ACPI_STR;
-		break;
-	case BOOT_EFI:
-		val = BOOT_EFI_STR;
-		break;
-	case BOOT_CF9_FORCE:
-		val = BOOT_PCI_STR;
-		break;
-	default:
-		val = REBOOT_UNDEFINED_STR;
+	for (i = 0; i < ARRAY_SIZE(reboot_type_strs); i++) {
+		if (reboot_type == reboot_type_strs[i].type) {
+			val = reboot_type_strs[i].str;
+			break;
+		}
 	}
 
 	return sysfs_emit(buf, "%s\n", val);
@@ -1297,27 +1269,21 @@ static ssize_t type_show(struct kobject
 static ssize_t type_store(struct kobject *kobj, struct kobj_attribute *attr,
 			  const char *buf, size_t count)
 {
+	unsigned int i;
+
 	if (!capable(CAP_SYS_BOOT))
 		return -EPERM;
 
-	if (!strncmp(buf, BOOT_TRIPLE_STR, strlen(BOOT_TRIPLE_STR)))
-		reboot_type = BOOT_TRIPLE;
-	else if (!strncmp(buf, BOOT_KBD_STR, strlen(BOOT_KBD_STR)))
-		reboot_type = BOOT_KBD;
-	else if (!strncmp(buf, BOOT_BIOS_STR, strlen(BOOT_BIOS_STR)))
-		reboot_type = BOOT_BIOS;
-	else if (!strncmp(buf, BOOT_ACPI_STR, strlen(BOOT_ACPI_STR)))
-		reboot_type = BOOT_ACPI;
-	else if (!strncmp(buf, BOOT_EFI_STR, strlen(BOOT_EFI_STR)))
-		reboot_type = BOOT_EFI;
-	else if (!strncmp(buf, BOOT_PCI_STR, strlen(BOOT_PCI_STR)))
-		reboot_type = BOOT_CF9_FORCE;
-	else
-		return -EINVAL;
-
-	reboot_default = 0;
+	for (i = 0; i < ARRAY_SIZE(reboot_type_strs); i++) {
+		if (!strncmp(buf, reboot_type_strs[i].str,
+			     strlen(reboot_type_strs[i].str))) {
+			reboot_type = reboot_type_strs[i].type;
+			reboot_default = 0;
+			return count;
+		}
+	}
 
-	return count;
+	return -EINVAL;
 }
 static struct kobj_attribute reboot_type_attr = __ATTR_RW(type);
 #endif
_

Patches currently in -mm which might be from include@grrlz.net are

lib-string-fix-memchr_inv-for-large-ranges.patch
signal-avoid-shared-siginfo-namespace-rewrites.patch
panic-fix-va_list-reuse-in-panic_try_force_cpu.patch
reboot-use-lookup-tables-for-sysfs-mode-and-type-strings.patch

