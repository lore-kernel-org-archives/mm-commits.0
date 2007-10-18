From: akpm@linux-foundation.org
Subject: - fix-make-htmldocs-build-break.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:05:03 -0700
Message-ID: <200710180705.l9I753W5031618@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51437 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758860AbXJRHSp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:18:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@landley.net, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Fix "make htmldocs" build break.
has been removed from the -mm tree.  Its filename was
     fix-make-htmldocs-build-break.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix "make htmldocs" build break.
From: Rob Landley <rob@landley.net>

Fix two htmldocs build breaks, introduced by moving include/linux/usb_gadget.h to
include/linux/usb/gadget.h and combining resume.c and suspend.c into main.c in
drivers/base/power.

Signed-off-by: Rob Landley <rob@landley.net>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/gadget.tmpl     |    6 +++---
 Documentation/DocBook/kernel-api.tmpl |    3 +--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff -puN Documentation/DocBook/gadget.tmpl~fix-make-htmldocs-build-break Documentation/DocBook/gadget.tmpl
--- a/Documentation/DocBook/gadget.tmpl~fix-make-htmldocs-build-break
+++ a/Documentation/DocBook/gadget.tmpl
@@ -144,7 +144,7 @@ with the lowest level (which directly ha
 	<para>This is the lowest software level.
 	It is the only layer that talks to hardware,
 	through registers, fifos, dma, irqs, and the like.
-	The <filename>&lt;linux/usb_gadget.h&gt;</filename> API abstracts
+	The <filename>&lt;linux/usb/gadget.h&gt;</filename> API abstracts
 	the peripheral controller endpoint hardware.
 	That hardware is exposed through endpoint objects, which accept
 	streams of IN/OUT buffers, and through callbacks that interact
@@ -494,7 +494,7 @@ side drivers (and usbcore).
 <sect1 id="core"><title>Core Objects and Methods</title>
 
 <para>These are declared in
-<filename>&lt;linux/usb_gadget.h&gt;</filename>,
+<filename>&lt;linux/usb/gadget.h&gt;</filename>,
 and are used by gadget drivers to interact with
 USB peripheral controller drivers.
 </para>
@@ -509,7 +509,7 @@ USB peripheral controller drivers.
 	     unless the explanations are trivial.
 	  -->
 
-!Iinclude/linux/usb_gadget.h
+!Iinclude/linux/usb/gadget.h
 </sect1>
 
 <sect1 id="utils"><title>Optional Utilities</title>
diff -puN Documentation/DocBook/kernel-api.tmpl~fix-make-htmldocs-build-break Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~fix-make-htmldocs-build-break
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -386,8 +386,7 @@ X!Edrivers/base/interface.c
 !Edrivers/base/bus.c
      </sect1>
      <sect1><title>Device Drivers Power Management</title>
-!Edrivers/base/power/resume.c
-!Edrivers/base/power/suspend.c
+!Edrivers/base/power/main.c
      </sect1>
      <sect1><title>Device Drivers ACPI Support</title>
 <!-- Internal functions only
_

Patches currently in -mm which might be from rob@landley.net are

origin.patch
comment-typo-in-scripts-kconfig-makefile.patch
