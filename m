From: akpm@linux-foundation.org
Subject: + fs-binfmts-add-a-name-field-to-the-binfmt-struct.patch added to -mm tree
Date: Tue, 30 Jul 2013 14:06:37 -0700
Message-ID: <51f82add.R0TYHgbXVvXh6jwO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab3G3VGi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jul 2013 17:06:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zach@zachsthings.com, viro@zeniv.linux.org.uk, zml@linux.vnet.ibm.com

Subject: + fs-binfmts-add-a-name-field-to-the-binfmt-struct.patch added to -mm tree
To: zml@linux.vnet.ibm.com,viro@zeniv.linux.org.uk,zach@zachsthings.com
From: akpm@linux-foundation.org
Date: Tue, 30 Jul 2013 14:06:37 -0700


The patch titled
     Subject: fs/binfmts: add a name field to the binfmt struct
has been added to the -mm tree.  Its filename is
     fs-binfmts-add-a-name-field-to-the-binfmt-struct.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-binfmts-add-a-name-field-to-the-binfmt-struct.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-binfmts-add-a-name-field-to-the-binfmt-struct.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zach Levis <zml@linux.vnet.ibm.com>
Subject: fs/binfmts: add a name field to the binfmt struct

Adding the name field helps when printing error messages referring to
specific binfmts.

Signed-off-by: Zach Levis <zach@zachsthings.com>
Signed-off-by: Zach Levis <zml@linux.vnet.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_aout.c        |    1 +
 fs/binfmt_elf.c         |    1 +
 fs/binfmt_elf_fdpic.c   |    1 +
 fs/binfmt_em86.c        |    1 +
 fs/binfmt_flat.c        |    1 +
 fs/binfmt_misc.c        |    1 +
 fs/binfmt_script.c      |    1 +
 fs/binfmt_som.c         |    1 +
 include/linux/binfmts.h |    1 +
 9 files changed, 9 insertions(+)

diff -puN fs/binfmt_aout.c~fs-binfmts-add-a-name-field-to-the-binfmt-struct fs/binfmt_aout.c
--- a/fs/binfmt_aout.c~fs-binfmts-add-a-name-field-to-the-binfmt-struct
+++ a/fs/binfmt_aout.c
@@ -115,6 +115,7 @@ end_coredump:
 #endif
 
 static struct linux_binfmt aout_format = {
+	.name		= "a.out",
 	.module		= THIS_MODULE,
 	.load_binary	= load_aout_binary,
 	.load_shlib	= load_aout_library,
diff -puN fs/binfmt_elf.c~fs-binfmts-add-a-name-field-to-the-binfmt-struct fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~fs-binfmts-add-a-name-field-to-the-binfmt-struct
+++ a/fs/binfmt_elf.c
@@ -75,6 +75,7 @@ static int elf_core_dump(struct coredump
 #define ELF_PAGEALIGN(_v) (((_v) + ELF_MIN_ALIGN - 1) & ~(ELF_MIN_ALIGN - 1))
 
 static struct linux_binfmt elf_format = {
+	.name		= "elf",
 	.module		= THIS_MODULE,
 	.load_binary	= load_elf_binary,
 	.load_shlib	= load_elf_library,
diff -puN fs/binfmt_elf_fdpic.c~fs-binfmts-add-a-name-field-to-the-binfmt-struct fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~fs-binfmts-add-a-name-field-to-the-binfmt-struct
+++ a/fs/binfmt_elf_fdpic.c
@@ -81,6 +81,7 @@ static int elf_fdpic_core_dump(struct co
 #endif
 
 static struct linux_binfmt elf_fdpic_format = {
+	.name		= "FDPIC ELF",
 	.module		= THIS_MODULE,
 	.load_binary	= load_elf_fdpic_binary,
 #ifdef CONFIG_ELF_CORE
diff -puN fs/binfmt_em86.c~fs-binfmts-add-a-name-field-to-the-binfmt-struct fs/binfmt_em86.c
--- a/fs/binfmt_em86.c~fs-binfmts-add-a-name-field-to-the-binfmt-struct
+++ a/fs/binfmt_em86.c
@@ -93,6 +93,7 @@ static int load_em86(struct linux_binprm
 }
 
 static struct linux_binfmt em86_format = {
+	.name		= "em86",
 	.module		= THIS_MODULE,
 	.load_binary	= load_em86,
 };
diff -puN fs/binfmt_flat.c~fs-binfmts-add-a-name-field-to-the-binfmt-struct fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~fs-binfmts-add-a-name-field-to-the-binfmt-struct
+++ a/fs/binfmt_flat.c
@@ -92,6 +92,7 @@ static int load_flat_binary(struct linux
 static int flat_core_dump(struct coredump_params *cprm);
 
 static struct linux_binfmt flat_format = {
+	.name		= "flat",
 	.module		= THIS_MODULE,
 	.load_binary	= load_flat_binary,
 	.core_dump	= flat_core_dump,
diff -puN fs/binfmt_misc.c~fs-binfmts-add-a-name-field-to-the-binfmt-struct fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~fs-binfmts-add-a-name-field-to-the-binfmt-struct
+++ a/fs/binfmt_misc.c
@@ -694,6 +694,7 @@ static struct dentry *bm_mount(struct fi
 }
 
 static struct linux_binfmt misc_format = {
+	.name	= "misc",
 	.module = THIS_MODULE,
 	.load_binary = load_misc_binary,
 };
diff -puN fs/binfmt_script.c~fs-binfmts-add-a-name-field-to-the-binfmt-struct fs/binfmt_script.c
--- a/fs/binfmt_script.c~fs-binfmts-add-a-name-field-to-the-binfmt-struct
+++ a/fs/binfmt_script.c
@@ -99,6 +99,7 @@ static int load_script(struct linux_binp
 }
 
 static struct linux_binfmt script_format = {
+	.name		= "script",
 	.module		= THIS_MODULE,
 	.load_binary	= load_script,
 };
diff -puN fs/binfmt_som.c~fs-binfmts-add-a-name-field-to-the-binfmt-struct fs/binfmt_som.c
--- a/fs/binfmt_som.c~fs-binfmts-add-a-name-field-to-the-binfmt-struct
+++ a/fs/binfmt_som.c
@@ -53,6 +53,7 @@ static int som_core_dump(struct coredump
 #define SOM_PAGEALIGN(_v) (((_v) + SOM_PAGESIZE - 1) & ~(SOM_PAGESIZE - 1))
 
 static struct linux_binfmt som_format = {
+	.name		= "SOM",
 	.module		= THIS_MODULE,
 	.load_binary	= load_som_binary,
 	.load_shlib	= load_som_library,
diff -puN include/linux/binfmts.h~fs-binfmts-add-a-name-field-to-the-binfmt-struct include/linux/binfmts.h
--- a/include/linux/binfmts.h~fs-binfmts-add-a-name-field-to-the-binfmt-struct
+++ a/include/linux/binfmts.h
@@ -70,6 +70,7 @@ struct coredump_params {
 struct linux_binfmt {
 	struct list_head lh;
 	struct module *module;
+	const char *name;
 	int (*load_binary)(struct linux_binprm *);
 	int (*load_shlib)(struct file *);
 	int (*core_dump)(struct coredump_params *cprm);
_

Patches currently in -mm which might be from zml@linux.vnet.ibm.com are

fs-binfmts-add-a-name-field-to-the-binfmt-struct.patch
fs-binfmts-better-handling-of-binfmt-loops.patch
fs-binfmts-whitespace-fixes-with-scripts-cleanfile.patch

