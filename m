From: akpm@osdl.org
Subject: + discuss-a-couple-common-errors-in-kernel-doc-usage.patch added to -mm tree
Date: Mon, 08 Jan 2007 15:39:34 -0800
Message-ID: <200701082339.l08NdY8k022860@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54540 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbXAHXkM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 18:40:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, randy.dunlap@oracle.com


The patch titled
     Discuss a couple common errors in kernel-doc usage.
has been added to the -mm tree.  Its filename is
     discuss-a-couple-common-errors-in-kernel-doc-usage.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Discuss a couple common errors in kernel-doc usage.
From: "Robert P. J. Day" <rpjday@mindspring.com>

Explain a couple of the most common errors in kernel-doc usage.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/kernel-doc-nano-HOWTO.txt |   37 +++++++++++++++++++---
 1 files changed, 33 insertions(+), 4 deletions(-)

diff -puN Documentation/kernel-doc-nano-HOWTO.txt~discuss-a-couple-common-errors-in-kernel-doc-usage Documentation/kernel-doc-nano-HOWTO.txt
--- a/Documentation/kernel-doc-nano-HOWTO.txt~discuss-a-couple-common-errors-in-kernel-doc-usage
+++ a/Documentation/kernel-doc-nano-HOWTO.txt
@@ -107,10 +107,14 @@ The format of the block comment is like 
  * (section header: (section description)? )*
 (*)?*/
 
-The short function description cannot be multiline, but the other
-descriptions can be (and they can contain blank lines). Avoid putting a
-spurious blank line after the function name, or else the description will
-be repeated!
+The short function description ***cannot be multiline***, but the other
+descriptions can be (and they can contain blank lines).  If you continue
+that initial short description onto a second line, that second line will
+appear further down at the beginning of the description section, which is
+almost certainly not what you had in mind.
+
+Avoid putting a spurious blank line after the function name, or else the
+description will be repeated!
 
 All descriptive text is further processed, scanning for the following special
 patterns, which are highlighted appropriately.
@@ -121,6 +125,31 @@ patterns, which are highlighted appropri
 '@parameter' - name of a parameter
 '%CONST' - name of a constant.
 
+NOTE 1:  The multi-line descriptive text you provide does *not* recognize
+line breaks, so if you try to format some text nicely, as in:
+
+  Return codes
+    0 - cool
+    1 - invalid arg
+    2 - out of memory
+
+this will all run together and produce:
+
+  Return codes 0 - cool 1 - invalid arg 2 - out of memory
+
+NOTE 2:  If the descriptive text you provide has lines that begin with
+some phrase followed by a colon, each of those phrases will be taken as
+a new section heading, which means you should similarly try to avoid text
+like:
+
+  Return codes:
+    0: cool
+    1: invalid arg
+    2: out of memory
+
+every line of which would start a new section.  Again, probably not
+what you were after.
+
 Take a look around the source tree for examples.
 
 
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
get-rid-of-double-zeroing-of-allocated-pages.patch
remove-unnecessary-memset0-calls-after-kzalloc-calls.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
