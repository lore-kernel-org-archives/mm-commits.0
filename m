From: akpm@linux-foundation.org
Subject: + scatterlisth-needs-typesh.patch added to -mm tree
Date: Thu, 01 Mar 2007 16:10:20 -0800
Message-ID: <200703020010.l220AKxD027046@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57250 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161296AbXCBALV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 19:11:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org


The patch titled
     scatterlist.h needs types.h
has been added to the -mm tree.  Its filename is
     scatterlisth-needs-typesh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: scatterlist.h needs types.h
From: Jean Delvare <khali@linux-fr.org>

Most architectures' scatterlist.h use the type dma_addr_t, but omit to
include <asm/types.h> which defines it.  This could lead to build failures,
so let's add the missing includes.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/scatterlist.h     |    1 +
 include/asm-avr32/scatterlist.h     |    2 ++
 include/asm-frv/scatterlist.h       |    2 ++
 include/asm-h8300/scatterlist.h     |    2 ++
 include/asm-i386/scatterlist.h      |    2 ++
 include/asm-ia64/scatterlist.h      |    2 ++
 include/asm-m32r/scatterlist.h      |    2 ++
 include/asm-m68knommu/scatterlist.h |    1 +
 include/asm-mips/scatterlist.h      |    2 ++
 include/asm-parisc/scatterlist.h    |    1 +
 include/asm-sh/scatterlist.h        |    2 ++
 include/asm-sh64/scatterlist.h      |    2 ++
 include/asm-sparc64/scatterlist.h   |    1 +
 include/asm-v850/scatterlist.h      |    2 ++
 include/asm-x86_64/scatterlist.h    |    2 ++
 include/asm-xtensa/scatterlist.h    |    2 ++
 16 files changed, 28 insertions(+)

diff -puN include/asm-alpha/scatterlist.h~scatterlisth-needs-typesh include/asm-alpha/scatterlist.h
--- a/include/asm-alpha/scatterlist.h~scatterlisth-needs-typesh
+++ a/include/asm-alpha/scatterlist.h
@@ -2,6 +2,7 @@
 #define _ALPHA_SCATTERLIST_H
 
 #include <asm/page.h>
+#include <asm/types.h>
   
 struct scatterlist {
 	struct page *page;
diff -puN include/asm-avr32/scatterlist.h~scatterlisth-needs-typesh include/asm-avr32/scatterlist.h
--- a/include/asm-avr32/scatterlist.h~scatterlisth-needs-typesh
+++ a/include/asm-avr32/scatterlist.h
@@ -1,6 +1,8 @@
 #ifndef __ASM_AVR32_SCATTERLIST_H
 #define __ASM_AVR32_SCATTERLIST_H
 
+#include <asm/types.h>
+
 struct scatterlist {
     struct page		*page;
     unsigned int	offset;
diff -puN include/asm-frv/scatterlist.h~scatterlisth-needs-typesh include/asm-frv/scatterlist.h
--- a/include/asm-frv/scatterlist.h~scatterlisth-needs-typesh
+++ a/include/asm-frv/scatterlist.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_SCATTERLIST_H
 #define _ASM_SCATTERLIST_H
 
+#include <asm/types.h>
+
 /*
  * Drivers must set either ->address or (preferred) ->page and ->offset
  * to indicate where data must be transferred to/from.
diff -puN include/asm-h8300/scatterlist.h~scatterlisth-needs-typesh include/asm-h8300/scatterlist.h
--- a/include/asm-h8300/scatterlist.h~scatterlisth-needs-typesh
+++ a/include/asm-h8300/scatterlist.h
@@ -1,6 +1,8 @@
 #ifndef _H8300_SCATTERLIST_H
 #define _H8300_SCATTERLIST_H
 
+#include <asm/types.h>
+
 struct scatterlist {
 	struct page	*page;
 	unsigned int	offset;
diff -puN include/asm-i386/scatterlist.h~scatterlisth-needs-typesh include/asm-i386/scatterlist.h
--- a/include/asm-i386/scatterlist.h~scatterlisth-needs-typesh
+++ a/include/asm-i386/scatterlist.h
@@ -1,6 +1,8 @@
 #ifndef _I386_SCATTERLIST_H
 #define _I386_SCATTERLIST_H
 
+#include <asm/types.h>
+
 struct scatterlist {
     struct page		*page;
     unsigned int	offset;
diff -puN include/asm-ia64/scatterlist.h~scatterlisth-needs-typesh include/asm-ia64/scatterlist.h
--- a/include/asm-ia64/scatterlist.h~scatterlisth-needs-typesh
+++ a/include/asm-ia64/scatterlist.h
@@ -6,6 +6,8 @@
  *	David Mosberger-Tang <davidm@hpl.hp.com>, Hewlett-Packard Co
  */
 
+#include <asm/types.h>
+
 struct scatterlist {
 	struct page *page;
 	unsigned int offset;
diff -puN include/asm-m32r/scatterlist.h~scatterlisth-needs-typesh include/asm-m32r/scatterlist.h
--- a/include/asm-m32r/scatterlist.h~scatterlisth-needs-typesh
+++ a/include/asm-m32r/scatterlist.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_M32R_SCATTERLIST_H
 #define _ASM_M32R_SCATTERLIST_H
 
+#include <asm/types.h>
+
 struct scatterlist {
     char *  address;    /* Location data is to be transferred to, NULL for
                          * highmem page */
diff -puN include/asm-m68knommu/scatterlist.h~scatterlisth-needs-typesh include/asm-m68knommu/scatterlist.h
--- a/include/asm-m68knommu/scatterlist.h~scatterlisth-needs-typesh
+++ a/include/asm-m68knommu/scatterlist.h
@@ -2,6 +2,7 @@
 #define _M68KNOMMU_SCATTERLIST_H
 
 #include <linux/mm.h>
+#include <asm/types.h>
 
 struct scatterlist {
 	struct page	*page;
diff -puN include/asm-mips/scatterlist.h~scatterlisth-needs-typesh include/asm-mips/scatterlist.h
--- a/include/asm-mips/scatterlist.h~scatterlisth-needs-typesh
+++ a/include/asm-mips/scatterlist.h
@@ -1,6 +1,8 @@
 #ifndef __ASM_SCATTERLIST_H
 #define __ASM_SCATTERLIST_H
 
+#include <asm/types.h>
+
 struct scatterlist {
 	struct page *	page;
 	unsigned int	offset;
diff -puN include/asm-parisc/scatterlist.h~scatterlisth-needs-typesh include/asm-parisc/scatterlist.h
--- a/include/asm-parisc/scatterlist.h~scatterlisth-needs-typesh
+++ a/include/asm-parisc/scatterlist.h
@@ -2,6 +2,7 @@
 #define _ASM_PARISC_SCATTERLIST_H
 
 #include <asm/page.h>
+#include <asm/types.h>
 
 struct scatterlist {
 	struct page *page;
diff -puN include/asm-sh/scatterlist.h~scatterlisth-needs-typesh include/asm-sh/scatterlist.h
--- a/include/asm-sh/scatterlist.h~scatterlisth-needs-typesh
+++ a/include/asm-sh/scatterlist.h
@@ -1,6 +1,8 @@
 #ifndef __ASM_SH_SCATTERLIST_H
 #define __ASM_SH_SCATTERLIST_H
 
+#include <asm/types.h>
+
 struct scatterlist {
     struct page * page; /* Location for highmem page, if any */
     unsigned int offset;/* for highmem, page offset */
diff -puN include/asm-sh64/scatterlist.h~scatterlisth-needs-typesh include/asm-sh64/scatterlist.h
--- a/include/asm-sh64/scatterlist.h~scatterlisth-needs-typesh
+++ a/include/asm-sh64/scatterlist.h
@@ -11,6 +11,8 @@
 #ifndef __ASM_SH64_SCATTERLIST_H
 #define __ASM_SH64_SCATTERLIST_H
 
+#include <asm/types.h>
+
 struct scatterlist {
     struct page * page; /* Location for highmem page, if any */
     unsigned int offset;/* for highmem, page offset */
diff -puN include/asm-sparc64/scatterlist.h~scatterlisth-needs-typesh include/asm-sparc64/scatterlist.h
--- a/include/asm-sparc64/scatterlist.h~scatterlisth-needs-typesh
+++ a/include/asm-sparc64/scatterlist.h
@@ -3,6 +3,7 @@
 #define _SPARC64_SCATTERLIST_H
 
 #include <asm/page.h>
+#include <asm/types.h>
 
 struct scatterlist {
 	struct page	*page;
diff -puN include/asm-v850/scatterlist.h~scatterlisth-needs-typesh include/asm-v850/scatterlist.h
--- a/include/asm-v850/scatterlist.h~scatterlisth-needs-typesh
+++ a/include/asm-v850/scatterlist.h
@@ -14,6 +14,8 @@
 #ifndef __V850_SCATTERLIST_H__
 #define __V850_SCATTERLIST_H__
 
+#include <asm/types.h>
+
 struct scatterlist {
 	struct page	*page;
 	unsigned	offset;
diff -puN include/asm-x86_64/scatterlist.h~scatterlisth-needs-typesh include/asm-x86_64/scatterlist.h
--- a/include/asm-x86_64/scatterlist.h~scatterlisth-needs-typesh
+++ a/include/asm-x86_64/scatterlist.h
@@ -1,6 +1,8 @@
 #ifndef _X8664_SCATTERLIST_H
 #define _X8664_SCATTERLIST_H
 
+#include <asm/types.h>
+
 struct scatterlist {
     struct page		*page;
     unsigned int	offset;
diff -puN include/asm-xtensa/scatterlist.h~scatterlisth-needs-typesh include/asm-xtensa/scatterlist.h
--- a/include/asm-xtensa/scatterlist.h~scatterlisth-needs-typesh
+++ a/include/asm-xtensa/scatterlist.h
@@ -11,6 +11,8 @@
 #ifndef _XTENSA_SCATTERLIST_H
 #define _XTENSA_SCATTERLIST_H
 
+#include <asm/types.h>
+
 struct scatterlist {
 	struct page 	*page;
 	unsigned int	offset;
_

Patches currently in -mm which might be from khali@linux-fr.org are

io_apic-needs-apicdefh.patch
parport-is-an-orphan.patch
git-dvb.patch
scatterlisth-needs-typesh.patch
