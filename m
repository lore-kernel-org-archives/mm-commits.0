From: akpm@linux-foundation.org
Subject: + linux-kernel-markers-documentation-update-markerh.patch added to -mm tree
Date: Fri, 16 Feb 2007 13:55:58 -0800
Message-ID: <200702162156.l1GLtwGN010863@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37883 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946146AbXBPV4K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 16:56:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: compudj@krystal.dyndns.org, mathieu.desnoyers@polymtl.ca


The patch titled
     Linux Kernel Markers: Documentation update (marker.h)
has been added to the -mm tree.  Its filename is
     linux-kernel-markers-documentation-update-markerh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Linux Kernel Markers: Documentation update (marker.h)
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>

Add information about including marker.h in the documentation.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/marker.txt |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff -puN Documentation/marker.txt~linux-kernel-markers-documentation-update-markerh Documentation/marker.txt
--- a/Documentation/marker.txt~linux-kernel-markers-documentation-update-markerh
+++ a/Documentation/marker.txt
@@ -34,6 +34,12 @@ variable by address that would be later 
 
 * Usage
 
+In order to use the macro MARK, you should include linux/marker.h.
+
+#include <linux/marker.h>
+
+Add, in your code :
+
 MARK(subsystem_event, "%d %s %p[struct task_struct]",
   someint, somestring, current);
 Where :
@@ -49,9 +55,6 @@ The expression %p[struct task_struct] is
 standard that could eventually be used for pointer type checking in
 sparse. The brackets contain the type to which the pointer refers.
 
-In order to use the macro MARK, you should include linux/marker.h or
-linux/kernel.h (which also includes linux/marker.h).
-
 Connecting a function (probe) to a marker is done by providing a probe
 (function to call) for the specific marker through marker_set_probe(). It will
 automatically connect the function and enable the marker site. Removing a probe
@@ -91,6 +94,7 @@ optimization can be disabled through men
 
 #include <linux/sched.h>
 #include <linux/kernel.h>
+#include <linux/marker.h>
 
 #define SUBSYSTEM_EVENT_FORMAT "%d %s %p[struct task_struct]"
 void probe_subsystem_event(const char *format, ...)
_

Patches currently in -mm which might be from compudj@krystal.dyndns.org are

origin.patch
atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch
linux-kernel-markers-documentation-update-markerh.patch
