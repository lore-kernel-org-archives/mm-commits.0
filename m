From: akpm@linux-foundation.org
Subject: [merged] bin2c-move-bin2c-in-scripts-basic.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:43:41 -0700
Message-ID: <53ea6e6d.q+g1Sxr9J14HazU8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:54612 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbaHLTnm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:42 -0400
Received: by mail-yh0-f74.google.com with SMTP id 29so1309080yhl.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:43:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, bhe@redhat.com, bp@suse.de, chaowang@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, greg@kroah.com, hpa@zytor.com, luto@amacapital.net, mjg59@srcf.ucam.org, mtk.manpages@gmail.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: bin2c: move bin2c in scripts/basic
has been removed from the -mm tree.  Its filename was
     bin2c-move-bin2c-in-scripts-basic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vivek Goyal <vgoyal@redhat.com>
Subject: bin2c: move bin2c in scripts/basic

This patch series does not do kernel signature verification yet.  I plan
to post another patch series for that.  Now distributions are already
signing PE/COFF bzImage with PKCS7 signature I plan to parse and verify
those signatures.

Primary goal of this patchset is to prepare groundwork so that kernel
image can be signed and signatures be verified during kexec load.  This
should help with two things.

- It should allow kexec/kdump on secureboot enabled machines.

- In general it can help even without secureboot. By being able to verify
  kernel image signature in kexec, it should help with avoiding module
  signing restrictions. Matthew Garret showed how to boot into a custom
  kernel, modify first kernel's memory and then jump back to old kernel and
  bypass any policy one wants to.



This patch (of 15):

Kexec wants to use bin2c and it wants to use it really early in the build
process. See arch/x86/purgatory/ code in later patches.

So move bin2c in scripts/basic so that it can be built very early and
be usable by arch/x86/purgatory/

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: WANG Chao <chaowang@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Makefile          |    2 +-
 scripts/.gitignore       |    1 -
 scripts/Makefile         |    1 -
 scripts/basic/.gitignore |    1 +
 scripts/basic/Makefile   |    1 +
 scripts/basic/bin2c.c    |   35 +++++++++++++++++++++++++++++++++++
 scripts/bin2c.c          |   36 ------------------------------------
 7 files changed, 38 insertions(+), 39 deletions(-)

diff -puN kernel/Makefile~bin2c-move-bin2c-in-scripts-basic kernel/Makefile
--- a/kernel/Makefile~bin2c-move-bin2c-in-scripts-basic
+++ a/kernel/Makefile
@@ -105,7 +105,7 @@ targets += config_data.gz
 $(obj)/config_data.gz: $(KCONFIG_CONFIG) FORCE
 	$(call if_changed,gzip)
 
-      filechk_ikconfiggz = (echo "static const char kernel_config_data[] __used = MAGIC_START"; cat $< | scripts/bin2c; echo "MAGIC_END;")
+      filechk_ikconfiggz = (echo "static const char kernel_config_data[] __used = MAGIC_START"; cat $< | scripts/basic/bin2c; echo "MAGIC_END;")
 targets += config_data.h
 $(obj)/config_data.h: $(obj)/config_data.gz FORCE
 	$(call filechk,ikconfiggz)
diff -puN scripts/.gitignore~bin2c-move-bin2c-in-scripts-basic scripts/.gitignore
--- a/scripts/.gitignore~bin2c-move-bin2c-in-scripts-basic
+++ a/scripts/.gitignore
@@ -4,7 +4,6 @@
 conmakehash
 kallsyms
 pnmtologo
-bin2c
 unifdef
 ihex2fw
 recordmcount
diff -puN scripts/Makefile~bin2c-move-bin2c-in-scripts-basic scripts/Makefile
--- a/scripts/Makefile~bin2c-move-bin2c-in-scripts-basic
+++ a/scripts/Makefile
@@ -13,7 +13,6 @@ HOST_EXTRACFLAGS += -I$(srctree)/tools/i
 hostprogs-$(CONFIG_KALLSYMS)     += kallsyms
 hostprogs-$(CONFIG_LOGO)         += pnmtologo
 hostprogs-$(CONFIG_VT)           += conmakehash
-hostprogs-$(CONFIG_IKCONFIG)     += bin2c
 hostprogs-$(BUILD_C_RECORDMCOUNT) += recordmcount
 hostprogs-$(CONFIG_BUILDTIME_EXTABLE_SORT) += sortextable
 hostprogs-$(CONFIG_ASN1)	 += asn1_compiler
diff -puN scripts/basic/.gitignore~bin2c-move-bin2c-in-scripts-basic scripts/basic/.gitignore
--- a/scripts/basic/.gitignore~bin2c-move-bin2c-in-scripts-basic
+++ a/scripts/basic/.gitignore
@@ -1 +1,2 @@
 fixdep
+bin2c
diff -puN scripts/basic/Makefile~bin2c-move-bin2c-in-scripts-basic scripts/basic/Makefile
--- a/scripts/basic/Makefile~bin2c-move-bin2c-in-scripts-basic
+++ a/scripts/basic/Makefile
@@ -9,6 +9,7 @@
 # fixdep: 	 Used to generate dependency information during build process
 
 hostprogs-y	:= fixdep
+hostprogs-$(CONFIG_IKCONFIG)     += bin2c
 always		:= $(hostprogs-y)
 
 # fixdep is needed to compile other host programs
diff -puN /dev/null scripts/basic/bin2c.c
--- /dev/null
+++ a/scripts/basic/bin2c.c
@@ -0,0 +1,35 @@
+/*
+ * Unloved program to convert a binary on stdin to a C include on stdout
+ *
+ * Jan 1999 Matt Mackall <mpm@selenic.com>
+ *
+ * This software may be used and distributed according to the terms
+ * of the GNU General Public License, incorporated herein by reference.
+ */
+
+#include <stdio.h>
+
+int main(int argc, char *argv[])
+{
+	int ch, total = 0;
+
+	if (argc > 1)
+		printf("const char %s[] %s=\n",
+			argv[1], argc > 2 ? argv[2] : "");
+
+	do {
+		printf("\t\"");
+		while ((ch = getchar()) != EOF) {
+			total++;
+			printf("\\x%02x", ch);
+			if (total % 16 == 0)
+				break;
+		}
+		printf("\"\n");
+	} while (ch != EOF);
+
+	if (argc > 1)
+		printf("\t;\n\nconst int %s_size = %d;\n", argv[1], total);
+
+	return 0;
+}
diff -puN scripts/bin2c.c~bin2c-move-bin2c-in-scripts-basic /dev/null
--- a/scripts/bin2c.c
+++ /dev/null
@@ -1,36 +0,0 @@
-/*
- * Unloved program to convert a binary on stdin to a C include on stdout
- *
- * Jan 1999 Matt Mackall <mpm@selenic.com>
- *
- * This software may be used and distributed according to the terms
- * of the GNU General Public License, incorporated herein by reference.
- */
-
-#include <stdio.h>
-
-int main(int argc, char *argv[])
-{
-	int ch, total=0;
-
-	if (argc > 1)
-		printf("const char %s[] %s=\n",
-			argv[1], argc > 2 ? argv[2] : "");
-
-	do {
-		printf("\t\"");
-		while ((ch = getchar()) != EOF)
-		{
-			total++;
-			printf("\\x%02x",ch);
-			if (total % 16 == 0)
-				break;
-		}
-		printf("\"\n");
-	} while (ch != EOF);
-
-	if (argc > 1)
-		printf("\t;\n\nconst int %s_size = %d;\n", argv[1], total);
