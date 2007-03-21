From: akpm@linux-foundation.org
Subject: - remove-unused-header-file-include-linux-elfnoteh.patch removed from -mm tree
Date: Wed, 21 Mar 2007 14:55:59 -0700
Message-ID: <200703212155.l2LLtxrI004544@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55300 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965138AbXCUV4E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 17:56:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     remove unused header file: include/linux/elfnote.h
has been removed from the -mm tree.  Its filename was
     remove-unused-header-file-include-linux-elfnoteh.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: remove unused header file: include/linux/elfnote.h
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/elfnote.h |   90 --------------------------------------
 1 file changed, 90 deletions(-)

diff -puN include/linux/elfnote.h~remove-unused-header-file-include-linux-elfnoteh /dev/null
--- a/include/linux/elfnote.h
+++ /dev/null
@@ -1,90 +0,0 @@
-#ifndef _LINUX_ELFNOTE_H
-#define _LINUX_ELFNOTE_H
-/*
- * Helper macros to generate ELF Note structures, which are put into a
- * PT_NOTE segment of the final vmlinux image.  These are useful for
- * including name-value pairs of metadata into the kernel binary (or
- * modules?) for use by external programs.
- *
- * Each note has three parts: a name, a type and a desc.  The name is
- * intended to distinguish the note's originator, so it would be a
- * company, project, subsystem, etc; it must be in a suitable form for
- * use in a section name.  The type is an integer which is used to tag
- * the data, and is considered to be within the "name" namespace (so
- * "FooCo"'s type 42 is distinct from "BarProj"'s type 42).  The
- * "desc" field is the actual data.  There are no constraints on the
- * desc field's contents, though typically they're fairly small.
- *
- * All notes from a given NAME are put into a section named
- * .note.NAME.  When the kernel image is finally linked, all the notes
- * are packed into a single .notes section, which is mapped into the
- * PT_NOTE segment.  Because notes for a given name are grouped into
- * the same section, they'll all be adjacent the output file.
- *
- * This file defines macros for both C and assembler use.  Their
- * syntax is slightly different, but they're semantically similar.
- *
- * See the ELF specification for more detail about ELF notes.
- */
-
-#ifdef __ASSEMBLER__
-/*
- * Generate a structure with the same shape as Elf{32,64}_Nhdr (which
- * turn out to be the same size and shape), followed by the name and
- * desc data with appropriate padding.  The 'desctype' argument is the
- * assembler pseudo op defining the type of the data e.g. .asciz while
- * 'descdata' is the data itself e.g.  "hello, world".
- *
- * e.g. ELFNOTE(XYZCo, 42, .asciz, "forty-two")
- *      ELFNOTE(XYZCo, 12, .long, 0xdeadbeef)
- */
-#define ELFNOTE(name, type, desctype, descdata)	\
-.pushsection .note.name			;	\
-  .align 4				;	\
-  .long 2f - 1f		/* namesz */	;	\
-  .long 4f - 3f		/* descsz */	;	\
-  .long type				;	\
-1:.asciz "name"				;	\
-2:.align 4				;	\
-3:desctype descdata			;	\
-4:.align 4				;	\
-.popsection				;
-#else	/* !__ASSEMBLER__ */
-#include <linux/elf.h>
-/*
- * Use an anonymous structure which matches the shape of
- * Elf{32,64}_Nhdr, but includes the name and desc data.  The size and
- * type of name and desc depend on the macro arguments.  "name" must
- * be a literal string, and "desc" must be passed by value.  You may
- * only define one note per line, since __LINE__ is used to generate
- * unique symbols.
- */
-#define _ELFNOTE_PASTE(a,b)	a##b
-#define _ELFNOTE(size, name, unique, type, desc)			\
-	static const struct {						\
-		struct elf##size##_note _nhdr;				\
-		unsigned char _name[sizeof(name)]			\
-		__attribute__((aligned(sizeof(Elf##size##_Word))));	\
-		typeof(desc) _desc					\
-			     __attribute__((aligned(sizeof(Elf##size##_Word)))); \
-	} _ELFNOTE_PASTE(_note_, unique)				\
-		__attribute_used__					\
-		__attribute__((section(".note." name),			\
-			       aligned(sizeof(Elf##size##_Word)),	\
-			       unused)) = {				\
-		{							\
-			sizeof(name),					\
-			sizeof(desc),					\
-			type,						\
-		},							\
-		name,							\
-		desc							\
-	}
-#define ELFNOTE(size, name, type, desc)		\
-	_ELFNOTE(size, name, __LINE__, type, desc)
-
-#define ELFNOTE32(name, type, desc) ELFNOTE(32, name, type, desc)
-#define ELFNOTE64(name, type, desc) ELFNOTE(64, name, type, desc)
-#endif	/* __ASSEMBLER__ */
-
-#endif /* _LINUX_ELFNOTE_H */
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
git-avr32.patch
git-powerpc.patch
remove-unused-header-file-arch-ppc-syslib-cpc710h.patch
remove-unused-header-file-arch-powerpc-platforms-83xx-mpc834x_itxh.patch
git-drm.patch
git-mtd.patch
jffs2-delete-everything-related-to-obsolete-jffs2_proc.patch
remove-unused-header-file-drivers-net-skfp-h-lnkstath.patch
remove-unused-header-file-drivers-net-wan-lmc-lmc_mediah.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-scsi-misc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
remove-unused-header-file-arch-m68k-atari-atasoundh.patch
remove-unused-header-file-drivers-serial-crisv10h.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
rocket-remove-modversions-include.patch
remove-unused-header-file-include-linux-elfnoteh.patch
remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
remove-unused-header-file-drivers-char-digih.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
remove-unused-header-file-drivers-video-riva-nv4refh.patch
