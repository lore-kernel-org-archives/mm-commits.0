From: akpm@linux-foundation.org
Subject: + doc-document-the-kernel-doc-conventions-for-kernel-hackers.patch added to -mm tree
Date: Fri, 30 May 2008 17:16:38 -0700
Message-ID: <200805310016.m4V0Gc9b018764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753517AbYEaARP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 20:17:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pj@sgi.com, alan@lxorguk.ukuu.org.uk, rdunlap@xenotime.net


The patch titled
     doc: document the kernel-doc conventions for kernel hackers
has been added to the -mm tree.  Its filename is
     doc-document-the-kernel-doc-conventions-for-kernel-hackers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: doc: document the kernel-doc conventions for kernel hackers
From: Paul Jackson <pj@sgi.com>

Provide documentation of the kernel-doc documentation conventions oriented
to kernel hackers.

Since I figure that there will be more people reading this
kernel-doc-nano-HOWTO.txt file who are kernel developers focused on the
rest of the kernel, than there will be readers of this file who are
documentation developers extracting that embedded kernel-doc
documentation, I have taken the liberty of making the new section added
here:

  How to format kernel-doc comments

the first section of the kernel-doc-nano-HOWTO.txt file.

This first section is intended to introduce, motivate and provide basic
usage of the kernel-doc mechanism for kernel hackers developing other
portions of the kernel.

Signed-off-by: Paul Jackson <pj@sgi.com>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-doc-nano-HOWTO.txt |   99 ++++++++++++++++++++++
 1 file changed, 99 insertions(+)

diff -puN Documentation/kernel-doc-nano-HOWTO.txt~doc-document-the-kernel-doc-conventions-for-kernel-hackers Documentation/kernel-doc-nano-HOWTO.txt
--- a/Documentation/kernel-doc-nano-HOWTO.txt~doc-document-the-kernel-doc-conventions-for-kernel-hackers
+++ a/Documentation/kernel-doc-nano-HOWTO.txt
@@ -1,6 +1,105 @@
 kernel-doc nano-HOWTO
 =====================
 
+How to format kernel-doc comments
+---------------------------------
+
+In order to provide an embedded, 'C' friendly, easy to maintain,
+but consistent and extractable documentation of the functions and
+data structures in the Linux kernel, the Linux kernel has adopted
+a consistent style for documenting functions and their parameters,
+and structures and their members.
+
+The format for this documentation is called the kernel-doc format.
+It as documented in this Documentation/kernel-doc-nano-HOWTO.txt file.
+
+This style embeds the documentation within the source files, using
+a few simple conventions.  The scripts/kernel-doc perl script, some
+SGML templates in Documentation/DocBook, and other tools understand
+these conventions, and are used to extract this embedded documentation
+into various documents.
+
+In order to provide good documentation of kernel functions and data
+structures, please use the following conventions to format your
+kernel-doc comments in Linux kernel source.
+
+We definitely need kernel-doc formatted documentation for functions
+that are exported to loadable modules using EXPORT_SYMBOL.
+
+We also look to provide kernel-doc formatted documentation for
+functions externally visible to other kernel files (not marked
+"static").
+
+We also recommend providing kernel-doc formatted documentation
+for private (file "static") routines, for consistency of kernel
+source code layout.  But this is lower priority and at the
+discretion of the MAINTAINER of that kernel source file.
+
+Data structures visible in kernel include files should also be
+documented using kernel-doc formatted comments.
+
+The opening comment mark "/**" is reserved for kernel-doc comments.
+Only comments so marked will be considered by the kernel-doc scripts,
+and any comment so marked must be in kernel-doc format.  Do not use
+"/**" to be begin a comment block unless the comment block contains
+kernel-doc formatted comments.  The closing comment marker for
+kernel-doc comments can be either "*/" or "**/".
+
+Kernel-doc comments should be placed just before the function
+or data structure being described.
+
+Example kernel-doc function comment:
+
+/**
+ * foobar() - short function description of foobar
+ * @arg1:	Describe the first argument to foobar.
+ * @arg2:	Describe the second argument to foobar.
+ *		One can provide multiple line descriptions
+ *		for arguments.
+ *
+ * A longer description, with more discussion of the function foobar()
+ * that might be useful to those using or modifying it.  Begins with
+ * empty comment line, and may include additional embedded empty
+ * comment lines.
+ *
+ * The longer description can have multiple paragraphs.
+ **/
+
+The first line, with the short description, must be on a single line.
+
+The @argument descriptions must begin on the very next line following
+this opening short function description line, with no intervening
+empty comment lines.
+
+Example kernel-doc data structure comment.
+
+/**
+ * struct blah - the basic blah structure
+ * @mem1:	describe the first member of struct blah
+ * @mem2:	describe the second member of struct blah,
+ *		perhaps with more lines and words.
+ *
+ * Longer description of this structure.
+ **/
+
+The kernel-doc function comments describe each parameter to the
+function, in order, with the @name lines.
+
+The kernel-doc data structure comments describe each structure member
+in the data structure, with the @name lines.
+
+The longer description formatting is "reflowed", losing your line
+breaks.  So presenting carefully formatted lists within these
+descriptions won't work so well; derived documentation will lose
+the formatting.
+
+See the section below "How to add extractable documentation to your
+source files" for more details and notes on how to format kernel-doc
+comments.
+
+Components of the kernel-doc system
+-----------------------------------
+
 Many places in the source tree have extractable documentation in the
 form of block comments above functions.  The components of this system
 are:
_

Patches currently in -mm which might be from pj@sgi.com are

cpusets-fix-and-update-documentation.patch
linux-next.patch
cpusets-fix-bug-when-adding-nonexistent-cpu-or-mem.patch
doc-document-the-kernel-doc-conventions-for-kernel-hackers.patch

