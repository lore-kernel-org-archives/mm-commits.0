From: akpm@linux-foundation.org
Subject: + allow-userspace-applications-to-use-markerh-to-parse-the-markers-section-in-the-kernel-binary.patch added to -mm tree
Date: Wed, 09 May 2007 20:44:31 -0700
Message-ID: <200705100344.l4A3iV47011243@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754275AbXEJDor (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 23:44:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, dsmith@redhat.com


The patch titled
     Allow userspace applications to use marker.h to parse the markers section in the kernel binary.
has been added to the -mm tree.  Its filename is
     allow-userspace-applications-to-use-markerh-to-parse-the-markers-section-in-the-kernel-binary.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Allow userspace applications to use marker.h to parse the markers section in the kernel binary.
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

One of the things I'm starting to work on is adding support for your kernel
markers to systemtap.  I know the marker stuff is still in a bit of flux
because you are trying to meet the (sometimes conflicting) requirements of
the people on lkml.

One of the things systemtap is going to need is to be able to parse the
'__markers' section so it will be able to look up a user-specified marker. 
For instance, if the user says 'probe kernel.mark("foo") {}', I've got to
see if marker "foo" really exists.

There are 2 problems with this currently, since systemtap is a user-land
program:

1) include/linux/markers.h isn't currently installed by "make
   headers_install"

2) even if include/linux/markers.h was installed, it is completely
   surrounded by "#ifdef __KERNEL__"

So, I've attached a patch that tries to fix those 2 problems.  I've moved
"#ifdef __KERNEL__" down a bit past the structure and flag definitions and
included marker.h in Kbuild so it will get installed.

Signed-off-by: David Smith <dsmith@redhat.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild   |    1 +
 include/linux/marker.h |    8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN include/linux/Kbuild~allow-userspace-applications-to-use-markerh-to-parse-the-markers-section-in-the-kernel-binary include/linux/Kbuild
--- a/include/linux/Kbuild~allow-userspace-applications-to-use-markerh-to-parse-the-markers-section-in-the-kernel-binary
+++ a/include/linux/Kbuild
@@ -253,6 +253,7 @@ unifdef-y += keyboard.h
 unifdef-y += llc.h
 unifdef-y += loop.h
 unifdef-y += lp.h
+unifdef-y += marker.h
 unifdef-y += mempolicy.h
 unifdef-y += mii.h
 unifdef-y += mman.h
diff -puN include/linux/marker.h~allow-userspace-applications-to-use-markerh-to-parse-the-markers-section-in-the-kernel-binary include/linux/marker.h
--- a/include/linux/marker.h~allow-userspace-applications-to-use-markerh-to-parse-the-markers-section-in-the-kernel-binary
+++ a/include/linux/marker.h
@@ -14,8 +14,6 @@
  * See the file COPYING for more details.
  */
 
-#ifdef __KERNEL__
-
 struct __mark_marker_data;
 
 typedef void marker_probe_func(const struct __mark_marker_data *mdata,
@@ -35,8 +33,6 @@ struct __mark_marker {
 	void *enable;
 } __attribute__((packed));
 
-#ifdef CONFIG_MARKERS
-
 /* Marker flags : selects the mechanism used to connect the probes to the
  * markers and what can be executed within the probes. This is primarily
  * used at reentrancy-unfriendly sites. */
@@ -45,6 +41,10 @@ struct __mark_marker {
 #define MF_PRINTK	(1 << 2)	/* vprintk can be called in the probe */
 #define _MF_NR		3		/* Number of marker flags */
 
+#ifdef __KERNEL__
+
+#ifdef CONFIG_MARKERS
+
 /* Generic marker flavor always available */
 #define trace_mark_generic(flags, name, format, args...) \
 	do { \
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
x86_64-fix-default_do_nmi-missing-return-after-a-if.patch
git-avr32.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-kconfig-menus-update.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-architecture-independant-code-update.patch
allow-userspace-applications-to-use-markerh-to-parse-the-markers-section-in-the-kernel-binary.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-powerpc-optimization-update.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-i386-optimization-update.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-non-optimized-architectures-update.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-update.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
