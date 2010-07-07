From: akpm@linux-foundation.org
Subject: + fujitsu-laptop-remove-unnecessary-input_free_device-calls.patch added to -mm tree
Date: Wed, 07 Jul 2010 14:40:36 -0700
Message-ID: <201007072140.o67LeaIE028155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757881Ab0GGVlD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jul 2010 17:41:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, dtor@mail.ru, jwoithe@physics.adelaide.edu.au, mjg@redhat.com


The patch titled
     fujitsu-laptop: remove unnecessary input_free_device calls
has been added to the -mm tree.  Its filename is
     fujitsu-laptop-remove-unnecessary-input_free_device-calls.patch

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
Subject: fujitsu-laptop: remove unnecessary input_free_device calls
From: Axel Lin <axel.lin@gmail.com>

input_free_device() should only be used if input_register_device() was not
called yet or if it failed.  This patch removes unnecessary
input_free_device calls.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Matthew Garrett <mjg@redhat.com>a
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/fujitsu-laptop.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/platform/x86/fujitsu-laptop.c~fujitsu-laptop-remove-unnecessary-input_free_device-calls drivers/platform/x86/fujitsu-laptop.c
--- a/drivers/platform/x86/fujitsu-laptop.c~fujitsu-laptop-remove-unnecessary-input_free_device-calls
+++ a/drivers/platform/x86/fujitsu-laptop.c
@@ -725,6 +725,7 @@ static int acpi_fujitsu_add(struct acpi_
 
 err_unregister_input_dev:
 	input_unregister_device(input);
+	input = NULL;
 err_free_input_dev:
 	input_free_device(input);
 err_stop:
@@ -738,8 +739,6 @@ static int acpi_fujitsu_remove(struct ac
 
 	input_unregister_device(input);
 
-	input_free_device(input);
-
 	fujitsu->acpi_handle = NULL;
 
 	return 0;
@@ -930,6 +929,7 @@ static int acpi_fujitsu_hotkey_add(struc
 
 err_unregister_input_dev:
 	input_unregister_device(input);
+	input = NULL;
 err_free_input_dev:
 	input_free_device(input);
 err_free_fifo:
@@ -953,8 +953,6 @@ static int acpi_fujitsu_hotkey_remove(st
 
 	input_unregister_device(input);
 
-	input_free_device(input);
