Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE5D7493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yRebJSwi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6F5C433C9;
	Mon, 11 Dec 2023 01:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257839;
	bh=qvODle3CTyTxjE7ltmrljzhVqqhqBwsiYxH+5q70oGU=;
	h=Date:To:From:Subject:From;
	b=yRebJSwihxlyGaTXVYMX4ta9N+8f8OZwRXzk0N+JUKdUO1ElWxHD2DW5MdrAg5Ys8
	 Blxvt1cqgLX1T0frKuZb/ZnslT88luzJrPRiiSdcz7WkN4PwR7TUU6Lx+73CsS5HX4
	 0y3XknjAEW20avqTOYBsnC0FWYLOii2uRf6wIVAI=
Date: Sun, 10 Dec 2023 17:23:58 -0800
To: mm-commits@vger.kernel.org,takahiro.akashi@linaro.org,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] resource-add-walk_system_ram_res_rev.patch removed from -mm tree
Message-Id: <20231211012359.4B6F5C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: resource: add walk_system_ram_res_rev()
has been removed from the -mm tree.  Its filename was
     resource-add-walk_system_ram_res_rev.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: resource: add walk_system_ram_res_rev()
Date: Wed, 15 Nov 2023 21:00:27 +0800

This function, being a variant of walk_system_ram_res() introduced in
commit 8c86e70acead ("resource: provide new functions to walk through
resources"), walks through a list of all the resources of System RAM in
reversed order, i.e., from higher to lower.

It will be used in kexec_file code to load kernel, initrd etc when
preparing kexec reboot.

Link: https://lkml.kernel.org/r/ZVTA6z/06cLnWKUz@MiWiFi-R3L-srv
Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h |    3 ++
 kernel/resource.c      |   57 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

--- a/include/linux/ioport.h~resource-add-walk_system_ram_res_rev
+++ a/include/linux/ioport.h
@@ -331,6 +331,9 @@ extern int
 walk_system_ram_res(u64 start, u64 end, void *arg,
 		    int (*func)(struct resource *, void *));
 extern int
+walk_system_ram_res_rev(u64 start, u64 end, void *arg,
+			int (*func)(struct resource *, void *));
+extern int
 walk_iomem_res_desc(unsigned long desc, unsigned long flags, u64 start, u64 end,
 		    void *arg, int (*func)(struct resource *, void *));
 
--- a/kernel/resource.c~resource-add-walk_system_ram_res_rev
+++ a/kernel/resource.c
@@ -27,6 +27,8 @@
 #include <linux/mount.h>
 #include <linux/resource_ext.h>
 #include <uapi/linux/magic.h>
+#include <linux/string.h>
+#include <linux/vmalloc.h>
 #include <asm/io.h>
 
 
@@ -430,6 +432,61 @@ int walk_system_ram_res(u64 start, u64 e
 }
 
 /*
+ * This function, being a variant of walk_system_ram_res(), calls the @func
+ * callback against all memory ranges of type System RAM which are marked as
+ * IORESOURCE_SYSTEM_RAM and IORESOUCE_BUSY in reversed order, i.e., from
+ * higher to lower.
+ */
+int walk_system_ram_res_rev(u64 start, u64 end, void *arg,
+				int (*func)(struct resource *, void *))
+{
+	struct resource res, *rams;
+	int rams_size = 16, i;
+	unsigned long flags;
+	int ret = -1;
+
+	/* create a list */
+	rams = kvcalloc(rams_size, sizeof(struct resource), GFP_KERNEL);
+	if (!rams)
+		return ret;
+
+	flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
+	i = 0;
+	while ((start < end) &&
+		(!find_next_iomem_res(start, end, flags, IORES_DESC_NONE, &res))) {
+		if (i >= rams_size) {
+			/* re-alloc */
+			struct resource *rams_new;
+
+			rams_new = kvrealloc(rams, rams_size * sizeof(struct resource),
+					     (rams_size + 16) * sizeof(struct resource),
+					     GFP_KERNEL);
+			if (!rams_new)
+				goto out;
+
+			rams = rams_new;
+			rams_size += 16;
+		}
+
+		rams[i].start = res.start;
+		rams[i++].end = res.end;
+
+		start = res.end + 1;
+	}
+
+	/* go reverse */
+	for (i--; i >= 0; i--) {
+		ret = (*func)(&rams[i], arg);
+		if (ret)
+			break;
+	}
+
+out:
+	kvfree(rams);
+	return ret;
+}
+
+/*
  * This function calls the @func callback against all memory ranges, which
  * are ranges marked as IORESOURCE_MEM and IORESOUCE_BUSY.
  */
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

