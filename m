Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2115A21859F
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545918; cv=none; b=pOaQZgxxGempEoJo1XK0aBmGUdKeahjKGPoSHHkZND5DQO18V7lQ4msfTzxvAWm/VOmiV2atVyzQ8WTiE+8wbOVOv4GSCFSTcLtDKjZJFknC+7SMUB2b3ObUshmoqFEex3GXc/t2R5zxqd3mE3/ZpRjYh0V/63HZbH44OqwN8sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545918; c=relaxed/simple;
	bh=AU+/4KhWIacgZY0sBS8B+YxTtV+J82nPEgEhJV0mVIw=;
	h=Date:To:From:Subject:Message-Id; b=YlGFwrA9UkdF2KP12tHChhm6EtVf+sxpbUr0xkKtZX3rW4rRA0gKSsyd4K8Vw1v3kcFzO5NGnkxOoOyk/d6zj7Nwach0QxMevliyQBADOoAHTBkjSy0PC+NXnswkvtgP0zC6CRmmp0LjZcd4f5AChB2XVMQrXS1elVcQnxUCoDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0mp84EG+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0mp84EG+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4360C4CEE4;
	Tue,  1 Apr 2025 22:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545918;
	bh=AU+/4KhWIacgZY0sBS8B+YxTtV+J82nPEgEhJV0mVIw=;
	h=Date:To:From:Subject:From;
	b=0mp84EG+fsZIKXc3qOvNCjLr+3ZzAMAQbQUYOu3cCsR+t258GrnWLJo+kqcYpt/JI
	 We4drZZaAcYv0viuwJMuwHR/7s8Cl3gfwume9iweAhZp1mfMHdy9u96/nzaBeNV/Lk
	 tlufsUluPtrDGRFdRXnFyhPBUO0o2AS7MlDSOyYA=
Date: Tue, 01 Apr 2025 15:18:37 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,thomas.weissschuh@linutronix.de,sroettger@google.com,rientjes@google.com,rdunlap@infradead.org,peterx@redhat.com,pedro.falcato@gmail.com,oleg@redhat.com,ojeda@kernel.org,mpe@ellerman.id.au,mingo@kernel.org,mike.rapoport@gmail.com,mhocko@suse.com,mark.rutland@arm.com,lorenzo.stoakes@oracle.com,linus.walleij@linaro.org,Liam.Howlett@oracle.com,kees@kernel.org,jorgelo@chromium.org,johannes@sipsolutions.net,jason@zx2c4.com,jannh@google.com,hch@lst.de,hca@linux.ibm.com,groeck@chromium.org,gerg@kernel.org,f.fainelli@gmail.com,enh@google.com,deller@gmx.de,davem@davemloft.net,dave.hansen@linux.intel.com,benjamin@sipsolutions.net,avagin@gmail.com,ardb@kernel.org,anna-maria@linutronix.de,aleksandr.mikhalitsyn@canonical.com,adobriyan@gmail.com,adhemerval.zanella@linaro.org,42.hyeyoo@gmail.com,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftest-test-system-mappings-are-sealed.patch removed from -mm tree
Message-Id: <20250401221837.E4360C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftest: test system mappings are sealed
has been removed from the -mm tree.  Its filename was
     selftest-test-system-mappings-are-sealed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Xu <jeffxu@chromium.org>
Subject: selftest: test system mappings are sealed
Date: Wed, 5 Mar 2025 02:17:11 +0000

Add sysmap_is_sealed.c to test system mappings are sealed.

Note: CONFIG_MSEAL_SYSTEM_MAPPINGS must be set, as indicated in
config file.

Link: https://lkml.kernel.org/r/20250305021711.3867874-8-jeffxu@google.com
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Kees Cook <kees@kernel.org>
Cc: Adhemerval Zanella <adhemerval.zanella@linaro.org>
Cc: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Benjamin Berg <benjamin@sipsolutions.net>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Elliot Hughes <enh@google.com>
Cc: Florian Faineli <f.fainelli@gmail.com>
Cc: Greg Ungerer <gerg@kernel.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Jorge Lucangeli Obes <jorgelo@chromium.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Linus Waleij <linus.walleij@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <mike.rapoport@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Röttger <sroettger@google.com>
Cc: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile                                 |    1 
 tools/testing/selftests/mseal_system_mappings/.gitignore         |    2 
 tools/testing/selftests/mseal_system_mappings/Makefile           |    6 
 tools/testing/selftests/mseal_system_mappings/config             |    1 
 tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c |  119 ++++++++++
 5 files changed, 129 insertions(+)

--- a/tools/testing/selftests/Makefile~selftest-test-system-mappings-are-sealed
+++ a/tools/testing/selftests/Makefile
@@ -62,6 +62,7 @@ TARGETS += mount
 TARGETS += mount_setattr
 TARGETS += move_mount_set_group
 TARGETS += mqueue
+TARGETS += mseal_system_mappings
 TARGETS += nci
 TARGETS += net
 TARGETS += net/af_unix
diff --git a/tools/testing/selftests/mseal_system_mappings/config a/tools/testing/selftests/mseal_system_mappings/config
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/mseal_system_mappings/config
@@ -0,0 +1 @@
+CONFIG_MSEAL_SYSTEM_MAPPINGS=y
diff --git a/tools/testing/selftests/mseal_system_mappings/.gitignore a/tools/testing/selftests/mseal_system_mappings/.gitignore
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/mseal_system_mappings/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+sysmap_is_sealed
diff --git a/tools/testing/selftests/mseal_system_mappings/Makefile a/tools/testing/selftests/mseal_system_mappings/Makefile
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/mseal_system_mappings/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0-only
+CFLAGS += -std=c99 -pthread -Wall $(KHDR_INCLUDES)
+
+TEST_GEN_PROGS := sysmap_is_sealed
+
+include ../lib.mk
diff --git a/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c a/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * test system mappings are sealed when
+ * KCONFIG_MSEAL_SYSTEM_MAPPINGS=y
+ */
+
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <errno.h>
+#include <unistd.h>
+#include <string.h>
+#include <stdbool.h>
+
+#include "../kselftest.h"
+#include "../kselftest_harness.h"
+
+#define VMFLAGS "VmFlags:"
+#define MSEAL_FLAGS "sl"
+#define MAX_LINE_LEN 512
+
+bool has_mapping(char *name, FILE *maps)
+{
+	char line[MAX_LINE_LEN];
+
+	while (fgets(line, sizeof(line), maps)) {
+		if (strstr(line, name))
+			return true;
+	}
+
+	return false;
+}
+
+bool mapping_is_sealed(char *name, FILE *maps)
+{
+	char line[MAX_LINE_LEN];
+
+	while (fgets(line, sizeof(line), maps)) {
+		if (!strncmp(line, VMFLAGS, strlen(VMFLAGS))) {
+			if (strstr(line, MSEAL_FLAGS))
+				return true;
+
+			return false;
+		}
+	}
+
+	return false;
+}
+
+FIXTURE(basic) {
+	FILE *maps;
+};
+
+FIXTURE_SETUP(basic)
+{
+	self->maps = fopen("/proc/self/smaps", "r");
+	if (!self->maps)
+		SKIP(return, "Could not open /proc/self/smap, errno=%d",
+			errno);
+};
+
+FIXTURE_TEARDOWN(basic)
+{
+	if (self->maps)
+		fclose(self->maps);
+};
+
+FIXTURE_VARIANT(basic)
+{
+	char *name;
+	bool sealed;
+};
+
+FIXTURE_VARIANT_ADD(basic, vdso) {
+	.name = "[vdso]",
+	.sealed = true,
+};
+
+FIXTURE_VARIANT_ADD(basic, vvar) {
+	.name = "[vvar]",
+	.sealed = true,
+};
+
+FIXTURE_VARIANT_ADD(basic, vvar_vclock) {
+	.name = "[vvar_vclock]",
+	.sealed = true,
+};
+
+FIXTURE_VARIANT_ADD(basic, sigpage) {
+	.name = "[sigpage]",
+	.sealed = true,
+};
+
+FIXTURE_VARIANT_ADD(basic, vectors) {
+	.name = "[vectors]",
+	.sealed = true,
+};
+
+FIXTURE_VARIANT_ADD(basic, uprobes) {
+	.name = "[uprobes]",
+	.sealed = true,
+};
+
+FIXTURE_VARIANT_ADD(basic, stack) {
+	.name = "[stack]",
+	.sealed = false,
+};
+
+TEST_F(basic, check_sealed)
+{
+	if (!has_mapping(variant->name, self->maps)) {
+		SKIP(return, "could not find the mapping, %s",
+			variant->name);
+	}
+
+	EXPECT_EQ(variant->sealed,
+		mapping_is_sealed(variant->name, self->maps));
+};
+
+TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from jeffxu@chromium.org are


