From: akpm@linux-foundation.org
Subject: + eeepc_laptop-properly-annote-eeepc_enable_camera.patch added to -mm tree
Date: Thu, 08 Oct 2009 15:57:25 -0700
Message-ID: <200910082257.n98MvPpH000619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932753AbZJHW7W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Oct 2009 18:59:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com, corentincj@iksaif.net, lenb@kernel.org


The patch titled
     eeepc_laptop: properly annote eeepc_enable_camera()
has been added to the -mm tree.  Its filename is
     eeepc_laptop-properly-annote-eeepc_enable_camera.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eeepc_laptop: properly annote eeepc_enable_camera()
From: Rakib Mullick <rakib.mullick@gmail.com>

Currently the annotation for function eeepc_enable_camera() is __init, and
refers to a function eeepc_hotk_add() which is non-init.  Use __devinit
for both functions which is more appropriate and fixes a section mismatch
warning.

We were warned by the following warning:

  LD      drivers/platform/x86/built-in.o
WARNING: drivers/platform/x86/built-in.o(.text+0x12e1): Section
mismatch in reference from the function eeepc_hotk_add() to the
function .init.text:eeepc_enable_camera()
The function eeepc_hotk_add() references
the function __init eeepc_enable_camera().
This is often because eeepc_hotk_add lacks a __init
annotation or the annotation of eeepc_enable_camera is wrong.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Corentin Chary <corentincj@iksaif.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/platform/x86/eeepc-laptop.c~eeepc_laptop-properly-annote-eeepc_enable_camera drivers/platform/x86/eeepc-laptop.c
--- a/drivers/platform/x86/eeepc-laptop.c~eeepc_laptop-properly-annote-eeepc_enable_camera
+++ a/drivers/platform/x86/eeepc-laptop.c
@@ -350,7 +350,7 @@ static const struct rfkill_ops eeepc_rfk
 	.set_block = eeepc_rfkill_set,
 };
 
-static void __init eeepc_enable_camera(void)
+static void __devinit eeepc_enable_camera(void)
 {
 	/*
 	 * If the following call to set_acpi() fails, it's because there's no
@@ -1189,7 +1189,7 @@ static int eeepc_input_init(struct devic
 	return 0;
 }
 
-static int eeepc_hotk_add(struct acpi_device *device)
+static int __devinit eeepc_hotk_add(struct acpi_device *device)
 {
 	struct device *dev;
 	int result;
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

linux-next.patch
acpi-annote-acpi_processor_add-with-__cpuinit.patch
eeepc_laptop-properly-annote-eeepc_enable_camera.patch

