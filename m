From: akpm@linux-foundation.org
Subject: [folded-merged]
 kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table-v5.patch removed from -mm tree
Date: Tue, 15 Mar 2016 14:44:21 -0700
Message-ID: <56e88235.YHwVhFS877y9Zmze%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60012 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbcCOVoW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Mar 2016 17:44:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard.biesheuvel@linaro.org, arnd@arndb.de, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, hpa@zytor.com, keescook@chromium.org, linux@roeck-us.net, mingo@kernel.org, mmarek@suse.cz, mpe@ellerman.id.au, rusty@rustcorp.com.au, sudipm.mukherjee@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kallsyms: add support for relative offsets in kallsyms address table
has been removed from the -mm tree.  Its filename was
     kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table-v5.patch

This patch was dropped because it was folded into kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table.patch

------------------------------------------------------
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: kallsyms: add support for relative offsets in kallsyms address table

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig       |   10 +++++----
 kernel/kallsyms.c  |    8 +++++--
 scripts/kallsyms.c |   47 +++++++++++++++++--------------------------
 3 files changed, 31 insertions(+), 34 deletions(-)

diff -puN init/Kconfig~kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table-v5 init/Kconfig
--- a/init/Kconfig~kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table-v5
+++ a/init/Kconfig
@@ -1449,13 +1449,15 @@ config KALLSYMS_ABSOLUTE_PERCPU
 config KALLSYMS_BASE_RELATIVE
 	bool
 	depends on KALLSYMS
-	default !IA64
+	default !IA64 && !(TILE && 64BIT)
 	help
 	  Instead of emitting them as absolute values in the native word size,
 	  emit the symbol references in the kallsyms table as 32-bit entries,
-	  each containing either an absolute value in the range [0, S32_MAX] or
-	  a relative value in the range [base, base + S32_MAX], where base is
-	  the lowest relative symbol address encountered in the image.
+	  each containing a relative value in the range [base, base + U32_MAX]
+	  or, when KALLSYMS_ABSOLUTE_PERCPU is in effect, each containing either
+	  an absolute value in the range [0, S32_MAX] or a relative value in the
+	  range [base, base + S32_MAX], where base is the lowest relative symbol
+	  address encountered in the image.
 
 	  On 64-bit builds, this reduces the size of the address table by 50%,
 	  but more importantly, it results in entries whose values are build
diff -puN kernel/kallsyms.c~kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table-v5 kernel/kallsyms.c
--- a/kernel/kallsyms.c~kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table-v5
+++ a/kernel/kallsyms.c
@@ -185,11 +185,15 @@ static unsigned long kallsyms_sym_addres
 	if (!IS_ENABLED(CONFIG_KALLSYMS_BASE_RELATIVE))
 		return kallsyms_addresses[idx];
 
-	/* positive offsets are absolute values */
+	/* values are unsigned offsets if --absolute-percpu is not in effect */
+	if (!IS_ENABLED(CONFIG_KALLSYMS_ABSOLUTE_PERCPU))
+		return kallsyms_relative_base + (u32)kallsyms_offsets[idx];
+
+	/* ...otherwise, positive offsets are absolute values */
 	if (kallsyms_offsets[idx] >= 0)
 		return kallsyms_offsets[idx];
 
-	/* negative offsets are relative to kallsyms_relative_base - 1 */
+	/* ...and negative offsets are relative to kallsyms_relative_base - 1 */
 	return kallsyms_relative_base - 1 - kallsyms_offsets[idx];
 }
 
diff -puN scripts/kallsyms.c~kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table-v5 scripts/kallsyms.c
--- a/scripts/kallsyms.c~kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table-v5
+++ a/scripts/kallsyms.c
@@ -375,23 +375,24 @@ static void write_src(void)
 	for (i = 0; i < table_cnt; i++) {
 		if (base_relative) {
 			long long offset;
+			int overflow;
 
-			if (symbol_absolute(&table[i])) {
+			if (!absolute_percpu) {
+				offset = table[i].addr - relative_base;
+				overflow = (offset < 0 || offset > UINT_MAX);
+			} else if (symbol_absolute(&table[i])) {
 				offset = table[i].addr;
-				if (offset < 0 || offset > INT_MAX) {
-					fprintf(stderr, "kallsyms failure: "
-						"absolute symbol value %#llx out of range in relative mode\n",
-						table[i].addr);
-					exit(EXIT_FAILURE);
-				}
+				overflow = (offset < 0 || offset > INT_MAX);
 			} else {
 				offset = relative_base - table[i].addr - 1;
-				if (offset < INT_MIN || offset >= 0) {
-					fprintf(stderr, "kallsyms failure: "
-						"relative symbol value %#llx out of range in relative mode\n",
-						table[i].addr);
-					exit(EXIT_FAILURE);
-				}
+				overflow = (offset < INT_MIN || offset >= 0);
+			}
+			if (overflow) {
+				fprintf(stderr, "kallsyms failure: "
+					"%s symbol value %#llx out of range in relative mode\n",
+					symbol_absolute(&table[i]) ? "absolute" : "relative",
+					table[i].addr);
+				exit(EXIT_FAILURE);
 			}
 			printf("\t.long\t%#x\n", (int)offset);
 		} else if (!symbol_absolute(&table[i])) {
@@ -742,21 +743,11 @@ static void record_relative_base(void)
 {
 	unsigned int i;
 
-	if (kernel_start_addr > 0) {
-		/*
-		 * If the kernel start address was specified, use that as
-		 * the relative base rather than going through the table,
-		 * since it should be a reasonable default, and values below
-		 * it will be ignored anyway.
-		 */
-		relative_base = kernel_start_addr;
-	} else {
-		relative_base = -1ULL;
-		for (i = 0; i < table_cnt; i++)
-			if (!symbol_absolute(&table[i]) &&
-			    table[i].addr < relative_base)
-				relative_base = table[i].addr;
-	}
+	relative_base = -1ULL;
+	for (i = 0; i < table_cnt; i++)
+		if (!symbol_absolute(&table[i]) &&
+		    table[i].addr < relative_base)
+			relative_base = table[i].addr;
 }
 
 int main(int argc, char **argv)
_

Patches currently in -mm which might be from ard.biesheuvel@linaro.org are

x86-kallsyms-disable-absolute-percpu-symbols-on-smp.patch
kallsyms-dont-overload-absolute-symbol-type-for-percpu-symbols.patch
kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table.patch

